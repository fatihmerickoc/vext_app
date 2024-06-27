import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class ApiService {
  final List<String> keys;

  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';
  static const username = 'fatih+tenant.admin@vext.fi';
  static const password = '782246Vext.';
  static const deviceId = '7ffc0a50-0317-11ef-a0ef-7f542c4ca39c';

  ApiService({required this.keys});

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
        for (String key in keys)
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
      var timeWindow = const Duration(hours: 1).inMilliseconds;

      var tsCmd = TimeSeriesCmd(
        keys: keys,
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
          .getAttributeKvEntries(foundDevice!.id!, ['serialNumber']);

      for (int i = 0; i < attributes.length; i++) {
        String key = attributes[i].getKey();
        String value = attributes[i].getValue();
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

      await Future.delayed(const Duration(milliseconds: 500));

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