import 'package:elbe/elbe.dart';
import 'package:peer_app/bit/b_auth.dart';

import '../app_config.dart';
import '../bit/b_test.dart';
import '../model/m_app.dart';
import '../util.dart';

class TestModal extends StatelessWidget {
  final AppModel app;
  const TestModal({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return AuthBit.builder(
        onData: (_, auth) => auth == null
            ? const Text("login to test")
            : TestBit.buildProvider(
                app: app,
                userId: auth.id,
                onData: (bit, t) => AppFocusObserver(
                    onChange: bit.onFocusChange,
                    child: t.isRunning
                        ? _runningView(context)
                        : t.isCompleted
                            ? _CompletedView(bit: bit)
                            : _tooShortView(context)),
              ));
  }
}

class _CompletedView extends StatefulWidget {
  final TestBit bit;
  const _CompletedView({super.key, required this.bit});

  @override
  State<_CompletedView> createState() => _CompletedViewState();
}

class _CompletedViewState extends State<_CompletedView> {
  final _feedbackController = TextEditingController();
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padded.all(child: const Icon(Icons.check)),
          const Text.h6("provide feedback:"),
          TextField(
              controller: _feedbackController,
              onChanged: (v) => setState(() => isEmpty = v.isEmpty),
              minLines: 2,
              maxLines: 3,
              decoration: elbeTextDeco(context, "your feedback")),
          Button.minor(
              icon: Icons.send,
              label: "submit",
              onTap: isEmpty
                  ? null
                  : () async {
                      final dynamic c = context;
                      final suc =
                          await widget.bit.submit(_feedbackController.text);
                      if (suc) Navigator.of(c).maybePop();
                      c.showToast("could not submit feedback");
                    })
        ].spaced(),
      );
}

Widget _runningView(BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const Text.bodyM("opening the app")
      ].spaced(),
    );

Widget _tooShortView(BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padded.all(child: const Icon(Icons.searchCode)),
        const Text.h6("test too short"),
        Text(
            "Please take your time. The test should take at least ${appConfig.testMinSec} seconds.",
            textAlign: TextAlign.center),
        const Spaced(height: .5),
        Button.action(
            label: "close", onTap: () => Navigator.of(context).maybePop())
      ].spaced(amount: .5),
    );
