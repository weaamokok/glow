import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

import '../../app/db_keys.dart';
import '../../app/local_db.dart';
import '../../domain/user.dart';

class ProfileDeps {
  static final updateProfile = ProviderFamily<Future<AsyncValue<User?>>, User>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();

      try {
        final user = await store
            .record(
              DbKeys.userProfile,
            )
            .put(await LocalDB.db, arg.toMap(), merge: true)
            .then(
          (value) {
            debugPrint('user info added successfully');
          },
        );
        ref.invalidate(userProfile);
        return AsyncValue.data(user);
        // print('post   ${arg}');
      } catch (e) {
        debugPrint('failed to add user info: $e');
        return AsyncValue.error(e, StackTrace.fromString(e.toString()));
      }
    },
  );
  static final userProfile = FutureProvider<User?>(
    (ref) async {
      var store = StoreRef.main();

      try {
        final user = await store
            .record(
              DbKeys.userProfile,
            )
            .get(
              await LocalDB.db,
            ) as Map<String, dynamic>?;
        print('user from provider $user');

        if (user == null) return null;
        return User.fromMap(user);
      } catch (e) {
        debugPrint('failed to retrieve user info: $e');
        return Future.error(e);
      }
    },
  );
}
