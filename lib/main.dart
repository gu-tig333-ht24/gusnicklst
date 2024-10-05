import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './api.dart' as api;
import './model.dart';


class MyState extends ChangeNotifier{

List<Todo> _todos = [];

List<Todo> get todos => _todos;

void fetchTodos() async {
  var todos = await api.getTodos();
  _todos = todos;
  notifyListeners();
}
void addTodo(Todo todo) async {
  await api.addTodo(todo);
  fetchTodos();
}
void deleteTodo(Todo todo) async {
  await api.deleteTodo(todo);
  fetchTodos();
}
}

void main() async {
  MyState state = MyState();
  state.fetchTodos();
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

class _MyHomePageState extends State<MyHomePage> {
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
    return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              side: BorderSide(
                width: 2,
                color: Colors.black,
                ),
              value: todo.done, 
              onChanged: (bool? newValue){
                setState((){
                  todo.done = newValue ?? false;
                });
              } 
            ),
            Expanded(
              child: Text(
                style: TextStyle(
                  fontSize: 28,
                  decoration: todo.done ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                todo.title
              ),
            ),
            Padding(              
              padding: EdgeInsets.only(right: 20),
              child: IconButton(                 
                icon: Icon(Icons.close),
                iconSize: 35,
                onPressed: (){
                  context.read<MyState>().deleteTodo(todo);
                },
                )
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
                Todo newTodo = Todo(null, inputText);
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
