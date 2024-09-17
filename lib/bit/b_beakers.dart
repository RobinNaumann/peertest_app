import 'package:elbe/elbe.dart';
import 'package:peer_app/service/s_pocket.dart';

class BeakersBit extends MapMsgBitControl<int> {
  static const builder = MapMsgBitBuilder<int, BeakersBit>.make;
  final String userId;

  BeakersBit(this.userId)
      : super.worker((_) async {
          final pb = PocketService.i.pb;
          final r = await pb.collection("peertest_beaker").getOne(userId);
          return r.data["count"];
        });
}
