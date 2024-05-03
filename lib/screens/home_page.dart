import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:todoapp/widgets/floating_Button_custom.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit()..createDB(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (context, state) {
          if (state is InsertState) Navigator.pop(context);
        },
        builder: (context, state) {
          print('bilder');
          ToDoCubit cubit = ToDoCubit.get(context);

          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              backgroundColor: Colors.brown,
            ),
            body: ConditionalBuilder(
              condition: cubit.tasks != null,
              builder: (context) {
                // print(cubit.screens[cubit.currentIndex].toString());
                // print(cubit.tasks.toString());
                return cubit.screens[cubit.currentIndex];
              },
              fallback: (context) {
                // print(cubit.tasks.toString());
                return const Center(
                  child: Text('no tasks yet'),
                );
              },
              // fallback: (context) =>
              //     const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: CustomFloatingButton(context),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 60.0,
              currentIndex: cubit.currentIndex, // cubit.currentIndex
              onTap: (index) {
                cubit.changeCurrentIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_box_outlined,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
