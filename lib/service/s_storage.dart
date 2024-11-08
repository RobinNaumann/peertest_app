import 'package:hive/hive.dart';

class StorageService {
  static StorageService i = StorageService._();
  static Box? _boxConfig;
  static Box? _boxAuth;

  StorageService._();

  Future<void> init() async {
    _boxConfig = await Hive.openBox("config");
    _boxAuth = await Hive.openBox("auth");
  }

  List<String> get bookmarks =>
      _boxConfig!.get("bookmarks", defaultValue: <String>[]);

  void toggleBookmark(String id) {
    final ms = bookmarks;
    final add = !ms.contains(id);
    final nMs = add ? [...ms, id] : ms.where((b) => b != id).toList();
    _boxConfig!.put("bookmarks", nMs);
  }

  ({String token, String id})? get auth {
    final r = _boxAuth!.get("pocket", defaultValue: null);
    if (r == null) return null;
    return (token: r["token"], id: r["id"]);
  }

  void setAuth(String? token, [String? id]) {
    _boxAuth!.put("pocket", token != null ? {"token": token, "id": id} : null);
  }
}
