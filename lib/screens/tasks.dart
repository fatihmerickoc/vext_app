import 'package:flutter/material.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/screens/tasks_archive.dart';
import 'package:vext_app/styles/styles.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  String _calendarText(String taskDueDate) {
    DateTime now = DateTime.now();
    DateTime task = DateTime.parse(taskDueDate);
    int difference = task.difference(now).inDays;

    if (difference == 0) {
      return "Due today";
    } else {
      return "Due in ${difference} days";
    }
  }

  Widget _taskContainer(TaskModel task) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(
        bottom: 10.0,
        top: 5.0,
        right: 10.0,
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _categoryContainer(task.task_category),
              Styles.width_15,
              const Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 18,
              ),
              Styles.width_5,
              Text(
                _calendarText(task.task_dueDate),
                style: const TextStyle(fontSize: 13.0, color: Colors.grey),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.task_title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.check_box_outline_blank),
            ],
          ),
          Text(
            'Learn how',
            style: Styles.subtitle_text.copyWith(
              color: Colors.grey,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryContainer(String category) {
    late Color color;
    switch (category) {
      case 'Device':
        color = Colors.red.shade200;
        break;
      case 'Water':
        color = Colors.blue.shade200;
        break;
      case "Plants":
        color = Colors.green.shade200;
        break;
      default:
        color = Colors.pink.shade200;
    }
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        category,
        style: Styles.subtitle_text.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: Styles.appBar_text,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TasksArchive()));
            },
            icon: const Icon(Icons.archive_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Week',
                style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AppData().task_thisWeek.length,
                  itemBuilder: (context, index) {
                    TaskModel task = AppData().task_thisWeek[index];
                    return _taskContainer(task);
                  },
                ),
              ),
              Text(
                'Upcoming Tasks',
                style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AppData().task_futureWeek.length,
                  itemBuilder: (context, index) {
                    TaskModel task = AppData().task_futureWeek[index];
                    return _taskContainer(task);
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
