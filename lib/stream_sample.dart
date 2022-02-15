import 'dart:async';

import 'package:flutter/material.dart';

class StreamSample extends StatefulWidget {
  const StreamSample({ Key? key }) : super(key: key);

  @override
  _StreamSampleState createState() => _StreamSampleState();
}

class _StreamSampleState extends State<StreamSample> {

  final StreamController _streamController=StreamController();

  


  addData()async{
    for(int i=1;i<=20;i++){
     await Future.delayed(Duration(seconds: 1));
      _streamController.sink.add(i);
    }
  }

  Stream<int> nuumberStream() async*{

     for(int i=1;i<=20;i++){
     await Future.delayed(Duration(seconds: 1));
      yield i;
    }

  }

  @override
  void initState() {

    super.initState();
      addData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Center(
        child: StreamBuilder(
          stream:nuumberStream().where((number) => number%2==0),
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text("Some error is here");
            }else if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();

            }else{
              return Text('${snapshot.data}');
            }
          }),
      ),
    );
  }
}