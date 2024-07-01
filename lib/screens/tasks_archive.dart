import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/styles/styles.dart';

class TasksArchive extends ConsumerStatefulWidget {
  const TasksArchive({super.key});

  @override
  ConsumerState<TasksArchive> createState() => _TasksArchiveState();
}

class _TasksArchiveState extends ConsumerState<TasksArchive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive', style: Styles.appBar_text),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previous Tasks',
                style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
