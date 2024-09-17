import 'package:elbe/elbe.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/model/m_pocket.dart';
import 'package:peer_app/service/s_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/s_pocket.dart';

class AuthState {
  final String id;
  final UserModel model;

  AuthState(this.id, this.model);
}

class AuthBit extends MapMsgBitControl<AuthState?> {
  static const builder = MapMsgBitBuilder<AuthState?, AuthBit>.make;

  AuthBit()
      : super.worker((_) async {
          final pb = PocketService.i.pb;

          final auth = StorageService.i.auth;
          if (auth == null) return null;
          pb.authStore.save(auth.token, auth.id);

          if (!pb.authStore.isValid) return null;
          return AuthState(auth.id, await _getUser(auth.id));
        });

  void login() async {
    final pb = PocketService.i.pb;
    await pb.collection("users").authWithOAuth2('google', (url) async {
      await launchUrl(url);
    });

    StorageService.i.setAuth(pb.authStore.token, pb.authStore.model.id);
    reload();
  }

  void blockUser(String userId) async {
    state.whenData((data) async {
      if (data == null) return;
      final pb = PocketService.i.pb;
      await pb.collection("users").update(data.id, body: {
        "blocked": [...data.model.blocked ?? [], userId]
      });
      reload();
    });
  }

  void logout() {
    PocketService.i.pb.authStore.clear();
    StorageService.i.setAuth(null);
    reload();
  }
}

Future<UserModel> _getUser(String userId) async {
  final pb = PocketService.i.pb;
  final res = await pb.collection("users").getOne(userId);
  return UserModel.fromMap(res.jsonMap);
}
