import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController passwordLama = TextEditingController();
  TextEditingController passwordBaru = TextEditingController();
  TextEditingController konfirmasiPasswordBaru = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (passwordLama.text.isNotEmpty &&
        passwordBaru.text.isNotEmpty &&
        konfirmasiPasswordBaru.text.isNotEmpty) {
      if (passwordBaru.text == konfirmasiPasswordBaru.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: passwordLama.text);

          await auth.currentUser!.updatePassword(passwordBaru.text);

          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: passwordBaru.text);

          Get.back();
          Get.snackbar('Berhasil', 'Password berhasil diupdate');
        } on FirebaseException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar('Gagal', 'Password yang anda masukkan salah');
          } else {
            Get.snackbar('Gagal', '${e.code.toLowerCase()}');
          }
        } catch (e) {
          Get.snackbar('Gagal', 'Terjadi kesalahan');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Gagal', 'Konfirmasi password baru tidak sama');
      }
    } else {
      Get.snackbar('Gagal', 'Semua data harus diisi');
    }
  }
}
