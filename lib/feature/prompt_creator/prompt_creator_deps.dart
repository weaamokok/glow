import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:sembast/sembast.dart';

import '../../app/local_db.dart';
import 'image_picker_step.dart';

class PromptCreatorDeps {
  static final addPromptImagesProvider =
      StateProviderFamily<Future<bool>, List<File?>>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();
      print('images -$arg');
      final imagesAsUnit8List = arg.map(
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
  static final promptCreatorStepProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      ref.keepAlive();

      return useState(0);
    },
  );
  static final promptImagesProvider = ChangeNotifierProvider(
    (ref) {
      return useState<List<File?>>(
          List.filled(UserImagesTypes.values.length, null, growable: true));
    },
  );

  static final promptProgressProvider = ChangeNotifierProvider(
    (ref) {
      return useState(0.0);
    },
  );
}
