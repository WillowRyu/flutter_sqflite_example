import 'dart:async';
import 'package:local_storage_example/models/todoModel.dart';
import 'package:local_storage_example/services/db_helper.dart';

class TodoBloc {
  TodoBloc() {
    getTodos();
  }

  final _todosController = StreamController<List<Todo>>.broadcast();
  get todos => _todosController.stream;

  dispose() {
    _todosController.close();
  }

  getTodos() async {
    _todosController.sink.add(await DBHelper().getAllTodos());
  }

  addTodos(Todo todo) async {
    await DBHelper().createData(todo);
    getTodos();
  }

  deleteTodo(int id) async {
    await DBHelper().deleteTodo(id);
    getTodos();
  }

  deleteAll() async {
    await DBHelper().deleteAllTodos();
    getTodos();
  }

  updateTodo(Todo item) async {
    Todo updateData = Todo(
        complete: !item.complete,
        todo: item.todo,
        type: item.type,
        id: item.id);
    await DBHelper().updateTodo(updateData);
    getTodos();
  }
}
