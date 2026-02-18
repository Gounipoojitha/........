import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sleep_data.dart';

class DatabaseService {
  Future<void> saveSleepData(String userId, SleepData data) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('data').add(data.toJson());
  }

  Future<String> getInsights(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('insights').doc(userId).get();
    return doc.data()?['recommendation'] ?? 'No insights yet';
  }

  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('data').add(data);
  }
}