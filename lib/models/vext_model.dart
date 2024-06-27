// ignore_for_file: non_constant_identifier_names
//remove all the  comments once they are registered inside thinngsboard
class VextModel {
  String vext_id;
  // List<String> vext_owners;
  String vext_network;
  int vext_waterLevel;
  int vext_lightBrightness;
  // bool vext_isLightOn;
  // bool vext_isCleaningModeOn;
  // String vext_plantStage;
  // List<String> vext_tasks;

  VextModel({
    required this.vext_id,
    required this.vext_network,
    required this.vext_waterLevel,
    required this.vext_lightBrightness,
  });

  factory VextModel.fromJson(Map<String, dynamic> json) {
    return VextModel(
      vext_id: json['serialNumber'],
      vext_network: json['ssid'],
      vext_waterLevel: double.parse(json['waterVolume']).round(),
      vext_lightBrightness: json['dimAllLedBrightness'],
    );
  }
}
