import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateIstriController extends GetxController {
  TextEditingController nama_istri = TextEditingController();
  TextEditingController tempat_lahir = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();
  TextEditingController tanggal_lahir = TextEditingController();
  TextEditingController alamat = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllIstri() async* {
    String uid = auth.currentUser!.uid;

    yield* await FirebaseFirestore.instance
        .collection('personil')
        .doc(uid)
        .collection('istri')
        .snapshots();
  }

  // deleteIstri
  Future<void> deleteIstri(String? id) async {
    String uid = auth.currentUser!.uid;

    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah anda yakin ingin menghapus data istri ini?",
      textConfirm: "Ya",
      textCancel: "Tidak",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        Get.dialog(
          Center(
            child: CircularProgressIndicator(),
          ),
        );
        await firestore
            .collection('personil')
            .doc(uid)
            .collection('istri')
            .doc(id)
            .delete();
        Get.back();
        Get.snackbar("Success", "Data Istri Berhasil Dihapus");
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
