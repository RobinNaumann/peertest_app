import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/bit/b_beakers.dart';
import 'package:peer_app/util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        title: "Account",
        child: AuthBit.builder(
            onData: (bit, auth) => auth != null
                ? BaseList(
                    children: [
                      // avatar section
                      Center(
                          child: UserIcon(url: auth.model.avatarURL, size: 8)),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(auth.model.name ?? "no name",
                                textAlign: TextAlign.center,
                                variant: TypeVariants.bold),
                            Text(auth.model.email ?? "no email",
                                textAlign: TextAlign.center),
                          ].spaced(amount: .5)),

                      const Spaced(),
                      const Text.h6("about"),
                      if (auth.model.description != null)
                        Text(auth.model.description!),
                      Spaced(),
                      Button.minor(
                          icon: Icons.code,
                          label: "my apps",
                          onTap: () => context.push("/own_apps")),
                      if (auth.model.homepage != null)
                        Button.action(
                            icon: Icons.externalLink,
                            label: "your homepage",
                            onTap: () => launchUrlString(auth.model.homepage!)),

                      Button.action(
                          icon: Icons.logOut,
                          label: "logout",
                          onTap: () {
                            bit.logout();
                            context.go("/");
                          }),
                      const Text.bodyS("edit your account in the web app",
                          variant: TypeVariants.italic,
                          textAlign: TextAlign.center),
                    ].spaced(),
                  )
                : _LoginView()));
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
      onData: (bit, data) => Padded.all(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text.h6("you're not logged in", textAlign: TextAlign.center),
            const Text(
                "To create an account,\nplease visit the peertest.org website",
                textAlign: TextAlign.center),
            const Spaced(),
            Button.minor(icon: Icons.logIn, onTap: () => bit.login()),
            const Spaced(),
          ].spaced(),
        ),
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  final String? url;
  final double size;
  const UserIcon({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return Card(
      scheme: ColorSchemes.secondary,
      border: Border(
          borderRadius: BorderRadius.circular(context.rem(size)),
          pixelWidth: 0),
      width: size,
      height: size,
      child: url != null
          ? Image.network(url!)
          : Icon(Icons.user,
              style: size > 3 ? TypeStyles.bodyM : TypeStyles.bodyS),
    );
  }
}

class AccountSnippet extends StatelessWidget {
  const AccountSnippet({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
        onData: (bit, auth) => auth != null
            ? Card(
                border: Border.none,
                onTap: () => context.push("/account"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SparkleHero(),
                    Row(
                      children: [
                        UserIcon(url: auth.model.avatarURL, size: 3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(auth.model.name, variant: TypeVariants.bold),
                              Text(auth.model.email ?? ""),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevronRight),
                      ].spaced(),
                    ),
                  ].spaced(),
                ))
            : Card(
                onTap: () => bit.login(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logIn),
                    const Text("sign in"),
                  ].spaced(),
                ),
              ));
  }
}

class _SparkleHero extends StatelessWidget {
  const _SparkleHero({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
        onData: (aBit, auth) => auth == null
            ? Spaced.zero
            : BitBuildProvider(
                create: (_) => BeakersBit(auth.id),
                onData: (bit, int beakers) {
                  return Card(
                    border: Border.none,
                    color: Colors.transparent,
                    style: ColorStyles.action,
                    child: InkWell(
                        onTap: () {
                          context.elbeBottomSheet(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text.h5("Beakers"),
                              Text(
                                "These are the rewards you've earned for testing other peoples apps. You can use them to publish your own apps.\n\nTest an app for a set number of days to earn one Beaker.",
                              ),
                            ].spaced(),
                          ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padded.only(
                              bottom: .25,
                              child: const Icon(Icons.flaskConical,
                                  style: TypeStyles.h1),
                            ),
                            Text.h1(
                              "$beakers",
                              resolvedStyle: const TypeStyle(
                                  fontSize: 2.5, variant: TypeVariants.bold),
                            )
                          ].spaced(amount: .5),
                        )),
                  );
                }));
  }
}
