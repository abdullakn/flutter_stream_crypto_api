import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_example/models/data_models.dart';

class APIStream extends StatefulWidget {
  const APIStream({ Key? key }) : super(key: key);

  @override
  _APIStreamState createState() => _APIStreamState();
}

class _APIStreamState extends State<APIStream> {

  StreamController<DataModel> _streamController=StreamController();

  @override
  void dispose() {
    // TODO: implement dispose
    
    _streamController.close();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
       getCryptoPrice();

     });
   

  }

  Future<void> getCryptoPrice() async{
    var url=Uri.parse('https://api.nomics.com/v1/currencies/ticker?key='YOUR_KEY'=ETH');
    final response=await http.get(url);
    print(response);
    final databody=json.decode(response.body).first;
    print(databody);
    DataModel datamodel=DataModel.fromJson(databody);
    print(datamodel.image);
    print(datamodel.name);
    print(datamodel.price);
    _streamController.sink.add(datamodel);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
          builder:(context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator(),);
                  default:if(snapshot.hasError){
                    return Text("Something Wrong...");
                  }else{
                    return CustomWidget(snapshot.data!);
                  }
            }
          }),
      ),
    );

  }

  Widget CustomWidget(DataModel datamodel){
    print("dada");
    print(datamodel.image);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${datamodel.name}'),
          SvgPicture.network(datamodel.image,semanticsLabel: 'Not loaded',headers: null,),
          SizedBox(height: 20,),
          Text('${datamodel.price}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)




        ],
      ),
    );

  }
}
