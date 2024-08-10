// ignore_for_file: non_constant_identifier_names

import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/models/owner_model.dart';

class CabinetModel {
  OwnerModel? cabinet_owner;

  String? cabinet_idTB;

  String? cabinet_name;
  String? cabinet_network;
  double? cabinet_waterVolume; //stored as L in the database
  int? cabinet_lightBrightness;
  int? cabinet_turnOnTime;
  int? cabinet_turnOffTime;
  bool? cabinet_isActive;
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
    this.cabinet_owner,
    this.cabinet_idTB,
    this.cabinet_name,
    this.cabinet_network,
    this.cabinet_waterVolume,
    this.cabinet_lightBrightness,
    this.cabinet_turnOnTime,
    this.cabinet_turnOffTime,
    this.cabinet_isActive,
    this.cabinet_tasks,
    this.cabinet_plantStage,
    this.cabinet_futureTasks,
    this.cabinet_completedTasks,
    this.cabinet_nutrientAVolume,
    this.cabinet_nutrientBVolume,
  });

  factory CabinetModel.fromJson(Map<String, dynamic> json) {
    return CabinetModel(
      cabinet_owner: OwnerModel.fromJson(json['owner'] ?? {}),
      cabinet_idTB: json['cabinetIdTB'] ?? '',
      cabinet_name: json['cabinetName'] ?? '',
      cabinet_network: json['ssid'] ?? '',
      cabinet_waterVolume: json['waterVolume'] != null
          ? double.tryParse(json['waterVolume'].toString()) ?? 0.0
          : 0.0,
      cabinet_lightBrightness: json['middleRightLedBrightness'] ?? 0,
      cabinet_turnOnTime: json['turnOnTime'] ?? 0,
      cabinet_turnOffTime: json['turnOffTime'] ?? 0,
      cabinet_isActive: json['isActive'] ?? false,
      cabinet_tasks: json['tasks'] ?? [],
      cabinet_plantStage: json['plantStage'] ?? '',
      cabinet_nutrientAVolume: json['nutrientAVolume'] != null
          ? double.tryParse(json['nutrientAVolume'].toString()) ?? 0.0
          : 0.0,
      cabinet_nutrientBVolume: json['nutrientBVolume'] != null
          ? double.tryParse(json['nutrientBVolume'].toString()) ?? 0.0
          : 0.0,
      cabinet_futureTasks: json['tasks_future'] ?? [],
      cabinet_completedTasks: json['tasks_completed'] ?? [],
    );
  }
}
