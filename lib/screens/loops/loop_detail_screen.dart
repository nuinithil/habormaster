import 'package:flutter/material.dart';
import 'package:harbor_master/screens/tasks/task_edit_screen.dart';
import 'package:provider/provider.dart';

import '../../models/id_name_args.dart';
import '../../models/id_fk_args.dart';
import '../../providers/loop_prov.dart';

class LoopDetailScreen extends StatefulWidget {
  const LoopDetailScreen({super.key});
  static const routeName = '/loop_detail_screen';

  @override
  State<LoopDetailScreen> createState() => _LoopDetailScreenState();
}

class _LoopDetailScreenState extends State<LoopDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as IdNameArgs;
    final loopId = args.id;
    final loopName = args.name;
    const fkType = 'loop';
    var loopTasks =
        Provider.of<Loop>(context).getLoopTasksById(loopId.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(loopName.toString()),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                TaskEditScreen.routeName,
                arguments: IdFkArgs(
                  fkId: loopId,
                  fkType: fkType,
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: loopTasks == null
          ? const Text('Add a task to your loop.')
          : ListView.builder(
              itemCount: loopTasks.length,
              itemBuilder: ((ctx, i) {
                return ListTile(
                  title: Text(
                    loopTasks[i].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      TaskEditScreen.routeName,
                      arguments: IdFkArgs(
                        pkId: loopTasks[i].id,
                        fkId: loopId,
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
