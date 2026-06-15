
class GenericRepository<T> {
  final List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  List<T> getAll() {
    return List<T>.from(_items); 
  }

  void update(bool Function(T) test, T newItem) {
    final index = _items.indexWhere(test);
    if (index != -1) {
      _items[index] = newItem;
    }
  }

  bool delete(bool Function(T) test) {
    final index = _items.indexWhere(test);
    if (index != -1) {
      _items.removeAt(index);
      return true;
    }
    return false;
  }
}