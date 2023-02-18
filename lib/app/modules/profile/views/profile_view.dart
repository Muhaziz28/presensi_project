import 'package:absensi_project_app/app/controllers/page_index_controller.dart';
import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:absensi_project_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final pageController = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.userStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          print('Nama Personil: ${snap.data!.data()!['nama_user']}');
          if (snap.hasData) {
            Map<String, dynamic> data = snap.data!.data()!;
            print("data: $data");
            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          data["foto_profile"] == null
                              ? 'https://ui-avatars.com/api/?name=${data["nama_user"]}'
                              : data["foto_profile"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('${data['nama_user']}'),
                Text('${data['email_user']}'),
                Text('${data['role']}'),
                ListTile(
                  title: Text('Update Profile'),
                  leading: Icon(Icons.person),
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: data),
                ),
                ListTile(
                  title: Text('Ubah Password'),
                  leading: Icon(Icons.vpn_key),
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                ),
                if (data['role'] == 'Operator')
                  ListTile(
                    title: Text('Tambah Pegawai'),
                    leading: Icon(Icons.person_add),
                    onTap: () => Get.toNamed(Routes.ADD_PERSONIL),
                  ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () => controller.logout(),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Data Tidak Ditemukan'),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: primaryColor,
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Absen'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageController.currentIndex.value,
        onTap: (int i) => pageController.changePage(i),
      ),
    );
  }
}
