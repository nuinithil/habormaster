import 'package:flutter/material.dart';

class HarborTask {
  final String id;
  final String? checklistId;
  final String? loopId;
  final String? goalId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final String? repetitionType;
  final int? repetitionPeriod;
  bool isComplete;
  DateTime? lastCompleted;

  HarborTask({
    required this.id,
    this.checklistId,
    this.loopId,
    this.goalId,
    this.description,
    this.dueDate,
    this.reminderDate,
    this.repetitionPeriod,
    this.repetitionType,
    required this.title,
    this.isComplete = false,
    this.lastCompleted,
  });
}

//-------SEARCH FUNCTIONS---------

class HarborTaskList with ChangeNotifier {
  final List<HarborTask> _taskList = [];

  List<HarborTask> get taskList {
    return [..._taskList];
  }

  HarborTask getTaskByID(
    String taskID,
  ) {
    return _taskList.firstWhere((tsk) => tsk.id == taskID);
  }

  List<HarborTask> getTaskByChecklistId(
    String checklistId,
  ) {
    return _taskList.where((tsk) => tsk.checklistId == checklistId).toList();
  }

  List<HarborTask> getTaskByLoopId(
    String loopId,
  ) {
    return _taskList.where((tsk) => tsk.loopId == loopId).toList();
  }

  List<HarborTask> getTaskByGoalId(
    String goalId,
  ) {
    return _taskList.where((tsk) => tsk.goalId == goalId).toList();
  }

//-------ADD/UPDATE/DELETE FUNCTIONS---------

  void addTask(HarborTask task) {
    print('task added in function.');
    _taskList.add(task);
    notifyListeners();
  }

  void updateTask(
    String taskID,
    HarborTask task,
  ) {
    final taskIndex = _taskList.indexWhere((task) => task.id == taskID);
    if (taskIndex >= 0) {
      _taskList[taskIndex] = task;
      notifyListeners();
    }
  }

  void toggleComplete(String taskID, bool isComplete) {
    final taskIndex = _taskList.indexWhere((task) => task.id == taskID);
    if (taskIndex >= 0) {
      _taskList[taskIndex].isComplete = !isComplete;
      if (isComplete == false) {
        _taskList[taskIndex].lastCompleted = DateTime.now();
      }
      notifyListeners();
    }
  }
}
