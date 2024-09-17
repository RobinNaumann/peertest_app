import 'dart:async';

import 'package:moewe/moewe.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketService {
  final pb = PocketBase('https://pocket.robbb.in');
  late final RecordAuth user;
  static final PocketService i = PocketService._();
  PocketService._();

  Future<void> createMany<T>(String collection, List<T> elements,
      JsonMap Function(T) serialize) async {
    for (final e in elements) {
      await pb.collection('briefchen_letter').create(body: serialize(e));
    }
  }

  Future<List<T>> list<T>(String collection, T Function(JsonMap) deserial,
      {String? filter, String? sort, String? expand}) async {
    final result = await pb
        .collection(collection)
        .getList(perPage: 1000, filter: filter, sort: sort, expand: expand);
    return result.items.map((e) {
      final m = {
        ...e.data,
        "id": e.id,
        "updated": e.updated,
        "created": e.created,
        "collection": e.collectionId,
      };
      return deserial(m);
    }).toList();
  }

  Future<void> set<T>(
    String collection,
    String? id,
    T element,
    JsonMap Function(T) serialize,
  ) async {
    if (id == null) {
      await pb.collection(collection).create(body: serialize(element));
    } else {
      await pb.collection(collection).update(id, body: serialize(element));
    }
  }
}
