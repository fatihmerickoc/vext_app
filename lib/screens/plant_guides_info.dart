import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vext_app/models/plant_model.dart';
import 'package:vext_app/styles/styles.dart';

class PlantGuidesInfo extends StatelessWidget {
  final PlantModel plant;
  const PlantGuidesInfo({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              Hero(
                tag: plant.plant_image_location,
                child: Image.asset(
                  plant.plant_image_location,
                ),
              ),
              Text(
                plant.plant_name,
                style: Styles.appBar_text.copyWith(
                  color: Styles.darkGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                plant.plant_description,
                style: Styles.title_text,
              ),
              Styles.height_15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset('assets/leaf.svg'),
                  SvgPicture.asset('assets/timer.svg'),
                  SvgPicture.asset('assets/plate.svg'),
                ],
              ),
              Styles.height_15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Sprouts in\n${plant.plant_sprout_time} days',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Harvest in\n${plant.plant_harvest_time} days',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Enjoy for\n${plant.plant_enjoy_time} weeks',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Styles.height_15,
              Text(
                'How to harvest',
                style: Styles.drawer_text.copyWith(
                  color: Styles.darkGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                plant.plant_how_to_harvest,
                style: Styles.title_text.copyWith(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
