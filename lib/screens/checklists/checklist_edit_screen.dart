import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/checklist_prov.dart';
import '../../models/id_fk_args.dart';

class ChecklistEditScreen extends StatefulWidget {
  const ChecklistEditScreen({super.key});
  static const routeName = '/checklist-edit';

  @override
  State<ChecklistEditScreen> createState() => _ChecklistEditScreenState();
}

class _ChecklistEditScreenState extends State<ChecklistEditScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  String? _checklistId;

  var _editedChecklist = ChecklistItem(
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
        _checklistId = arguments.pkId;
      }

      if (_checklistId != null) {
        _editedChecklist = Provider.of<Checklist>(context, listen: false)
            .checklistById(_checklistId.toString());
        _initValues = {
          'title': _editedChecklist.title,
          'id': _editedChecklist.id,
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

    _editedChecklist = ChecklistItem(
      id: _editedChecklist.id.isEmpty ? const Uuid().v4() : _editedChecklist.id,
      title: _editedChecklist.title,
    );

    print(_editedChecklist.toString());

    try {
      if (_checklistId == null) {
        print('loop add');
        Provider.of<Checklist>(context, listen: false)
            .addChecklistItem(_editedChecklist);
      } else {
        Provider.of<Checklist>(context, listen: false)
            .updateChecklistItem(_checklistId.toString(), _editedChecklist);
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
        title: const Text('Add Checklist'),
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
                    _editedChecklist = ChecklistItem(
                      id: _editedChecklist.id,
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
