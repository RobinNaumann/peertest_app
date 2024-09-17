import 'package:elbe/elbe.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:peer_app/app_config.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/service/s_pocket.dart';
import 'package:peer_app/util.dart';

enum TestState {
  running,
  completed,
  tooShort;

  bool get isRunning => this == TestState.running;
  bool get isCompleted => this == TestState.completed;
  bool get isTooShort => this == TestState.tooShort;
}

class _State {
  final int _started;
  final int? _ended;

  TestState get state {
    if (_ended == null) return TestState.running;
    if (_ended! >= (_started + appConfig.testMinSec * 1000)) {
      return TestState.completed;
    }
    return TestState.tooShort;
  }

  const _State(this._started, [this._ended]);
}

class TestBit extends MapMsgBitControl<_State> {
  static const builder = MapMsgBitBuilder<_State, TestBit>.make;
  static buildProvider(
          {required String userId,
          required AppModel app,
          required Widget Function(TestBit bit, TestState state) onData}) =>
      BitBuildProvider(
          create: (_) => TestBit(userId, app),
          onData: (bit, _State data) => onData(bit, data.state));

  final AppModel app;
  final String userId;

  TestBit(this.userId, this.app)
      : super.worker((_) {
          Future.delayed(const Duration(milliseconds: 300),
              () => LaunchApp.openApp(androidPackageName: app.packageId));
          return _State(now());
        });

  void onFocusChange(bool focused) {
    state.whenData((data) {
      if (!focused) return;
      if (data._ended != null) return;
      emit(_State(data._started, now()));
    });
  }

  Future<bool> submit(String feedback) async {
    final pb = PocketService.i.pb;
    try {
      await pb.collection("peertest_testing").create(body: {
        "account": userId,
        "app": app.base!.id,
        "device": null,
        "feedback": feedback
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
