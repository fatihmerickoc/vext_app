import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class ApiService {
  final List<String> telemetryKeys;
  final List<String> attributeKeys;

  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';
  static const username = 'fatih+tenant.admin@vext.fi';
  static const password = '782246Vext.';
  static const deviceId = '7ffc0a50-0317-11ef-a0ef-7f542c4ca39c';

  ApiService({required this.telemetryKeys, required this.attributeKeys});

  //method to create subscription to get telemetry updates
  Future<Map<String, dynamic>> fetchDataFromThingsBoard() async {
    var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

    try {
      await tbClient.login(LoginRequest(username, password));

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

      var telemetryService = tbClient.getTelemetryService();

      var subscription = TelemetrySubscriber(telemetryService, [cmd]);

      debugPrint("Started");

      Map<String, dynamic> telemetryData = {};

      var foundDevice =
          await tbClient.getDeviceService().getDeviceInfo(deviceId);

      var attributes = await tbClient
          .getAttributeService()
          .getAttributeKvEntries(foundDevice!.id!, attributeKeys);

      for (int i = 0; i < attributes.length; i++) {
        String key = attributes[i].getKey();
        var value = attributes[i].getValue();
        telemetryData[key] = value;
      }

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

      await Future.delayed(const Duration(milliseconds: 600));

      subscription.unsubscribe();
      await tbClient.logout();
      debugPrint("Ended");

      return telemetryData;
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      await tbClient.logout();
      return {};
    }
  }

  Future<void> setLightsFromSlider(int sliderValue) async {
    var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

    try {
      await tbClient.login(LoginRequest(username, password));

      var foundDevice =
          await tbClient.getDeviceService().getDeviceInfo(deviceId);

      // Save device shared attributes
      await tbClient.getAttributeService().saveEntityAttributesV2(
        foundDevice!.id!,
        AttributeScope.SHARED_SCOPE.toShortString(),
        {'dimAllLedBrightness': sliderValue},
        /*  {
            'lowerLeftLedBrightness': sliderValue,
            'lowerRightLedBrightness': sliderValue,
            'middleLeftLedBrightness': sliderValue,
            'middleRightLedBrightness': sliderValue,
            'upperLeftLedBrightness': sliderValue,
            'upperRightLedBrightness': sliderValue,
          }*/
      );

      await tbClient.logout();
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
      await tbClient.logout();
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