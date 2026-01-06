import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Access the Firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Function to Save a Diary Entry (Cloud Database Integration)
  Future<void> addEntry(String content, String weather) async {
    try {
      await _db.collection('diaries').add({
        'content': content,
        'weather': weather,
        'timestamp': FieldValue.serverTimestamp(), // Saves the exact time
      });
    } catch (e) {
      print("Error saving to Firestore: $e");
      rethrow; // Pass error back to UI
    }
  }

  // 2. Function to Get Entries (Real-time updates)
  Stream<QuerySnapshot> getDiaryStream() {
    return _db
        .collection('diaries')
        .orderBy('timestamp', descending: true) // Newest first
        .snapshots();
  }
}
