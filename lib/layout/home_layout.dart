import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shard/components.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> screensList = [NewTasks(), DoneTasks(), ArchivedTasks()];

  List<String> titlesList = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isBottomSheetOpen = false;
  var fabIcon = const Icon(Icons.edit);

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titlesList[currentIndex]),
      ),
      body: screensList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
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
          if (isBottomSheetOpen) {
            print('validated? ${_formKey.currentState?.validate()}');

            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              isBottomSheetOpen = false;
              setState(() {
                fabIcon = const Icon(Icons.edit);
              });
              print('close bottom sheet');
            }
          } else {
            scaffoldKey.currentState?.showBottomSheet((context) => Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          print('vv $value');
                          if (value == null || value.isEmpty) {
                            return 'Task title must not be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Task Title',
                          prefixIcon: Icon(Icons.title),
                        ),
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
                          print('pick time');
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            if (value != null) {
                              timeController.text =
                                  value.format(context).toString();
                              print(
                                  'time: ${value.format(context).toString()}');
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Task Time',
                          prefixIcon: Icon(Icons.watch_later_outlined),
                        ),
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
                                  'time: ${DateFormat.yMMMd().format(value)}');
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Task Date',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),

                      // DefaultTextFormField(
                      //   controller: titleController,
                      //   hintText: 'Task Title',
                      //   prefixIcon: Icon(Icons.title),
                      //   validator: (String value){
                      //     print('vv $value');
                      //     if(value.isEmpty){
                      //       return 'Task title must not be empty';
                      //     }
                      //     return null;
                      //   },
                      //   textInputType: TextInputType.text,
                      // ),
                      // DefaultTextFormField(
                      //   controller: timeController,
                      //   hintText: 'Task Time',
                      //   prefixIcon: Icon(Icons.watch_later_outlined),
                      //   validator: (String value){
                      //     if(value.isEmpty){
                      //       return 'Task time must not be empty';
                      //     }
                      //   },
                      //   textInputType: TextInputType.datetime,
                      //   // onFieldTap: (){
                      //   //
                      //   // },
                      // ),
                    ],
                  ),
                ));

            isBottomSheetOpen = true;
            setState(() {
              fabIcon = const Icon(Icons.add);
            });
            print('open bottom sheet');
          }
        },
        child: fabIcon,
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) {
        print('Database created');
        db
            .execute(
                'Create Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('error in creating db, ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('Database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("title", "12346", "1333", "new")')
          .then((value) {
        print('$value row inserted');
      }).catchError((error) {
        print('error when inserted, ${error.toString()}');
      });
    });
  }
}
