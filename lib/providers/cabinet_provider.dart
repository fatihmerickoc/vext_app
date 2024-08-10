import 'package:flutter/material.dart';
import 'package:vext_app/models/cabinet_model.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/services/cabinet_service.dart';

class CabinetProvider extends ChangeNotifier {
  CabinetModel _cabinet = CabinetModel();
  CabinetModel get cabinet => _cabinet;

  final CabinetService _cabinetService = CabinetService(
    telemetryKeys: [
      'waterVolume',
      'ssid',
      'nutrientAVolume',
      'nutrientBVolume'
    ],
    attributeKeys: [
      'middleRightLedBrightness',
      'turnOnTime',
      'turnOffTime',
      'plantStage',
    ],
    durationOfFetching: const Duration(hours: 4),
  );

  Future<CabinetModel?> fetchCabinet() async {
    try {
      final fetchedCabinetData =
          await _cabinetService.fetchDataForCabinetModel();
      if (fetchedCabinetData != null) {
        _cabinet = fetchedCabinetData;
        notifyListeners();
        return _cabinet;
      } else {
        print("JSON value is empty");
      }
    } catch (e) {
      print('Catched an error fetching cabinet: $e');
    }
    return null;
  }

  Future<void> updateCabinetLights(int sliderValue) async {
    try {
      await _cabinetService.setLightsFromSlider(sliderValue);
      _cabinet.cabinet_lightBrightness = sliderValue;
      notifyListeners();
    } catch (e) {
      print('Catched an error setting cabinet lights: $e');
    }
  }

  Future<void> updateCabinetSchedule(int turnOn, turnOFF) async {
    try {
      await _cabinetService.setTimeFromTimePicker(turnOn, turnOFF);
      _cabinet.cabinet_turnOnTime = turnOn;
      _cabinet.cabinet_turnOffTime = turnOFF;
      notifyListeners();
    } catch (e) {
      print('Catched an error updating cabinet schedule: $e');
    }
  }

  Future<void> updateCabinetTask(TaskModel task,
      {bool isFutureTask = false}) async {
    try {
      await _cabinetService.setCompleteTasks(task);
      if (isFutureTask) {
        _cabinet.cabinet_futureTasks!.remove(task);
      } else {
        _cabinet.cabinet_tasks!.remove(task);
      }
      notifyListeners();
    } catch (e) {
      print('Catched an error updating cabinet task: $e');
    }
  }

  Future<void> updateCabinetPlantStage(String plantStage) async {
    try {
      await _cabinetService.setPlantStage(plantStage);
      _cabinet.cabinet_plantStage = plantStage;
      notifyListeners();
    } catch (e) {
      print('Catched an error updating cabinet plant stage: $e');
    }
  }
}
