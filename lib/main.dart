import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (c) => CustomSheet(stpoPoints: stpoPoints),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<StpoPointModel> stpoPoints = List.generate(
    4,
    (index) => StpoPointModel(
      name: 'stop ${index + 1}',
      dateTime: DateTime.now().add(Duration(days: index)),
    ),
  );
}

class CustomSheet extends StatefulWidget {
  final List<StpoPointModel> stpoPoints;
  const CustomSheet({super.key, required this.stpoPoints});

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  late List<StpoPointModel?> selectedStopPoints = List.generate(widget.stpoPoints.length, (index) => null);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.stpoPoints.length,
                (index) {
                  if (index == widget.stpoPoints.length - 1) return const SizedBox();
                  return Container(
                    width: 24,
                    height: 76,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      width: 2,
                      color: Colors.orange.withOpacity(
                        selectedStopPoints.where((element) => element != null).length > 2 && selectedStopPoints[index] != null ? 1 : 0,
                      ),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.stpoPoints.length,
              (index) {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        height: 24,
                        width: 24,
                        child: CupertinoCheckbox(
                          value: selectedStopPoints.any((element) => element?.name == widget.stpoPoints[index].name),
                          onChanged: (v) {
                            final lastI = selectedStopPoints.indexWhere((element) => element != null);
                            if (lastI == -1) {
                              selectedStopPoints[index] = selectedStopPoints[index] == null ? widget.stpoPoints[index] : null;
                            } else if (index > lastI) {
                              for (int i = index; i < selectedStopPoints.length; i--) {
                                if (i == lastI) break;
                                selectedStopPoints[i] = widget.stpoPoints[i];
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.stpoPoints[index].name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.stpoPoints[index].name,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StpoPointModel {
  final String name;
  final DateTime dateTime;

  StpoPointModel({required this.name, required this.dateTime});

  @override
  String toString() {
    return 'StpoPointModel(name: $name, dateTime: $dateTime)';
  }
}
