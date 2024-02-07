import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'Screens/main_screen.dart';
import 'provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check location service status
  if (await Permission.location.serviceStatus.isEnabled) {
    var status = await Permission.location.status;
    if (status.isGranted) {
      print('Location permission granted');
    } else {
      // Request location permission
      var permissionStatus = await Permission.location.request();
      if (permissionStatus.isDenied) {
        // Handle denied permission
        print('Location permission denied');
      }
    }
    // Run the app
    runApp(const MyApp());
  } else {
    // Handle case when location service is not enabled
    print('Location service is not enabled');
    // You might want to show a dialog or a message to the user here
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider()..getCurrentLocation(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainScreen(),
      ),
    );
  }
}
