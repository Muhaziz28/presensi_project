import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> stremUser() async* {
    String getUid = auth.currentUser!.uid;

    yield* firestore.collection('personil').doc(getUid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stremPresence() async* {
    String getUid = auth.currentUser!.uid;

    yield* firestore
        .collection('personil')
        .doc(getUid)
        .collection("presence")
        .orderBy('date', descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stremPresenceToday() async* {
    String getUid = auth.currentUser!.uid;

    String todayPresence =
        DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');
    yield* firestore
        .collection('personil')
        .doc(getUid)
        .collection("presence")
        .doc(todayPresence)
        .snapshots();
  }
}
