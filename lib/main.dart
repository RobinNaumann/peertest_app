import 'package:elbe/elbe.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/bit/b_testings.dart';
import 'package:peer_app/service/s_storage.dart';
import 'package:peer_app/view/own/v_own_apps.dart';
import 'package:peer_app/view/v_account.dart';

import 'bit/b_bookmark.dart';
import 'bit/b_installed.dart';
import 'view/v_app.dart';
import 'view/v_apps.dart';
import 'view/v_home.dart';

void main() async {
  await Hive.initFlutter();
  await StorageService.i.init();
  runApp(const _Providers());
}

class _Providers extends StatelessWidget {
  const _Providers({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BitProvider(
        create: (_) => AuthBit(),
        child: BitProvider(
          create: (_) => InstalledBit(),
          child: BitProvider(
              create: (_) => StorageBit(),
              child: AuthBit.builder(
                  onData: (bit, auth) => _App(userId: auth?.id),
                  onLoading: (_, __) => const _App(),
                  onError: (_, __) => const _App())),
        ));
  }
}

class _App extends StatelessWidget {
  final String? userId;
  const _App({this.userId});

  static final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/apps', builder: (context, state) => const AppsPage()),
    GoRoute(path: '/account', builder: (context, state) => const AccountPage()),
    GoRoute(
        path: '/own_apps', builder: (context, state) => const OwnAppsPage()),
    GoRoute(
        path: '/app/:id',
        builder: (context, state) =>
            AppPage(appId: state.pathParameters['id']!)),
  ]);

  @override
  Widget build(BuildContext context) {
    return BitProvider(
        create: (_) => TestingsBit(userId),
        child: ElbeApp(
            debugShowCheckedModeBanner: false,
            mode: ColorModes.fromPlatform,
            router: router,
            theme: ThemeData.preset(
                color: const Color(0xFF7700fe),
                titleFont: "SpaceGrotesk",
                titleVariant: TypeVariants.bold)));
  }
}
