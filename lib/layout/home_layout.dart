import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shard/components.dart';
import 'package:to_do_app/shard/cubit/cubit.dart';
import 'package:to_do_app/shard/cubit/states.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit appCubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(appCubit.titlesList[appCubit.currentIndex]),
            ),
            body: state is AppGetFromDatabaseLoadingState
                ? Center(child: CircularProgressIndicator())
                : appCubit.screensList[appCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: appCubit.currentIndex,
              onTap: (index) {
                appCubit.changeIndexOfNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // insertToDatabase();
                if (appCubit.isBottomSheetOpen) {
                  print('validated? ${_formKey.currentState?.validate()}');

                  if (_formKey.currentState!.validate()) {
                    appCubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);

                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) =>
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      print('Task title: $value');
                                      if (value == null || value.isEmpty) {
                                        return 'Task title must not be empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Task Title',
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    readOnly: true,
                                    //to hide keyboard
                                    showCursor: true,
                                    validator: (value) {
                                      print('task time: $value');
                                      if (value == null || value.isEmpty) {
                                        return 'Task time must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        if (value != null) {
                                          timeController.text =
                                              value.format(context).toString();
                                          print(
                                              'time: ${value.format(context)
                                                  .toString()}');
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Task Time',
                                        prefixIcon:
                                        Icon(Icons.watch_later_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    readOnly: true,
                                    showCursor: true,
                                    validator: (value) {
                                      print('task date $value');
                                      if (value == null || value.isEmpty) {
                                        return 'Task date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 365)))
                                          .then((value) {
                                        if (value != null) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                          print(
                                              'time: ${DateFormat.yMMMd()
                                                  .format(value)}');
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Task Date',
                                        prefixIcon: Icon(Icons.date_range),
                                        border: OutlineInputBorder()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      elevation: 20)
                      .closed
                      .then((value) {
                    appCubit.closeBottomSheet();
                    print('close bottom sheet');
                  });

                  appCubit.openBottomSheet();
                  print('open bottom sheet');
                }
              },
              child: appCubit.fabIcon,
            ),
          );
        },
      ),
    );
  }
}


