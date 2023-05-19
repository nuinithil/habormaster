import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/harbor_task.dart';
import '../../providers/loop_prov.dart';
import '../../providers/goal_list_prov.dart';
import '../../models/id_fk_args.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen({super.key});
  static const routeName = '/task-edit';

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  String? _foreignKeyId = '';
  String? _fkType = '';
  String? _taskID;

  var _editedTask = HarborTask(
    id: '',
    checklistId: '',
    loopId: '',
    goalId: '',
    title: '',
    reminderDate: null,
    repetitionPeriod: 0,
    repetitionType: '',
    description: '',
    dueDate: null,
    isComplete: false,
    lastCompleted: null,
  );

  var _initValues = {
    'id': '',
    'checklistId': '',
    'loopId': '',
    'goalId': '',
    'title': '',
    'reminderDate': '',
    'repetitionPeriod': '',
    'repetitionType': '',
    'description': '',
    'dueDate': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arguments = ModalRoute.of(context)!.settings.arguments as IdFkArgs;
      _foreignKeyId = arguments.fkId;
      print('Foreign Key: $_foreignKeyId');
      _taskID = arguments.pkId;
      _fkType = arguments.fkType;

      if (_taskID != null) {
        _editedTask = Provider.of<HarborTaskList>(context, listen: false)
            .getTaskByID(_taskID.toString());
        _initValues = {
          'title': _editedTask.title,
          ''
                  'reminderDate':
              _editedTask.reminderDate == null
                  ? ''
                  : _editedTask.reminderDate.toString(),
          'repetitionPeriod': _editedTask.repetitionPeriod == null
              ? ''
              : _editedTask.repetitionPeriod.toString(),
          'repetitionType': _editedTask.repetitionType ?? '',
          'description': _editedTask.description ?? '',
          'dueDate':
              _editedTask.dueDate == null ? '' : _editedTask.dueDate.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;

    if (!isValid) {
      print('invalid');
      return;
    }

    _form.currentState?.save();
    print('saving');
    setState(() {
      _isLoading = true;
    });

    _editedTask = HarborTask(
      id: _editedTask.id.isEmpty ? const Uuid().v4() : _editedTask.id,
      checklistId: _fkType == 'checklist' ? _foreignKeyId : null,
      loopId: _fkType == 'loop' ? _foreignKeyId : null,
      goalId: _fkType == 'goal' ? _foreignKeyId : null,
      title: _editedTask.title,
      description: _editedTask.description,
      dueDate: _editedTask.dueDate,
      reminderDate: _editedTask.reminderDate,
      repetitionPeriod: _editedTask.repetitionPeriod,
      repetitionType: _editedTask.repetitionType,
      isComplete: _editedTask.isComplete,
      lastCompleted: _editedTask.lastCompleted,
    );
    print(_editedTask.toString());
    try {
      if (_taskID == null) {
        print('adding task');
        Provider.of<HarborTaskList>(context, listen: false)
            .addTask(_editedTask);
        if (_fkType == 'loop') {
          Provider.of<Loop>(context, listen: false)
              .addLoopTask(_foreignKeyId as String, _editedTask);
        }
        if (_fkType == 'goal') {
          Provider.of<Goals>(context, listen: false)
              .addGoalMilestone(_foreignKeyId as String, _editedTask);
        }
      } else {
        //Update Task
        Provider.of<HarborTaskList>(context, listen: false)
            .updateTask(_taskID.toString(), _editedTask);

        //Update dependents
        if (_fkType == 'loop') {
          Provider.of<Loop>(context, listen: false).updateLoopTask(
              _taskID as String, _foreignKeyId as String, _editedTask);
        }

        if (_fkType == 'goal') {
          Provider.of<Goals>(context, listen: false).updateGoalMilestone(
              _taskID as String, _foreignKeyId as String, _editedTask);
        }
      }
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Adding Task'),
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
        title: const Text('Task'),
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
                    _editedTask = HarborTask(
                        id: _editedTask.id,
                        title: newValue ?? '',
                        description: _editedTask.description,
                        dueDate: _editedTask.dueDate,
                        reminderDate: _editedTask.reminderDate,
                        repetitionPeriod: _editedTask.repetitionPeriod,
                        repetitionType: _editedTask.repetitionType,
                        isComplete: _editedTask.isComplete,
                        lastCompleted: _editedTask.lastCompleted);
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 4,
                  onSaved: (newValue) {
                    _editedTask = HarborTask(
                        id: _editedTask.id,
                        title: _editedTask.title,
                        description: newValue ?? '',
                        dueDate: _editedTask.dueDate,
                        reminderDate: _editedTask.reminderDate,
                        repetitionPeriod: _editedTask.repetitionPeriod,
                        repetitionType: _editedTask.repetitionType,
                        isComplete: _editedTask.isComplete,
                        lastCompleted: _editedTask.lastCompleted);
                  },
                ),
                if (_fkType == 'checklist')
                  TextFormField(
                    initialValue: _initValues['dueDate'],
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (newValue) {
                      _editedTask = HarborTask(
                          id: _editedTask.id,
                          title: _editedTask.title,
                          description: _editedTask.description,
                          dueDate: DateTime.tryParse(newValue ?? ''),
                          reminderDate: _editedTask.reminderDate,
                          repetitionPeriod: _editedTask.repetitionPeriod,
                          repetitionType: _editedTask.repetitionType,
                          isComplete: _editedTask.isComplete,
                          lastCompleted: _editedTask.lastCompleted);
                    },
                  ),
                if (_fkType == 'checklist')
                  TextFormField(
                    initialValue: _initValues['reminderDate'],
                    decoration: const InputDecoration(
                      labelText: 'Reminder Date',
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (newValue) {
                      _editedTask = HarborTask(
                          id: _editedTask.id,
                          title: _editedTask.title,
                          description: _editedTask.description,
                          dueDate: _editedTask.dueDate,
                          reminderDate: DateTime.tryParse(newValue ?? ''),
                          repetitionPeriod: _editedTask.repetitionPeriod,
                          repetitionType: _editedTask.repetitionType,
                          isComplete: _editedTask.isComplete,
                          lastCompleted: _editedTask.lastCompleted);
                    },
                  ),
                if (_fkType == 'checklist')
                  TextFormField(
                    initialValue: _initValues['repetitionType'],
                    decoration: const InputDecoration(
                      labelText: 'Repetition Type',
                    ),
                    onSaved: (newValue) {
                      _editedTask = HarborTask(
                          id: _editedTask.id,
                          title: _editedTask.title,
                          description: _editedTask.description,
                          dueDate: _editedTask.dueDate,
                          reminderDate: _editedTask.reminderDate,
                          repetitionPeriod: int.tryParse(newValue ?? ''),
                          repetitionType: _editedTask.repetitionType,
                          isComplete: _editedTask.isComplete,
                          lastCompleted: _editedTask.lastCompleted);
                    },
                  ),
                if (_fkType == 'checklist')
                  TextFormField(
                    initialValue: _initValues['repetitionPeriod'],
                    decoration: const InputDecoration(
                      labelText: 'Repetition Period',
                    ),
                    onSaved: (newValue) {
                      _editedTask = HarborTask(
                          id: _editedTask.id,
                          title: _editedTask.title,
                          description: _editedTask.description,
                          dueDate: _editedTask.dueDate,
                          reminderDate: _editedTask.reminderDate,
                          repetitionPeriod: _editedTask.repetitionPeriod,
                          repetitionType: newValue ?? '',
                          isComplete: _editedTask.isComplete,
                          lastCompleted: _editedTask.lastCompleted);
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
