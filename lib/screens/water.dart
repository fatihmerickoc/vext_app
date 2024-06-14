import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vext_app/styles/styles.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  //method that builds a toggleswitch for the plantStageList (Seed - Growth - Mature)
  Widget _plantStageList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ToggleSwitch(
            minWidth: 100,
            customTextStyles: [Styles.body_text.copyWith(color: Colors.black)],
            initialLabelIndex: 0,
            totalSwitches: 3,
            activeBgColor: const [Colors.white],
            inactiveBgColor: Colors.transparent,
            labels: const ['Seed', 'Growth', 'Mature'],
          ),
        ),
      ],
    );
  }

  //method that produces boxes for different ingredients such as Water, Vitamin A and Vitamin B
  Widget _statusBox(int flex, Color color, String title, value) {
    return Expanded(
      flex: flex,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Styles.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(15.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Styles.title_text,
              ),
            ),
          ),
          Container(
            height: 150, //this value will change based on the amount of water
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(15.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: Styles.title_text.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vext Status',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                children: [
                  _statusBox(2, Styles.lightBlue, 'Water', '2.5L'),
                  Styles.width_5,
                  _statusBox(1, Styles.muddyGreen, 'A', '46%'),
                  Styles.width_5,
                  _statusBox(1, Styles.orange, 'B', '55%'),
                ],
              ),
            ),
            Center(
              child: Text(
                'Plant stage',
                style: Styles.title_text.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Styles.height_10,
            _plantStageList(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Refill nutrients',
                style: Styles.title_text.copyWith(color: Styles.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
