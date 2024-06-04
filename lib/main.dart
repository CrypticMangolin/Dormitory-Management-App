import 'package:flutter/material.dart';
import 'package:golek_kos_client/pages/detail_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golek_kos_client/services/firestore_service.dart';

import 'model/room_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirestoreService firestoreService = FirestoreService();
  RoomData initialRoom = await firestoreService.getInitialRoom();

  runApp(MyApp(initialRoom: initialRoom));
}

class MyApp extends StatelessWidget {
  final RoomData initialRoom;

  const MyApp({Key? key, required this.initialRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoomDetails(roomData: initialRoom),
    );
  }
}
