import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vext_app/styles/styles.dart';

class Lights extends StatefulWidget {
  const Lights({super.key});

  @override
  State<Lights> createState() => _LightsState();
}

class _LightsState extends State<Lights> {
  Widget _lightsTile(String title, trailing, svgIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Styles.yellow),
          bottom: BorderSide(color: Styles.yellow),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Styles.title_text.copyWith(fontWeight: FontWeight.w300),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 8.0,
            ),
            decoration: const BoxDecoration(
              color: Styles.grey,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Text(
              trailing,
              style: Styles.title_text,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          SvgPicture.asset(svgIcon)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lights',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Styles.height_30,
            Text(
              'Light Schedule',
              style: Styles.title_text.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              'Aim for 14 - 16 hours of light each day',
              style: Styles.body_text.copyWith(fontWeight: FontWeight.w300),
            ),
            Styles.height_20,
            _lightsTile('Turn on at', '06:00', 'assets/sunrise.svg'),
            Styles.height_20,
            _lightsTile('Turn off at', '22:00', 'assets/sunset.svg'),
            Styles.height_30,
            const Text(
              '16 hours is plenty of light!',
              style: Styles.title_text,
            ),
            Styles.height_30,
            const Text(
              'Why is light so important',
              style: Styles.title_text,
            ),
            Text(
              'The right amount of light helps plants reach\ntheir full potential and stay healthy. Giving you better results, and more to harvest!',
              textAlign: TextAlign.center,
              style: Styles.body_text.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
