import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vext_app/models/vext_model.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/styles/styles.dart';

class Water extends ConsumerStatefulWidget {
  const Water({super.key});

  @override
  ConsumerState<Water> createState() => _WaterState();
}

class _WaterState extends ConsumerState<Water> {
  // creates a box widget for displaying ingredient information
  Widget _box({
    int flex = 1,
    required Color color,
    required String title,
    required int value,
    required String measureValue,
  }) {
    return Expanded(
      flex: flex,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(15.0),
              child: Text(
                '$value$measureValue',
                textAlign: TextAlign.center,
                style: Styles.title_text.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Styles.title_text,
            ),
          ),
        ],
      ),
    );
  }

  // creates a ToggleSwitch widget for selecting plant stages
  Widget _plantStageList() {
    return ToggleSwitch(
      minWidth: 120,
      minHeight: 50,
      customTextStyles: const [Styles.body_text],
      initialLabelIndex: 0,
      totalSwitches: 3,
      inactiveBgColor: Styles.grey,
      activeBgColor: [Styles.muddyGreen],
      labels: const ['Seed', 'Growth', 'Mature'],
    );
  }

  // Creates an AlertDialog widget with information about plant stages
  AlertDialog _infoDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        'WHAT?',
        style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
      ),
      content: const Text(
        'Seed: Gentle light and nutrients for germination.\n\nGrowth: Increased light and nutrients for development.\n\nMature: Balanced care for fully grown plants.',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Column(
            children: [
              _buildIngredientBoxRow(updatedVext),
              Styles.height_15,
              _buildPlantStageContainer(),
              const Spacer(),
              _buildRefillNutrientsContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientBoxRow(VextModel updatedVext) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          _box(
            title: 'Water',
            measureValue: 'L',
            value: updatedVext.vext_waterLevel,
            color: Styles.waterColour,
            flex: 2,
          ),
          Styles.width_5,
          _box(
            title: 'A',
            measureValue: 'dL',
            value: 0,
            color: Styles.green,
          ),
          Styles.width_5,
          _box(
            title: 'B',
            measureValue: 'dL',
            value: 0,
            color: Styles.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildPlantStageContainer() {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Styles.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plant Stage',
                style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
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
          const Spacer(),
          _plantStageList(),
        ],
      ),
    );
  }

  Widget _buildRefillNutrientsContainer() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Text(
        'Refill nutrients',
        textAlign: TextAlign.center,
        style: Styles.body_text,
      ),
    );
  }
}
