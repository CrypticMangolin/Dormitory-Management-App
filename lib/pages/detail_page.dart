import 'package:flutter/material.dart';

import '../model/room_data.dart';
import '../services/firestore_service.dart';
import 'edit_room_page.dart';

class RoomDetails extends StatelessWidget {
  final RoomData roomData;
  final FirestoreService firestoreService = FirestoreService();

  RoomDetails({Key? key, required this.roomData}) : super(key: key);

  Future<void> deleteRoom(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Room'),
          content: Text('Are you sure you want to delete this room?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        await firestoreService.deleteRoom(roomData.id);
        Navigator.pop(context);
      } catch (e) {
        print('Error deleting room: $e');
      }
    }
  }

  Future<void> editRoom(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Room'),
          content: Text('Are you sure you want to edit this room?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Edit'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditRoomPage(room: roomData),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => editRoom(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => deleteRoom(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  roomData.roomImages.isNotEmpty
                      ? roomData.roomImages[0].imageLink
                      : 'https://via.placeholder.com/400',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              roomData.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              roomData.description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Harga: Rp ${roomData.price}/bulan',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Availability: ${roomData.availability ? 'Available' : 'Not Available'}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fasilitas:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: roomData.roomFacilities.isNotEmpty
                  ? roomData.roomFacilities
                  .map((facility) => Text('- ${facility.name}'))
                  .toList()
                  : [
                Text('- Free Wi-Fi'),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: roomData.availability
                    ? () {
                  // TODO
                }
                    : null,
                child: Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
