import 'package:flutter/material.dart';
import 'package:harbor_master/models/id_name_args.dart';
import 'package:harbor_master/screens/goals/goal_edit_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/goal_list_prov.dart';
import './goal_detail_screen.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({super.key});
  static const routeName = '/goal_list_screen';

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<Goals>(context).goals;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(GoalEditScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: ((ctx, i) {
                return ListTile(
                  title: Text(
                    goals[i].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(GoalDetailScreen.routeName,
                        arguments: IdNameArgs(
                          id: goals[i].id,
                          name: goals[i].title,
                        ));
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
