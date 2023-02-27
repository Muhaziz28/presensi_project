import 'package:absensi_project_app/app/routes/app_pages.dart';
import 'package:absensi_project_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_istri_controller.dart';

class UpdateIstriView extends GetView<UpdateIstriController> {
  UpdateIstriView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Istri'),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.ADD_ISTRI);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StreamBuilder(
            stream: controller.streamAllIstri(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (snapshot.data?.docs.length == 0 || snapshot.data == null)
                return Center(
                  child: Text('Tidak ada data'),
                );
                print(snapshot.data?.docs.length);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                     border: Border.all(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Text(data['nama_istri']),
                      subtitle: Text(data['tempat_lahir']),
                      // icon edit dan delete
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.UPDATE_ISTRI, arguments: data);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: ()  {
                              print(snapshot.data?.docs[index].reference.id);
                              controller.deleteIstri(snapshot.data?.docs[index].reference.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
