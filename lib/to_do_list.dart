import 'package:flutter/material.dart';
import 'package:to_do_app/to_do_model.dart';

import 'database/to_do_db.dart';
import 'database/to_do_dbio.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  var array = <ToDoModel>[];
  TodoDb databaseProvider = TodoDb.instance;
  TodoDbIO todoDbIO = TodoDbIO();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDatabaseValues();
    });

    //array.
  }

  void getDatabaseValues() async {
    array.clear();
    array.addAll(await todoDbIO.getFromTaskTable());

    setState(() {});
  }

  // bool isSelected = false;

  var searchController = TextEditingController();
  var dateEditingController = TextEditingController();
  String selectedDate = DateTime.now().toString();
  void _showDialogFunction() {
    var dateEditingController = TextEditingController();
    String selectedDate = DateTime.now().toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter alertState) {
            return AlertDialog(
              title: const Text("Add Item"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var returnValue = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030));
                      selectedDate = returnValue.toString();
                      alertState(() {});
                    },
                    child: Text("$selectedDate"),
                  ),
                  TextField(
                    controller: dateEditingController,
                    decoration: const InputDecoration(hintText: "Enter task "),
                  )
                ],
              ),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      if (dateEditingController.text.toString().isNotEmpty) {
                        todoDbIO.insertIntoTaskTable(ToDoModel(
                            date: "$selectedDate",
                            task: dateEditingController.text.toString()));

                        // list.add(ToDoModel(
                        //     date: "$selectedDate",
                        //     task: dateEditingController.text.toString()));

                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    },
                    child: const Text("Add Task"))
              ],
            );
          });
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,

              decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  hintText: "Search",
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              style: const TextStyle(fontSize: 20),
              maxLines: 1,
              maxLength: 50,
              // focusNode: searchFocusnode,
              // onSubmitted: (value) {
              // },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                  // border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(99, 3, 58, 141)),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: array.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Remove Task"),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        // array.removeAt(index);

                                        todoDbIO
                                            .removeTodo(array[index].id ?? 0);
                                        Navigator.of(context).pop();
                                        getDatabaseValues();
                                      },
                                      child: const Text("Delete Task"),
                                    )
                                  ],
                                );
                              });
                        },
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Update Item"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var returnValue =
                                              await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2030));
                                          selectedDate = returnValue.toString();
                                          setState(() {});
                                        },
                                        child: Text("$selectedDate"),
                                      ),
                                      TextField(
                                        controller: dateEditingController,
                                        decoration: const InputDecoration(
                                            hintText: "Enter task "),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        if (dateEditingController.text
                                            .toString()
                                            .isNotEmpty) {
                                          array[index].date = "$selectedDate";
                                          array[index].task =
                                              dateEditingController.text
                                                  .toString();
                                          array[index].isCompleted = 0;
                                          todoDbIO.updateTodo(array[index],
                                              array[index].id ?? 0);
                                          Navigator.of(context).pop();
                                          getDatabaseValues();
                                        }
                                      },
                                      child: const Text("Update Task"),
                                    )
                                  ],
                                );
                              });
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text(array[index].date ?? ""),
                              Text(array[index].task ?? "")
                            ]),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (array[index].isCompleted == 1)
                                    array[index].isCompleted = 0;
                                  else {
                                    array[index].isCompleted = 1;
                                  }
                                });
                              },
                              child: Icon(
                                array[index].isCompleted == 1
                                    ? Icons.check_circle_outline_outlined
                                    : Icons.circle_outlined,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogFunction,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
