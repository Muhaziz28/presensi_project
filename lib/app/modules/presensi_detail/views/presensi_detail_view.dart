import 'package:absensi_project_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/presensi_detail_controller.dart';

class PresensiDetailView extends GetView<PresensiDetailController> {
  PresensiDetailView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Presensi'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '${DateFormat.yMMMMd().format(DateTime.parse(data['date']))}',
                        style: blackTextStyle.copyWith(
                            fontSize: 16, fontWeight: semiBold),
                      ),
                    ),
                    Text('Masuk',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                    Text(data['check_in'] == null
                        ? '-'
                        : '${DateFormat.jms().format(DateTime.parse(data['check_in']['date']))}'),
                    Text(
                        data['check_in'] == null
                            ? '-'
                            : 'Latitude : ${data['check_in']['latitude']} , Longitude : ${data['check_in']['longitude']}',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
// format meter',
                    Text(
                        'Jarak : ${data['check_in']['distance'] == null ? '-' : '${data['check_in']['distance']} meter'}',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                    Text(
                        'Status  : ${data['check_in']['status'] == null ? '-' : data['check_in']['status']}',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Keluar',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                    Text(data['check_out'] == null
                        ? '-'
                        : '${DateFormat.jms().format(DateTime.parse(data['check_out']?['date']))}'),
                    Text(
                        data['check_out'] == null
                            ? 'Latitude : - , Longitude : -'
                            : 'Latitude : ${data['check_out']?['latitude']} , Longitude : ${data['check_out']?['longitude']}',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                    Text(
                        data['check_out'] == null
                            ? 'Status : -'
                            : 'Status : ${data['check_out']?['status']}',
                        style: blackTextStyle.copyWith(fontWeight: medium)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
