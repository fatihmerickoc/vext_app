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
    required this.vext_completedTasks,
  });

  factory VextModel.fromJson(Map<String, dynamic> json) {
    return VextModel(
      vext_id: json['serialNumber'],
      vext_network: json['ssid'],
      vext_waterLevel: 23, //double.parse(json['waterVolume']).round(),
      vext_lightBrightness: json['middleRightLedBrightness'],
      vext_turnOnTime: json['turnOnTime'],
      vext_turnOffTime: json['turnOffTime'],
      vext_tasks: [
        TaskModel(
          task_title: 'Plant new capsules',
          task_dueDate: 1719848963,
          task_category: 'Plants',
        ),
        TaskModel(
          task_title: 'Refill water tank',
          task_dueDate: 1728460163,
          task_category: 'Water',
        ),
      ],
      vext_completedTasks: [
        TaskModel(
          task_title: 'Sweep the lid',
          task_dueDate: 1728460163,
          task_category: 'Device',
        ),
      ],
    );
  }
}
