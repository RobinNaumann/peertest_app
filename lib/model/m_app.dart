import 'package:elbe/elbe.dart';
import 'package:elbe/util/json_tools.dart';
import 'package:peer_app/model/m_pocket.dart';

enum PlatformType {
  android(
    "Android",
    Icons.smartphone,
  ),
  ios(
    "iOS",
    Icons.phone,
  ),
  web(
    "Web",
    Icons.globe2,
  );

  const PlatformType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class AppModel extends PocketModel {
  final UserModel? account;
  final String name;
  final String description;
  final String? icon;
  final String deviceType;
  final String? urlDownload;
  final String? emailFeedback;
  final String? status;

  const AppModel({
    this.account,
    required this.name,
    required this.description,
    this.icon,
    required this.deviceType,
    this.urlDownload,
    this.emailFeedback,
    this.status,
  });

  PlatformType get platform => PlatformType.values.firstWhere(
      (e) => e.label.toLowerCase() == deviceType.toLowerCase(),
      orElse: () => PlatformType.web);

  String? get iconURL => base?.fileURL(icon);

  String? get packageId => urlDownload?.split("/").last.split("=").last;

  String? get urlJoin => urlDownload != null &&
          urlDownload!.startsWith("https://play.google.com/apps/testing/")
      ? urlDownload
      : null;

  @override
  JsonMap get map => {
        ...super.map,
        'account': account,
        'name': name,
        'description': description,
        'icon': icon,
        'device_type': deviceType,
        'url_download': urlDownload,
        'email_feedback': emailFeedback,
        'status': status,
      };

  AppModel.fromMap(JsonMap map, {bool offline = false})
      : account = map.maybeExpand("account", UserModel.fromMap),
        name = map['name'],
        description = map['description'],
        icon = map['icon'],
        deviceType = map['device_type'],
        urlDownload = map['url_download'],
        emailFeedback = map['email_feedback'],
        status = map['status'],
        super.fromMap(offline ? null : map);
}

class UserModel extends PocketModel {
  final String id;
  final String? email;
  final String name;
  final String? description;
  final String? homepage;
  final List<String>? blocked;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.description,
    this.homepage,
    this.blocked,
  });

  String? get avatarURL => base?.fileURL(avatar);

  @override
  JsonMap get map => {
        ...super.map,
        'id': id,
        'name': name,
        'avatar': avatar,
        'email': email,
        'description': description,
        'homepage': homepage,
        'blocked': blocked,
      };

  UserModel.fromMap(JsonMap map, {bool offline = false})
      : id = map['id'],
        email = map.maybeCast("email"),
        name = map['name'],
        avatar = map.maybeCast('avatar'),
        description = map.maybeCast('description'),
        homepage = map.maybeCast('homepage'),
        blocked = map.maybeCastList('blocked'),
        super.fromMap(offline ? null : map);
}
