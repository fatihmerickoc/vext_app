// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:gotrue/src/types/user.dart' as prefix;
import 'package:vext_app/models/task_model.dart';

class ApiService {
  final List<String> telemetryKeys;
  final List<String> attributeKeys;

  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';
  static const username = 'fatih+tenant.admin@vext.fi';
  static const password = '782246Vext.';
  static const deviceId = '9cc4a980-0317-11ef-a0ef-7f542c4ca39c';

  final _tbClient = ThingsboardClient(thingsBoardApiEndpoint);

  final _sbClient = Supabase.instance.client;

  ApiService({required this.telemetryKeys, required this.attributeKeys});

  Future<List<TaskModel>> _fetchTasksFromSupabase() async {
    try {
      await _sbClient.auth.signInWithPassword(
        email: 'fatihmerickoc@gmail.com',
        password: '782246Supabase.',
      );

      final taskData = await _sbClient.from('tasks').select();
      List<TaskModel> taskList = [];
      for (var task in taskData) {
        final task_infoData =
            await _sbClient.from('task_info').select().eq('id', task['info']);
        task['name'] = task_infoData.first['name'];
        task['category'] = task_infoData.first['type'];
        task['description'] = task_infoData.first['description'];
        task['category_color'] = task_infoData.first['color'];

        taskList.add(TaskModel.fromJson(task));
      }

      return taskList;
    } catch (e, s) {
      print("ERROR: $e and STACK $s");
      return [];
    }
  }

  Future<Map<String, dynamic>> _fetchDataFromThingsboard() async {
    try {
      await _tbClient.login(LoginRequest(username, password));

      var deviceName = 'White Vext';

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
          pageSize: 10,
        ),
      );

      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var timeWindow = const Duration(hours: 2).inMilliseconds;

      var tsCmd = TimeSeriesCmd(
        keys: telemetryKeys,
        startTs: currentTime - timeWindow,
        timeWindow: timeWindow,
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

  //method to construct the vext model by fething/subscribing data from Thingsboard & Supabase
  Future<Map<String, dynamic>> fetchDataForVextModel() async {
    try {
      final value = await _fetchDataFromThingsboard();
      value['tasks'] = await _fetchTasksFromSupabase();
      return value;
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');

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
