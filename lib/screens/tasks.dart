import 'package:flutter/material.dart';
import 'package:vext_app/data/app_data.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/styles/styles.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<TaskModel> thisWeekTasks = [];
  List<TaskModel> futureTasks = [
    TaskModel(
        task_dueDay: 'in 14 days',
        task_category: 'Device',
        task_title: 'Sweep the lid'),
  ]; // Dummy future task

  @override
  void initState() {
    super.initState();
    thisWeekTasks =
        List.from(AppData().taskData); // Assuming all tasks are for this week
  }

  Color getCategoryColour(String category) {
    switch (category) {
      case "Plants":
        return Styles.lightGreen;
      case "Device":
        return Styles.lightRed;
      case "Water":
        return Styles.lightBlue;
      default:
        return Colors.grey;
    }
  }

  void _removeTask(TaskModel task) {
    setState(() {
      thisWeekTasks.remove(task);
      futureTasks.remove(task); // If you also want to remove from future tasks
    });
  }

  Widget _topRow(String due, String category, TaskModel task) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: getCategoryColour(category),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            category,
            style: Styles.body_text,
          ),
        ),
        Styles.width_10,
        const Icon(
          Icons.calendar_today,
          size: 20,
          color: Styles.yellow,
        ),
        Styles.width_5,
        Text(
          'Due $due',
          style: Styles.body_text
              .copyWith(color: Styles.yellow, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _taskCard(TaskModel task) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topRow(task.task_dueDay, task.task_category, task),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.task_title,
                  style:
                      Styles.title_text.copyWith(fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.check_box_outline_blank_rounded),
                  onPressed: () => _removeTask(task),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Learn how',
              style: Styles.body_text.copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskList(List<TaskModel> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return _taskCard(tasks[index]);
      },
    );
  }

  Widget _section(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Styles.title_text,
          ),
          Styles.height_10,
          content,
        ],
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section(
                'This Week',
                SizedBox(
                  height: 300,
                  child: _taskList(thisWeekTasks),
                ),
              ),
              Spacer(),
              _section(
                'Future Tasks',
                SizedBox(
                  height: 250,
                  child: _taskList(futureTasks),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
