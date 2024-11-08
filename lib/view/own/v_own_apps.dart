import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/bit/b_own_apps.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/own/v_own_app.dart';
import 'package:peer_app/view/v_app.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OwnAppsPage extends StatelessWidget {
  const OwnAppsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        title: "your apps", child: BaseList(children: [OwnAppsList()]));
  }
}

class OwnAppsList extends StatelessWidget {
  const OwnAppsList({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
        onData: (bit, auth) => BitBuildProvider(
            create: (_) => OwnAppsBit(auth!.id),
            onData: (bit, List<AppModel> apps) => Column(
                  children: [
                    Card(
                        scheme: ColorSchemes.secondary,
                        child: GestureDetector(
                          onTap: () => launchUrlString("https://peerTest.org",
                              mode: LaunchMode.externalApplication),
                          child: Row(
                            children: const [
                              Icon(Icons.wrench),
                              Expanded(
                                  child: Text(
                                "create and close apps for testing through the web app",
                              )),
                            ].spaced(),
                          ),
                        )),
                    if (apps.isEmpty) const Text("you don't have any apps yet"),
                    for (final app in apps)
                      Card(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OwnAppPage(app: app))),
                          child: Row(
                              children: [
                            AppIcon(app: app, size: 3),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text.bodyL(app.name,
                                          variant: TypeVariants.bold),
                                      if (app.account != null)
                                        AccountSnippet(account: app.account!)
                                    ].spaced(amount: .5))),
                            const Icon(Icons.chevronRight)
                          ].spaced()))
                  ].spaced(),
                )));
  }
}
