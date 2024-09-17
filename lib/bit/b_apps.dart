import 'package:elbe/elbe.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/service/s_data.dart';

class _State {
  final List<AppModel> apps;
  final String sortBy;
  final int? nextPage;
  _State(
      {required this.apps, required this.nextPage, this.sortBy = "-updated"});
}

class AppsBit extends MapMsgBitControl<_State> {
  static const builder = MapMsgBitBuilder<_State, AppsBit>.make;

  AppsBit()
      : super.worker((_) async => _State(
            apps: await DataService.i.listApps(),
            nextPage: 2,
            sortBy: "-updated"));

  void sort(String by) {
    state.whenOrNull(onData: (d) async {
      final apps = await DataService.i.listApps(sort: by);
      emit(_State(apps: apps, sortBy: by, nextPage: 2));
    });
  }

  void loadNextPage() {
    state.whenOrNull(onData: (d) async {
      if (d.nextPage == null) return;
      final page =
          await DataService.i.listApps(sort: d.sortBy, page: d.nextPage!);
      emit(_State(
          apps: [...d.apps, ...page],
          sortBy: d.sortBy,
          nextPage: d.nextPage! + 1));
    });
  }
}

class AppBit extends MapMsgBitControl<AppModel> {
  static const builder = MapMsgBitBuilder<AppModel, AppBit>.make;
  final String id;

  AppBit(this.id) : super.worker((_) => DataService.i.getApp(id));
}

/*class BookmarkedAppsBit extends MapMsgBitControl<List<AppModel>> {
  static const builder =
      MapMsgBitBuilder<List<AppModel>, BookmarkedAppsBit>.make;
  final List<String> ids;

  BookmarkedAppsBit(this.ids)
      : super.worker((_) => DataService.i.listAppsById(ids));
}*/
