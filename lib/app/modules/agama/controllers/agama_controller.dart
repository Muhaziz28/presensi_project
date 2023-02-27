import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgamaController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController namaAgama = TextEditingController();

  Future<void> AddAgama() async {
    if (namaAgama.text.isNotEmpty) {
      try {
        await firestore.collection('agama').add({
          'nama_agama': namaAgama.text,
        });
        Get.back();
        Get.snackbar('Berhasil', 'Berhasil menambahkan agama',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Gagal', '${e.toString()}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Gagal', 'Gagal menambahkan agama',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteAgama(String id) async {
    try {
      await firestore.collection('agama').doc(id).delete();
      Get.snackbar('Berhasil', 'Berhasil menghapus agama',
          snackPosition: SnackPosition.BOTTOM);
      print('berhasil');
    } catch (e) {
      Get.snackbar('Gagal', '${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAgama() async* {
    yield* await FirebaseFirestore.instance.collection('agama').snapshots();
  }
}
