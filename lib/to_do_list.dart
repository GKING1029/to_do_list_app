import 'package:flutter/material.dart';
import 'package:to_do_app/to_do_model.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  var list = <ToDoModel>[];
  // var list1 = [];

  bool isSelected = false;
  // bool isCompleted = false;
  // void _onOff() {
  //   isCompleted = !isCompleted;
  //   setState(() {});
  // }

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
              builder: (BuildContext context, StateSetter setState) {
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
                      setState(() {});
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
                        list.add(ToDoModel("$selectedDate",
                            dateEditingController.text.toString()));

                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    },
                    child: const Text("Add Task"))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
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
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return AlertDialog(
                                      title: const Text("Add Item"),
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
                                              selectedDate =
                                                  returnValue.toString();
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
                                                list.add(ToDoModel(
                                                    "$selectedDate",
                                                    dateEditingController.text
                                                        .toString()));

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
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(list[index].date ?? ""),
                                Text(list[index].task ?? "")
                              ]),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    list[index].isCompleted =
                                        !list[index].isCompleted;
                                  });
                                },
                                // GestureDetector(
                                // onTap: _onOff,
                                child: Icon(
                                  list[index].isCompleted
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogFunction,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
