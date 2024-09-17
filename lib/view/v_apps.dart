import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_apps.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/v_app.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        title: "available apps", child: BaseList(children: [AppsList()]));
  }
}

class AppsList extends StatelessWidget {
  const AppsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
        create: (_) => AppsBit(),
        child: AppsBit.builder(
            onData: (bit, data) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("sort"),
                        DropdownButton(
                            borderRadius:
                                BorderRadius.circular(context.rem(.5)),
                            alignment: AlignmentDirectional.centerEnd,
                            value: data.sortBy,
                            icon: Padded.only(
                                left: .5,
                                child: const Icon(Icons.arrowDownWideNarrow)),
                            underline: Container(),
                            items: const [
                              DropdownMenuItem(
                                  value: "-updated", child: Text("updated")),
                              DropdownMenuItem(
                                  value: "name", child: Text("name")),
                            ],
                            onChanged: (v) => bit.sort(v ?? "-updated")),
                      ],
                    ),
                    ...data.apps.map((e) => _AppSnippet(app: e)).toList(),
                    if (data.nextPage != null)
                      Button.action(
                        onTap: () => bit.loadNextPage(),
                        label: "load more",
                      )
                  ].spaced(),
                )));
  }
}

class _AppSnippet extends StatelessWidget {
  final AppModel app;
  const _AppSnippet({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Card(
        //style:  ColorStyles.minorAlertWarning,
        onTap: () => context.push('/app/${app.base?.id}'),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AppIcon(app: app, size: 3.5),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text.bodyL(app.name,
                                  variant: TypeVariants.bold)),
                          if (app.urlJoin == null)
                            const Icon(Icons.alertTriangle)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text.bodyS(app.account?.name ?? "")),
                          Text.bodyS(maybeDateString(app.base?.updated) ?? ""),
                        ],
                      ),
                    ],
                  )),
                ].spaced(),
              ),
            ].spaced()));
  }
}
