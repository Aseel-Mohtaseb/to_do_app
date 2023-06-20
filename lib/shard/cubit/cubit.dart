// this cubit shared between all screens (for the whole app)

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void changeIndexOfNavBar(index){
    currentIndex = index;
    emit(AppChangeNavBarState());
  }


}
