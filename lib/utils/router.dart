class RouterUtils {
  int? _currentPageIndex;
  static const tabPaths = ['/explore', '/search', '/library'];

  RouterUtils._();

  static final RouterUtils _instance = RouterUtils._();

  factory RouterUtils() => _instance;

  void setCurrentPageIndex(int newIndex) {
    _currentPageIndex = newIndex;
  }

  int get currentPageIndex {
    return _currentPageIndex ?? 0;
  }

  static String getPathByIndex(int index) {
    return tabPaths[index];
  }

  static int getIndexByPath(String path) {
    final index = tabPaths.indexWhere(
      (tab) => path == tab || path.startsWith('$tab/'),
    );
    if (index != -1) return index;
    if (path.startsWith('/game_details')) return 0;
    return 0;
  }
}
