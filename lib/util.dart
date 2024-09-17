import 'package:elbe/elbe.dart';

/// return the current time in milliseconds
int now() => DateTime.now().millisecondsSinceEpoch;

/// return a string representation of a date. uses respective local format
String? maybeDateString(int? timestamp) {
  if (timestamp == null) return null;
  final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return "${d.day}.${d.month}.${d.year}";
}

class BaseList extends StatelessWidget {
  final List<Widget> children;
  final double padding;
  const BaseList({super.key, required this.children, this.padding = 1.5});

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: context.rem(padding)),
        child: ListView(
          clipBehavior: Clip.none,
          children: [const Spaced(), ...children, Spaced.vertical(padding)],
        ));
  }
}

class AppFocusObserver extends StatefulWidget {
  final Widget child;
  final Function(bool) onChange;
  const AppFocusObserver(
      {super.key, required this.onChange, required this.child});

  @override
  State<AppFocusObserver> createState() => _AppFocusObserverState();
}

class _AppFocusObserverState extends State<AppFocusObserver>
    with WidgetsBindingObserver {
  AppLifecycleState? _current;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _current = state;
      widget.onChange(state == AppLifecycleState.resumed);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  build(BuildContext context) => widget.child;
}

InputDecoration elbeTextDeco(BuildContext context, String? hint) =>
    InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
            vertical: context.rem(1), horizontal: context.rem(1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                context.theme.geometry.border.borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(
                color: context.theme.color.activeLayer.border,
                width: context.theme.geometry.border.pixelWidth ?? 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              context.theme.geometry.border.borderRadius ?? BorderRadius.zero,
          borderSide: BorderSide(
              color: context.theme.color.activeLayer.border,
              width: (context.theme.geometry.border.pixelWidth ?? 1) * 2),
        ));

extension ElbeBottomSheet on BuildContext {
  Future<void> elbeBottomSheet(
          {ColorSchemes scheme = ColorSchemes.secondary,
          RemInsets padding = const RemInsets.all(1.5),
          required Widget child}) =>
      showModalBottomSheet(
          isScrollControlled: true,
          context: this,
          builder: (context) => AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: BottomSheet(
                  clipBehavior: Clip.hardEdge,
                  onClosing: () {},
                  builder: (_) => Box(
                      constraints:
                          const RemConstraints(minWidth: double.infinity),
                      border: Border.noneRect,
                      scheme: scheme,
                      child: Padded(padding: padding, child: child)))));
}

Future<bool> showConfirmDialog(BuildContext context,
    {required String title, required String message, Function()? ifYes}) async {
  return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text.h6(title),
                content: Text(message),
                actions: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Button.action(
                              label: "no",
                              onTap: () => Navigator.of(context).pop(false)),
                        ),
                        Expanded(
                          child: Button.action(
                              label: "yes",
                              onTap: () {
                                ifYes?.call();
                                Navigator.of(context).pop(true);
                              }),
                        )
                      ].spaced())
                ],
              ))) ??
      false;
}

extension GroupBy<T> on Iterable<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) key) {
    final res = <K, List<T>>{};
    for (final e in this) {
      final k = key(e);
      if (!res.containsKey(k)) res[k] = [];
      res[k]!.add(e);
    }
    return res;
  }
}
