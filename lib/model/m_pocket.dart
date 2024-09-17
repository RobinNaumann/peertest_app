import 'package:elbe/util/json_tools.dart';
import 'package:elbe/util/m_data.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseModel extends DataModel {
  final String id;
  final int updated;
  final int created;
  final String collection;

  @override
  JsonMap get map => {
        "id": id,
        "updated": updated,
        "created": created,
        "collection": collection,
      };

  PocketBaseModel.fromMap(JsonMap map)
      : id = map["id"],
        updated = map["updated"],
        created = map["created"],
        collection = map["collection"];

  String? fileURL(String? key) {
    return key != null && key.isNotEmpty
        ? "https://pocket.robbb.in/api/files/$collection/$id/$key"
        : null;
  }
}

abstract class PocketModel extends DataModel {
  /// only defined once the model is persisted online
  final PocketBaseModel? base;

  const PocketModel() : base = null;

  PocketModel.fromMap(JsonMap? map)
      : base = map != null ? PocketBaseModel.fromMap(map) : null;

  @override
  JsonMap get map => base?.map ?? {};
}

extension ReqToMap on RecordModel {
  JsonMap get jsonMap => {
        ...data,
        "expand": expand,
        "id": id,
        "updated": DateTime.parse(updated).millisecondsSinceEpoch,
        "created": DateTime.parse(created).millisecondsSinceEpoch,
        "collection": collectionId,
      };
}

extension MaybeExpand on JsonMap {
  T? maybeExpand<T>(String key, T? Function(JsonMap) parser) {
    try {
      if (!containsKey("expand") || this["expand"] == null) return null;
      final exp = this["expand"] as JsonMap;
      if (!exp.containsKey(key) || exp[key] == null) return null;
      final es = exp[key] as List<RecordModel>;
      if (es.isEmpty) return null;
      return parser(es.first.jsonMap);
    } catch (e) {
      return null;
    }
  }
}
