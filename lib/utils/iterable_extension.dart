extension IterableExtension<E> on Iterable<E> {
  int indexOf(E elem) {
    var i = 0;
    for (final e in this) {
      if (e == elem) return i;
      i++;
    }
    return -1;
  }
}