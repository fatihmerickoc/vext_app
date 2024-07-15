// ignore_for_file: non_constant_identifier_names
//remove all the  comments once they are registered inside thinngsboard
import 'package:vext_app/models/task_model.dart';

class VextModel {
  String vext_id;
  // List<String> vext_owners;
  String vext_network;
  int vext_waterLevel;
  int vext_lightBrightness;
  int vext_turnOnTime;
  int vext_turnOffTime;
  List<TaskModel> vext_tasks;

  //these values are not fetched, they are filtered from tasks
  List<TaskModel> vext_futureTasks;
  List<TaskModel> vext_completedTasks;

  // bool vext_isLightOn;
  // bool vext_isCleaningModeOn;
  // String vext_plantStage;
  // List<String> vext_tasks;

  VextModel({
    required this.vext_id,
    required this.vext_network,
    required this.vext_waterLevel,
    required this.vext_lightBrightness,
    required this.vext_turnOnTime,
    required this.vext_turnOffTime,
    required this.vext_tasks,
    required this.vext_futureTasks,
    required this.vext_completedTasks,
  });

  factory VextModel.fromJson(Map<String, dynamic> json) {
    return VextModel(
      vext_id: json['serialNumber'],
      vext_network: json['ssid'],
      vext_waterLevel: 20,
      vext_lightBrightness: json['middleRightLedBrightness'],
      vext_turnOnTime: json['turnOnTime'],
      vext_turnOffTime: json['turnOffTime'],
      vext_tasks: json['tasks'],
      vext_futureTasks: json['tasks_future'],
      vext_completedTasks: json['tasks_completed'],
    );
  }
}
