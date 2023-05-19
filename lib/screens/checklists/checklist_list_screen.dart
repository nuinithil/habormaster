import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/id_name_args.dart';
import '../../providers/checklist_prov.dart';
import './checklist_detail_screen.dart';
import './checklist_edit_screen.dart';

class ChecklistListScreen extends StatelessWidget {
  const ChecklistListScreen({super.key});
  static const routeName = '/checklist_list_screen';

  @override
  Widget build(BuildContext context) {
    final checklists = Provider.of<Checklist>(context).checklists;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklists'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ChecklistEditScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Text('Some title.'),
          Expanded(
            child: ListView.builder(
              itemCount: checklists.length,
              itemBuilder: ((ctx, i) {
                return ListTile(
                  title: Text(
                    checklists[i].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ChecklistDetailScreen.routeName,
                      arguments: IdNameArgs(
                        id: checklists[i].id,
                        name: checklists[i].title,
                      ),
                    );
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
