import 'package:thingsboard_client/thingsboard_client.dart';

class VextBackend {
  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';

  //method to create subscription to get telemetry updates
  Future<void> subThingsBoard(List<String> keys) async {
    try {
      var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

      await tbClient.login(
        LoginRequest('fatih+tenant.admin@vext.fi', '782246Vext.'),
      );

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
          sortOrder: EntityDataSortOrder(
              key: EntityKey(
                  type: EntityKeyType.ENTITY_FIELD, key: 'createdTime'),
              direction: EntityDataSortOrderDirection.DESC),
        ),
      );

      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var timeWindow = const Duration(hours: 1).inMilliseconds;

      var tsCmd = TimeSeriesCmd(
          keys: keys,
          startTs: currentTime - timeWindow,
          timeWindow: timeWindow);

      var cmd = EntityDataCmd(query: devicesQuery, tsCmd: tsCmd);

      var telemetryService = tbClient.getTelemetryService();

      var subscription = TelemetrySubscriber(telemetryService, [cmd]);

      print("Started");
      subscription.entityDataStream.listen((entityDataUpdate) {
        if (entityDataUpdate.update != null) {
          for (var entityData in entityDataUpdate.update!) {
            entityData.timeseries.forEach((key, value) {
              for (var tsValue in value) {
                print(
                    'Telemetry key: $key, value: ${tsValue.value}, timestamp: ${tsValue.ts}\n');
              }
            });
          }
        } else {
          print("No Updates");
        }
      });

      subscription.subscribe();

      // for (var i = 0; i < 10; i++) {
      //   await Future.delayed(const Duration(seconds: 1));
      //   var temperature = 10 + 20 * rng.nextDouble();
      //   var humidity = 30 + 40 * rng.nextDouble();
      //   var telemetryRequest = {
      //     'temperature': temperature,
      //     'humidity': humidity
      //   };
      //   print('Save telemetry request: $telemetryRequest');
      //   var res = await tbClient.getAttributeService().saveEntityTelemetry(
      //       savedDevice.id!, 'TELEMETRY', telemetryRequest);
      //   print('Save telemetry result: $res');
      // }

      await Future.delayed(const Duration(minutes: 10));
      subscription.unsubscribe();
      await tbClient.logout();
      print("Ended");
    } catch (e, s) {
      print('Error: $e');
      print('Stack: $s');
    }
  }
}
