import 'package:absensi_project_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_personil_controller.dart';

class AddPersonilView extends GetView<AddPersonilController> {
  const AddPersonilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('AddPersonilView'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: controller.namaUser,
            decoration: InputDecoration(
              label: Text("Nama Personil"),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.emailUser,
            decoration: InputDecoration(
              label: Text("Email"),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.tempatLahir,
            decoration: InputDecoration(
              label: Text("Tempat Lahir"),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.jenisKelamin,
            decoration: InputDecoration(
              label: Text("Jenis Kelamin"),
              border: OutlineInputBorder(),
            ),
          ),
          // dropdown
          const SizedBox(height: 20),
          DropdownButtonFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text("Pilih Role"),
            value: controller.selectedRole.value,
            items: controller.roles
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != 'Pilih Role') {
                controller.selectedRole.value = value.toString();
                print(controller.selectedRole.value);
              } else {
                print('role belum dipilih');
              }
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text("Pilih Jenis Kelamin"),
            value: controller.selectedGender.value,
            items: controller.genders
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != 'Pilih Jenis Kelamin') {
                controller.selectedGender.value = value.toString();
                print(controller.selectedGender.value);
              } else {
                print('jenis kelamin belum dipilih');
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await controller.AddPersonil();
              }
            },
            child: Obx(
              () => controller.isLoading.isTrue
                  ? const CircularProgressIndicator()
                  : const Text("Tambah Personil"),
            ),
          ),
        ],
      ),
    );
  }
}
