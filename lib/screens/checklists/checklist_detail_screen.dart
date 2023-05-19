import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/id_fk_args.dart';
import '../../models/id_name_args.dart';
import '../tasks/task_edit_screen.dart';
import '../../providers/harbor_task.dart';

class ChecklistDetailScreen extends StatefulWidget {
  static const routeName = '/checklist_detail';

  const ChecklistDetailScreen({super.key});

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    const fkType = 'checklist';
    final args = ModalRoute.of(context)?.settings.arguments as IdNameArgs;
    final checklistID = args.id;
    final checklistName = args.name;
    var taskData = Provider.of<HarborTaskList>(context)
        .getTaskByChecklistId(checklistID.toString());

    void _toggleTaskComplete(String taskId, bool isComplete) {
      Provider.of<HarborTaskList>(context, listen: false)
          .toggleComplete(taskId, isComplete);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(checklistName.toString()),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(TaskEditScreen.routeName,
                  arguments: IdFkArgs(
                    fkId: checklistID,
                    fkType: fkType,
                  ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskData.length,
        itemBuilder: ((ctx, i) {
          return ListTile(
            style: ListTileStyle.list,
            leading: IconButton(
              icon: taskData[i].isComplete
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.circle_outlined),
              onPressed: () {
                _toggleTaskComplete(
                  taskData[i].id,
                  taskData[i].isComplete,
                );
              },
            ),
            title: Text(
              taskData[i].title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                if (taskData[i].dueDate != null)
                  Expanded(
                    child: Text(taskData[i].dueDate.toString()),
                  ),
                Expanded(
                  child: Text(
                    taskData[i].description.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                TaskEditScreen.routeName,
                arguments: IdFkArgs(
                  fkId: checklistID,
                  pkId: taskData[i].id,
                  fkType: fkType,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
