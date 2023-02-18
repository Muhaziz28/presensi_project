import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:absensi_project_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History Presensi'),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: controller.streamAllPresence(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (snapshot.data?.docs.length == 0 ||
                        snapshot.data == null)
                      return Center(
                        child: Text('Tidak ada data'),
                      );
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data?.docs[index]
                            .data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.PRESENSI_DETAIL,
                                    arguments: data);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text(
                                            '${data['date'] == null ? '-' : DateFormat.yMMMEd().format(DateTime.parse(data['date']))}'),
                                      ],
                                    ),
                                    Text(
                                      data['check_in']?['date'] == null
                                          ? '-'
                                          : '${DateFormat.jms().format(DateTime.parse(data['check_in']['date']))}',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: medium,
                                      ),
                                    ),
                                    Text(
                                      'Keluar',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    Text(
                                      data['check_out']?['date'] == null
                                          ? '-'
                                          : '${DateFormat.jms().format(DateTime.parse(data['check_out']['date']))}',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
