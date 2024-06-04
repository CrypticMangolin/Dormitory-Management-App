import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/room_data.dart';

class FirestoreService {
  final CollectionReference rooms =
  FirebaseFirestore.instance.collection('rooms');

  // CREATE
  Future<void> addRoom(RoomData room) {
    return rooms.add(room.toFirestore());
  }

  // READ
  Stream<QuerySnapshot> getRoomsStream() {
    final roomsStream = rooms.snapshots();
    return roomsStream;
  }

  // UPDATE
  Future<void> updateRoom(String docID, RoomData room) {
    return rooms.doc(docID).update(room.toFirestore());
  }

  // DELETE
  Future<void> deleteRoom(String docID) {
    return rooms.doc(docID).delete();
  }

  Future<bool> roomsExist() async {
    final snapshot = await rooms.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<RoomData> getInitialRoom() async {
    final querySnapshot = await rooms.limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return RoomData.fromFirestore(querySnapshot.docs.first);
    } else {
      // If no rooms exist, return a default room
      RoomData initialRoom =  RoomData(
        id: '1',
        name: 'Kamar 1',
        description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        price: '1.500.000',
        roomImages: [
          RoomImage(imageLink: 'https://via.placeholder.com/400'),
          RoomImage(imageLink: 'https://via.placeholder.com/401'),
        ],
        roomFacilities: [
          Facility(name: 'Free Wi-Fi'),
          Facility(name: 'Air Conditioning'),
        ],
        availability: true,
      );

      await addRoom(initialRoom);
      return initialRoom;
    }
  }
}
