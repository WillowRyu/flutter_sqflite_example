class Todo {
  int id;
  String todo;
  String type;
  bool complete;

  Todo({
    this.id,
    this.todo,
    this.type,
    this.complete,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => new Todo(
        id: json["id"],
        todo: json["todo"],
        type: json["type"],
        complete: json["complete"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "type": type,
        "complete": complete,
      };
}
