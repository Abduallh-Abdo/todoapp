import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/widgets/tasks_screens.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    // var cubit = ToDoCubit.get(context);
    // return BlocConsumer<ToDoCubit, ToDoStates>(
    //   listener: (context, state) {},
    //   builder: (context, state) {
        return tasksBuilder(tasks: ToDoCubit.get(context).archivedTasks);
    //   },
    // );
  }
}
