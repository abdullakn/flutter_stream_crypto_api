import 'dart:async';

import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({ Key? key }) : super(key: key);

  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter=60;

  void startTimer() async{
    Timer.periodic(Duration(seconds: 1), (timer) { 
      _counter--;
      _streamController.sink.add(_counter);
      if(_counter<=0){
        timer.cancel();
        _streamController.close();
      }
    });

  }

  StreamController _streamController=StreamController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: _streamController.stream,
          initialData: _counter,
          builder: (context,snapshot){
          return Text(snapshot.data.toString());

        }),
        ElevatedButton(onPressed: (){
          startTimer();
        }, child: Text("start timer"))
      ],
    );
  }
}