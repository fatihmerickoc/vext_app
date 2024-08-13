// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:vext_app/main.dart';
import 'package:vext_app/models/cabinet_model.dart';
import 'package:vext_app/models/owner_model.dart';
import 'package:vext_app/models/taskInfo_model.dart';
import 'package:vext_app/models/task_model.dart';

class CabinetService {
  final List<String> telemetryKeys;
  final List<String> attributeKeys;
  final Duration durationOfFetching;

  CabinetModel _cabinetModel = CabinetModel();

  final _tbClient = ThingsboardClient('https://thingsboard.vinicentus.net');

  List<TaskModel> taskList = [];
  List<TaskModel> taskFutureList = [];
  List<TaskModel> taskCompletedList = [];

  List<TaskInfoModel> taskInfoList = [];

  CabinetService({
    required this.telemetryKeys,
    required this.attributeKeys,
    required this.durationOfFetching,
  });

  //method to construct the vext model by fething/subscribing data from Thingsboard & Supabase
  Future<CabinetModel?> fetchDataForCabinetModel() async {
    try {
      _cabinetModel.cabinet_owner = await _fetchOwnerInfo();

      if (_cabinetModel.cabinet_owner?.owner_email == null) {
        throw Exception('User has no cabinets that are assigned to him');
      }

      Map<String, dynamic> value = {};

      value = await _fetchCabinetInfoFromTB();
      if (value == {}) return null;

      _cabinetModel.cabinet_idTB = value['cabinetIdTB'];
      _cabinetModel.cabinet_name = value['cabinetName'];

      value.addAll(await _fetchDataFromThingsboard());
      value['tasks'] = await _fetchTasksFromSupabase();
      value['tasks_future'] = taskFutureList;
      value['tasks_completed'] = taskCompletedList;

      _cabinetModel = CabinetModel.fromJson(value);

      return _cabinetModel;
    } catch (e) {
      debugPrint('Error: $e');

      throw Exception('Failed to fetch data for vext model');
    }
  }

  Future<OwnerModel?> _fetchOwnerInfo() async {
    try {
      final profilesData = await supabase.from('profiles').select().eq(
            'id',
            supabase.auth.currentUser!.id,
          );

      if (profilesData.first.isEmpty) return null;

      String tbID = profilesData.first['thingsboard_user_id'];

      final thingsboard_usersData =
          await supabase.from('thingsboard_users').select().eq('id', tbID);

      return OwnerModel(
        owner_id: tbID,
        owner_email: thingsboard_usersData.first['email'],
        owner_password: thingsboard_usersData.first['password'],
      );
    } catch (e) {
      debugPrint('Error: $e');

      throw Exception('Failed to fetch owner info');
    }
  }

  Future<Map<String, dynamic>> _fetchCabinetInfoFromTB() async {
    try {
      await _tbClient.login(LoginRequest(
          _cabinetModel.cabinet_owner!.owner_email!,
          _cabinetModel.cabinet_owner!.owner_password!));
      var pageLink = PageLink(1);
      PageData<DeviceInfo> device;

      device = await _tbClient.getDeviceService().getCustomerDeviceInfos(
            _tbClient.getAuthUser()!.customerId!,
            pageLink,
          );

      await _tbClient.logout();
      return {
        "cabinetName": device.data.first.name,
        'cabinetIdTB': device.data.first.id!.id,
        'isActive': device.data.first.active!,
      };
    } catch (e, s) {
      print('Error: $e');
      print('Stack: $s');
    }
    return {};
  }

