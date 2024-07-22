// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vext_app/providers/cabinet_provider.dart';
import 'package:vext_app/styles/styles.dart';

Timer? _debounce;

class Lights extends StatefulWidget {
  const Lights({super.key});

  @override
  State<Lights> createState() => LightsState();
}

class LightsState extends State<Lights> {
  double _sliderValue = 50;

  TimeOfDay _turnOnAt = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _turnOffAt = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    super.initState();
    //filled-later
    _turnOffAt = millisecondsToTimeOfDay(79200000);
    _turnOnAt = millisecondsToTimeOfDay(21600000);
  }

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

      //filled-later
      /*ref.read(vextNotifierProvider.notifier).updateTimes(
            timeOfDayToMilliseconds(_turnOnAt),
            timeOfDayToMilliseconds(_turnOffAt),
          );*/
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
            //filled-later
            //ref.read(vextNotifierProvider.notifier).updateLights(value.round());
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

  Widget _lightsInfoDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: Styles.title_text,
        ),
        content: Text(
          body,
          textAlign: TextAlign.start,
          style: Styles.body_text,
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'OK',
              style: TextStyle(color: Styles.darkGreen),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: Styles.title_text,
        ),
        content: Text(
          body,
          textAlign: TextAlign.start,
          style: Styles.body_text,
        ),
        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: Styles.darkGreen),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CabinetProvider cabinetProvider = Provider.of<CabinetProvider>(context);
    print("CabinetProvider: ${cabinetProvider.cabinet}");
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
                          builder: (context) => _lightsInfoDialog(
                            context: context,
                            title: 'Why?',
                            body:
                                'Plants need 14-16 hours of light daily because it gives them the energy to grow, stay healthy, and produce flowers or fruit. This light mimics natural sunlight, helping them thrive as they would in nature.',
                          ),
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
                  Text('Currently at fixed-later%', style: Styles.body_text),
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
