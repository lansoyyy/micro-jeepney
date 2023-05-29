import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeepney/utils/const.dart';

Future addAccount(email, password) async {
  final docUser = FirebaseFirestore.instance.collection('Users').doc(userId);

  final json = {
    'email': email,
    'password': password,
    'dateTime': DateTime.now(),
    'coordinates': {'lat': 0.00, 'long': 0.00},
    'id': userId
  };

  await docUser.set(json);
}
