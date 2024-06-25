import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/models/vext_model.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/screens/drawer_screens/membership.dart';
import 'package:vext_app/screens/drawer_screens/profile.dart';
import 'package:vext_app/screens/drawer_screens/settings.dart';
import 'package:vext_app/screens/drawer_screens/support.dart';
import 'package:vext_app/styles/styles.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';
  static const username = 'fatih+tenant.admin@vext.fi';
  static const password = '782246Vext.';
  static const blackVextId = '7ffc0a50-0317-11ef-a0ef-7f542c4ca39c';

  @override
  void initState() {
    super.initState();
    subThingsBoard(
      keys: ['waterVolume', 'ssid'],
    );
  }

//method to create subscription to get telemetry updates
  Future<void> subThingsBoard({required List<String> keys}) async {
    try {
      VextModel vextModel = VextModel('', '', 0);

      var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

      await tbClient.login(LoginRequest(username, password));

      var deviceName = 'Black Vext';

      vextModel.vext_id = blackVextId;

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

      print("Started");

      subscription.entityDataStream.listen((entityDataUpdate) {
        if (entityDataUpdate.update != null) {
          for (var entityData in entityDataUpdate.update!) {
            entityData.timeseries.forEach((key, value) {
              for (var tsValue in value) {
                switch (key) {
                  case 'waterVolume':
                    vextModel.vext_waterLevel =
                        double.parse(tsValue.value!).round();
                    break;
                  case 'ssid':
                    vextModel.vext_network = tsValue.value!;
                }
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

      //   var telemetryRequest = {
      //     'temperature': temperature,
      //     'humidity': humidity
      //   };
      //   print('Save telemetry request: $telemetryRequest');
      //   var res = await tbClient.getAttributeService().saveEntityTelemetry(
      //       savedDevice.id!, 'TELEMETRY', telemetryRequest);
      //   print('Save telemetry result: $res');
      // }

      await Future.delayed(const Duration(milliseconds: 500));
      subscription.unsubscribe();
      await tbClient.logout();

      ref.watch(vextNotifierProvider.notifier).updateVext(vextModel);

      print("Ended");
    } catch (e, s) {
      print('Error: $e');
      print('Stack: $s');
    }
  }

  //method to create listTiles inside the drawer (My profile - Setting - Membership - Support )
  Widget _drawerTile({
    required String title,
    required Widget Function(BuildContext) pushedTo,
  }) {
    return ListTile(
      title: Text(title, style: Styles.drawer_text),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: pushedTo),
        );
      },
    );
  }

  //method to create the menu-button that opens the drawer
  Widget _menuButton() {
    return Builder(
      builder: (myContext) => GestureDetector(
        onTap: () => Scaffold.of(myContext).openDrawer(),
        child: const Align(
          alignment: Alignment.topLeft,
          child: Icon(
            Icons.menu_rounded,
            size: 30,
          ),
        ),
      ),
    );
  }

  //method to build 4 grid items on the list (Tasks - Plant Guides - Lights - Refill)
  Widget _gridItem(String text, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => AppData().homeRoutes[index])),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 32),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Styles.body_text,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Hi, Christian!',
                  style:
                      Styles.appBar_text.copyWith(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                )
              ],
            ),
            Styles.height_10,
            const Divider(),
            _drawerTile(
              title: 'My profile',
              pushedTo: (context) => const Profile(),
            ),
            _drawerTile(
              title: 'Settings',
              pushedTo: (context) => const Settings(),
            ),
            _drawerTile(
              title: 'Membership',
              pushedTo: (context) => const Membership(),
            ),
            _drawerTile(
              title: 'Support',
              pushedTo: (context) => const Support(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    _menuButton(),
                    Center(child: Image.asset('assets/plant_pod.png')),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 80,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: AppData().homeItems.length,
                  itemBuilder: (context, index) {
                    IconData icon = AppData().homeItems.values.elementAt(index);
                    String text = AppData().homeItems.keys.elementAt(index);

                    return _gridItem(text, icon, index);
                  },
                ),
              ),
              Styles.height_20,
            ],
          ),
        ),
      ),
    );
  }
}
