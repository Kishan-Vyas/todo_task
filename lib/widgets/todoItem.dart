import 'package:flutter/material.dart';
import 'package:todo_task/constanst/colors.dart';
import 'package:todo_task/model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChange;
  final onDeleteItem;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onDeleteItem,
    required this.onToDoChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        child: ListTile(
          onTap: () {
            onToDoChange(todo);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          tileColor: Colors.white,
          leading: todo.isDone
              ? Icon(Icons.check_box, color: tdBlue)
              : Icon(Icons.check_box_outline_blank),
          title: Text(
            todo.todoText!,
            style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null),
          ),
          trailing: IconButton(
            color: Colors.red,
            iconSize: 24,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id);
            },
          ),
        ),
      ),
    );
  }
}
