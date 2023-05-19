import 'package:flutter/material.dart';
import 'package:harbor_master/models/id_fk_args.dart';
import 'package:harbor_master/screens/purchase_lists/purchase_item_edit_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/purchase_prov.dart';
import './purchase_list_detail_screen.dart';

class PurchaseListScreen extends StatelessWidget {
  const PurchaseListScreen({super.key});
  static const routeName = '/purchase_list_screen';

  @override
  Widget build(BuildContext context) {
    final shoppingLists = Provider.of<ShoppingList>(context).shoppingLists;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PurchaseListEditScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          shoppingLists.isEmpty
              ? const Text('Add your first shopping list.')
              : Expanded(
                  child: ListView.builder(
                    itemCount: shoppingLists.length,
                    itemBuilder: ((ctx, i) {
                      return ListTile(
                        title: Text(
                          shoppingLists[i].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              PurchaseDetailScreen.routeName,
                              arguments: IdFkArgs(pkId: shoppingLists[i].id));
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
