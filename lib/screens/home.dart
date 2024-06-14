import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/screens/drawer_screens/membership.dart';
import 'package:vext_app/screens/drawer_screens/profile.dart';
import 'package:vext_app/screens/drawer_screens/settings.dart';
import 'package:vext_app/screens/drawer_screens/support.dart';
import 'package:vext_app/styles/styles.dart';
import 'package:vext_app/provider/vext_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
            ],
          ),
        ),
      ),
    );
  }
}
