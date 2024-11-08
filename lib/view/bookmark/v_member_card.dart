import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_apps.dart';
import 'package:peer_app/bit/b_installed.dart';
import 'package:peer_app/bit/b_testings.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/util.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../v_app.dart';
import '../v_test.dart';

class MemberCard extends StatelessWidget {
  final String appId;
  final Function()? onRemove;
  final bool onAppPage;
  const MemberCard(
      {super.key, required this.appId, this.onRemove, this.onAppPage = false});

  @override
  Widget build(BuildContext context) => Card(
      padding: RemInsets.zero,
      child: InstalledBit.builder(
        onLoading: (bit, _) =>
            Padded.all(child: const Center(child: CircularProgressIndicator())),
        onData: (iBit, installed) => BitBuildProvider(
            create: (_) => AppBit(appId),
            onLoading: (bit, _) => Padded.all(
                child: const Center(child: CircularProgressIndicator())),
            onData: (bit, AppModel app) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padded.all(
                    child: Row(
                        children: [
                      AppIcon(app: app, size: 3, clickable: !onAppPage),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text.bodyL(app.name,
                                    variant: TypeVariants.bold),
                                if (app.account != null)
                                  AccountSnippet(account: app.account!)
                              ].spaced(amount: .5))),
                      if (onRemove != null)
                        IconButton.integrated(icon: Icons.x, onTap: onRemove)
                    ].spaced()),
                  ),
                  !iBit.isInstalled(app.packageId)
                      ? Padded.all(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Button.minor(
                                icon: Icons.users,
                                label: "join PeerTest group",
                                onTap: () => launchUrlString(
                                    "https://groups.google.com/g/peertest-org")),
                            _DownloadButton(url: app.urlJoin)
                          ].spaced(),
                        ))
                      : _TestButton(app: app)
                ].spaced(amount: .5))),
      ));
}

class _DownloadButton extends StatefulWidget {
  final String? url;
  const _DownloadButton({super.key, required this.url});

  @override
  State<_DownloadButton> createState() => __DownloadButtonState();
}

class __DownloadButtonState extends State<_DownloadButton> {
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return _downloading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Button.action(
                  label: "cancel",
                  onTap: () => setState(() => _downloading = false))
            ].spaced(),
          )
        : Button.major(
            icon: Icons.download,
            label: "install app",
            onTap: widget.url == null
                ? null
                : () {
                    setState(() => _downloading = true);
                    launchUrlString(widget.url!);
                  },
          );
  }
}

class _TestButton extends StatelessWidget {
  final AppModel app;
  const _TestButton({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return TestingsBit.builder(onData: (bit, data) {
      final testing = data.apps[app.base?.id ?? ""] ?? AppTesting.empty();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padded.all(
            child: testing.credited
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text.h4("testing completed 🎉",
                          textAlign: TextAlign.center),
                      Text(
                          "You've received your reward for testing this app. Thank you for your help!\n(You can remove it from the list)",
                          textAlign: TextAlign.center)
                    ].spaced(),
                  )
                : testing.nextTestPossible
                    ? Button.major(
                        icon: Icons.arrowRight,
                        label: "open app",
                        onTap: () async {
                          await context.elbeBottomSheet(
                              child: TestModal(app: app));
                          bit.reload(silent: true);
                        })
                    : const Text(
                        "you already tested the app today.\ncome back tomorrow.",
                        textAlign: TextAlign.center),
          ),
          if (!testing.credited && testing.testings.isNotEmpty)
            _testingsBar(context, testing.testings.length, testing.maxDays),
        ].spaced(amount: .5),
      );
    });
  }
}

Widget _testingsBar(BuildContext context, int count, int max) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      InkWell(
        onTap: () {
          context.elbeBottomSheet(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text.h4("why do I need to test for 24 days?"),
              const Text(
                  "Google Play requires 20 testers to actively test an app for at least 14 days. Since not all testers will join on the same day, we recommend testing for an additional 10 days to ensure testing is successful."),
            ].spaced(),
          ));
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text.bodyM("testing days:", textAlign: TextAlign.end),
          const Spaced.horizontal(.25),
          Text.bodyM(
            "$count/$max",
            textAlign: TextAlign.start,
            variant: TypeVariants.bold,
          ),
          const Spaced.horizontal(.5),
          const Icon(Icons.info, style: TypeStyles.bodyS)
        ]),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: count,
              child: const Box(
                  height: .75,
                  style: ColorStyles.minorAccent,
                  border: Border.noneRect,
                  child: Spaced.zero)),
          Expanded(flex: max - count, child: Spaced.zero)
        ],
      ),
    ].spaced(amount: .5),
  );
}
