import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:sembast/sembast.dart';

import '../../app/local_db.dart';

class PromptCreatorDeps {
  static final addPromptImagesProvider =
      StateProviderFamily<Future<bool>, List<File?>>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();
      try {
        await store
            .record(
              DbKeys.userImages,
            )
            .put(LocalDB.db, arg)
            .then(
          (value) {
            print('images added ');
          },
        );
      } catch (e) {
        print('error adding images-->$e');
        return false;
      }
      return true;
    },
  );
}
