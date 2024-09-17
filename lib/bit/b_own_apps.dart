import 'package:elbe/elbe.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/model/m_pocket.dart';
import 'package:peer_app/service/s_pocket.dart';

class OwnAppsBit extends MapMsgBitControl<List<AppModel>> {
  static const builder = MapMsgBitBuilder<List<AppModel>, OwnAppsBit>.make;
  final String userId;

  OwnAppsBit(this.userId)
      : super.worker((_) async {
          final pb = PocketService.i.pb;
          final res = await pb
              .collection("peertest_app")
              .getFullList(filter: "account = '$userId'");
          return res.map((e) => AppModel.fromMap(e.jsonMap)).toList();
        });
}
