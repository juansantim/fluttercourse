import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:intl/intl.dart';

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
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(todo.title),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    TextField(
                      controller: titleController,
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
                        onChanged: (item) {
                          _priority = item;
                        },
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}
