import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt currentIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int index) async {
    // print('Index==> $index');

    switch (index) {
      case 1:
        // print('Get Location');
        Map<String, dynamic> data = await determinePosition();
        // print(data);
        if (data['error'] == true) {
          Get.dialog(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
          Get.back();
          Get.snackbar('Error', data['message']);
        } else {
          Get.dialog(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
          Position position = data['position'];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          // check distance
          double distance = Geolocator.distanceBetween(
              -0.897697, 100.374608, position.latitude, position.longitude);

          await updatePosition(position);
          Get.back();
          await presensi(position, placemarks, distance);
        }
        break;
      case 2:
        currentIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        currentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, List<Placemark> placemarks, double distance) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> collectionReference =
        await firestore.collection('personil').doc(uid).collection('presence');
    QuerySnapshot<Map<String, dynamic>> snapPresence =
        await collectionReference.get();

    // print(snapPresence.docs.length);
    DateTime now = DateTime.now();
    String today = DateFormat.yMd().format(now).replaceAll('/', '-');
    // print(today);
    // print(placemarks[0].name);
    String status = 'Di luar area';

    // show progress dialog

    if (distance <= 100) {
      String status = 'Di dalam area';

      if (snapPresence.docs.length == 0) {
        // belum pernah absen, set absen masuk
        await Get.defaultDialog(
          title: 'Absen Masuk',
          middleText: 'Apakah anda yakin ingin absen masuk?',
          textConfirm: 'Ya',
          textCancel: 'Tidak',
          onConfirm: () async {
            await collectionReference.doc(today).set({
              'date': now.toIso8601String(),
              'check_in': {
                'date': now.toIso8601String(),
                'latitude': position.latitude,
                'longitude': position.longitude,
                'address': placemarks[0].name,
                'status': status,
                'distance': distance,
              },
            });
            Get.back();
            Get.snackbar('Success', 'Presensi Berhasil');
          },
        );
      } else {
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await collectionReference.doc(today).get();

        if (todayDoc.exists == true) {
          Map<String, dynamic>? dataPresenceToday = todayDoc.data();

          if (dataPresenceToday?['check_out'] != null) {
            Get.back();
            Get.snackbar('Error', 'Anda sudah absen pulang');
          } else {
            await Get.defaultDialog(
              title: 'Absen Pulang',
              middleText: 'Apakah anda yakin ingin absen pulang?',
              textConfirm: 'Ya',
              textCancel: 'Tidak',
              onConfirm: () async {
                await collectionReference.doc(today).update({
                  'date': now.toIso8601String(),
                  'check_out': {
                    'date': now.toIso8601String(),
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'address': placemarks[0].name,
                    'status': status,
                    'distance': distance,
                  },
                });
                Get.back();
              },
            );
            Get.back();
            Get.snackbar('Success', 'Presensi Berhasil');
          }
        } else {
          await Get.defaultDialog(
            title: 'Absen Masuk',
            middleText: 'Apakah anda yakin ingin absen masuk?',
            textConfirm: 'Ya',
            textCancel: 'Tidak',
            onConfirm: () async {
              await collectionReference.doc(today).set({
                'date': now.toIso8601String(),
                'check_in': {
                  'date': now.toIso8601String(),
                  'latitude': position.latitude,
                  'longitude': position.longitude,
                  'address': placemarks[0].name,
                  'status': status,
                  'distance': distance,
                },
              });
              Get.back();
              Get.snackbar('Success', 'Presensi Berhasil');
            },
          );
          Get.back();
          Get.snackbar('Success', 'Presensi Berhasil');
        }
      }
    } else {
      Get.back();
      Get.snackbar(
        'Error',
        'Anda dil luar area, jarak anda dengan kantor $distance',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        animationDuration: Duration(milliseconds: 500),
        shouldIconPulse: true,
        snackPosition: SnackPosition.BOTTOM,
        padding: EdgeInsets.all(20),
      );
    }
  }

  Future<void> updatePosition(Position position) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection('personil').doc(uid).update({
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      }
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'message': 'Location services are disabled.',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          'message': 'Location permissions are denied',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message':
            'Location permissions are permanently denied, we cannot request permissions.',
        'error': true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'Location services are enabled',
      'error': false,
    };
  }
}
