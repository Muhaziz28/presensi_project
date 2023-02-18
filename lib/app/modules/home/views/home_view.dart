import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:absensi_project_app/theme.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final pageController = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.stremUser(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                String role = snap.data!.data()!['role'];
                if (role == 'Operator') {
                  // operator
                  return IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.ADD_PERSONIL);
                    },
                    icon: const Icon(Icons.person_add),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ],
      ),
      body: StreamBuilder(
          stream: controller.stremUser(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, dynamic> data = snap.data!.data()!;

            if (snap.hasData) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            data["foto_profile"] == null
                                ? 'https://ui-avatars.com/api/?name=${data["nama_user"]}'
                                : data["foto_profile"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${data['nama_user']}',
                            style: blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder(
                        stream: controller.stremPresenceToday(),
                        builder: (context, snapPresenceToday) {
                          if (snapPresenceToday.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          Map<String, dynamic>? dataToday =
                              snapPresenceToday.data?.data();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Masuk'),
                                  Text(
                                    '${dataToday?["check_in"] == null ? '-' : DateFormat('HH:mm').format(DateTime.parse(dataToday?['check_in']?['date']))}',
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.black,
                              ),
                              Column(
                                children: [
                                  Text('Keluar'),
                                  Text(
                                      '${dataToday?["check_out"] == null ? '-' : DateFormat('HH:mm').format(DateTime.parse(dataToday?['check_out']?['date']))}'),
                                ],
                              ),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Absensi Hari Ini',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                        child: Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.stremPresence(),
                      builder: (context, snapPresence) {
                        if (snapPresence.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // print('Ini data ${snapPresence.data!.docs}');
                        if (snapPresence.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('Belum ada data'),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapPresence.data!.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataPresence =
                                snapPresence.data!.docs[index].data();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.PRESENSI_DETAIL,
                                        arguments: dataPresence);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Masuk',
                                              style: blackTextStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: bold,
                                              ),
                                            ),
                                            Text(dataPresence['check_in']
                                                        ?['date'] ==
                                                    null
                                                ? '-'
                                                : '${DateFormat('dd MMMM yyyy').format(DateTime.parse(dataPresence['check_in']?['date']))}'),
                                          ],
                                        ),
                                        Text(
                                            '${DateFormat('dd MMMM yyyy').format(DateTime.parse(dataPresence['date']))}'),
                                        Text(
                                          'Keluar',
                                          style: blackTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: bold,
                                          ),
                                        ),
                                        Text(dataPresence['check_out']
                                                    ?['date'] ==
                                                null
                                            ? '-'
                                            : '${DateFormat('dd MMMM yyyy').format(DateTime.parse(dataPresence['check_in']?['date']))}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })
                ],
              );
            } else {
              return const Center(
                child: Text('Gagal memuat data'),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Absen'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageController.currentIndex.value,
        onTap: (int i) => pageController.changePage(i),
      ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () async {
      //       if (controller.isLoading.isFalse) {
      //         controller.isLoading.value = true;
      //         await FirebaseAuth.instance.signOut();
      //         Get.offAllNamed(Routes.LOGIN);
      //         controller.isLoading.value = false;
      //         Get.snackbar(
      //           "Success",
      //           "Berhasil Logout",
      //           backgroundColor: Colors.green,
      //           colorText: Colors.white,
      //         );
      //       }
      //     },
      //     child: controller.isLoading.isTrue
      //         ? const CircularProgressIndicator()
      //         : const Icon(Icons.logout),
      //   ),
      // ),
    );
  }
}
