import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/data_card_widget.dart';
import '../services/database_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _insights = 'Loading insights...';

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final insights = await DatabaseService().getInsights(user.uid);
      setState(() => _insights = insights);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('data').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final data = snapshot.data?.docs.last?.data();  // Latest data
          return ListView(
            children: [
              DataCardWidget(title: 'Sleep Efficiency', value: '${data?['sleepEfficiency'] ?? 0}%'),
              DataCardWidget(title: 'Stress Level', value: '${data?['stressLevel'] ?? 0}'),
              DataCardWidget(title: 'Insights', value: _insights),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/sleep'), child: Text('Monitor Sleep')),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, '/consent'), child: Icon(Icons.add)),
    );
  }
}