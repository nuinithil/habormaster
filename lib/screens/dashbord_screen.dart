import 'package:flutter/material.dart';
import 'package:harbor_master/screens/goals/goal_list_screen.dart';
import 'package:harbor_master/screens/loops/loop_list_screen.dart';
import 'package:harbor_master/screens/purchase_lists/purchase_list_screen.dart';

import './checklists/checklist_list_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harbor Master'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('Menu'),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            ListTile(
              title: const Text('Checklists'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ChecklistListScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Loops'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LoopListScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Goals'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(GoalListScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Shopping'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(PurchaseListScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Due Dash',
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Text('To do lists here'),
            // child: ListView.builder(

            //     itemBuilder: ((context, index) => const ListTile(title: 'Item',))),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Shopping'),
          ),
          ElevatedButton(
            onPressed: (() {}),
            child: const Text('View Goals'),
          )
        ],
      ),
    );
  }
}
