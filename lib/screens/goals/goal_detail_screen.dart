import 'package:flutter/material.dart';
import 'package:harbor_master/providers/harbor_task.dart';
import 'package:provider/provider.dart';

import '../../models/id_fk_args.dart';
import '../../models/id_name_args.dart';
import '../tasks/task_edit_screen.dart';
import '../../providers/goal_list_prov.dart';

class GoalDetailScreen extends StatefulWidget {
  static const routeName = '/goal-detail-screen';

  const GoalDetailScreen({super.key});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    const fkType = 'goal';
    final args = ModalRoute.of(context)?.settings.arguments as IdNameArgs;
    final goalId = args.id;
    var goalData = Provider.of<Goals>(context).getGoalById(goalId.toString());
    final String goalDescription = goalData.description ?? '';
    final List<HarborTask> goalMilestones = goalData.milestones;
    return Scaffold(
      appBar: AppBar(
        title: Text(goalData.title.toString()),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                if (goalDescription.isNotEmpty) Text(goalDescription),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                'Milestones',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(TaskEditScreen.routeName,
                    arguments: IdFkArgs(
                      fkId: goalId,
                      fkType: fkType,
                    ));
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: goalMilestones.length,
            itemBuilder: ((ctx, i) {
              return ListTile(
                title: Text(
                  goalMilestones[i].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                shape: const Border(
                    bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                  style: BorderStyle.solid,
                )),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    TaskEditScreen.routeName,
                    arguments: IdFkArgs(
                      fkId: goalId,
                      pkId: goalMilestones[i].id,
                      fkType: fkType,
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ]),
    );
  }
}
