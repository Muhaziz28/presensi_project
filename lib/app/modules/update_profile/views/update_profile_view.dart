import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:absensi_project_app/theme.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.namaUser.text = data['nama_user'];
    controller.emailUser.text = data['email_user'];
    controller.tempatLahir.text = data['tempat_lahir'];
    controller.selectedRole.value = data['role'];
    controller.selectedGender.value = data['jenis_kelamin'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
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
          Text('Foto Profile'),
          // SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(builder: (controller) {
                if (controller.image != null) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(File(controller.image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  if (data['foto_profile'] != null) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(data['foto_profile']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteImage(data['uid']);
                          },
                          child: Text(
                            "Hapus foto",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('Belum ada foto');
                  }
                }
              }),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text("Pilih foto"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
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
                await controller.updateProfile(data['uid']);
              }
            },
            child: Obx(
              () => controller.isLoading.isTrue
                  ? const CircularProgressIndicator()
                  : const Text("Update Profile"),
            ),
          ),
        ],
      ),
    );
  }
}
