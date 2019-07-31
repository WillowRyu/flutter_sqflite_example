// lib > main.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'models/todoModel.dart';
import 'bloc/todo_bloc.dart';

List<Todo> todosDatas = [
  Todo(todo: '오늘은 무슨일을 할까', type: 'TALK', complete: false),
  Todo(todo: '내일은 무슨일을 할까', type: 'MEET', complete: true),
  Todo(todo: '모레는 무슨일을 할까', type: 'TALK', complete: false),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalStorageExample',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bloc 을 가져옵시다.
  final TodoBloc bloc = TodoBloc();

  // Stateful Widget 이 dispose 될때 스트림을 닫는다.
  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOCAL CRUD'),
      ),
      body: StreamBuilder(
        stream: bloc.todos,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Todo item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        bloc.deleteTodo(item.id);
                      },
                      child: ListTile(
                        title: Text(item.todo),
                        leading: Text(
                          item.id.toString(),
                        ),
                        trailing: Checkbox(
                          onChanged: (bool value) {
                            bloc.updateTodo(item);
                          },
                          value: item.complete,
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Center(
                    child: Text('No data'),
                  ),
                );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () {
              bloc.deleteAll();
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Todo newTodo = todosDatas[Random().nextInt(todosDatas.length)];
              bloc.addTodos(newTodo);
            },
          ),
        ],
      ),
    );
  }
}
