import 'package:flutter/material.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/screens/plant_guides_info.dart';
import 'package:vext_app/styles/styles.dart';

class PlantGuides extends StatefulWidget {
  const PlantGuides({super.key});

  @override
  State<PlantGuides> createState() => _PlantGuidesState();
}

class _PlantGuidesState extends State<PlantGuides> {
  //method to build each plant for the gridview list
  Widget _plantItem(String name, String image, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantGuidesInfo(
            plant: AppData().plantData[index],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: image,
                child: Image.asset(
                  image,
                ),
              ),
            ),
            Text(
              name,
              style: Styles.body_text.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Read more',
              style: Styles.subtitle_text.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant guides',
          style: Styles.appBar_text,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: AppData().plantData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          mainAxisExtent: 190,
        ),
        itemBuilder: (context, index) {
          String name = AppData().plantData[index].plant_name;
          String image = AppData().plantData[index].plant_image_location;

          return _plantItem(name, image, index);
        },
      ),
    );
  }
}
