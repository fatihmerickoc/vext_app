import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/providers/cabinet_provider.dart';
import 'package:vext_app/screens/tasks_archive.dart';
import 'package:vext_app/styles/styles.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Widget _taskContainer(TaskModel task, bool isFutureTask) {
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
              _taskCategoryContainer(task),
              Styles.width_15,
              const Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 18,
              ),
              Styles.width_5,
              _taskDueText(task),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.task_name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                  onTap: () => _completeTask(task, isFutureTask),
                  child: const Icon(Icons.check_box_outline_blank)),
            ],
          ),
          InkWell(
            onTap: () => debugPrint(task.task_description),
            child: Text(
              'Learn how',
              style: Styles.subtitle_text.copyWith(
                color: Colors.grey,
                decoration: TextDecoration.underline,
                decorationColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCategoryContainer(TaskModel task) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Color(int.parse(task.task_category_color)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        task.task_category,
        style: Styles.subtitle_text.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _taskDueText(TaskModel task) {
    String displayText = "";
    DateTime now = DateTime.now();
    int differenceInHours = task.task_dueDate.difference(now).inHours;

    if (differenceInHours <= 24) {
      displayText = "Due today";
    } else if (differenceInHours > 24 && differenceInHours <= 48) {
      displayText = "Due tomorrow";
    } else {
      int differenceInDays = task.task_dueDate.difference(now).inDays;

      displayText = "Due in $differenceInDays days";
    }

    return Text(
      displayText,
      style: const TextStyle(fontSize: 13.0, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cabinetProvider = Provider.of<CabinetProvider>(context);

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
                  itemCount: cabinetProvider.cabinet.cabinet_tasks!.length,
                  itemBuilder: (context, index) {
                    TaskModel task =
                        cabinetProvider.cabinet.cabinet_tasks![index];

                    return _taskContainer(task, false);
                  },
                ),
              ),
              Text(
                'Upcoming Tasks',
                style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      cabinetProvider.cabinet.cabinet_futureTasks!.length,
                  itemBuilder: (context, index) {
                    TaskModel task =
                        cabinetProvider.cabinet.cabinet_futureTasks![index];

                    return _taskContainer(task, true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeTask(TaskModel task, bool isFutureTask) async {
    final cabinetProvider =
        Provider.of<CabinetProvider>(context, listen: false);
    cabinetProvider.updateCabinetTask(task, isFutureTask: isFutureTask);

    setState(() {});
  }
}
