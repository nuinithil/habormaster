import 'package:flutter/material.dart';

import 'harbor_task.dart';

class ChecklistItem {
  final String id;
  final String title;
  final List<HarborTask>? tasks;

  ChecklistItem({
    required this.id,
    required this.title,
    this.tasks,
  });
}

class Checklist with ChangeNotifier {
  final List<ChecklistItem> _checklists = [
    ChecklistItem(id: 'C1', title: 'Checklist 1', tasks: [
      HarborTask(
        id: 'H1',
        title: 'A Task',
      ),
    ]),
    ChecklistItem(id: 'C2', title: 'Another One'),
    ChecklistItem(id: 'C3', title: 'Weeeeee'),
  ];

//-------SEARCH FUNCTIONS---------
  List<ChecklistItem> get checklists {
    return [..._checklists];
  }

  ChecklistItem checklistById(id) {
    return _checklists.firstWhere((item) => item.id == id);
  }

//-------DATA MANIPULATION FUNCTIONS---------
  void addChecklistItem(ChecklistItem item) {
    _checklists.add(item);
    notifyListeners();
  }

  void updateChecklistItem(String checklistId, ChecklistItem item) {
    final loopIndex =
        _checklists.indexWhere((checklist) => checklist.id == checklistId);
    if (loopIndex >= 0) {
      _checklists[loopIndex] = item;
      notifyListeners();
    }
  }
}
