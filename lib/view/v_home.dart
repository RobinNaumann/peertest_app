import 'package:elbe/elbe.dart';
import 'package:moewe/moewe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/v_account.dart';

import 'bookmark/v_bookmark.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
      onData: (bit, auth) => auth == null
          ? _LoginPage(bit: bit)
          : Scaffold(
              title: "peerTest",
              actions: [
                IconButton.integrated(
                    icon: Icons.plus,
                    onTap: () => context.elbeBottomSheet(
                        child: const Text(
                            "please use the web app to create new apps:\n"
                            "https://peerTest.org"))),
                IconButton.integrated(
                    icon: Icons.messagesSquare,
                    onTap: () => showFeedbackPage(context,
                        labels: const FeedbackLabels(
                          description:
                              "thank you for making peerTest better! We will review your feedback and get back to you soon.",
                        ),
                        theme: MoeweTheme(
                            colorAccent:
                                context.theme.color.activeScheme.majorAccent))),
              ],
              children: [
                const AccountSnippet(),
                Button.action(
                    icon: Icons.layoutGrid,
                    label: "view available apps",
                    onTap: () => context.push('/apps')),
                AuthBit.builder(
                    small: true,
                    onData: (bit, data) =>
                        data != null ? const BookmarksView() : Spaced.zero),
              ].spaced(),
            ),
    );
  }
}

class _LoginPage extends StatelessWidget {
  final AuthBit bit;
  const _LoginPage({super.key, required this.bit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        title: "peerTest",
        child: Padded.all(
          child: Column(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.handMetal),
                      Text.h1("welcome", textAlign: TextAlign.center),
                      Text(
                          "log into your peerTest.org account\nto start testing apps",
                          textAlign: TextAlign.center)
                    ].spaced())),
            Button.major(
                icon: Icons.logIn, label: "login", onTap: () => bit.login()),
          ]),
        ));
  }
}
