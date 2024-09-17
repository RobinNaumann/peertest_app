import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';
import 'package:peer_app/service/s_pocket.dart';
import 'package:peer_app/util.dart';

void reportApp(
  context, {
  required String? userId,
  required String? element,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _ReportPage(
        userId: userId,
        element: element,
        project: "peertest",
        collection: 'peertest_app',
        title: "App",
      ),
    ),
  );
}

void reportTest(
  context, {
  required String? userId,
  required String? element,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _ReportPage(
        userId: userId,
        element: element,
        project: "peertest",
        collection: 'peertest_testing',
        title: "Test",
      ),
    ),
  );
}

class _ReportPage extends StatefulWidget {
  final String project;
  final String collection;
  final String title;

  final String? userId;
  final String? element;

  const _ReportPage({
    super.key,
    required this.userId,
    required this.project,
    required this.collection,
    required this.element,
    required this.title,
  });

  @override
  State<_ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<_ReportPage> {
  final _description = TextEditingController();
  bool isEmpty = true;

  void sendReport(String uId) async {
    final pb = PocketService.i.pb;

    pb.collection("report").create(body: {
      "project": widget.project,
      "collection": widget.collection,
      "element": widget.element,
      "reported": widget.userId,
      "description": _description.text,
      "reporter": uId,
    }).then((_) {
      context.showToast("report sent");
      Navigator.pop(context);
    }, onError: (e) {
      context.showToast("error sending report");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        leadingIcon: const LeadingIcon.close(),
        title: "Report ${widget.title}",
        child: Padded.all(
          child: widget.userId == null || widget.element == "null"
              ? const Center(child: Text("Element not found"))
              : AuthBit.builder(
                  onData: (bit, auth) => auth == null
                      ? const Center(child: Text("login to report"))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                  children: [
                                const Text(
                                    "Thank you for helping us keep the community safe. We will review your report and take appropriate action. Please provide as much detail as possible."),
                                TextField(
                                    controller: _description,
                                    onChanged: (text) =>
                                        setState(() => isEmpty = text.isEmpty),
                                    maxLines: 5,
                                    decoration: elbeTextDeco(context,
                                        "provide a reason for your report")),
                              ].spaced()),
                            ),
                            Button.major(
                              icon: Icons.flag,
                              label: "Report",
                              onTap: isEmpty ? null : () => sendReport(auth.id),
                            ),
                          ],
                        ),
                ),
        ));
  }
}
