import 'dart:async';

import 'package:appcheck/appcheck.dart';
import 'package:elbe/elbe.dart';

Future<List<String>> _getApps() async {
  final apps = await AppCheck().getInstalledApps();
  return apps?.map((e) => e.packageName).toList() ?? [];
}

class InstalledBit extends MapMsgBitControl<List<String>> {
  static const builder = MapMsgBitBuilder<List<String>, InstalledBit>.make;
  Timer? _timer;

  isInstalled(String? packageName) => packageName != null
      ? state.whenData((d) => d.contains(packageName)) ?? false
      : false;

  InstalledBit() : super.worker((_) => _getApps()) {
    _timer = Timer.periodic(const Duration(seconds: 6),
        (timer) => state.whenData((d) => reload(silent: true)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
