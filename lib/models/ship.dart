class Ship {
  String path;
  String name;
  int length;
  bool isDestroyed;

  Ship({
    required this.path,
    required this.name,
    required this.length,
    this.isDestroyed = false,
  });

  void destroy() {
    isDestroyed = true;
  }
}
