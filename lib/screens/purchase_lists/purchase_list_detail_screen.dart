import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/purchase_prov.dart';
import '../../models/id_fk_args.dart';

class PurchaseDetailScreen extends StatefulWidget {
  const PurchaseDetailScreen({super.key});
  static const routeName = '/purchase-detail';

  @override
  State<PurchaseDetailScreen> createState() => _ShoppingListEditScreenState();
}

class _ShoppingListEditScreenState extends State<PurchaseDetailScreen> {
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  String? _shoppingListId;

  var _editedShoppingList = ShoppingListItem(
    id: '',
    title: '',
    shoppingList: '',
  );

  var _initValues = {
    'id': '',
    'title': '',
    'shoppingList': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments != null) {
        arguments = arguments as IdFkArgs;
        _shoppingListId = arguments.pkId;
      }

      if (_shoppingListId != null) {
        _editedShoppingList = Provider.of<ShoppingList>(context, listen: false)
            .getShoppingListById(_shoppingListId.toString());
        _initValues = {
          'title': _editedShoppingList.title,
          'id': _editedShoppingList.id,
          'shoppingList': _editedShoppingList.shoppingList ?? '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _form.currentState?.save();

    _editedShoppingList = ShoppingListItem(
      id: _editedShoppingList.id.isEmpty
          ? const Uuid().v4()
          : _editedShoppingList.id,
      title: _editedShoppingList.title,
    );

    print(_editedShoppingList.toString());

    try {
      if (_shoppingListId == null) {
        print('loop add');
        Provider.of<ShoppingList>(context, listen: false)
            .addShoppingList(_editedShoppingList);
      } else {
        Provider.of<ShoppingList>(context, listen: false).updateShoppingList(
            _shoppingListId.toString(), _editedShoppingList);
      }
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Adding Loop'),
          content: Text('Something went wrong. $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedShoppingList.title),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['shoppingList'],
                      decoration: InputDecoration(
                          labelText: _editedShoppingList.title,
                          border: InputBorder.none,
                          labelStyle: const TextStyle(fontSize: 30),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 10,
                          )),
                      minLines: 2,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        //valid
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedShoppingList = ShoppingListItem(
                          id: _editedShoppingList.id,
                          title: _editedShoppingList.title,
                          shoppingList: newValue ?? '',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
