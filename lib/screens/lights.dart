import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/styles/styles.dart';

Timer? _debounce;

class Lights extends ConsumerStatefulWidget {
  const Lights({super.key});

  @override
  ConsumerState<Lights> createState() => LightsState();
}

class LightsState extends ConsumerState<Lights> {
  double _sliderValue = 0;

  TimeOfDay _turnOnAt = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _turnOffAt = const TimeOfDay(hour: 0, minute: 0);

  Future<void> _showTimePicker(bool isTurningOn) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isTurningOn ? _turnOnAt : _turnOffAt,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (selectedTime != null) {
      setState(() {
        if (isTurningOn) {
          _turnOnAt = selectedTime;
        } else {
          _turnOffAt = selectedTime;
        }
      });

      ref.read(vextNotifierProvider.notifier).updateTimes(
            timeOfDayToMilliseconds(_turnOnAt),
            timeOfDayToMilliseconds(_turnOffAt),
          );
    }
  }

  Widget _timePickerButton(String value, bool isFrom) {
    return InkWell(
      onTap: () => _showTimePicker(isFrom),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Text(
              isFrom
                  ? _turnOnAt.format(context).toString()
                  : _turnOffAt.format(context).toString(),
              style: Styles.drawer_text,
            ),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  Widget _timeSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'From',
          style: Styles.subtitle_text,
        ),
        _timePickerButton('6:00', true),
        Styles.height_10,
        const Text(
          'To',
          style: Styles.subtitle_text,
        ),
        _timePickerButton('22:00', false),
      ],
    );
  }

  Widget _slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 25,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: _sliderValue,
        inactiveColor: Colors.grey.shade200,
        activeColor: Styles.orange,
        thumbColor: Colors.white,
        min: 0.0,
        max: 100.0,
        divisions: 4,
        onChanged: (value) async {
          setState(() {
            _sliderValue = value;
          });
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 100), () {
            ref.read(vextNotifierProvider.notifier).updateLights(value.round());
          });
        },
      ),
    );
  }

  Widget _buildContainer(
      {required double height,
      required List<Widget> children,
      double borderRadius = 30.0,
      EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
      CrossAxisAlignment cross = CrossAxisAlignment.start}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Styles.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Column(crossAxisAlignment: cross, children: children),
    );
  }

  AlertDialog _infoDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        'WHY?',
        style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
      ),
      content: const Text(
        'The right amount of light helps plants reach their full potential and stay healthy. Giving you better results, and more to harvest!',
        style: Styles.body_text,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            'Done',
            style: Styles.subtitle_text,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final updatedVext = ref.watch(vextNotifierProvider);
    _turnOffAt = millisecondsToTimeOfDay(updatedVext.vext_turnOffTime);
    _turnOnAt = millisecondsToTimeOfDay(updatedVext.vext_turnOnTime);
    _sliderValue = updatedVext.vext_lightBrightness.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lights', style: Styles.appBar_text),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Column(
            children: [
              _buildContainer(
                height: 160,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Schedule',
                        style: Styles.drawer_text
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (context) => _infoDialog(),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Aim for 14-16 hours of light each day',
                    style: Styles.body_text,
                  ),
                  const Spacer(),
                  _timeSelectionRow(),
                ],
              ),
              Styles.height_15,
              _buildContainer(
                height: 150,
                children: [
                  Text(
                    'Brightness',
                    style: Styles.drawer_text
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text('Currently at ${updatedVext.vext_lightBrightness}%',
                      style: Styles.body_text),
                  const Spacer(),
                  _slider(),
                ],
              ),
              Styles.height_15,
            ],
          ),
        ),
      ),
    );
  }

  int timeOfDayToMilliseconds(TimeOfDay timeOfDay) {
    int totalMinutes = timeOfDay.hour * 60 + timeOfDay.minute;
    int totalMilliseconds = totalMinutes * 60 * 1000;
    return totalMilliseconds;
  }

  TimeOfDay millisecondsToTimeOfDay(int milliseconds) {
    int totalMinutes = milliseconds ~/ (60 * 1000);
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
