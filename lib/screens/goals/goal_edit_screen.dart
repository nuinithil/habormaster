import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/goal_list_prov.dart';
import '../../models/id_fk_args.dart';

class GoalEditScreen extends StatefulWidget {
  const GoalEditScreen({super.key});
  static const routeName = '/goals-edit';

  @override
  State<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends State<GoalEditScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  String? _goalId;

  var _editedGoal = GoalItem(
    id: '',
    title: '',
    description: '',
  );

  var _initValues = {
    'id': '',
    'title': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments != null) {
        arguments = arguments as IdFkArgs;
        _goalId = arguments.pkId;
      }

      if (_goalId != null) {
        _editedGoal = Provider.of<Goals>(context, listen: false)
            .getGoalById(_goalId.toString());
        _initValues = {
          'title': _editedGoal.title,
          'id': _editedGoal.id,
          'description': _editedGoal.description ?? '',
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

    _editedGoal = GoalItem(
      id: _editedGoal.id.isEmpty ? const Uuid().v4() : _editedGoal.id,
      title: _editedGoal.title,
    );

    print(_editedGoal.toString());

    try {
      if (_goalId == null) {
        print('loop add');
        Provider.of<Goals>(context, listen: false).addGoal(_editedGoal);
      } else {
        Provider.of<Goals>(context, listen: false)
            .updateGoal(_goalId.toString(), _editedGoal);
      }
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Adding Goal'),
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
        title: const Text('Add Goals'),
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
                    _editedGoal = GoalItem(
                      id: _editedGoal.id,
                      title: newValue ?? '',
                      description: _editedGoal.description,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    //valid
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedGoal = GoalItem(
                      id: _editedGoal.id,
                      title: _editedGoal.title,
                      description: newValue ?? '',
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
