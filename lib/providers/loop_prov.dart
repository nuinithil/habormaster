import 'package:flutter/material.dart';
import './harbor_task.dart';

class LoopItem {
  final String id;
  final String title;
  List<HarborTask> tasks;

  LoopItem({
    required this.id,
    required this.title,
    List<HarborTask>? tasks,
  }) : tasks = tasks ?? [];
}

class Loop with ChangeNotifier {
  final List<LoopItem> _loops = [];

//-------SEARCH FUNCTIONS---------
  List<LoopItem> get loops {
    return [..._loops];
  }

  LoopItem getLoopById(id) {
    return _loops.firstWhere((loop) => loop.id == id);
  }

  List<HarborTask>? getLoopTasksById(id) {
    return _loops.firstWhere((loop) => loop.id == id).tasks;
  }

  void addLoop(LoopItem loop) {
    _loops.add(loop);
    notifyListeners();
  }

  void addLoopTask(String loopId, HarborTask task) {
    LoopItem loopItem = getLoopById(loopId);
    print(loopItem.tasks.toString());
    loopItem.tasks.add(task);
    updateLoopItem(loopId, loopItem);
    notifyListeners();
  }

  void updateLoopTask(String taskId, String loopId, HarborTask task) {
    LoopItem loopItem = getLoopById(loopId);
    final taskIndex = loopItem.tasks.indexWhere((task) => task.id == taskId);
    loopItem.tasks[taskIndex] = task;
    updateLoopItem(loopId, loopItem);
    notifyListeners();
  }

  void updateLoopItem(String loopId, LoopItem loop) {
    final loopIndex = _loops.indexWhere((loop) => loop.id == loopId);
    if (loopIndex >= 0) {
      _loops[loopIndex] = loop;
      notifyListeners();
    }
  }
}
