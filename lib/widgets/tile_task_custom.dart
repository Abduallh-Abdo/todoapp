import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';

@override
Widget CustomTile(Map model, context) {
  ToDoCubit cubit = ToDoCubit.get(context);
  // return BlocConsumer<ToDoCubit, ToDoStates>(
  //   listener: (context, state) {},
  //   builder: (context, state) {
  return Dismissible(
    key: Key(model['id'].toString()),
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
            '${model['time']}',
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
          '${model['date']}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckboxListTile(
                activeColor: Colors.white,
                title: const Text(
                  'Task Added to Done Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: cubit.isDone,
                onChanged: (newValue) {
                  cubit.toggleCheckbox(newValue!, model['id']);
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
              IconButton(
                onPressed: () {
                  cubit.updateDB(
                    status: 'archieve',
                    id: model['id'],
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
      cubit.deleteFromDB(id: model['id']);
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
  //   },
  // );
}
