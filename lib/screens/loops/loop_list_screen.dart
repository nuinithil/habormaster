import 'package:flutter/material.dart';
import 'package:harbor_master/models/id_name_args.dart';
import 'package:provider/provider.dart';

import '../../providers/loop_prov.dart';
import './loop_edit_screen.dart';

import './loop_detail_screen.dart';

class LoopListScreen extends StatelessWidget {
  const LoopListScreen({super.key});
  static const routeName = '/loop_list_screen';

  @override
  Widget build(BuildContext context) {
    final loopsProv = Provider.of<Loop>(context);
    final loops = loopsProv.loops;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loops'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LoopEditScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Column(
        children: <Widget>[
          loops.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      const Divider(),
                      Text(
                        'Add your first Loop!',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: loops.length,
                    itemBuilder: ((ctx, i) {
                      return ListTile(
                        title: Text(
                          loops[i].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(LoopDetailScreen.routeName,
                                  arguments: IdNameArgs(
                                    id: loops[i].id,
                                    name: loops[i].title,
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
