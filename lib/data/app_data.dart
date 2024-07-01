import 'package:flutter/material.dart';
import 'package:vext_app/models/plant_model.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/screens/lights.dart';
import 'package:vext_app/screens/plant_guides.dart';
import 'package:vext_app/screens/tasks.dart';
import 'package:vext_app/screens/water.dart';

class AppData {
  final Map<String, IconData> homeItems = {
    'Tasks': Icons.checklist_rounded,
    'Plant\nGuides': Icons.egg_alt_outlined,
    'Lights\n100%': Icons.wb_sunny_outlined,
    'Refill in\n14 days': Icons.water_drop_outlined,
  };

  final homeRoutes = [
    const Tasks(),
    const PlantGuides(),
    const Lights(),
    const Water(),
  ];

  final List<PlantModel> plantData = [
    PlantModel(
      'Lettuce',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/lettuce.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Cherry tomatoes',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/tomato.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Basil',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/basil.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Corainder/cilantro',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/coriander.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Butter lettuce',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/butter_lettuce.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Strawberries',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/strawberry.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Mint',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/mint.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
    PlantModel(
      'Dill',
      'Known for its crisp texture and mild flavor, serves as a versatile ingredient in various culinary applications.',
      'assets/plants/dill.png',
      '7-14',
      '30-50',
      '4-8',
      'Harvest individual leaves by cutting the largest leaves from the outside of the plant. New leaves will grow from the center of the plant.To harvest the whole plant in a way that let’s it re-grow, trim two thirds of the plant with clean scissors.',
    ),
  ];

  final List<TaskModel> task_thisWeek = [
    TaskModel(
      task_title: 'Plant new capsules',
      task_dueDate: '2024-07-01T00:00:00.000',
      task_category: 'Plants',
    ),
    TaskModel(
      task_title: 'Refill water tank',
      task_dueDate: '2024-07-01T00:00:00.000',
      task_category: 'Water',
    ),
  ];

  final List<TaskModel> task_futureWeek = [
    TaskModel(
      task_title: 'Sweep the lid',
      task_dueDate: '2024-07-15T00:00:00.000',
      task_category: 'Device',
    ),
  ];
}
