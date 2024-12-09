String cleanContent(String content) {
  final regex = RegExp(r'\s\[\+\d+ chars\]$');
  return content.replaceAll(regex, '');
}
