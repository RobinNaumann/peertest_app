import 'package:elbe/elbe.dart';
import 'package:peer_app/service/s_storage.dart';

class StorageState {
  final List<String> bookmarks;

  StorageState({required this.bookmarks});
}

class StorageBit extends MapMsgBitControl<StorageState> {
  static const builder = MapMsgBitBuilder<StorageState, StorageBit>.make;

  StorageBit()
      : super.worker((_) async {
          return StorageState(bookmarks: StorageService.i.bookmarks);
        });

  void toggleBookmark(String? id) {
    if (id == null) return;
    StorageService.i.toggleBookmark(id);
    reload();
  }
}
