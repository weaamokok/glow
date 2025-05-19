import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:glow/app/local_db.dart';
import 'package:glow/domain/glow.dart';
import 'package:sembast/sembast.dart';

class CalendarDeps {
  static final scheduleProvider = FutureProvider<GlowSchedule?>(
    (ref) async {
      final store = StoreRef.main();
      final schedule = await store
          .record(DbKeys.glowSchedule)
          .get(await LocalDB.db) as Map<String, dynamic>?;

      if (schedule == null) return null;
      return GlowSchedule.fromMap(schedule);
    },
  );
}
