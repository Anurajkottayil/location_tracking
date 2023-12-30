import 'dart:async';

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';





@pragma('vm:entry-point')
void backgroundCallback() {
  BackgroundLocationTrackerManager.handleBackgroundUpdated(
    (data) async => Repo().update(data),
  );
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 // await initializeService();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
 
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 
  var isTracking = false;

  //Timer? _timer;
  final List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _getTrackingStatus();
   
    // _startLocationsUpdatesStream();
  }

  @override
  void dispose() {
    //_timer?.cancel();
    super.dispose();
  }

  Future<void> track(int seconds) async {
    await BackgroundLocationTrackerManager.initialize(
      backgroundCallback,
      config: BackgroundLocationTrackerConfig(
        loggingEnabled: true,
        androidConfig: AndroidConfig(
          notificationIcon: 'explore',
          trackingInterval: const Duration(seconds: 3),
          distanceFilterMeters: null,
        ),
        iOSConfig: const IOSConfig(
          activityType: ActivityType.FITNESS,
          distanceFilterMeters: null,
          restartAfterKill: true,
        ),
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Live Locator'),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                  // Text('Send notification'),
                   

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      // child: TextField(
                      //   controller: textEditingController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Tracking Interval (Seconds)',
                      //   ),
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.allow(RegExp(r'\d'))
                      //   ],
                      // ),
                    ),
                    Padding(
                     
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      // child: TextField(
                      //   controller: textEditingUploadIntervalController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Upload Interval',
                      //   ),
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.allow(RegExp(r'\d'))
                      //   ],
                      // ),
                    ),
                   
                    MaterialButton(
                      child: const Text('Stop Tracking'),
                      onPressed: isTracking
                          ? () async {
                             
                              await BackgroundLocationTrackerManager
                                  .stopTracking();
                              setState(() => isTracking = false);
                            }
                          : null,
                    ),
                     MaterialButton(
                       child: const Text('Start Tracking'),
                       onPressed: isTracking
                           ? null
                           : () async {
                            // await track();
                             await BackgroundLocationTrackerManager
                               .startTracking();
                             setState(() => isTracking = true);
                           },
                     ),
                   
                 //  Text('Location Updates:'),
                    // Display the location updates here
                    Column(
                      children: _locations.map((location) {
                        return Text(location);
                      }).toList(),
                    )
                  ],
                ),
              ],
            ),
           
          ),
        ),
      ),
    );
  }

 

 

  Future<void> _getTrackingStatus() async {
    isTracking = await BackgroundLocationTrackerManager.isTracking();
    setState(() {});
  }

  Future<void> _requestLocationPermission() async {
    final result = await Permission.locationAlways.request();
    if (result == PermissionStatus.granted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

  Future<void> _requestNotificationPermission() async {
    final result = await Permission.notification.request();
    if (result == PermissionStatus.granted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

 
}

class Repo {
  static Repo? _instance;

  Repo._();

  factory Repo() => _instance ??= Repo._();

  void update(BackgroundLocationUpdateData data) {
    final text = 'Lat: ${data.lat} Lon: ${data.lon}';
    print(text); // Display the location data in the console
    // setState(() {
    //   // Update the UI with the new location
    //   _locations.add(text);
    // });
  }
}

// class LocationDao {
//   static const _locationsKey = 'background_updated_locations';
//   static const _locationSeparator = '-/-/-/';

//   static LocationDao? _instance;

//   LocationDao._();

//   factory LocationDao() => _instance ??= LocationDao._();
// }
