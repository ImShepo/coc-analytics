String normalizeClanTag(String tag) {
  final decoded = tag.trim().replaceAll('%23', '#');
  if (decoded.isEmpty) return decoded;
  return decoded.startsWith('#') ? decoded : '#$decoded';
}

String clanTagToApiPath(String tag) =>
    normalizeClanTag(tag).replaceAll('#', '%23');
