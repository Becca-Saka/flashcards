import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

abstract class ILocalStorage {
  Future<void> init();

  /// Create
  Future<void> add(String key, {required dynamic value});

  /// Read
  T? get<T>(String key, {T? def});

  /// Delete
  Future<void> delete(String key);

  Future<int?> clear();
}

// TODO: Throw Errors when errors occur
class LocalStorageService implements ILocalStorage {
  static const boxName = 'FlashCards Storage';
  final _log = Logger();

  Box get _box => Hive.box(boxName);

  @override
  Future<void> init() async {
    final storageDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(storageDir.path);
    await Hive.openBox(boxName);
    _log.i('Local storage service initialized');
  }

  @override
  Future<void> add(String key, {required dynamic value}) async {
    try {
      return await _box.put(key, jsonEncode(value));
    } catch (e) {
      _log.e(e);
      return;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _box.delete(key);
    } catch (e) {
      _log.e(e);
    }
  }

  @override
  T? get<T>(String key, {T? def}) {
    try {
      final res = jsonDecode(_box.get(key)) as T?;
      return res ?? def;
    } catch (e) {
      _log.e(e);
      return null;
    }
  }

  @override
  Future<int?> clear() async {
    try {
      return await _box.clear();
    } catch (e) {
      _log.e(e);
      return null;
    }
  }
}

class StorageKeys {
  StorageKeys._();

  static const String collections = 'collections';
  static String collectionAssets(String collectionId) =>
      'collection/$collectionId';
  static String questions(String collectionId) => 'questions/$collectionId';
}
