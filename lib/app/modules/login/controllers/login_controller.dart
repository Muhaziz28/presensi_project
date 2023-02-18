import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    // print(emailController.text);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Semua Field Harus Diisi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20));
    } else {
      try {
        // sleep(const Duration(seconds: 2));
        isLoading.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        print(userCredential);

        // verify email
        if (userCredential.user!.emailVerified) {
          isLoading.value = false;
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(20),
            title: "Verifikasi Email",
            middleText: "Silahkan Verifikasi Email Anda",
            actions: [
              OutlinedButton(
                onPressed: () {
                  isLoading.value = true;
                  Get.back();
                },
                child: Text("Batal"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await userCredential.user!.sendEmailVerification();
                    Get.back();
                    Get.snackbar(
                      "Success",
                      "Email Verifikasi Terkirim",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    isLoading.value = false;
                  } catch (e) {
                    isLoading.value = false;
                    Get.snackbar("Error", e.toString());
                  }
                },
                child: Text("Verifikasi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          );
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Error", "Email Tidak Terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Password Salah");
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }
}
