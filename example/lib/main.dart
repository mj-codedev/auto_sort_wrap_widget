import 'package:auto_sort_wrap_widget/auto_sort_wrap_widget.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoSortWrapWidget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AutoSortWrapWidget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> data = [
    'hi',
    'spent',
    'life',
    'suffocating',
    'Ignoring',
    'villains',
    'living',
    'Will',
    'Under',
    'show me the money',
    'Will you stay a part of me',
    'You’re killing me from within',
    'abcdefghijklmnopqrstuvwxyz'
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> data = [_getItem('show me the money'), _getItem('asbcdef'), _getItem('1234567890'), _getItem('hi'), _getItem('love')];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(101.0),
              child: Container(
                color: Colors.amber.withOpacity(0.3),
                child: AutoSortWrapWidget<Widget>(
                    data: data,
                    runSpacing: 5,
                    spacing: 5,
                    itemBuilder: (context, index, data) => Container(
                      child: data,
                      padding:  const EdgeInsets.all(5.0),
                      color:Colors.blueAccent,
                    ),
                ),
                // child: Wrap(
                //   runSpacing: 5,
                //   spacing: 5,
                //   children: List.generate(data.length, (index) => _getItem(data[index])),
                // )
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getItem(data){
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Text(
        data,
        style: TextStyle(
            fontSize: 15
        ),
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }
}
