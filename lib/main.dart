import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}


double lat = 0.0;
double lon = 0.0;
String lattext = '';
String lontext = '';
String timestampText = '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true
      ),
      home: const HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState () => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  bool _isRunning = false; 
  static const MethodChannel _platform = MethodChannel('gnss_plugin');

  Future<Position> determinePosition() async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission== LocationPermission.denied){
        return Future.error('Error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async{
    try {
      Position position = await determinePosition();

      int? gnssTimeMillis = await _platform.invokeMethod<int>('getGnssTime');
      
      print('Tiempo GNSS recibido: $gnssTimeMillis ms');
      print('Funcionando');  //cambio para primer pullrequest

      setState(() {
        lat = position.latitude;
        lon = position.longitude;

        lattext = lat.toString();
        lontext = lon.toString();

        if ( gnssTimeMillis! > 0) {
          int gnssTimeSec = gnssTimeMillis ~/ 1000;
          DateTime gpsEpoch = DateTime.utc(1980, 1, 6);
          
          DateTime gnssDate = gpsEpoch.add(Duration(seconds: gnssTimeSec)).toLocal();
          DateTime gnssDateSync = gnssDate.subtract(Duration(seconds: 18));
          timestampText = DateFormat('yyyy-MM-dd HH:mm:ss').format(gnssDateSync);

    
        
        } else {
        timestampText = "GNSS Time no disponible";
        }
        

      });

    } on PlatformException catch (e) {
      setState(() {
        timestampText = 'Error obteniendo tiempo GNSS: ${e.message}';
      });
    }
  }

  void timerwidget(){
    if (_isRunning){
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      getCurrentLocation();
      _timer = Timer.periodic(Duration(seconds: 10), (timer){
        if (!_isRunning){
          timer.cancel();
        } else {
          getCurrentLocation();
        }
      });

      setState(() {
        _isRunning = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  
   @override
   Widget build(BuildContext context){


    return Scaffold(
      appBar: AppBar(
          title: const Text('GPS app'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lattext, style: TextStyle(fontSize: 24),),
              SizedBox(height: 10,),
              Text(lontext, style: TextStyle(fontSize: 24),),
              SizedBox(height: 10,),
              Text(timestampText, style: const TextStyle(fontSize: 18, color: Colors.orange)),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                timerwidget();
              }, child: Text('Enviar Datos')),
            ],
          ),
        ),

    );
   }
}

