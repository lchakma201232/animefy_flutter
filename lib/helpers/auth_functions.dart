import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<int> checkCredit(User user) async {
  final DocumentSnapshot doc = await _db
      .collection('users')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((snapshot) => snapshot.docs[0]);
  print(doc);
  return doc['credit'];
}

Future<void> addImage(User user, String base64) async {
  await _db.collection(user.uid).add(
      {'base64': base64, 'timestamp': DateTime.now().millisecondsSinceEpoch});
}

Future<List<Map<String, dynamic>>> getImages(User user) async {
  final QuerySnapshot docs = await _db.collection(user.uid).get();
  return docs.docs
      .map((doc) => {
            'base64': doc['base64'],
            'timestamp': doc['timestamp'],
          })
      .toList();
}

Future<void> addUser(User user) async {
  await _db.collection('users').doc(user.uid).set({
    'uid': user.uid,
    'credit': 100,
  });
}

Future<void> updateCredit(User user, int credit) async {
  await _db.collection('users').doc(user.uid).update({
    'credit': credit,
  });
}
