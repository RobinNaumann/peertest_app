import 'package:elbe/elbe.dart';
import 'package:peer_app/model/m_pocket.dart';
import 'package:peer_app/model/m_testing.dart';
import 'package:peer_app/service/s_pocket.dart';

class OwnTestingsBit extends MapMsgBitControl<List<TestingModel>> {
  static const builder =
      MapMsgBitBuilder<List<TestingModel>, OwnTestingsBit>.make;
  final String appId;

  OwnTestingsBit(this.appId)
      : super.worker((_) async {
          final pb = PocketService.i.pb;
          final res = await pb
              .collection("peertest_testing")
              .getFullList(filter: "app = '$appId'", expand: "account");
          return res.map((e) => TestingModel.fromMap(e.jsonMap)).toList();
        });
}
