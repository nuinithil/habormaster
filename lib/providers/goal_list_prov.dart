import 'package:flutter/material.dart';
import 'package:harbor_master/providers/harbor_task.dart';

class GoalItem {
  final String id;
  final String title;
  final String? description;
  final List<HarborTask> milestones;

  GoalItem({
    required this.id,
    required this.title,
    this.description,
    List<HarborTask>? milestones,
  }) : milestones = milestones ?? [];
}

class Goals with ChangeNotifier {
  final List<GoalItem> _goals = [];

//-------SEARCH FUNCTIONS---------
  List<GoalItem> get goals {
    return [..._goals];
  }

  GoalItem getGoalById(id) {
    return _goals.firstWhere((goal) => goal.id == id);
  }

//-------DATA MANIPULATION FUNCTIONS---------
  void addGoal(GoalItem item) {
    _goals.add(item);
    notifyListeners();
  }

  void updateGoal(String goalId, GoalItem item) {
    final loopIndex = _goals.indexWhere((goal) => goal.id == goalId);
    if (loopIndex >= 0) {
      _goals[loopIndex] = item;
      notifyListeners();
    }
  }

  void addGoalMilestone(String goalId, HarborTask task) {
    GoalItem goalItem = getGoalById(goalId);
    goalItem.milestones.add(task);
    updateGoal(goalId, goalItem);
    notifyListeners();
  }

  void updateGoalMilestone(String taskId, String goalId, HarborTask task) {
    GoalItem goalItem = getGoalById(goalId);
    final milestoneIndex =
        goalItem.milestones.indexWhere((task) => task.id == taskId);
    goalItem.milestones[milestoneIndex] = task;
    updateGoal(goalId, goalItem);
    notifyListeners();
  }
}
