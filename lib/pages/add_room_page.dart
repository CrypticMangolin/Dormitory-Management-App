import 'package:flutter/material.dart';

import '../model/room_data.dart';
import '../services/firestore_service.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _price = '';
  bool _availability = true;

  final FirestoreService _firestoreService = FirestoreService();

  void _saveRoom() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      RoomData newRoom = RoomData(
        id: '',
        name: _name,
        description: _description,
        price: _price,
        roomImages: [],
        roomFacilities: [],
        availability: _availability,
      );

      _firestoreService.addRoom(newRoom);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = value!;
                },
              ),
              SwitchListTile(
                title: Text('Availability'),
                value: _availability,
                onChanged: (value) {
                  setState(() {
                    _availability = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRoom,
                child: Text('Save Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
