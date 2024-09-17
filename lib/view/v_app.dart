import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_apps.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/report.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/v_account.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'bookmark/v_bookmark.dart';

class AppPage extends StatelessWidget {
  final String appId;
  const AppPage({super.key, required this.appId});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
        create: (_) => AppBit(appId),
        child: Scaffold(
            title: "app details",
            child: AppBit.builder(
              onData: (bit, data) => BaseList(
                children: [
                  Row(
                      children: [
                    AppIcon(app: data, size: 4, clickable: false, hero: true),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text.bodyL(data.name, variant: TypeVariants.bold),
                            if (data.account != null)
                              AccountSnippet(account: data.account!),
                          ].spaced(amount: .5)),
                    ),
                  ].spaced()),
                  _section(
                    title: "info",
                    children: [
                      SizedBox(
                        height: context.rem(3.5),
                        //scrollDirection: Axis.horizontal,
                        child: ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Card(
                                child: Row(
                                    children: [
                              Icon(data.platform.icon),
                              Text(data.platform.label),
                            ].spaced(amount: .5))),
                            Card(
                                child: Row(
                                    children: [
                              const Icon(Icons.calendar),
                              Text(maybeDateString(data.base?.updated) ?? ""),
                            ].spaced(amount: .5))),
                            /*Card(
                                child: Row(
                                    children: [
                              const Icon(Icons.users),
                              const Text("42 testers"),
                            ].spaced(amount: .5))),*/
                          ].spaced(),
                        ),
                      ),
                    ],
                  ),
                  _section(
                    title: "description",
                    children: [Text.bodyM(data.description)],
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        data.urlJoin != null
                            ? BookmarkJoinButton(app: data)
                            : Card(
                                style: ColorStyles.minorAlertWarning,
                                child: Row(
                                    children: const [
                                  Icon(Icons.alertTriangle),
                                  Expanded(
                                      child: Text(
                                          "app has no valid download link")),
                                ].spaced())),
                        if (data.emailFeedback != null)
                          Button.action(
                              icon: Icons.mail,
                              onTap: () => launchUrlString(
                                  "mailto:${data.emailFeedback}"),
                              label: "message developer"),
                        Button.action(
                            onTap: () => reportApp(context,
                                userId: data.account?.id,
                                element: data.base?.id),
                            icon: Icons.flag,
                            label: "report"),
                      ].spaced())
                ].spaced(amount: 2),
              ),
            )));
  }
}

Widget _section({required String title, required List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [Text.h5(title), ...children].spaced(amount: .5),
  );
}

class AppIcon extends StatelessWidget {
  final AppModel app;
  final double size;
  final bool clickable;
  final bool hero;

  const AppIcon(
      {super.key,
      required this.app,
      required this.size,
      this.clickable = true,
      this.hero = false});

  @override
  Widget build(BuildContext context) {
    final url = app.iconURL;
    return Card(
        onTap: clickable ? () => context.push("/app/${app.base?.id}") : null,
        heroTag: clickable || hero ? "appicon_${app.base?.id}" : null,
        scheme: ColorSchemes.secondary,
        height: size,
        width: size,
        border: Border.none,
        padding: RemInsets.zero,
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.cover,
              )
            : Spaced.zero);
  }
}

class AccountSnippet extends StatelessWidget {
  final UserModel account;
  const AccountSnippet({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserIcon(url: account.avatarURL, size: 1.3),
        Text.bodyM(account.name),
      ].spaced(amount: .5),
    );
  }
}
