import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

import '../../app/db_keys.dart';
import '../../app/local_db.dart';

class LocalStorageNotifier extends StateNotifier<void> {
  LocalStorageNotifier() : super(());
  var store = StoreRef.main();

  Future<bool> saveUserImages({required List<File?> images}) async {
    //add image to local

    final imagesAsUnit8List = images.map(
      (e) {
        return e?.readAsBytesSync();
      },
    ).toList();
    try {
      await store
          .record(
            DbKeys.userImages,
          )
          .put(await LocalDB.db, imagesAsUnit8List)
          .then(
        (value) {
          debugPrint('image added successfully!');
        },
      );
    } catch (e) {
      debugPrint('failed to add image: $e');

      return false;
    }
    return true;
  }

  Future<List<File?>?> getUserImages() async {
    return await store.record(DbKeys.userImages).get(await LocalDB.db)
        as List<File?>;
  }
}
