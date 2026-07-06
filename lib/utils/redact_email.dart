/// Masks an email address so it can be logged without exposing PII.
///
/// Example: `jane.doe@example.com` becomes `j***@example.com`.
/// Values that do not look like an email are fully masked as `***`.
String redactEmail(String email) {
  final int atIndex = email.indexOf('@');

  // Too short or not an email at all: do not leak anything.
  if (atIndex <= 1) {
    return '***';
  }

  final String firstCharacter = email.substring(0, 1);
  final String domainPart = email.substring(atIndex);
  return '$firstCharacter***$domainPart';
}
