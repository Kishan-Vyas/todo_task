import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:todo_task/constanst/colors.dart';
import 'package:todo_task/widgets/todoItem.dart';
import 'package:todo_task/model/todo.dart';

class screen1 extends StatefulWidget {
  const screen1({super.key});

  @override
  State<screen1> createState() => _screen1State();
}

class _screen1State extends State<screen1> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: MenuPage(),
      mainScreen: Home(),
      angle: 0,
      duration: Duration(milliseconds: 400),
    );
  }
}

// main screen
class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: tdBlack,
                          size: 30,
                        ),
                        onPressed: () {
                          ZoomDrawer.of(context)!.toggle();
                        },
                      ),
                      const Text(
                        "TO-DO",
                        style: TextStyle(
                            color: tdBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Container(
                        height: 46,
                        width: 46,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Image.asset('assets/images/avatar.png'),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: searchBox(),
                ),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // first Scroll vie
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                for (ToDo todo in _foundToDo.reversed)
                                  if (!todo.isDone)
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TodoItem(
                                        todo: todo,
                                        onToDoChange: _handleToDoChange,
                                        onDeleteItem: _deleteToDoItem,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        // secound Scroll view
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                for (ToDo todo in _foundToDo.reversed)
                                  if (todo.isDone)
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TodoItem(
                                        todo: todo,
                                        onToDoChange: _handleToDoChange,
                                        onDeleteItem: _deleteToDoItem,
                                      ),
                                    ),
                                SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Padding(
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                right: 20,
                                left: 20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _todoController,
                                decoration: InputDecoration(
                                  hintText: 'Add new Task!!',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20, right: 20),
                            child: ElevatedButton(
                              child: Text('+', style: TextStyle(fontSize: 30)),
                              onPressed: () {
                                _addToDoItem(_todoController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: tdBlue,
                                minimumSize: Size(56, 56),
                                elevation: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Task!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: const Text(
            'are you sure you want to Delete this task??',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todoList.removeWhere((item) => item.id == id);
                });

                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _addToDoItem(String todo) {
    setState(() {
      if (todo.isNotEmpty) {
        todoList.add(
          ToDo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              todoText: todo),
        );
      }
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((element) => element.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: tdWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// menu screen
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kishan Vyas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: tdWhite,
              ),
            ),
            // const SizedBox(height: 100),
            // _menuItems(Icons.home, "Home"),
            // const SizedBox(height: 20),
            // _menuItems(Icons.home, "Home"),
            // const SizedBox(height: 20),
            // _menuItems(Icons.home, "Home"),
            // const SizedBox(height: 20),
            // _menuItems(Icons.home, "Home"),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _menuItems(IconData icon, String text) {
  return Card(
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
