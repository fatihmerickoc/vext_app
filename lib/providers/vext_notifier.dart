/*import 'package:vext_app/models/task_model.dart';
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
      telemetryKeys: [
        'waterVolume',
        'ssid',
        'nutrientAVolume',
        'nutrientBVolume'
      ],
      attributeKeys: [
        'serialNumber',
        'middleRightLedBrightness',
        'turnOnTime',
        'turnOffTime',
        'plantStage',
      ],
      durationOfFetching: const Duration(hours: 4),
    );
    fetchData();
    return VextModel(
      vext_id: '',
      vext_network: '',
      vext_waterVolume: 0,
      vext_lightBrightness: 0,
      vext_turnOnTime: 0,
      vext_turnOffTime: 0,
      vext_tasks: [],
      vext_nutrientAVolume: 0,
      vext_nutrientBVolume: 0,
      vext_plantStage: '',
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
      state = VextModel(
        vext_id: state.vext_id,
        vext_network: state.vext_network,
        vext_waterVolume: state.vext_waterVolume,
        vext_lightBrightness: sliderValue,
        vext_turnOnTime: state.vext_turnOnTime,
        vext_turnOffTime: state.vext_turnOffTime,
        vext_tasks: state.vext_tasks,
        vext_nutrientAVolume: state.vext_nutrientAVolume,
        vext_nutrientBVolume: state.vext_nutrientBVolume,
        vext_plantStage: state.vext_plantStage,
        vext_futureTasks: state.vext_futureTasks,
        vext_completedTasks: state.vext_completedTasks,
      );
    }
  }

  Future<void> updateTimes(int turnOn, turnOFF) async {
    await _apiService.setTimeFromTimePicker(turnOn, turnOFF);
    if (state.vext_turnOnTime != turnOn || state.vext_turnOffTime != turnOFF) {
      state = VextModel(
        vext_id: state.vext_id,
        vext_network: state.vext_network,
        vext_waterVolume: state.vext_waterVolume,
        vext_lightBrightness: state.vext_lightBrightness,
        vext_turnOnTime: turnOn,
        vext_turnOffTime: turnOFF,
        vext_tasks: state.vext_tasks,
        vext_nutrientAVolume: state.vext_nutrientAVolume,
        vext_nutrientBVolume: state.vext_nutrientBVolume,
        vext_plantStage: state.vext_plantStage,
        vext_futureTasks: state.vext_futureTasks,
        vext_completedTasks: state.vext_completedTasks,
      );
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

  Future<void> updatePlantStage(String selectedPlantStage) async {
    await _apiService.setPlantStage(selectedPlantStage);
    if (state.vext_plantStage != selectedPlantStage) {
      state = VextModel(
        vext_id: state.vext_id,
        vext_network: state.vext_network,
        vext_waterVolume: state.vext_waterVolume,
        vext_lightBrightness: state.vext_lightBrightness,
        vext_turnOnTime: state.vext_turnOnTime,
        vext_turnOffTime: state.vext_turnOffTime,
        vext_tasks: state.vext_tasks,
        vext_nutrientAVolume: state.vext_nutrientAVolume,
        vext_nutrientBVolume: state.vext_nutrientBVolume,
        vext_plantStage: selectedPlantStage,
        vext_futureTasks: state.vext_futureTasks,
        vext_completedTasks: state.vext_completedTasks,
      );
    }
  }

  //method to update state
  void updateVext(VextModel vext) {
    if (state != vext) {
      state = vext;
    }
  }
}
*/