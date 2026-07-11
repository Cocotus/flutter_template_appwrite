import crypto from 'node:crypto';
import { Client, TablesDB, Users, Permission, Role, Query, ID } from 'node-appwrite';

// Lemon Squeezy → Appwrite entitlement webhook.
//
// Flow: a completed checkout fires the `order_created` webhook. This
// function verifies the HMAC signature, resolves the Appwrite user (via the
// user_id the app put into the checkout's custom data, falling back to the
// buyer e-mail) and upserts one row into the `entitlements` table with the
// user ID as row ID. The app's LicenseService only ever READS that table.
//
// Required function environment variables (Appwrite console → function →
// Settings → Environment variables):
//   LS_SIGNING_SECRET   The signing secret configured on the Lemon Squeezy
//                       webhook (Settings → Webhooks).
//   APPWRITE_API_KEY    An API key with scopes: rows.read, rows.write,
//                       users.read.
// Optional overrides (defaults match the app's AppConfig defaults):
//   DATABASE_ID (app), ENTITLEMENTS_TABLE_ID (entitlements)
//
// APPWRITE_FUNCTION_API_ENDPOINT and APPWRITE_FUNCTION_PROJECT_ID are
// injected automatically by the Appwrite runtime.

export default async ({ req, res, log, error }) => {
  const signingSecret = process.env.LS_SIGNING_SECRET;
  if (!signingSecret) {
    error('LS_SIGNING_SECRET is not configured');
    return res.json({ ok: false }, 500);
  }

  // 1) Verify the webhook signature over the RAW body. Reject anything
  //    unsigned — this endpoint is public.
  const signature = req.headers['x-signature'] ?? '';
  const digest = crypto
    .createHmac('sha256', signingSecret)
    .update(req.bodyRaw ?? '')
    .digest('hex');
  const signatureOk =
    signature.length === digest.length &&
    crypto.timingSafeEqual(Buffer.from(digest), Buffer.from(signature));
  if (!signatureOk) {
    error('Invalid webhook signature');
    return res.json({ ok: false }, 401);
  }

  const payload = JSON.parse(req.bodyRaw);
  const eventName = payload?.meta?.event_name;
  if (eventName !== 'order_created') {
    // Not an event we handle — acknowledge so LS does not retry.
    log(`Ignoring event: ${eventName}`);
    return res.json({ ok: true, ignored: true });
  }

  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);
  const tablesDB = new TablesDB(client);
  const users = new Users(client);

  const databaseId = process.env.DATABASE_ID ?? 'app';
  const tableId = process.env.ENTITLEMENTS_TABLE_ID ?? 'entitlements';

  // 2) Resolve the Appwrite user: primary = the user_id the app appended
  //    to the checkout URL; fallback = the buyer's e-mail (must match an
  //    existing account exactly).
  const attributes = payload?.data?.attributes ?? {};
  const buyerEmail = attributes.user_email ?? '';
  let userId = payload?.meta?.custom_data?.user_id ?? '';

  if (!userId && buyerEmail) {
    const match = await users.list({
      queries: [Query.equal('email', buyerEmail)],
    });
    if (match.total > 0) {
      userId = match.users[0].$id;
    }
  }
  if (!userId) {
    // No account found — keep the order visible in the LS dashboard for
    // manual assignment; do not fail the webhook (LS would retry forever).
    error(`No user found for order ${attributes.identifier} (${buyerEmail})`);
    return res.json({ ok: true, unassigned: true });
  }

  // 3) Write the entitlement. Row ID = user ID (one row per user); the
  //    user gets READ permission only — the client can never write this.
  await tablesDB.upsertRow({
    databaseId,
    tableId,
    rowId: userId,
    data: {
      plan: 'premium',
      orderId: String(attributes.identifier ?? payload?.data?.id ?? ''),
      purchasedAt: attributes.created_at ?? new Date().toISOString(),
      email: buyerEmail,
    },
    permissions: [Permission.read(Role.user(userId))],
  });

  log(`Entitlement written for user ${userId}`);
  return res.json({ ok: true });
};
