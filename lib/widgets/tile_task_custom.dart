import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';

@override
Widget CustomTile(Map model, context) {
  ToDoCubit cubit = ToDoCubit.get(context);
  return BlocConsumer<ToDoCubit, ToDoStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return Dismissible(
        key: Key(model['ID'].toString()),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          padding: const EdgeInsets.all(8),
          child: ListTile(
            tileColor: Colors.transparent,
            leading: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Text(
                '${model['date']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            title: Text(
              '${model['title']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              '${model['time']}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                    width: 40,
                    child: CheckboxListTile(
                      activeColor: Colors.white,
                      title: const Text(
                        'Task Added to Done Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: model['status'] == 'done' ? true : false,
                      onChanged: (newValue) {
                        cubit.toggleCheckbox(newValue!, model['ID']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              newValue
                                  ? 'Task Added to Done Tasks'
                                  : 'Task Removed from Done Tasks',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (model['status'] == 'archieve') {
                        cubit.updateDB(
                          status: 'new',
                          id: model['ID'],
                        );
                      } else {
                        cubit.updateDB(
                          status: 'archieve',
                          id: model['ID'],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Task Added to Archieved Tasks',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.archive_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onDismissed: (direction) {
          print(model);
          cubit.deleteFromDB(id: model['ID']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Task Deleted',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              duration: Duration(seconds: 3),
            ),
          );
        },
      );
    },
  );
}
