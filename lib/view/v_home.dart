import 'package:elbe/elbe.dart';
import 'package:moewe/moewe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/v_account.dart';
import 'package:peer_app/view/v_login.dart';

import 'bookmark/v_bookmark.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
      onData: (bit, auth) => auth == null
          ? LoginPage(bit: bit)
          : Scaffold(
              title: "peerTest",
              leadingIcon: LeadingIcon(
                  icon: Icons.user, onTap: (_) => context.push("/account")),
              actions: [
                IconButton.integrated(
                    icon: Icons.plus,
                    onTap: () => context.elbeBottomSheet(
                        child: const Text(
                            "for now, please use the web app to create new apps: "
                            "peerTest.org"))),
                IconButton.integrated(
                    icon: Icons.messagesSquare,
                    onTap: () => MoeweFeedbackPage.show(context,
                        labels: const FeedbackLabels(
                          description:
                              "thank you for making peerTest better! I'll review your feedback and get back to you soon.",
                        ),
                        theme: MoeweTheme(
                            colorAccent:
                                context.theme.color.activeScheme.majorAccent))),
              ],
              child: ListView(
                  children: [
                const MoeweUpdateView(),
                Padded.all(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AccountSnippet(),
                        Button.action(
                            icon: Icons.layoutGrid,
                            label: "view available apps",
                            onTap: () => context.push('/apps')),
                        AuthBit.builder(
                            small: true,
                            onData: (bit, data) => data != null
                                ? const BookmarksView()
                                : Spaced.zero),
                      ].spaced()),
                ),
              ].spaced()),
            ),
    );
  }
}
