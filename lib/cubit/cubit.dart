import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:todoapp/screens/archived_task_body.dart';
import 'package:todoapp/screens/done_task_body.dart';
import 'package:todoapp/screens/newTask_screen.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(InitialState()) {
    // createDB(); // Initialize the database
  }
  static ToDoCubit get(context) => BlocProvider.of(context);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  int currentIndex = 0;

  List<Widget> screens = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeCurrentIndex(int index) {
    print('1');
    currentIndex = index;
    emit(ChangeCurrentIndexState());
  }

  List<Map>? tasks;

  late List<Map> newTasks;
  late List<Map> doneTasks;
  late List<Map> archivedTasks;

  late Database database;

  bool isBottomSheetShown = false;
  IconData changeIcon = Icons.edit;

  // (ID INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)
  void createDB() async {
    emit(CreateDatabaseLoadingState());

    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db.execute('''
        CREATE TABLE tasks(ID INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT, status TEXT)
        ''').then((value) {
          print('table created');
        });
      },
      onOpen: (db) {
        print('open database');
        database = db;
        getRecordsFromDB(database);
        emit(CreateDatabaseState());
      },
    ).catchError((error) {
      print(error.toString());
    });
  }

  void insertDB({
    required String title,
    required String date,
    required String time,
    String status = 'new',
  }) async {
    print('3');
    await database.rawInsert(
        // 'INSERT INTO tasks(title, date, time, status) VALUES(?, ?)',
        // [note, number],
        '''INSERT INTO tasks(title, date, time, status)
             VALUES("$title" , "$date","$time","$status")''').then((value) {
      // this value is the ID to this insertedRow
      titleController.clear();
      timeController.clear();
      dateController.clear();
      emit(InsertState());
      getRecordsFromDB(database);
      print('insert success : $value');
    }).catchError((error) {
      print(error.toString());
    });
  }

  void updateDB({
    required String status,
    required int id,
  }) async {
    print('4');

    await database.rawUpdate(
      'UPDATE tasks SET status=? WHERE id=?',
      [status, id],
    ).then((value) {
      getRecordsFromDB(database);
      emit(UpdateState());
    });
  }

  void deleteFromDB({
    required int id,
  }) async {
    print('5');

    await database.rawDelete(
      'DELETE FROM tasks WHERE id=?',
      [id],
    ).then((value) {
      getRecordsFromDB(database);
      emit(DeleteState());
    });
  }

  void getRecordsFromDB(Database database) async {
    print('6');

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetRecordsLoadingState());

    database
        .rawQuery(
      'SELECT * FROM tasks',
    )
        .then((value) {
      tasks = value;
      for (Map<String, Object?> row in value) {
        if (row['status'] == 'new') {
          newTasks.add(row);
        } else if (row['status'] == 'done') {
          doneTasks.add(row);
        } else {
          archivedTasks.add(row);
        }
      }
      emit(GetRecordsState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void selectTime(BuildContext context) async {
    print('7');

    // TimeOfDay? pickedTime =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      timeController.text = value!.format(context).toString();
      emit(ChangeDateTimeState());
      return null;
    });
  }

  void selectDate(BuildContext context) async {
    print('8');

    // DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    ).then((value) {
      dateController.text = DateFormat.yMMMd().format(value!);
      emit(ChangeDateTimeState());

      return null;
    });
  }

  void changeBottomSheetState({
    required IconData fabIcon2,
    required bool isShown,
  }) {
    print('9');

    changeIcon = fabIcon2;
    isBottomSheetShown = isShown;
    emit(BottomSheetState());
  }

  void toggleCheckbox(bool newValue, int id) {
    if (newValue == true) {
      updateDB(status: 'done', id: id);
    } else {
      updateDB(status: 'new', id: id);
    }

    emit(CheckboxChangedState());
  }

  // void archivedChange(String newValue, int id) {
  //   if (newValue == true) {
  //     updateDB(status: 'archieve', id: id);
  //   } else {
  //     updateDB(status: 'new', id: id);
  //   }
  //   emit(UpdateState());
  // }
}
