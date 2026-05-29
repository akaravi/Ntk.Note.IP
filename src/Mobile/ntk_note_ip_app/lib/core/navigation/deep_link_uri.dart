/// Maps https://ipnote.ir web paths to in-app go_router locations.
String? mapWebDeepLinkToAppPath(Uri uri) {
  if (uri.scheme != 'https' && uri.scheme != 'http') {
    return null;
  }

  final host = uri.host.toLowerCase();
  if (host != 'ipnote.ir' && host != 'www.ipnote.ir') {
    return null;
  }

  var path = uri.path;
  if (path.endsWith('/') && path.length > 1) {
    path = path.substring(0, path.length - 1);
  }

  if (path == '/ip-lookup' || path.startsWith('/ip-lookup/')) {
    final address = uri.queryParameters['address'];
    if (address != null && address.trim().isNotEmpty) {
      return '/?address=${Uri.encodeQueryComponent(address.trim())}';
    }

    return '/';
  }

  const allowed = {'/', '/dashboard', '/ip-notes', '/tools', '/login'};
  if (allowed.contains(path)) {
    if (uri.query.isEmpty) {
      return path;
    }

    return '$path?${uri.query}';
  }

  return null;
}
