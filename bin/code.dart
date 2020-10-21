class Folder {
  final String name;
  final String idParent;

  Folder(
    this.name,
    this.idParent,
  );
  @override
  String toString() {
    // TODO: implement toString
    return '$name ($idParent)';
  }
}

void main() {
  Map<String, Folder> folderMap = {};
  folderMap['a'] = Folder('a', null);
  folderMap['b'] = Folder('b', 'a');
  folderMap['b1'] = Folder('b1', 'a');
  folderMap['c'] = Folder('c', 'b');
  print(folderMap);
  // Remove com erro
  // String rm = 'a';
  // folderMap.removeWhere((key, value) => value.idParent == rm);
  // Result em
  //   {a: a (null), b: b (a), b1: b1 (a), c: c (b1)}
  //   {a: a (null), c: c (b1)}
  List<String> removeParent = ['b'];
  List<String> removeChild = [];
  bool goBack;
  do {
    // folderMap.entries.where((element) {
    //   if (list.contains(element.value.idParent)) {
    //     removeChild.add(element.key);
    //   }
    //   return true;
    // });
    goBack = false;
    for (var folder in folderMap.entries) {
      if (removeParent.contains(folder.value.idParent)) {
        removeChild.add(folder.key);
        goBack = true;
      }
    }
    folderMap.removeWhere((key, value) => removeParent.contains(key));
    folderMap.removeWhere((key, value) => removeChild.contains(key));
    removeParent.clear();
    removeParent.addAll(removeChild);
    removeChild.clear();
  } while (goBack);
  print(folderMap);
}
