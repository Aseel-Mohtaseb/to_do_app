// this cubit shared between all screens (for the whole app)

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shard/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Map> newTasksList = [];

  late List<Widget> screensList = [
    NewTasks(newTasksList: newTasksList),
    DoneTasks(),
    ArchivedTasks()
  ];

  List<String> titlesList = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndexOfNavBar(index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  late Database database;

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database database, int version) {
        print('Database created');
        database
            .execute(
                'Create Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          emit(AppCreateDatabaseState());
          print('Table created');
        }).catchError((error) {
          print('error in creating db, ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDatabase(database);
        print('Database opened');
      },
    );
  }

  Future insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    return await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value row inserted');
        emit(AppInsertToDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('error when inserted, ${error.toString()}');
      });
    });
  }

  void getFromDatabase(database) async {
    newTasksList = await database.rawQuery('SELECT * FROM tasks');
    print('get tasks from database');
    emit(AppGetFromDatabaseState());
  }

  bool isBottomSheetOpen = false;
  var fabIcon = const Icon(Icons.edit);

  void openBottomSheet() {
    isBottomSheetOpen = true;
    fabIcon = const Icon(Icons.add);
    emit(AppOpenBottomSheetState());
  }

  void closeBottomSheet() {
    isBottomSheetOpen = false;
    fabIcon = const Icon(Icons.edit);
    emit(AppCloseBottomSheetState());
  }
}
