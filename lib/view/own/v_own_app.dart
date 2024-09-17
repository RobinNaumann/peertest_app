import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/bit/b_own_testings.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/model/m_testing.dart';
import 'package:peer_app/util.dart';

import '../v_app.dart';

class OwnAppPage extends StatelessWidget {
  final AppModel app;
  const OwnAppPage({super.key, required this.app});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        title: app.name,
        child: BitBuildProvider(
            create: (_) => OwnTestingsBit(app.base!.id),
            onData: (bit, List<TestingModel> ts) => BaseList(
                    children: [
                  _overview(context, app, ts),
                  Padded.only(
                      top: 1, child: const Text.h5("feedback you received")),
                  _list(context, ts)
                ].spaced(amount: 2))));
  }
}

Widget _list(BuildContext context, List<TestingModel> ts) {
  return AuthBit.builder(
      onData: (aBit, auth) => auth == null
          ? Spaced.zero
          : () {
              final tests = ts.where(
                  (e) => !(auth.model.blocked ?? []).contains(e.account));
              return Column(
                  children: [
                for (final t in tests)
                  Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(t.accountModel?.name ?? t.account)),
                          Text(maybeDateString(t.base?.created) ?? ""),
                          if (auth.id != t.account)
                            IconButton.integrated(
                                icon: Icons.ban,
                                onTap: () {
                                  showConfirmDialog(context,
                                      title: "block user?",
                                      message:
                                          "do you want to block this user from testing your app? \n\nTHIS CAN NOT BE UNDONE! ",
                                      ifYes: () => aBit.blockUser(t.account));
                                })
                        ].spaced(),
                      ),
                      Text(t.feedback),
                    ].spaced(),
                  )),
                if (tests.isEmpty) const Text("no feedback yet")
              ].spaced());
            }());
}

Widget _overview(BuildContext context, AppModel app, List<TestingModel> ts) {
  final byUsers = ts.groupBy((e) => e.account);

  return SizedBox(
      height: context.rem(3.5),
      //scrollDirection: Axis.horizontal,
      child: ListView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          children: [
            AppIcon(app: app, size: 3.5),
            Card(
                child: Row(
                    children: [
              const Icon(Icons.files),
              Text("${ts.length} tests"),
            ].spaced(amount: .5))),
            Card(
                child: Row(
                    children: [
              const Icon(Icons.users),
              Text("${byUsers.keys.length} testers"),
            ].spaced(amount: .5))),
            Card(
                child: Row(
                    children: [
              const Icon(Icons.calendar),
              Text("latest: ${maybeDateString(ts.last.base?.created)}"),
            ].spaced(amount: .5))),
          ].spaced()));
}
