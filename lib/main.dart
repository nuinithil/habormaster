import 'package:flutter/material.dart';
import 'package:harbor_master/screens/purchase_lists/purchase_item_edit_screen.dart';
import 'package:provider/provider.dart';

import './screens/dashbord_screen.dart';
import './screens/checklists/checklist_list_screen.dart';
import './screens/checklists/checklist_detail_screen.dart';
import './screens/checklists/checklist_edit_screen.dart';
import './screens/tasks/task_edit_screen.dart';
import './screens/goals/goal_list_screen.dart';
import './screens/goals/goal_detail_screen.dart';
import './screens/goals/goal_edit_screen.dart';
import './screens/loops/loop_list_screen.dart';
import './screens/loops/loop_detail_screen.dart';
import './screens/loops/loop_edit_screen.dart';
import './screens/purchase_lists/purchase_list_screen.dart';
import './screens/purchase_lists/purchase_list_detail_screen.dart';

import './providers/checklist_prov.dart';
import './providers/loop_prov.dart';
import './providers/harbor_task.dart';
import './providers/goal_list_prov.dart';
import './providers/purchase_prov.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((ctx) => Checklist())),
        ChangeNotifierProvider(create: ((ctx) => HarborTaskList())),
        ChangeNotifierProvider(create: ((ctx) => Loop())),
        ChangeNotifierProvider(create: ((ctx) => Goals())),
        ChangeNotifierProvider(create: ((context) => ShoppingList())),
      ],
      child: MaterialApp(
        title: 'Harbor Master',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: Colors.greenAccent),
        ),
        home: const DashBoardScreen(),
        routes: {
          ChecklistListScreen.routeName: (ctx) => const ChecklistListScreen(),
          ChecklistDetailScreen.routeName: (ctx) =>
              const ChecklistDetailScreen(),
          ChecklistEditScreen.routeName: (ctx) => const ChecklistEditScreen(),
          TaskEditScreen.routeName: (ctx) => const TaskEditScreen(),
          GoalListScreen.routeName: (ctx) => const GoalListScreen(),
          GoalEditScreen.routeName: (ctx) => const GoalEditScreen(),
          GoalDetailScreen.routeName: (ctx) => const GoalDetailScreen(),
          LoopListScreen.routeName: (ctx) => const LoopListScreen(),
          LoopDetailScreen.routeName: (ctx) => const LoopDetailScreen(),
          LoopEditScreen.routeName: (ctx) => const LoopEditScreen(),
          PurchaseListScreen.routeName: (ctx) => const PurchaseListScreen(),
          PurchaseDetailScreen.routeName: (ctx) => const PurchaseDetailScreen(),
          PurchaseListEditScreen.routeName: (ctx) =>
              const PurchaseListEditScreen(),
        },
      ),
    );
  }
}