  Future<Map<String, dynamic>> _fetchDataFromThingsboard() async {
    try {
      Map<String, dynamic> tbData = {};

      await _tbClient.login(
        LoginRequest(
          _cabinetModel.cabinet_owner!.owner_email!,
          _cabinetModel.cabinet_owner!.owner_password!,
        ),
      );

      //ATTRIBUTE KEYS
      var foundDevice = await _tbClient
          .getDeviceService()
          .getDeviceInfo(_cabinetModel.cabinet_idTB!);

      var attributes = await _tbClient
          .getAttributeService()
          .getAttributeKvEntries(foundDevice!.id!, attributeKeys);

      for (int i = 0; i < attributes.length; i++) {
        String key = attributes[i].getKey();
        var value = attributes[i].getValue();

        tbData[key] = value;
      }

      //TELEMETRY KEYS
      var entityFilter = EntityNameFilter(
        entityType: EntityType.DEVICE,
        entityNameFilter: _cabinetModel.cabinet_name!,
      );

      var devicesQuery = EntityDataQuery(
        entityFilter: entityFilter,
        pageLink: EntityDataPageLink(
          pageSize: 1,
        ),
      );

      var currentTime = DateTime.now().millisecondsSinceEpoch;

      var tsCmd = TimeSeriesCmd(
        keys: telemetryKeys,
        startTs: currentTime - durationOfFetching.inMilliseconds,
        timeWindow: durationOfFetching.inMilliseconds,
        limit: 1,
      );

      var cmd = EntityDataCmd(query: devicesQuery, tsCmd: tsCmd);

      var telemetryService = _tbClient.getTelemetryService();

      var subscription = TelemetrySubscriber(telemetryService, [cmd]);

      // getting the telemtry values
      subscription.entityDataStream.listen(
        (dataUpdate) {
          for (var entry in dataUpdate.data!.data.first.timeseries.entries) {
            var key = entry.key;
            var value = entry.value.first.value;
            tbData[key] = value;
          }
        },
      );

      subscription.subscribe();

      await Future.delayed(const Duration(seconds: 1));

      subscription.unsubscribe();

      return tbData;
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      //await tbClient.logout();
      return {};
    }
  }

  Future<List<TaskModel>> _fetchTasksFromSupabase() async {
    try {
      final task_infoData = await supabase.from('task_info').select();

      for (var task_info in task_infoData) {
        taskInfoList.add(TaskInfoModel.fromJson(task_info));
      }

      //filter tasks whose cabinet equals to user's cabinet
      final taskData = await supabase.from('tasks').select().eq(
            'cabinet',
            _cabinetModel.cabinet_name!,
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

  //method that updates lights values from Thingsboard
  Future<void> setLightsFromSlider(int sliderValue) async {
    try {
      //  await tbClient.login(LoginRequest(email, password));

      var foundDevice = await _tbClient
          .getDeviceService()
          .getDeviceInfo(_cabinetModel.cabinet_idTB!);

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
      var foundDevice = await _tbClient
          .getDeviceService()
          .getDeviceInfo(_cabinetModel.cabinet_idTB!);

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

  //method that updates the task values from Supabase
  Future<void> setCompleteTasks(TaskModel task) async {
    await supabase.from('tasks').update(
        {'completed_date': DateTime.now().toString()}).eq('id', task.task_id);
  }

  //method that updates the plant stage values from Thingsboard
  Future<void> setPlantStage(String plantStage) async {
    try {
      var foundDevice = await _tbClient
          .getDeviceService()
          .getDeviceInfo(_cabinetModel.cabinet_idTB!);

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

  //method that sends 2 way server-side-rpc using REST API which sets nutrients values
  Future<void> setNutrients(double nutrientA, nutrientB) async {
    try {
      print("URL:   '/api/plugins/rpc/twoway/${_cabinetModel.cabinet_idTB}'");
      var rpc = await _tbClient.post<Map<String, dynamic>>(
        '/api/plugins/rpc/twoway/${_cabinetModel.cabinet_idTB}',
        queryParameters: {
          'method': 'refillNutrients',
          'params': {
            'nutrientA': nutrientA,
            'nutrientB': nutrientB,
          }
        },
      );
      print("RPC DATA: ${rpc.data}");
    } catch (e) {
      debugPrint('Error refilling nutrients: $e');
    }
  }
}
