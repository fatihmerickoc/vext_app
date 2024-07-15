// ignore_for_file: non_constant_identifier_names
//remove all the  comments once they are registered inside thinngsboard
import 'package:vext_app/models/task_model.dart';

class VextModel {
  String vext_id;
  String vext_network;
  double vext_waterVolume; //stored as L in the database
  int vext_lightBrightness;
  int vext_turnOnTime;
  int vext_turnOffTime;
  List<TaskModel> vext_tasks;
  String vext_plantStage;
  double vext_nutrientAVolume; //stored as mL in the database
  double vext_nutrientBVolume; //stored as mL in the database

  //these values are not fetched, they are filtered from tasks
  List<TaskModel> vext_futureTasks;
  List<TaskModel> vext_completedTasks;

  // bool vext_isLightOn;
  // bool vext_isCleaningModeOn;
  // List<String> vext_tasks;
  // List<String> vext_owners;

  VextModel({
    required this.vext_id,
    required this.vext_network,
    required this.vext_waterVolume,
    required this.vext_lightBrightness,
    required this.vext_turnOnTime,
    required this.vext_turnOffTime,
    required this.vext_tasks,
    required this.vext_plantStage,
    required this.vext_futureTasks,
    required this.vext_completedTasks,
    required this.vext_nutrientAVolume,
    required this.vext_nutrientBVolume,
  });

  factory VextModel.fromJson(Map<String, dynamic> json) {
    return VextModel(
      vext_id: json['serialNumber'],
      vext_network: json['ssid'] ?? 'network-not-found',
      vext_waterVolume:
          json['waterVolume'] != null ? double.parse(json['waterVolume']) : 0.0,
      vext_lightBrightness: json['middleRightLedBrightness'],
      vext_turnOnTime: json['turnOnTime'],
      vext_turnOffTime: json['turnOffTime'],
      vext_tasks: json['tasks'],
      vext_plantStage: json['plantStage'],
      vext_nutrientAVolume: json['nutrientAVolume'] != null
          ? double.parse(json['nutrientAVolume'])
          : 0.0,
      vext_nutrientBVolume: json['nutrientBVolume'] != null
          ? double.parse(json['nutrientBVolume'])
          : 0.0,
      vext_futureTasks: json['tasks_future'],
      vext_completedTasks: json['tasks_completed'],
    );
  }
}
