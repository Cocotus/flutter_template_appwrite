// Appwrite Function: a generic CORS proxy, demonstrated against example.com.
//
// WHY THIS FUNCTION EXISTS
// ------------------------
// Flutter Web runs inside a browser, and a browser refuses to hand a web
// page the response of a cross-origin request unless the SERVER being
// called sends back permission headers (this is called CORS — Cross-Origin
// Resource Sharing). Most plain web pages, many internal/legacy REST APIs,
// and anything you'd casually "scrape" send no such headers at all — so a
// direct request to them from a Flutter Web build is blocked before your app
// ever sees a reply. A desktop or mobile build of the exact same app has no
// such restriction: there is no browser sandbox involved, so it can call the
// same URL directly and it just works. See `WebApiProxyService` in
// `lib/services/web_api_proxy_service.dart` and README §12 for the full
// walkthrough, including a screenshot of what this looks like in the app.
//
// This function is the fix. It runs on Appwrite's own servers, not inside a
// browser, so it is not subject to CORS at all — it can fetch any page or
// API exactly like `curl` or a desktop build already can. The Flutter web
// build asks THIS function for the data instead of asking the real target
// directly, and this function fetches it and hands the answer back.
//
// THE DEMO TARGET: example.com
// ------------------------------
// This function's default allowlist only permits `example.com` — the
// domain IANA reserves specifically for use in examples and documentation
// like this one, so it is guaranteed stable and appropriate to depend on.
// The Flutter-side demo asks this function to fetch example.com's homepage
// and then pulls the page's `<title>` out of the raw HTML — a tiny,
// self-contained example of "scraping" a page that has no API and no CORS
// support of its own.
//
// ADAPTING THIS TO YOUR OWN API
// -------------------------------
// Swap `example.com` in ALLOWED_HOSTS (see below) for your own API's
// hostname, and change what `WebApiProxyService` does with the response on
// the Flutter side (e.g. `jsonDecode` instead of a title regex, if your API
// returns JSON instead of HTML) — this function itself needs no other
// changes, because it never interprets the response body; it only forwards
// it.
//
// HOW THE FLUTTER APP CALLS THIS FUNCTION
// ----------------------------------------
// The app never calls this function's own URL directly. It uses the
// Appwrite SDK's `Functions.createExecution(...)`, which is a normal request
// to Appwrite's own REST API — the exact same API the app already uses for
// login. Because of that, this function needs NO CORS headers of its own to
// satisfy the browser: the browser's permission check happens against
// Appwrite's API, and that is already allowed for your app's origin the
// moment you register it as a "Web" platform in the Appwrite console (the
// same registration your login flow already requires, if this template's
// login is enabled).
//
// SECURITY: the ALLOWED_HOSTS allowlist
// --------------------------------------
// Without an allowlist, this function would happily fetch ANY url a caller
// hands it — turning it into an "open proxy" that anyone on the internet
// could use to make requests appear to come from your Appwrite project
// (this class of bug is called SSRF: Server-Side Request Forgery). Keep the
// allowlist scoped to only the host(s) you actually intend to call, and
// never widen it to "allow everything".

// The demo target. Replace with your own API's hostname when you adapt this
// function — see "ADAPTING THIS TO YOUR OWN API" above.
const DEFAULT_ALLOWED_HOSTS = ['example.com'];

// A browser-like User-Agent — some sites/APIs reject requests that look
// like they come from a script rather than a browser.
const USER_AGENT =
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
  '(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36';

// Give up on a slow/unreachable target rather than let a request hang.
const REQUEST_TIMEOUT_MS = 15_000;

export default async ({ req, res, log, error }) => {
  // 1) Read the allowlist from the function's own environment variables
  //    (Appwrite console → this function → Settings → Environment
  //    variables), falling back to the demo default if it was never set.
  const configuredHosts = (process.env.ALLOWED_HOSTS ?? '')
    .split(',')
    .map((host) => host.trim())
    .filter((host) => host.length > 0);
  const allowedHosts =
    configuredHosts.length > 0 ? configuredHosts : DEFAULT_ALLOWED_HOSTS;

  // 2) The Flutter app passes the URL it actually wants as a single query
  //    parameter: /?url=<the%20real%20url%2C%20url-encoded>
  const target = req.query.url;
  if (!target) {
    return res.json({ error: 'Missing "url" query parameter' }, 400);
  }

  let parsedTarget;
  try {
    parsedTarget = new URL(target);
  } catch {
    return res.json({ error: 'Invalid "url" query parameter' }, 400);
  }

  // 3) Reject anything not on the allowlist BEFORE making any network call.
  if (!allowedHosts.includes(parsedTarget.hostname)) {
    error(`Blocked request to disallowed host: ${parsedTarget.hostname}`);
    return res.json(
      { error: `Host not allowed: ${parsedTarget.hostname}` },
      403,
    );
  }

  // 4) Fetch the real target, server-side — this is the line a browser
  //    could never run directly because of CORS, but a server has no such
  //    restriction.
  const abortController = new AbortController();
  const timeoutHandle = setTimeout(
    () => abortController.abort(),
    REQUEST_TIMEOUT_MS,
  );

  let upstreamResponse;
  try {
    upstreamResponse = await fetch(parsedTarget, {
      headers: {
        'User-Agent': USER_AGENT,
        Accept: 'text/html,application/json;q=0.9,*/*;q=0.8',
      },
      signal: abortController.signal,
    });
  } catch (fetchError) {
    error(`Upstream fetch failed for ${parsedTarget.hostname}: ${fetchError}`);
    return res.json({ error: 'Upstream request failed' }, 502);
  } finally {
    clearTimeout(timeoutHandle);
  }

  const upstreamBody = await upstreamResponse.text();
  log(`Proxied ${parsedTarget.hostname} -> HTTP ${upstreamResponse.status}`);

  // 5) Hand the real response's status code and body straight back,
  //    unmodified. `WebApiProxyService` on the Flutter side decodes/parses
  //    this exactly like it would a direct response — it has no idea a
  //    proxy was involved.
  return res.send(upstreamBody, upstreamResponse.status, {
    'content-type':
      upstreamResponse.headers.get('content-type') ?? 'text/plain',
  });
};
