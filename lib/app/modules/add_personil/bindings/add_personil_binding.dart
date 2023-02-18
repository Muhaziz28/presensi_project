import 'package:get/get.dart';

import '../controllers/add_personil_controller.dart';

class AddPersonilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPersonilController>(
      () => AddPersonilController(),
    );
  }
}
