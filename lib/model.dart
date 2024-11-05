class Todo {
  final String? id;
  String title;
  bool done;

  Todo(this.id, this.title, {this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(json['id'], json['title'], done: json['done'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "done" : done,
    };
  }

}