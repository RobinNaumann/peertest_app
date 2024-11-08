import 'package:elbe/elbe.dart';
import 'package:peer_app/util.dart';
import 'package:peer_app/view/bookmark/v_member_card.dart';

import '../../bit/b_bookmark.dart';
import '../../model/m_app.dart';

bool isBookmarked(StorageState state, String? id) {
  if (id == null) return false;
  return state.bookmarks.contains(id);
}

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageBit.builder(
        onData: (bit, data) => data.bookmarks.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spaced(),
                  const Text.h6("You're testing"),
                  for (final id in data.bookmarks)
                    MemberCard(
                        key: Key(id),
                        appId: id,
                        onRemove: () {
                          showConfirmDialog(context,
                              title: "remove App?",
                              message: "your tests will not be affected",
                              ifYes: () => bit.toggleBookmark(id));
                        }),
                  const Spaced()
                ].spaced(),
              )
            : Padded.symmetric(
                vertical: 3,
                child: const Center(
                  child: Text("Apps you're testing\nwill appear here",
                      textAlign: TextAlign.center),
                ),
              ));
  }
}

class BookmarkJoinButton extends StatelessWidget {
  final AppModel app;
  const BookmarkJoinButton({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return StorageBit.builder(onData: (bit, data) {
      final bookmarked = isBookmarked(data, app.base?.id);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          !bookmarked
              ? Button(
                  style: ColorStyles.minorAccent,
                  icon: Icons.bookmark,
                  label: "join test",
                  onTap: () => bit.toggleBookmark(app.base?.id))
              : MemberCard(
                  appId: app.base!.id,
                  onAppPage: true,
                  onRemove: () => bit.toggleBookmark(app.base?.id),
                ),
        ].spaced(),
      );
    });
  }
}
