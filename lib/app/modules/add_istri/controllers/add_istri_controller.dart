import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddIstriController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController nama_istri = TextEditingController();
  TextEditingController tempat_lahir = TextEditingController();

  List<String> pekerjaan = [
    'Pilih Pekerjaan Istri',
    'Ibu Rumah Tangga',
    'Pegawai Negeri Sipil',
    'Pegawai Swasta',
    'Wiraswasta',
    'Lainnya',
  ];
  RxString selectedPekerjaan = 'Pilih Pekerjaan Istri'.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> store() async {
    isLoadingAdd.value = true;

    try {
      String uid = await auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> collectionReference =
          await firestore.collection('personil').doc(uid).collection('istri');

      QuerySnapshot<Map<String, dynamic>> snapIstri =
          await collectionReference.get();

      int id = snapIstri.docs.length + 1;

      await collectionReference.doc(id.toString()).set({
        'nama_istri': nama_istri.text,
        'tempat_lahir': tempat_lahir.text,
        'pekerjaan': selectedPekerjaan.value,
      });

      Get.back();
      Get.snackbar("Success", "Data Istri Berhasil Ditambahkan");



      isLoadingAdd.value = false;
    } on FirebaseAuthException catch (e) {
      isLoadingAdd.value = false;
      Get.snackbar("Error", e.toString());
    } catch (e) {
      isLoadingAdd.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
