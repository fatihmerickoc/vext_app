import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/data/widget_data.dart';
import 'package:vext_app/models/vext_model.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/styles/styles.dart';

class Water extends ConsumerStatefulWidget {
  const Water({super.key});

  @override
  ConsumerState<Water> createState() => _WaterState();
}

class _WaterState extends ConsumerState<Water> {
  String selectedPlantStage = '';

  // creates a box widget for displaying ingredient information
  Widget _box({
    int flex = 1,
    required Color color,
    required double height,
    required String title,
    required double value,
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
            height: height,
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
                '${value.round()}',
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
      initialLabelIndex: _getInitialLabelIndex(selectedPlantStage),
      totalSwitches: 3,
      inactiveBgColor: Styles.grey,
      activeBgColor: const [Styles.muddyGreen],
      labels: const ['Seed', 'Growth', 'Mature'],
      onToggle: (index) {
        switch (index) {
          case 0:
            selectedPlantStage = 'Seed';
            break;
          case 1:
            selectedPlantStage = 'Growth';
            break;
          case 2:
            selectedPlantStage = 'Mature';
            break;
          default:
            selectedPlantStage = 'Seed';
        }
        ref
            .read(vextNotifierProvider.notifier)
            .updatePlantStage(selectedPlantStage);
      },
    );
  }

  // This method calculates and returns the initial index of the label based on the provided parameters
  int _getInitialLabelIndex(String selectedPlantStage) {
    switch (selectedPlantStage) {
      case 'Seed':
        return 0;
      case 'Growth':
        return 1;
      case 'Mature':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final updatedVext = ref.watch(vextNotifierProvider);

    selectedPlantStage = updatedVext.vext_plantStage;
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
            height: (updatedVext.vext_waterVolume / 15) * 10,
            value: updatedVext.vext_waterVolume,
            color: Styles.waterColour,
            flex: 2,
          ),
          Styles.width_5,
          _box(
            title: 'A',
            height: updatedVext.vext_nutrientAVolume,
            value: updatedVext.vext_nutrientAVolume,
            color: Styles.green,
          ),
          Styles.width_5,
          _box(
            title: 'B',
            height: updatedVext.vext_nutrientBVolume,
            value: updatedVext.vext_nutrientBVolume,
            color: Styles.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildPlantStageContainer() {
    String text = "";

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Styles.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  builder: (context) => WidgetData().infoDialog(
                    context: context,
                    title: 'Plant Stage',
                    body: 'This is example plant stage text',
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
            'Set the stage of your plant',
            style: Styles.body_text,
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
