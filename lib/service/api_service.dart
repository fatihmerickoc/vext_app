// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:vext_app/models/taskInfo_model.dart';
import 'package:vext_app/models/task_model.dart';

class ApiService {
  final List<String> telemetryKeys;
  final List<String> attributeKeys;
  final Duration durationOfFetching;

  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';
  static const username = 'fatih+tenant.admin@vext.fi';
  static const password = '782246Vext.';
  static const deviceId = '7ffc0a50-0317-11ef-a0ef-7f542c4ca39c';
  static const cabinetId = 'T00P00TEST0'; //FIXME: get this later from supabase

  final _tbClient = ThingsboardClient(thingsBoardApiEndpoint);

  final _sbClient = Supabase.instance.client;

  List<TaskModel> taskList = [];
  List<TaskModel> taskFutureList = [];
  List<TaskModel> taskCompletedList = [];

  List<TaskInfoModel> taskInfoList = [];

  ApiService(
      {required this.telemetryKeys,
      required this.attributeKeys,
      required this.durationOfFetching});

  //method to construct the vext model by fething/subscribing data from Thingsboard & Supabase
  Future<Map<String, dynamic>> fetchDataForVextModel() async {
    try {
      final value = await _fetchDataFromThingsboard();
      value['tasks'] = await _fetchTasksFromSupabase();
      value['tasks_future'] = taskFutureList;
      value['tasks_completed'] = taskCompletedList;

      return value;
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');

      return {};
    }
  }

  Future<List<TaskModel>> _fetchTasksFromSupabase() async {
    try {
      await _sbClient.auth.signInWithPassword(
        email: 'fatihmerickoc@gmail.com',
        password: '782246Supabase.',
      );

      final task_infoData = await _sbClient.from('task_info').select();

      for (var task_info in task_infoData) {
        taskInfoList.add(TaskInfoModel.fromJson(task_info));
      }

      //filter tasks whose cabinet equals to user's cabinet
      final taskData = await _sbClient.from('tasks').select().eq(
            'cabinet',
            cabinetId,
          );

      for (var task in taskData) {
        TaskInfoModel taskInfoModel =
            taskInfoList.firstWhere((map) => map.id == task['info']);

        task['name'] = taskInfoModel.name;
        task['category'] = taskInfoModel.type;
        task['description'] = taskInfoModel.description;
        task['category_color'] = taskInfoModel.color;

        TaskModel uploadTask = TaskModel.fromJson(task);

        if (uploadTask.task_completedDate !=
            DateTime.fromMillisecondsSinceEpoch(0)) {
          taskCompletedList.add(uploadTask);
        } else if (uploadTask.task_dueDate.difference(DateTime.now()).inDays >
            7) {
          taskFutureList.add(uploadTask);
        } else {
          taskList.add(uploadTask);
        }
      }

      //
      taskList.sort((a, b) => a.task_dueDate.compareTo(b.task_dueDate));
      taskCompletedList.sort(
          (a, b) => a.task_completedDate!.compareTo(b.task_completedDate!));

      return taskList;
    } catch (e, s) {
      print("ERROR: $e and STACK $s");
      return [];
    }
  }

