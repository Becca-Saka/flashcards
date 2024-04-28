import 'package:flashcards/data/services/local_storage_service.dart';

import '../../model/collections_model.dart';

abstract class ICollectionService {
  Future<void> createCollection(CollectionModel collection);

  Future<void> deleteCollection(String collectionId);

  List<CollectionModel> get collections;

  Future<void> addAssetsToCollection(
    String collectionId,
    List<CollectionAssetModel> assets,
  );

  Future<void> removeAssetsFromCollection(
    String collection,
    CollectionAssetModel asset,
  );
}

class ApiCollectionService implements ICollectionService {
  final ILocalStorage _localStorage = LocalStorageService();

  /// Fetches the collections from the local storage. If there are no collections
  /// stored, an empty list is returned. Adds the new collection to the list of
  /// collections and stores it in the local storage.
  ///
  /// Throws an exception if the collection cannot be created.
  @override
  Future<void> createCollection(CollectionModel collection) async {
    try {
      var collections = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.collections,
        def: [],
      );
      collections ??= [];
      collections.add(collection.toMap());
      await _localStorage.add(StorageKeys.collections, value: collections);
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
      var collections = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.collections,
        def: [],
      );
      collections ??= [];
      if (collections.isEmpty) return;
      collections.removeWhere(
        (item) => CollectionModel.fromMap(item).id == collectionId,
      );
      await _localStorage.add(StorageKeys.collections, value: collections);
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
      var collections = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.collections,
        def: [],
      );
      collections ??= [];
      return collections.map((item) => CollectionModel.fromMap(item)).toList();
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
  Future<void> addAssetsToCollection(
    String collectionId,
    List<CollectionAssetModel> assets,
  ) async {
    try {
      var storedAssets = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.collectionAssets(collectionId),
        def: [],
      );
      storedAssets ??= [];
      storedAssets.addAll(assets.map((asset) => asset.toMap()));
      await _localStorage.add(StorageKeys.collections, value: storedAssets);
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
  Future<void> removeAssetsFromCollection(
    String collection,
    CollectionAssetModel asset,
  ) async {
    try {
      var storedAssets = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.collectionAssets(collection),
        def: [],
      );
      storedAssets ??= [];
      storedAssets.removeWhere(
        (item) => CollectionAssetModel.fromMap(item).id == asset.id,
      );
      await _localStorage.add(StorageKeys.collections, value: storedAssets);
    } on Exception catch (e) {
      throw Exception('Failed to remove assets from collection: $e');
    }
  }
}
