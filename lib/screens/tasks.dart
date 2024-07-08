import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/models/task_model.dart';
import 'package:vext_app/provider/vext_notifier.dart';
import 'package:vext_app/screens/tasks_archive.dart';
import 'package:vext_app/styles/styles.dart';

class Tasks extends ConsumerStatefulWidget {
  const Tasks({super.key});

  @override
  ConsumerState<Tasks> createState() => _TasksState();
}

class _TasksState extends ConsumerState<Tasks> {
  String _taskDueText() {
    return "Due in 0 days";
  }

  Widget _taskCategoryContainer(String category, String color) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Color(int.parse(color)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        category,
        style: Styles.subtitle_text.copyWith(fontWeight: FontWeight.w500),
      ),
    );
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
              _taskCategoryContainer(
                  task.task_category, task.task_category_color),
              Styles.width_15,
              const Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 18,
              ),
              Styles.width_5,
              Text(
                _taskDueText(),
                style: const TextStyle(fontSize: 13.0, color: Colors.grey),
              )
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
              const Icon(Icons.check_box_outline_blank),
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

  @override
  Widget build(BuildContext context) {
    final updatedVext = ref.watch(vextNotifierProvider);
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
                  itemCount: updatedVext.vext_tasks.length,
                  itemBuilder: (context, index) {
                    TaskModel task = updatedVext.vext_tasks[index];
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
                  itemCount: updatedVext.vext_completedTasks.length,
                  itemBuilder: (context, index) {
                    TaskModel task = updatedVext.vext_completedTasks[index];
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