  Future<Map<String, dynamic>> _fetchDataFromThingsboard() async {
    try {
      await _tbClient.login(LoginRequest(username, password));

      var deviceName = 'Black Vext';

      var entityFilter = EntityNameFilter(
          entityType: EntityType.DEVICE, entityNameFilter: deviceName);

      var deviceFields = <EntityKey>[
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'name'),
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'type'),
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'createdTime')
      ];

      var deviceTelemetry = <EntityKey>[
        for (String key in telemetryKeys)
          EntityKey(type: EntityKeyType.TIME_SERIES, key: key),
      ];

      var devicesQuery = EntityDataQuery(
        entityFilter: entityFilter,
        entityFields: deviceFields,
        latestValues: deviceTelemetry,
        pageLink: EntityDataPageLink(
          pageSize: telemetryKeys.length,
        ),
      );

      var currentTime = DateTime.now().millisecondsSinceEpoch;

      var tsCmd = TimeSeriesCmd(
        keys: telemetryKeys,
        startTs: currentTime - durationOfFetching.inMilliseconds,
        timeWindow: durationOfFetching.inMilliseconds,
        limit: 1,
      );

      var latesCmd = LatestValueCmd(
        keys: deviceTelemetry,
      );

      var cmd =
          EntityDataCmd(query: devicesQuery, tsCmd: tsCmd, latestCmd: latesCmd);

      var telemetryService = _tbClient.getTelemetryService();

      var subscription = TelemetrySubscriber(telemetryService, [cmd]);

      debugPrint("Started");

      Map<String, dynamic> telemetryData = {};

      var foundDevice =
          await _tbClient.getDeviceService().getDeviceInfo(deviceId);

      //getting the attributes
      var attributes = await _tbClient
          .getAttributeService()
          .getAttributeKvEntries(foundDevice!.id!, attributeKeys);

      for (int i = 0; i < attributes.length; i++) {
        String key = attributes[i].getKey();
        var value = attributes[i].getValue();

        telemetryData[key] = value;
      }

      // getting the telemtry values
      subscription.entityDataStream.listen(
        (dataUpdate) {
          if (dataUpdate.update != null) {
            for (var data in dataUpdate.update!) {
              data.timeseries.forEach((key, value) {
                if (value.isNotEmpty) {
                  telemetryData[key] = value.last.value;
                }
              });
            }
          }
        },
      );

      subscription.subscribe();

      await Future.delayed(const Duration(milliseconds: 700));

      subscription.unsubscribe();
      //await tbClient.logout();
      debugPrint("Ended");

      return telemetryData;
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      //await tbClient.logout();
      return {};
    }
  }

  //method that updates lights values from Thingsboard
  Future<void> setLightsFromSlider(int sliderValue) async {
    try {
      //  await tbClient.login(LoginRequest(username, password));

      var foundDevice =
          await _tbClient.getDeviceService().getDeviceInfo(deviceId);

      // Save device shared attributes
      await _tbClient.getAttributeService().saveEntityAttributesV2(
          foundDevice!.id!,
          AttributeScope.SHARED_SCOPE.toShortString(),
          // {'dimAllLedBrightness': sliderValue},
          {
            'lowerLeftLedBrightness': sliderValue,
            'lowerRightLedBrightness': sliderValue,
            'middleLeftLedBrightness': sliderValue,
            'middleRightLedBrightness': sliderValue,
            'upperLeftLedBrightness': sliderValue,
            'upperRightLedBrightness': sliderValue,
          });

      // await tbClient.logout();
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      // await tbClient.logout();
    }
  }

  //method that updates turnOn and turnOFF values from Thingsboard
  Future<void> setTimeFromTimePicker(int turnOn, turnOFF) async {
    try {
      var foundDevice =
          await _tbClient.getDeviceService().getDeviceInfo(deviceId);

      // Save device shared attributes
      await _tbClient.getAttributeService().saveEntityAttributesV2(
          foundDevice!.id!,
          AttributeScope.SHARED_SCOPE.toShortString(),
          // {'dimAllLedBrightness': sliderValue},
          {
            'turnOnTime': turnOn,
            'turnOffTime': turnOFF,
          });

      //   await tbClient.logout();
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      // await tbClient.logout();
    }
  }

  Future<void> setCompleteTasks(TaskModel task) async {
    await _sbClient.from('tasks').update(
        {'completed_date': DateTime.now().toString()}).eq('id', task.task_id);
  }

  Future<void> setPlantStage(String plantStage) async {
    try {
      var foundDevice =
          await _tbClient.getDeviceService().getDeviceInfo(deviceId);

      // Save device shared attributes
      await _tbClient.getAttributeService().saveEntityAttributesV2(
          foundDevice!.id!, AttributeScope.SHARED_SCOPE.toShortString(), {
        'plantStage': plantStage,
      });

      //   await tbClient.logout();
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      // await tbClient.logout();
    }
  }
}

//to save updates
/*  var telemetryRequest = {
         'temperature': temperature,
         'humidity': humidity
    };
    print('Save telemetry request: $telemetryRequest');
    var res = await tbClient.getAttributeService().saveEntityTelemetry(
    savedDevice.id!, 'TELEMETRY', telemetryRequest);
    print('Save telemetry result: $res');
*/
