import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';

/// Maps an authentication [error] to a localized, user-friendly message.
///
/// Appwrite reports auth problems as [AppwriteException] with an HTTP-like
/// status code:
/// - `409`: a user with this email already exists (register).
/// - `401`: invalid credentials (login).
/// Everything else falls back to a generic error message. The raw server
/// message is intentionally not shown to end users.
String mapAuthError(BuildContext context, Object error) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  if (error is AppwriteException) {
    if (error.code == 409) {
      return localizations.errorEmailAlreadyExists;
    }
    if (error.code == 401) {
      return localizations.errorInvalidCredentials;
    }
  }

  return localizations.errorGeneric;
}
