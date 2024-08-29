import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/providers/cabinet_provider.dart';

import 'package:vext_app/screens/drawer_screens/membership.dart';
import 'package:vext_app/screens/drawer_screens/profile.dart';
import 'package:vext_app/screens/drawer_screens/settings.dart';
import 'package:vext_app/screens/drawer_screens/support.dart';
import 'package:vext_app/styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
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
    final cabinetProvider =
        Provider.of<CabinetProvider>(context, listen: false);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DrawerHeader(
              child: Text(
                cabinetProvider.cabinet.cabinet_owner?.owner_displayName == null
                    ? 'Welcome'
                    : "Hi, ${cabinetProvider.cabinet.cabinet_owner?.owner_displayName}",
                style: Styles.appBar_text.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
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
      body: _futureBuilder(),
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
      future: Provider.of<CabinetProvider>(
        context,
        listen: false,
      ).fetchCabinet(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        _menuButton(),
                        Center(
                          child: Image.asset('assets/plant_pod.png'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 80,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: AppData().homeItems.length,
                      itemBuilder: (context, index) {
                        IconData icon =
                            AppData().homeItems.values.elementAt(index);
                        String text = AppData().homeItems.keys.elementAt(index);

                        return _gridItem(text, icon, index);
                      },
                    ),
                  ),
                  Styles.height_20,
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.bouncingBall(
              color: Styles.darkGreen,
              size: 200,
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Error fetching data',
              style: Styles.title_text,
            ),
          );
        }
      },
    );
  }
}
