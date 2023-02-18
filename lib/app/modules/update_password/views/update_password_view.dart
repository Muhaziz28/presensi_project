import 'package:absensi_project_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),
          TextField(
            controller: controller.passwordLama,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Lama',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.passwordBaru,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.konfirmasiPasswordBaru,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePassword();
                }
              },
              child: Text(
                controller.isLoading.isFalse ? 'Update Password' : 'Loading',
                style: whiteTextStyle.copyWith(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
