import 'package:flutter/material.dart';
import '../model/room_data.dart';
import '../services/firestore_service.dart';

class EditRoomPage extends StatefulWidget {
  final RoomData room;

  EditRoomPage({required this.room});

  @override
  _EditRoomPageState createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _price;
  late bool _availability;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _name = widget.room.name;
    _description = widget.room.description;
    _price = widget.room.price;
    _availability = widget.room.availability;
  }

  void _saveRoom() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      RoomData updatedRoom = RoomData(
        id: widget.room.id,
        name: _name,
        description: _description,
        price: _price,
        roomImages: widget.room.roomImages,
        roomFacilities: widget.room.roomFacilities,
        availability: _availability,
      );

      _firestoreService.updateRoom(widget.room.id, updatedRoom);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                initialValue: _name,
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
                initialValue: _description,
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
                initialValue: _price,
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
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
