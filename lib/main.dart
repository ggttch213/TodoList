import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:todolist/data/bored_repository.dart';
import 'package:todolist/data/weather_repository.dart';
import 'package:todolist/data/api_client.dart';
import 'package:todolist/widgets/weather_card.dart';
import 'package:todolist/model/weather.dart';
// WidgetsFlutterBinding.ensureInitialized();
// await dotenv.load(fileName: ".env");

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
  late final WeatherRepository _weatherRepo;
  final double _lat = 22.6273;   // 先手填測試：高雄
  final double _lon = 120.3014;
  final String _apiKey = '920308ec0e58bebccf48e335a9f66069';

  late final BoredRepository _repo;
  bool _loading = false;

  final _todos = <Todo>[];                    /// 2. 清單資料
  final _titlecontroller = TextEditingController();/// 3. 輸入框控制
  final _contentcontroller = TextEditingController();

  void _addTodo([String? title,String? content]) {
    final titletext = (title ?? _titlecontroller.text).trim();
    final contenttext = (content ?? _contentcontroller.text).trim();
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

  void _openAddTodoDialog(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Todo",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,

                      )
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: _titlecontroller,
                    decoration: const InputDecoration(
                      hintText: "Enter TODO title...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                    const SizedBox(height: 12,),
                    TextField(
                    controller: _contentcontroller,
                    decoration: const InputDecoration(
                      hintText: "Enter TODO content...",
                      border: OutlineInputBorder(),
                    ),
                  ),
              const SizedBox(height: 16,),
              FilledButton(
                onPressed: () {
                  _addTodo();
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    ).show();
  }


  @override
  void initState(){
    super.initState();
    final apiClient = const ApiClient(); // 共用一個
    _repo = BoredRepository(apiClient);
    _weatherRepo = WeatherRepository(apiClient);
  }
  Future<void> _addRandomTask() async{
    if (_loading) return;
    setState(() => _loading = true);
    try{
      final act =await _repo.fetchRandomActivity();
      debugPrint('before add, todos=${_todos.length}');
      _addTodo(act.activity, '${act.type} • ${act.accessibility}');
      debugPrint('after add,  todos=${_todos.length}');
    } catch(e){
      if(!mounted) return;
    } finally{
    if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("My TODO List"),
          actions: [
            IconButton(onPressed: _loading ? null : _addRandomTask,
            icon: _loading ? const CircularProgressIndicator() : const Icon(Icons.lightbulb_outline)
      )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodoDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<Weather>(
                future: _weatherRepo.fetchWeather(lat: _lat, lon: _lon, apiKey: _apiKey),
                builder: (context,snap){
                  if (snap.connectionState != ConnectionState.done){
                    return Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Loading weather...'),
                      ],
                    );
                  }
                  if (snap.hasError){
                    return const Center(child: Text('Something went wrong'));
                  }
                  final w = snap.data!;
                  return WeatherCard(
                    dt:w.dt,
                    sunrise: w.sunrise ,
                    sunset: w.sunset,
                    temp: w.temp,
                    feels_like: w.feels_like,
                    humidity: w.humidity,
                    // uvi: w.uvi,
                  );
                }
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

