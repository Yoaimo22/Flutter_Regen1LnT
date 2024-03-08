import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import 'key.dart' as key;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cuaca iklim kita'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;
   @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String? _kotaInput;
  Future _goToNextPage(BuildContext context) async {
 Map result = 
  await Navigator.of(context).push(MaterialPageRoute<dynamic>(builder: (context) {
    return changeCity();
  }));
  
  if (result != null && result.containsKey("kota") ){
    _kotaInput = result["kota"].toString();
    //print(result["kota"].toString());
setState(() {
  
});
    // .toString());


  }
}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
              title: Text(widget.title),
        backgroundColor: Colors.redAccent,
     
     
        actions: [
          IconButton (
            onPressed: () {
              _goToNextPage(context);
            },
          icon: const Icon(Icons.search),
          ),
          ],
      ),
      body: Stack(children: [
          Center(
            
           child: Image.asset(
              'images/bgip.jpg',
              width: 600,
              color: Color.fromARGB(255, 243, 9, 9).withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
              fit: BoxFit.fill,
              
            ),
           ),
          
          
      Container(
        alignment: Alignment.topRight,
        child: Text('${_kotaInput == null ? key.defaultCity : _kotaInput}',style: kotaStyle,),
     
        
    
      margin: EdgeInsets.fromLTRB(0.0, 11, 20,0),
         ),
    Container(
      alignment: Alignment.center,
      child: Image.asset('images/storm.png'),

    
    ),
    Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0.0, 150, 20, 0),
      child: updateTempWidget(_kotaInput ?? key.defaultCity ),
    )
     
     ] ),
     );
  }
}
TextStyle kotaStyle = const TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 230, 154, 42)
);
//         child: Column(
          
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


class changeCity extends StatelessWidget {
var kotaFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Kota'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Stack(
        children : [
          Center(
            child: Image.asset('images/sunny.png', fit: BoxFit.fill),
          
          ),
          ListView(
            children: [
              ListTile(
                title: TextField(
                  decoration: InputDecoration(hintText: 'Masukkan Nama Kota'),
                  controller: kotaFieldController,
                  keyboardType: TextInputType.text,
                )),
              ListTile(
                title: TextButton(onPressed: () {
                    Navigator.pop(context, {'kota': kotaFieldController.text});
                  },
                  style: TextButton.styleFrom( backgroundColor: Colors.redAccent),
                  child: Text('Pilih',style: TextStyle(color: Colors.white,),),
             
                 ),)
            ],
            ),
        ]
        )
        );
  }
  }

  Future<Map> getWeather(String apiId, String city)async{
    final response= await http.get(Uri.parse( 
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=metric '));
      return json.decode(response.body);
    
  }
  Widget updateTempWidget(String city){
    return FutureBuilder(
      future: getWeather(key.apiId, city),
      builder: ( context, snapshot){
        if (snapshot.hasData){
          Map data = snapshot.data as Map;
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(data['main']['temp'].toString() + "°C",
                  style: tempStyle(),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      "Humidity :" + data['main']['humidity'].toString() + "\n"
                      "Min :" + data['main']['temp_min'].toString() + "C\n"
                      "Max :" + data['main']['temp_max'].toString() + "C\n"
                      "wind :" + data['wind']['speed'].toString() + "m/s\n"
                    )
                    ),
              ),
               
              ] ),
              
         
          );
        } else {
          return Container();
        }
      });
      }
    
  

  TextStyle tempStyle (){
    return TextStyle(
    color: const Color.fromARGB(255, 2, 1, 1),
    fontSize: 49,
    fontWeight: FontWeight.w500
    );
  }