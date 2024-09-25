import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class Todo {
  final String chore;
  bool isChecked;
  Todo(this.chore, {this.isChecked = false});
}

class _MyHomePageState extends State<MyHomePage> {

  //bool? value = false;
  List<Todo> todos = [
    Todo("Write a book"),
    Todo("Do homework"),
    Todo("Tidy room"),
    Todo("Watch TV"),
    Todo("Nap"),
    Todo("Shop groceries"),
    Todo("Have fun"),
    Todo("Meditate"),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("To-do list"),
      ),
      body: ListView(

        children: 
            todos.map((todo) => chores(todo)).toList(),
      ),
    );
  }
  Widget chores(Todo todo){
    return Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              side: BorderSide(width: 500),
              value: todo.isChecked, 
              onChanged: (bool? newValue){
                setState((){
                  todo.isChecked = newValue ?? false;
                });
              } 
            ),
            Expanded(
              child: Text(
                style: TextStyle(fontSize: 28),
                todo.chore
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
              size: 35, 
              Icons.close
            )
            )
          ],
        );
  }


}
