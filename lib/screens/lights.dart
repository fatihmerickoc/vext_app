import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/styles/styles.dart';

class Lights extends ConsumerStatefulWidget {
  const Lights({super.key});

  @override
  ConsumerState<Lights> createState() => _LightsState();
}

class _LightsState extends ConsumerState<Lights> {
  Widget _interactiveSlide(double initialValue) {
    return InteractiveSlider(
        unfocusedOpacity: 1,
        unfocusedHeight: 30,
        focusedHeight: 50,
        focusedMargin: const EdgeInsets.symmetric(horizontal: 10),
        unfocusedMargin: const EdgeInsets.symmetric(horizontal: 10),
        initialProgress: initialValue,
        foregroundColor: Styles.yellow,
        backgroundColor: Colors.white,
        min: 0.0,
        max: 100.0,
        onChanged: (value) async {
          ref.read(vextNotifierProvider.notifier).updateLights(value.round());
        });
  }

  @override
  Widget build(BuildContext context) {
    final updatedVext = ref.watch(vextNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lights',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              updatedVext.vext_lightBrightness.toString(),
              style: Styles.title_text,
            ),
            _interactiveSlide(updatedVext.vext_lightBrightness.toDouble()),
          ],
        ),
      ),
    );
  }
}
