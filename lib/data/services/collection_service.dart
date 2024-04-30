import 'package:flashcards/data/services/local_storage_service.dart';

import '../../model/collection_file.dart';
import '../../model/collection_model.dart';

abstract class ICollectionService {
  Future<void> createCollection(CollectionModel collection);

  Future<void> deleteCollection(String collectionId);

  List<CollectionModel> get collections;

  Future<CollectionModel> addAssetsToCollection(
    String collectionId,
    List<CollectionFile> assets,
  );

  Future<CollectionModel> removeAssetsFromCollection(
    String collectionId,
    CollectionFile asset,
  );
}

class CollectionService implements ICollectionService {
  final ILocalStorage _localStorage = LocalStorageService();

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned. Adds the new collection to the list of
  /// collections and stores it in the local storage.
  ///
  /// Throws an exception if the collection cannot be created.
  @override
  Future<void> createCollection(CollectionModel collection) async {
    try {
      var collections = this.collections;
      collections.add(collection);
      await _localStorage.add(
        StorageKeys.collections,
        value: collections.map((e) => e.toMap()).toList(),
      );
    } on Exception catch (e) {
      throw Exception('Failed to create collection: $e');
    }
  }

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned. Removes the collection with the given
  /// [collectionId] from the list of collections and stores the updated list in
  /// the local storage.
  ///
  /// Throws an exception if the collection cannot be deleted.
  @override
  Future<void> deleteCollection(String collectionId) async {
    try {
      var collections = this.collections;
      if (collections.isEmpty) return;
      collections.removeWhere((item) => item.uid == collectionId);
      await _localStorage.add(
        StorageKeys.collections,
        value: collections.map((e) => e.toMap()).toList(),
      );
    } on Exception catch (e) {
      throw Exception('Failed to delete collection: $e');
    }
  }

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned.
  ///
  /// Returns a list of [CollectionModel] objects.
  @override
  List<CollectionModel> get collections {
    try {
      var collections = _localStorage.get<List>(
        StorageKeys.collections,
        def: [],
      );
      collections ??= [];
      return collections.map((item) => CollectionModel.fromMap(item)).toList();
    } on Exception {
      return [];
    }
  }

  List<CollectionFile> getCollectionAssets(String collectionId) {
    try {
      var storedAssets = _localStorage.get<List>(
        StorageKeys.collectionAssets(collectionId),
        def: [],
      );
      storedAssets ??= [];
      return storedAssets.map((item) => CollectionFile.fromMap(item)).toList();
    } on Exception {
      return [];
    }
  }

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned. Adds the new assets to the list of
  /// assets for the collection with the given [collectionId] and stores the
  /// updated list in the local storage.
  ///
  /// Throws an exception if the assets cannot be added to the collection.
  @override
  Future<CollectionModel> addAssetsToCollection(
    String collectionId,
    List<CollectionFile> assets,
  ) async {
    try {
      var collections = this.collections;
      final index = collections.indexWhere((e) => e.uid == collectionId);
      final files = collections[index].files;

      collections[index] =
          collections[index].copyWith(files: files..addAll(assets));

      await _localStorage.add(
        StorageKeys.collections,
        value: collections.map((e) => e.toMap()).toList(),
      );
      return collections[index];
    } on Exception catch (e) {
      throw Exception('Failed to add assets to collection: $e');
    }
  }

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned. Removes the asset that matches the given
  /// [asset] from the list of assets for the collection with the given [collection]
  /// and stores the updated list in the local storage.
  ///
  /// Throws an exception if the assets cannot be removed from the collection.
  @override
  Future<CollectionModel> removeAssetsFromCollection(
    String collectionId,
    CollectionFile asset,
  ) async {
    try {
      var collections = this.collections;
      final index = collections.indexWhere((e) => e.uid == collectionId);
      final files = collections[index].files;

      collections[index] = collections[index].copyWith(
        files: files..removeWhere((file) => file.id == asset.id),
      );

      await _localStorage.add(
        StorageKeys.collections,
        value: collections.map((e) => e.toMap()).toList(),
      );
      return collections[index];
    } on Exception catch (e) {
      throw Exception('Failed to remove assets from collection: $e');
    }
  }
}
