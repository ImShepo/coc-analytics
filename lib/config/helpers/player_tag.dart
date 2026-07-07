String normalizePlayerTag(String tag) {
  final decoded = tag.trim().replaceAll('%23', '#');
  return decoded.replaceAll('#', '').toUpperCase();
}

String playerTagToDisplay(String tag) {
  final normalized = normalizePlayerTag(tag);
  return normalized.isEmpty ? tag : '#$normalized';
}
