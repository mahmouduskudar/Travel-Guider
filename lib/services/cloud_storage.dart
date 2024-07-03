import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  const CloudStorage._();

  FirebaseStorage get _firebaseStorage => FirebaseStorage.instance;

  static const CloudStorage instance = CloudStorage._();

  Future<String?> uploadFile(File file) async {
    try {
      final fileExtension = file.path.split('.').last;
      final ref = _firebaseStorage
          .ref()
          .child(
            'images',
          )
          .child(
            DateTime.now().millisecondsSinceEpoch.toString() +
                '.' +
                fileExtension,
          );

      final bytes = await file.readAsBytes();

      final uploadTask = ref.putData(bytes);
      uploadTask.snapshotEvents.listen(
        (event) {
          print('EVENT ${event.state}');
        },
      );
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();

      return url;
    } catch (e) {
      print(e);

      return null;
    }
  }
}
