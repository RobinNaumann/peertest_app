import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/model/m_pocket.dart';
import 'package:peer_app/service/s_pocket.dart';

class DataService {
  static final DataService i = DataService._();
  DataService._();

  Future<List<AppModel>> listApps(
      {int page = 1, String sort = "-updated"}) async {
    final res = await PocketService.i.pb.collection("peertest_app").getList(
        filter: "status = 'active' && public = True",
        perPage: 25,
        page: page,
        expand: "account",
        sort: sort);

    return res.items.map((e) => AppModel.fromMap(e.jsonMap)).toList();
  }

  Future<List<AppModel>> listAppsById(List<String> ids) async {
    final filter = ids.map((id) => "id = '$id'").join("||");

    final res = await PocketService.i.pb
        .collection("peertest_app")
        .getFullList(filter: filter, expand: "account");

    return res.map((e) => AppModel.fromMap(e.jsonMap)).toList();
  }

  Future<AppModel> getApp(String id) async {
    final res = await PocketService.i.pb
        .collection("peertest_app")
        .getOne(id, expand: "account");
    return AppModel.fromMap(res.jsonMap);
  }
}
