
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetOpen = false;

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
            formKey.currentState?.validate();
            print(formKey.currentState?.validate());
            Navigator.pop(context);
            isBottomSheetOpen = false;
            print('close bottom sheet');
          } else {
            scaffoldKey.currentState?.showBottomSheet((context) => Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextFormField(
                    controller: titleController,
                    hintText: 'Task Title',
                    prefixIcon: Icon(Icons.title),
                    validator: (String value){
                      print('vv $value');
                      if(value.isEmpty){
                        return 'Task title must not be empty';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                  ),
                  DefaultTextFormField(
                    controller: timeController,
                    hintText: 'Task Time',
                    prefixIcon: Icon(Icons.watch_later_outlined),
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Task time must not be empty';
                      }
                    },
                    textInputType: TextInputType.datetime,
                    // onFieldTap: (){
                    //
                    // },
                  ),


                ],
              ),
            ));
            isBottomSheetOpen = true;
            print('open bottom sheet');

          }
        },
        child: Icon(Icons.add),
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
      return txn.rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("title", "12346", "1333", "new")')
          .then((value) {
        print('$value row inserted');
      }).catchError((error) {
        print('error when inserted, ${error.toString()}');
      });
    });
  }
}
