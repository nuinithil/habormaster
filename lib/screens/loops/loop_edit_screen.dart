import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/loop_prov.dart';
import '../../models/id_fk_args.dart';

class LoopEditScreen extends StatefulWidget {
  const LoopEditScreen({super.key});
  static const routeName = '/loop-edit';

  @override
  State<LoopEditScreen> createState() => _LoopEditScreenState();
}

class _LoopEditScreenState extends State<LoopEditScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  String? _loopId;

  var _editedLoop = LoopItem(
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
        _loopId = arguments.pkId;
      }

      if (_loopId != null) {
        _editedLoop = Provider.of<Loop>(context, listen: false)
            .getLoopById(_loopId.toString());
        _initValues = {
          'title': _editedLoop.title,
          'id': _editedLoop.id,
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

    _editedLoop = LoopItem(
      id: _editedLoop.id.isEmpty ? const Uuid().v4() : _editedLoop.id,
      title: _editedLoop.title,
    );

    print(_editedLoop.toString());

    try {
      if (_loopId == null) {
        print('loop add');
        Provider.of<Loop>(context, listen: false).addLoop(_editedLoop);
      } else {
        Provider.of<Loop>(context, listen: false)
            .updateLoopItem(_loopId.toString(), _editedLoop);
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
        title: const Text('Loop'),
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
                    _editedLoop = LoopItem(
                      id: _editedLoop.id,
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
