import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/domain/weather.dart';
import 'package:glow/feature/home/home_deps.dart';

import '../../../helper/helper_functions.dart';

class WeatherSummaryWidget extends ConsumerWidget {
  const WeatherSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather =
        ref.watch(HomeDeps.weatherProvider(Coord(lon: 5454, lat: 5454)));
    print(weather);
    return weather.map(
      data: (data) {
        if (!data.hasValue) return Text('empty');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.value?.main?.temp}°C',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(getEmojiFromIconId(data.value?.weather?.firstOrNull?.icon))
              ],
            ),
            Text(
              '${data.value?.weather?.firstOrNull?.description}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '${data.value?.name}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        );
      },
      loading: (data) => CircularProgressIndicator(),
      error: (data) => Text('Weather unavailable'),
    );
  }
}
