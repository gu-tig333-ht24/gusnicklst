import 'dart:convert';
import 'package:http/http.dart' as http;
import './model.dart';

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

String? apiKey;

Future<void> getApiKey() async {
  try {
    http.Response response = await http.get(Uri.parse('$ENDPOINT/register'));
    
    if (response.statusCode == 200) {
      apiKey = response.body.trim(); 
    } else {
      print('Failed to fetch API key.');
    }
  } catch (e) {
    print('Error fetching API key: $e');
  }
}

Future<List<Todo>> getTodos() async {
  if (apiKey == null) {
    await getApiKey(); 
  }
  if (apiKey != null) {
    print('Fetching Todos');
    try {
      http.Response response = await http.get(Uri.parse('$ENDPOINT/todos?key=$apiKey'));
      
      if (response.statusCode == 200) {
        String body = response.body;
        List todosJson = jsonDecode(body); 
        return todosJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        print('Failed to fetch todos.');
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }
  
  return [];
}

Future<void> addTodo(Todo todo) async {
  if (apiKey == null) {
    await getApiKey();
  }

  if (apiKey != null) {
    await http.post(
      Uri.parse('$ENDPOINT/todos?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toJson()),
    );
  }
}

Future<void> deleteTodo(Todo todo) async {
  if (apiKey == null) {
    await getApiKey();
  }

  if (apiKey != null && todo.id != null) {
    String id = todo.id!;
    await http.delete(Uri.parse('$ENDPOINT/todos/$id?key=$apiKey'));
  }
}
Future<void> updateTodo(Todo todo, String title, bool done) async {
  if (apiKey == null) {
    await getApiKey();
  }
  if (apiKey != null && todo.id != null) {
    String id = todo.id!;
    todo.title = title;
    todo.done = done;
    await http.put(
      Uri.parse('$ENDPOINT/todos/$id?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toJson()),
      );
  }
}
