// ignore_for_file: non_constant_identifier_names

import 'package:vext_app/models/task_model.dart';

class CabinetModel {
  String? cabinet_id;
  String? cabinet_network;
  double? cabinet_waterVolume; //stored as L in the database
  int? cabinet_lightBrightness;
  int? cabinet_turnOnTime;
  int? cabinet_turnOffTime;
  List<TaskModel>? cabinet_tasks;
  String? cabinet_plantStage;
  double? cabinet_nutrientAVolume; //stored as mL in the database
  double? cabinet_nutrientBVolume; //stored as mL in the database

  //these values are not fetched, they are filtered from tasks
  List<TaskModel>? cabinet_futureTasks;
  List<TaskModel>? cabinet_completedTasks;

  // bool cabinet_isLightOn;
  // bool cabinet_isCleaningModeOn;
  // List<String> cabinet_tasks;
  // List<String> cabinet_owners;

  CabinetModel({
    this.cabinet_id,
    this.cabinet_network,
    this.cabinet_waterVolume,
    this.cabinet_lightBrightness,
    this.cabinet_turnOnTime,
    this.cabinet_turnOffTime,
    this.cabinet_tasks,
    this.cabinet_plantStage,
    this.cabinet_futureTasks,
    this.cabinet_completedTasks,
    this.cabinet_nutrientAVolume,
    this.cabinet_nutrientBVolume,
  });

  factory CabinetModel.fromJson(Map<String, dynamic> json) {
    return CabinetModel(
      cabinet_id: json['serialNumber'],
      cabinet_network: json['ssid'] ?? '',
      cabinet_waterVolume:
          json['waterVolume'] != null ? double.parse(json['waterVolume']) : 0.0,
      cabinet_lightBrightness: json['middleRightLedBrightness'],
      cabinet_turnOnTime: json['turnOnTime'],
      cabinet_turnOffTime: json['turnOffTime'],
      cabinet_tasks: json['tasks'],
      cabinet_plantStage: json['plantStage'],
      cabinet_nutrientAVolume: json['nutrientAVolume'] != null
          ? double.parse(json['nutrientAVolume'])
          : 0.0,
      cabinet_nutrientBVolume: json['nutrientBVolume'] != null
          ? double.parse(json['nutrientBVolume'])
          : 0.0,
      cabinet_futureTasks: json['tasks_future'],
      cabinet_completedTasks: json['tasks_completed'],
    );
  }
}
