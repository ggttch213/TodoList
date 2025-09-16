import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
       debugShowCheckedModeBanner: false,
       title: "TODO LIST",
        theme: ThemeData(useMaterial3: true),
        home: const TodoPage(),
      )
  );
}

/// 1. 資料模型:代辦事項->1.標題,2.內容,3.是否完成
class Todo{
  String title;
  String content;
  bool done;
  Todo(this.title,this.content,{this.done = false});
}


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _todos = <Todo>[];                    /// 2. 清單資料
  final _titlecontroller = TextEditingController();/// 3. 輸入框控制
  final _contentcontroller = TextEditingController();

  void _addTodo() {
    final titletext = _titlecontroller.text.trim();
    final contenttext = _contentcontroller.text.trim();
    if (titletext.isEmpty && contenttext.isEmpty) return;
    setState(() {
      _todos.insert(0, Todo(titletext,contenttext));
      _titlecontroller.clear();
      _contentcontroller.clear();
    });
  }

  void _toggleDone(int index,bool? value){
    setState(() {
      _todos[index].done = value ?? false; ///切換完成狀態
    });
  }
  void _toggleDelete(int index){
    setState(() {
      _todos.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My TODO List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ///上方:輸入區
            Row(
              children: [
                Expanded(
                    child:TextField(
                      controller: _titlecontroller,
                      decoration: const InputDecoration(
                        hintText: "Enter TODO title...",
                        border: OutlineInputBorder(),
                      ),
                      // onSubmitted: (_) => _addTodo(),
                    )
                ),
                Expanded(
                    child:TextField(
                      controller: _contentcontroller,
                      decoration: const InputDecoration(
                        hintText: "Enter TODO content...",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTodo(),
                    )
                )
              ],
            ),
            const SizedBox(width: 8,),
            FilledButton(
                onPressed: _addTodo,
                child: const Text("Create"),
            ),
            
            const SizedBox(height: 20),
            Expanded(
                child: _todos.isEmpty
                ? const Center(child: Text('You didnt have a TODO List'))
                : ListView.separated(
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                    final todo = _todos[index];
                    return ListTile(
                      leading: Checkbox(
                          value: todo.done,
                          onChanged: (v) => _toggleDone(index, v)
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.done
                              ?TextDecoration.lineThrough
                              :TextDecoration.none,
                          color: todo.done
                            ?Colors.grey
                            :null,
                        ),
                      ),
                      subtitle: Text(
                        todo.content,
                        style: TextStyle(
                          decoration: todo.done
                              ?TextDecoration.lineThrough
                              :TextDecoration.none,
                          color: todo.done
                              ?Colors.grey
                              :null,
                        ),
                      ),
                      trailing:
                        _todos[index].done == true
                        ? IconButton(
                          icon: const Icon(Icons.delete),
                            onPressed: () => _toggleDelete(index),
                        )
                        : null,
                    );
                    },
                ),

            )
          ],
        ),
      ),
    );
  }
}

