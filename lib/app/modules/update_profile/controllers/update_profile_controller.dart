import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController namaUser = TextEditingController();
  TextEditingController emailUser = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();

  List<String> roles = [
    'Pilih Role',
    'Operator',
    'Propam',
    'Personil',
    'Bendahara Keuangan',
    'Kapolres'
  ];
  RxString selectedRole = 'Pilih Role'.obs;

  List<String> genders = [
    'Pilih Jenis Kelamin',
    'Laki-laki',
    'Perempuan',
  ];
  RxString selectedGender = 'Pilih Jenis Kelamin'.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   print(image!.name);
    //   print(image!.name.split('.').last);
    //   print(image!.path);
    // } else {
    //   print(image);
    // }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (namaUser.text.isEmpty ||
        tempatLahir.text.isEmpty ||
        selectedRole.value == 'Pilih Role' ||
        selectedGender.value == 'Pilih Jenis Kelamin') {
      Get.snackbar('Gagal', 'Semua data harus diisi');
    } else {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "nama_user": namaUser.text,
          "tempat_lahir": tempatLahir.text,
          "role": selectedRole.value,
          "jenis_kelamin": selectedGender.value,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split('.').last;

          await firebase_storage.FirebaseStorage.instance
              .ref('$uid/profile.$ext')
              .putFile(file);
          String imageUrl =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"foto_profile": imageUrl});
        }
        await firestore.collection("personil").doc(uid).update(data);
        Get.snackbar('Berhasil', 'Data berhasil diupdate');
      } catch (e) {
        Get.snackbar('Gagal', 'Data gagal diupdate');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteImage(String uid) async {
    try {
      await firestore.collection('personil').doc(uid).update({
        'foto_profile': FieldValue.delete(),
      });

      await storage.ref('$uid/profile.jpg').delete();
      Get.back();
      Get.snackbar('Berhasil', 'Foto berhasil dihapus');
    } catch (e) {
      Get.snackbar('Terjadi keasalahan', e.toString());
    } finally {
      update();
    }
  }
}
