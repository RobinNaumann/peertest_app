import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/util.dart';

class LoginPage extends StatelessWidget {
  final AuthBit bit;
  const LoginPage({super.key, required this.bit});

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
                    children: const [
                      Icon(Icons.handMetal),
                      Text.h1("welcome", textAlign: TextAlign.center),
                      Text(
                          "log into your peerTest.org account\nto start testing apps",
                          textAlign: TextAlign.center)
                    ].spaced())),
            Button.major(
                icon: Icons.logIn, label: "login", onTap: () => bit.login()),
            Button.integrated(
                label: "login with email",
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      final email = TextEditingController();
                      final password = TextEditingController();
                      return AlertDialog(
                          backgroundColor: context.theme.color.activeLayer.back,
                          surfaceTintColor:
                              context.theme.color.activeLayer.back,
                          title: const Text.h4("login with email"),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      style: ColorStyles.minorAlertInfo,
                                      child: Row(
                                        children: const [
                                          Icon(Icons.info),
                                          Expanded(
                                            child: Text(
                                              "this only works for existing accounts",
                                            ),
                                          )
                                        ].spaced(),
                                      ),
                                    ),
                                    TextField(
                                      controller: email,
                                      decoration:
                                          elbeTextDeco(context, "email"),
                                    ),
                                    TextField(
                                      controller: password,
                                      decoration:
                                          elbeTextDeco(context, "password"),
                                    ),
                                  ].spaced()),
                            ),
                          ),
                          actions: [
                            Button.major(
                                label: "login",
                                onTap: () {
                                  bit.loginWithEmail(email.text, password.text);
                                  Navigator.pop(context);
                                })
                          ]);
                    })),
          ]),
        ));
  }
}
