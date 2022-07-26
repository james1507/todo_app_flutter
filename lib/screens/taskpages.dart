import 'package:flutter/material.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screens/homepages.dart';
import 'package:to_do_app/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({Key? key, @required this.task}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool? _contentVisible = false;

  @override
  void initState() {
    //print("ID: ${widget.task!.id}");

    if (widget.task != null) {
      // Set visibility to true

      _contentVisible = true;

      _taskTitle = widget.task!.title!;
      _taskDescription = widget.task!.description ?? "";
      _taskId = widget.task!.id!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _todoFocus!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              print("Field value: $value");

                              if (value != "") {
                                if (widget.task == null) {
                                  // DatabaseHelper _dbHelper = DatabaseHelper();

                                  Task _newTask = Task(title: value);

                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print("New Task Id $_taskId");
                                } else {
                                  _dbHelper.updatetaskTitle(_taskId, value);
                                  print("Task Update");
                                }

                                _descriptionFocus!.requestFocus();
                              }
                              // setState(() {});
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomePages()));
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Nhập ở đây",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible!,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updatetaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }

                          _todoFocus!.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                            hintText:
                                "Nhập mô tả nội dung nhiệm vụ cần làm của bạn ...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible!,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data?[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data?[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data?[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: ToDoWidget(
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: Color(0xFF86829D),
                                  width: 1.5,
                                )),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            focusNode: _todoFocus,
                            controller: TextEditingController()..text = "",
                            onSubmitted: (value) async {
                              print("Field value: $value");

                              if (value != "") {
                                if (_taskId != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();

                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: _taskId,
                                  );

                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  _todoFocus!.requestFocus();
                                } else {
                                  print("Điều cần làm không tồn tại");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Nhập điều cần làm",
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible!,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFFE3577),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Image(
                        image: AssetImage('assets/images/delete_icon.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
