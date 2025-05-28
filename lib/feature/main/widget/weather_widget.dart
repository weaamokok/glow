import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/domain/weather.dart';
import 'package:glow/feature/home/home_deps.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../helper/helper_functions.dart';

class WeatherSummaryWidget extends ConsumerWidget {
  const WeatherSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(HomeDeps.weatherProvider);
    print(weather);
    if (weather.hasError) return SizedBox();
    return Skeletonizer(
        containersColor: Colors.white.withValues(alpha: .67),
        effect: ShimmerEffect(
            baseColor: Colors.white.withValues(alpha: .46),
            highlightColor: Colors.white.withValues(alpha: .67)),
        textBoneBorderRadius:
            TextBoneBorderRadius(BorderRadius.all(Radius.circular(3))),
        enabled: weather.isLoading,
        child: WeatherWidget(weatherResponse: weather.value));
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.weatherResponse});

  final WeatherResponse? weatherResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${weatherResponse?.main?.temp}°C',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
                getEmojiFromIconId(weatherResponse?.weather?.firstOrNull?.icon))
          ],
        ),
        Text(
          '${weatherResponse?.weather?.firstOrNull?.description}',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          '${weatherResponse?.name}',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
