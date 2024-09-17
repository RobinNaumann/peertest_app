import 'package:elbe/elbe.dart';
import 'package:peer_app/model/m_pocket.dart';
import 'package:peer_app/service/s_pocket.dart';

import '../model/m_testing.dart';

class AppTesting {
  final int maxDays;
  final List<TestingModel> testings;

  bool get credited => testings.length > maxDays;
  bool get nextTestPossible =>
      (testings.lastOrNull?.base?.created ?? 0) <
      DateTime.now().subtract(const Duration(hours: 14)).millisecondsSinceEpoch;

  AppTesting({
    required this.maxDays,
    required this.testings,
  });

  AppTesting.empty()
      : maxDays = 30,
        testings = [];
}

typedef TestingsState = ({
  List<TestingModel> testings,
  Map<String, AppTesting> apps
});

const _emptyState = (testings: <TestingModel>[], apps: <String, AppTesting>{});

class TestingsBit extends MapMsgBitControl<TestingsState> {
  static const builder = MapMsgBitBuilder<TestingsState, TestingsBit>.make;

  final String? userId;

  TestingsBit(this.userId)
      : super.worker((_) async {
          if (userId == null) return _emptyState;
          final ts = (await PocketService.i.pb
                  .collection("peertest_testing")
                  .getFullList(filter: "account = '$userId'"))
              .map((e) => TestingModel.fromMap(e.jsonMap))
              .toList();

          Map<String, AppTesting> byApps = {};
          for (var t in ts) {
            byApps.putIfAbsent(
                t.app, () => AppTesting(maxDays: 24, testings: []));
            byApps[t.app]!.testings.add(t);
          }

          return (testings: ts, apps: byApps);
        });
}
