import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/models/vext_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vext_app/service/api_service.dart';
part 'vext_notifier.g.dart';

@riverpod
class VextNotifier extends _$VextNotifier {
  late final ApiService _apiService;

  @override
  VextModel build() {
    _apiService = ApiService(
      telemetryKeys: ['waterVolume', 'ssid'],
      attributeKeys: [
        'serialNumber',
        'middleRightLedBrightness',
        'turnOnTime',
        'turnOffTime',
      ],
    );
    fetchData();
    return VextModel(
      vext_id: '',
      vext_network: '',
      vext_waterLevel: 0,
      vext_lightBrightness: 0,
      vext_turnOnTime: 0,
      vext_turnOffTime: 0,
      vext_tasks: [],
      vext_futureTasks: [],
      vext_completedTasks: [],
    );
  }

  Future<void> fetchData() async {
    try {
      final jsonData = await _apiService.fetchDataForVextModel();
      final vext = VextModel.fromJson(jsonData);
      updateVext(vext);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateLights(int sliderValue) async {
    await _apiService.setLightsFromSlider(sliderValue);

    if (state.vext_lightBrightness != sliderValue) {
      state.vext_lightBrightness = sliderValue;
    }
  }

  Future<void> updateTimes(int turnOn, turnOFF) async {
    await _apiService.setTimeFromTimePicker(turnOn, turnOFF);
    if (state.vext_turnOnTime != turnOn || state.vext_turnOffTime != turnOFF) {
      state.vext_turnOnTime = turnOn;
      state.vext_turnOffTime = turnOFF;
    }
  }

  Future<void> updateTask(TaskModel task, bool isFutureTask) async {
    await _apiService.setCompleteTasks(task);
    if (!state.vext_completedTasks.contains(task)) {
      state.vext_completedTasks.add(task);
      if (isFutureTask) {
        state.vext_futureTasks.remove(task);
      } else {
        state.vext_tasks.remove(task);
      }
    }
  }

  //method to update state
  void updateVext(VextModel vext) {
    if (state != vext) {
      state = vext;
    }
  }
}
