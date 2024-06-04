import 'package:flutter/material.dart';

import '../model/room_data.dart';
import '../services/firestore_service.dart';

class RoomDetails extends StatelessWidget {
  final RoomData roomData;
  final FirestoreService firestoreService = FirestoreService();

  RoomDetails({Key? key, required this.roomData}) : super(key: key);

  Future<void> deleteRoom(BuildContext context) async {
    try {
      await firestoreService.deleteRoom(roomData.id);
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting room: $e');
    }
  }

  Future<void> editRoom(BuildContext context) async {
    final nameController = TextEditingController(text: roomData.name);
    final descriptionController =
    TextEditingController(text: roomData.description);
    final priceController = TextEditingController(text: roomData.price);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final updatedRoom = RoomData(
                  id: roomData.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  price: priceController.text,
                  roomImages: roomData.roomImages,
                  roomFacilities: roomData.roomFacilities,
                  availability: roomData.availability,
                );
                await firestoreService.updateRoom(roomData.id, updatedRoom);
                print('SUCCESS');
                Navigator.pop(context);
              } catch (e) {
                print('Error editing room: $e');
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
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
              'Price: Rp ${roomData.price}/night',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Availability: ${roomData.availability ? 'Available' : 'Not Available'}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Amenities:',
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
                  // Add booking functionality here
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