import 'package:elbe/util/json_tools.dart';
import 'package:peer_app/model/m_app.dart';
import 'package:peer_app/model/m_pocket.dart';

class TestingModel extends PocketModel {
  final String account;
  final String app;
  final String device;
  final String feedback;
  final UserModel? accountModel;

  const TestingModel(
      {required this.account,
      required this.app,
      required this.device,
      required this.feedback,
      this.accountModel});

  TestingModel.fromMap(JsonMap map, {bool offline = false})
      : account = map["account"],
        app = map["app"],
        device = map["device"],
        feedback = map["feedback"],
        accountModel = map.maybeExpand("account", UserModel.fromMap),
        super.fromMap(offline ? null : map);

  @override
  get map => {
        ...super.map,
        "account": account,
        "app": app,
        "device": device,
        "feedback": feedback,
        "accountModel": accountModel?.map,
      };
}
