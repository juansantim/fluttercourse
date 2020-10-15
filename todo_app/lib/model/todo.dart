import 'package:flutter/cupertino.dart';

class Todo {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Todo(this._title, this._priority, this._date, [this._description]);

  Todo.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int get id {
    return _id;
  }

  String get title {
    return _title;
  }

  String get date {
    return _date;
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  String get description {
    return _description;
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  int get priority {
    return _priority;
  }

  set priority(int newPriority) {
    if (newPriority > 0 && newPriority <= 3) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Todo.formObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["descripcion"];
    this._priority = o["priority"];
    this._date = o["date"];
  }
}
