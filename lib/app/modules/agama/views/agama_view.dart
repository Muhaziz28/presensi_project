import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:absensi_project_app/theme.dart';
import '../controllers/agama_controller.dart';

class AgamaView extends GetView<AgamaController> {
  const AgamaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AgamaView'),
          centerTitle: true,
          backgroundColor: primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Tambah Agama'),
                    content: TextFormField(
                      controller: controller.namaAgama,
                      decoration: InputDecoration(
                        hintText: 'Agama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.AddAgama();
                        },
                        child: Text('Simpan'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // create a list of agama
            StreamBuilder(
                stream: controller.streamAgama(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.data?.docs.length == 0 || snapshot.data == null)
                    return Center(
                      child: Text('Tidak ada data'),
                    );
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data?.docs[index].data()['nama_agama'],
                        ),
                        // add button to delete and edit agama
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Edit Agama'),
                                    content: TextFormField(
                                      controller: controller.namaAgama,
                                      decoration: InputDecoration(
                                        hintText: 'Agama',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.AddAgama();
                                        },
                                        child: Text('Simpan'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Hapus Agama'),
                                    content: Text(
                                        'Apakah anda yakin ingin menghapus agama ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.deleteAgama(
                                              '${snapshot.data?.docs[index].id}}');
                                        },
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ],
        ));
  }
}
