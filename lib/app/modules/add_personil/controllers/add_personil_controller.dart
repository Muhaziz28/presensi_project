import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPersonilController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController namaUser = TextEditingController();
  TextEditingController emailUser = TextEditingController();

  TextEditingController tempatLahir = TextEditingController();

  TextEditingController jenisKelamin = TextEditingController();

  TextEditingController passwordAdmin = TextEditingController();

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

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> store() async {
    isLoadingAdd.value = true;
    if (passwordAdmin.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passwordAdmin.text);

        UserCredential personilCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailUser.text, password: "123456");

        String uid = personilCredential.user!.uid;
        if (uid != null) {
          await firestore.collection('personil').doc(uid).set({
            'uid': uid,
            'nama_user': namaUser.text,
            'email_user': emailUser.text,
            'role': selectedRole.value,
            'tempat_lahir': tempatLahir.text,
            'jenis_kelamin': jenisKelamin.text,
            'created_at': DateTime.now().toIso8601String(),
          });

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdmin.text,
          );

          Get.back();
          Get.back();
          Get.snackbar("Success", "Personil Berhasil Ditambahkan");
        }
        isLoadingAdd.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAdd.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "Password Terlalu Lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email Sudah Terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Password Salah");
        } else {
          Get.snackbar("Error", e.toString());
        }
      } catch (e) {
        isLoadingAdd.value = false;
        Get.snackbar("Error", e.toString());
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Password Admin Harus Diisi");
    }
  }

  Future<void> AddPersonil() async {
    if (namaUser.text.isEmpty ||
        emailUser.text.isEmpty ||
        tempatLahir.text.isEmpty ||
        jenisKelamin.text.isEmpty) {
      Get.snackbar("Error", "Semua Field Harus Diisi");
    } else {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Konfirmasi",
        content: Column(
          children: [
            Text('Gunakan password anda untuk konfirmasi'),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordAdmin,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (isLoadingAdd.isFalse) {
                await store();
              }
              isLoading.value = false;
            },
            child: Obx(
              () {
                if (isLoadingAdd.isTrue) {
                  return SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return Text("Konfirmasi");
                }
              },
            ),
          ),
        ],
      );
    }
  }
}
