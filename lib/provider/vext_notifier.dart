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
        attributeKeys: ['serialNumber', 'dimAllLedBrightness']);
    fetchData();
    return VextModel(
        vext_id: '',
        vext_network: '',
        vext_waterLevel: 0,
        vext_lightBrightness: 0);
  }

  Future<void> fetchData() async {
    try {
      final jsonData = await _apiService.fetchDataFromThingsBoard();
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
        vext_waterLevel: state.vext_waterLevel,
        vext_lightBrightness: sliderValue,
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
