import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/styles/styles.dart';

Timer? _debounce;

class Lights extends ConsumerStatefulWidget {
  const Lights({super.key});

  @override
  ConsumerState<Lights> createState() => _LightsState();
}

class _LightsState extends ConsumerState<Lights> {
  double _slidervalue = 0;
  TimeOfDay _turnOnAt = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _turnOffAt = const TimeOfDay(hour: 22, minute: 0);

  void _showTimePicker(bool isTurningOn) {
    showTimePicker(
            context: context, initialTime: isTurningOn ? _turnOnAt : _turnOffAt)
        .then((value) {
      if (isTurningOn) {
        setState(() {
          _turnOnAt = value!;
        });
        ref.watch(vextNotifierProvider.notifier).updateTimes(
            timeOfDayToMilliseconds(_turnOnAt),
            timeOfDayToMilliseconds(_turnOffAt));
      } else {
        setState(() {
          _turnOffAt = value!;
        });
        ref.watch(vextNotifierProvider.notifier).updateTimes(
            timeOfDayToMilliseconds(_turnOnAt),
            timeOfDayToMilliseconds(_turnOffAt));
      }
    });
  }

  Widget _lightsTile(String title, svgIcon, bool isTurnedOn) {
    return InkWell(
      onTap: () {
        _showTimePicker(isTurnedOn);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
            color: Styles.yellow,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: Styles.title_text.copyWith(fontWeight: FontWeight.w300),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Styles.yellow,
                ),
              ),
              child: Text(
                isTurnedOn
                    ? _turnOnAt.format(context).toString()
                    : _turnOffAt.format(context).toString(),
                style: Styles.title_text.copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            SvgPicture.asset(svgIcon)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _interactiveSlide() {
    return InteractiveSlider(
      unfocusedOpacity: 1,
      unfocusedHeight: 30,
      focusedHeight: 50,
      padding: EdgeInsets.zero,
      unfocusedMargin: const EdgeInsets.symmetric(horizontal: 0),
      initialProgress: _slidervalue,
      foregroundColor: Styles.yellow,
      backgroundColor: Colors.white,
      min: 0.0,
      max: 100.0,
      onChanged: (value) async {
        setState(() {
          _slidervalue = value;
        });
        // Debounce the API call
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          ref.watch(vextNotifierProvider.notifier).updateLights(value.round());
        });
      },
    );
  }

  int timeOfDayToMilliseconds(TimeOfDay timeOfDay) {
    int totalMinutes = timeOfDay.hour * 60 + timeOfDay.minute;
    int totalMilliseconds = totalMinutes * 60 * 1000;
    return totalMilliseconds;
  }

  TimeOfDay millisecondsToTimeOfDay(int milliseconds) {
    int totalMinutes =
        milliseconds ~/ (60 * 1000); // Convert milliseconds to minutes
    int hours = totalMinutes ~/ 60; // Extract hours
    int minutes = totalMinutes % 60; // Extract remaining minutes
    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  Widget build(BuildContext context) {
    final updatedVext = ref.watch(vextNotifierProvider);
    _turnOffAt = millisecondsToTimeOfDay(updatedVext.vext_turnOffTime);
    _turnOnAt = millisecondsToTimeOfDay(updatedVext.vext_turnOnTime);
    _slidervalue = updatedVext.vext_lightBrightness.toDouble();
    print("BRIGHTNESS: ${updatedVext.vext_lightBrightness.toDouble()}");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lights',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Light Schedule',
                style: Styles.title_text.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                'Aim for 14 - 16 hours of light each day',
                style: Styles.body_text.copyWith(fontWeight: FontWeight.w300),
              ),
              Styles.height_20,
              _lightsTile('Turn on at', 'assets/sunrise.svg', true),
              Styles.height_20,
              _lightsTile('Turn off at', 'assets/sunset.svg', false),
              Styles.height_30,
              const Text(
                '16 hours is plenty of light!',
                style: Styles.title_text,
              ),
              Styles.height_30,
              const Text(
                'Why is light so important',
                style: Styles.title_text,
              ),
              Text(
                'The right amount of light helps plants reach\ntheir full potential and stay healthy. Giving you better results, and more to harvest!',
                style: Styles.body_text.copyWith(fontWeight: FontWeight.w300),
              ),
              Styles.height_50,
              Text(
                "Brightness: ${updatedVext.vext_lightBrightness.toString()}%",
                style: Styles.title_text,
              ),
              _interactiveSlide(),
            ],
          ),
        ),
      ),
    );
  }
}
