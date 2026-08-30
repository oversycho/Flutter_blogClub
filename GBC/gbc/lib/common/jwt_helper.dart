import 'dart:convert';

/// Extracts the 'sub' claim (user id) from a Supabase access token.
/// JWTs are base64url-encoded, not encrypted — this doesn't verify the
/// signature, it just reads a claim out of a token we already trust
/// (it's the one WE stored after a successful login).
String? userIdFromAccessToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final normalizedPayload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalizedPayload));
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    return map['sub'] as String?;
  } catch (_) {
    return null;
  }
}
