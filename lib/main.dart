import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyState extends ChangeNotifier{
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

  List<Todo> get todolist => todos;

  void addTodo(Todo todo){
    todos.add(todo);
    notifyListeners();
  }
  void removeTodo(Todo todo){
    todos.remove(todo);
    notifyListeners();
  }
}

void main() {
  MyState state = MyState();
  runApp(
    ChangeNotifierProvider(
    create: (context) => state,
    child:
    MyApp(),
    ),
  );
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
  /*
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
  */
  @override
  Widget build(BuildContext context) {
    var todos = context.watch<MyState>().todos;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("To-do list"),
      ),
      body: ListView(          
        children: todos.map((todo) => chores(todo)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddTodo()));

        },
      child: const Icon(Icons.add),
      )

    );
  }

  Widget chores(Todo todo){
    //var todos = context.watch<MyState>().todos;
    return Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              side: BorderSide(
                width: 2,
                color: Colors.black,
                ),
              value: todo.isChecked, 
              onChanged: (bool? newValue){
                setState((){
                  todo.isChecked = newValue ?? false;
                });
              } 
            ),
            Expanded(
              child: Text(
                style: TextStyle(
                  fontSize: 28,
                  decoration: todo.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                todo.chore
              ),
            ),
            Padding(
              
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                 
                icon: Icon(Icons.close),
                iconSize: 35,
                onPressed: (){
                  context.read<MyState>().removeTodo(todo);
                },
                )
              //child: Icon(
              //size: 35, 
              //Icons.close
            //)
            )
          ],
        );
  }


}

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Todo"),
      ),

    body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "What are you going to do?"
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String inputText = _controller.text;
              if(inputText.isNotEmpty){
                Todo newTodo = Todo(inputText);
                context.read<MyState>().addTodo(newTodo);
              }
              Navigator.pop(context);
            },
            child: const Text("Add Todo"),
          )
        ],
      ),
    )
    );
  }
}
