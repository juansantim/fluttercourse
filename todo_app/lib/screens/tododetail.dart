import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/util/dbhelper.dart';

DbHelper helper = DbHelper();

final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo) {}

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;

  TodoDetailState(this.todo);

  final _priorities = ["High", "Medium", "Low", "Other"];
  String _priority = "Low";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    this._priority = retrivePriorituy(todo.priority);

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(todo.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    TextField(
                      controller: titleController,
                      onChanged: (value) => updateTitle(),
                      style: textStyle,
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15.0),
                      child: TextField(
                        controller: descriptionController,
                        onChanged: (value) => updateDescription(),
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText: 'Descripcion',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    ListTile(
                      title: DropdownButton<String>(
                          items: _priorities.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          style: textStyle,
                          value: _priority,
                          onChanged: (item) => updatePriority(item)),
                    )
                  ],
                ),
              ],
            )));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        {
          Navigator.pop(context);
          if (todo.id == null) {
            return;
          }
          result = await helper.deleteTodo(todo.id);
          if (result != 0) {
            AlertDialog alertDialog = AlertDialog(
              title: Text("Delete Operation"),
              content: Text("The has been deleted"),
            );

            showDialog(context: context, builder: (_) => alertDialog);
          }
          break;
        }
      case mnuBack:
        {
          Navigator.pop(context, true);
          break;
        }
      default:
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id == null) {
      helper.insertTodo(todo);
    } else {
      helper.updateTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    //"High", "Medium", "Low", "Other"
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      case "Other":
        todo.priority = 4;
        break;
      default:
    }

    setState(() {
      this._priority = value;
    });
  }

  String retrivePriorituy(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}
