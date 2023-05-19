import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/purchase_prov.dart';
import '../../models/id_fk_args.dart';

class PurchaseListEditScreen extends StatefulWidget {
  const PurchaseListEditScreen({super.key});
  static const routeName = '/purchase-list-edit';

  @override
  State<PurchaseListEditScreen> createState() => _ShoppingListEditScreenState();
}

class _ShoppingListEditScreenState extends State<PurchaseListEditScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  String? _shoppingListId;

  var _editedShoppingList = ShoppingListItem(
    id: '',
    title: '',
  );

  var _initValues = {
    'id': '',
    'title': '',
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

    setState(() {
      _isLoading = true;
    });

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
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add shoppingList'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    //valid
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedShoppingList = ShoppingListItem(
                      id: _editedShoppingList.id,
                      title: newValue ?? '',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
