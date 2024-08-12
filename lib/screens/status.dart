import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vext_app/models/cabinet_model.dart';
import 'package:vext_app/providers/cabinet_provider.dart';
import 'package:vext_app/styles/styles.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String selectedPlantStage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cabinetProvider =
        Provider.of<CabinetProvider>(context, listen: false);
    setState(() {
      selectedPlantStage = cabinetProvider.cabinet.cabinet_plantStage!;
    });
  }

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

        final cabinetProvider =
            Provider.of<CabinetProvider>(context, listen: false);
        cabinetProvider.updateCabinetPlantStage(selectedPlantStage);
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

  Widget _statusInfoDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
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

  Widget _refillNutrientsDialog(double nutrientA, nutrientB) {
    return AlertDialog(
      title: const Text(
        'Refill Nutrients',
        style: Styles.title_text,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Nutrient A: ${nutrientA.round()}'),
          Slider(
            value: nutrientA,
            min: 0,
            max: 300,
            divisions: 300,
            onChanged: (value) {
              setState(() {
                nutrientA = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text('Nutrient 2: ${nutrientB.round()}'),
          Slider(
            value: nutrientB,
            min: 0,
            max: 300,
            divisions: 300,
            onChanged: (value) {
              setState(() {
                nutrientB = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Update'),
          onPressed: () {
            // You can use slider1Value and slider2Value here
            // or pass them back to the parent widget
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cabinetProvider = Provider.of<CabinetProvider>(context);

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
              _buildPlantStageContainer(),
              Styles.height_15,
              _buildIngredientBoxRow(cabinetProvider.cabinet),
              const Spacer(),
              _buildRefillNutrientsContainer(cabinetProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientBoxRow(CabinetModel updatedCabinet) {
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
            height: updatedCabinet.cabinet_waterVolume! * 15,
            value: updatedCabinet.cabinet_waterVolume!,
            color: Styles.waterColour,
            flex: 2,
          ),
          Styles.width_5,
          _box(
            title: 'A',
            height: updatedCabinet.cabinet_nutrientAVolume!,
            value: updatedCabinet.cabinet_nutrientAVolume!,
            color: Styles.green,
          ),
          Styles.width_5,
          _box(
            title: 'B',
            height: updatedCabinet.cabinet_nutrientBVolume!,
            value: updatedCabinet.cabinet_nutrientBVolume!,
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
                  builder: (context) => _statusInfoDialog(
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

  Widget _buildRefillNutrientsContainer(CabinetProvider cabinetProvider) {
    return InkWell(
      onTap: () async {
        showDialog<String>(
          context: context,
          builder: (context) => _refillNutrientsDialog(
            cabinetProvider.cabinet.cabinet_nutrientAVolume!,
            cabinetProvider.cabinet.cabinet_nutrientBVolume!,
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
