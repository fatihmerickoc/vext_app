import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/screens/drawer_screens/membership.dart';
import 'package:vext_app/screens/drawer_screens/profile.dart';
import 'package:vext_app/screens/drawer_screens/settings.dart';
import 'package:vext_app/screens/drawer_screens/support.dart';
import 'package:vext_app/styles/styles.dart';
import 'package:vext_app/provider/vext_provider.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'dart:math';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    subsribeThingsboard();
  }

  //method to create subscription to get device data and telemetry updates using Entity Data Query API over WebSocket API
  Future<void> subsribeThingsboard() async {
    try {
      var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

      await tbClient.login(LoginRequest('**************', '************'));

      var deviceName = 'Black Vext';

      print('TEST');

      // Create entity filter to get device by its name
      var entityFilter = EntityNameFilter(
          entityType: EntityType.DEVICE, entityNameFilter: deviceName);

      // Prepare list of queried device fields
      var deviceFields = <EntityKey>[
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'turnOffTime'),
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'turnOnTime'),
        EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'pumpOnSeconds')
      ];

      // Prepare list of queried device timeseries
      var deviceTelemetry = <EntityKey>[
        EntityKey(type: EntityKeyType.TIME_SERIES, key: 'waterVolume'),
        EntityKey(type: EntityKeyType.TIME_SERIES, key: 'isDoorOpen')
      ];

      // Create entity query with provided entity filter, queried fields and page link
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

      // Create timeseries subscription command to get data for 'temperature' and 'humidity' keys for last hour with realtime updates
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var timeWindow = const Duration(hours: 1).inMilliseconds;

      var tsCmd = TimeSeriesCmd(
          keys: ['waterVolume', 'isDoorOpen'],
          startTs: currentTime - timeWindow,
          timeWindow: timeWindow);

      // Create subscription command with entities query and timeseries subscription
      var cmd = EntityDataCmd(query: devicesQuery, tsCmd: tsCmd);

      // Create subscription with provided subscription command
      var telemetryService = tbClient.getTelemetryService();
      var subscription = TelemetrySubscriber(telemetryService, [cmd]);

      // Create listener to get data updates from WebSocket
      subscription.entityDataStream.listen((entityDataUpdate) {
        print('Received entity data update: $entityDataUpdate');
      });

      // Perform subscribe (send subscription command via WebSocket API and listen for responses)
      subscription.subscribe();

      // Finally unsubscribe to release subscription
      subscription.unsubscribe();

      // Finally perform logout to clear credentials
      await tbClient.logout();
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
    final myVext = ref.watch(vextProvider);
    final updatedVext = ref.watch(vextNotifierProvider);

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
