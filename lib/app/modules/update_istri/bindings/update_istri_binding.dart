import 'package:get/get.dart';

import '../controllers/update_istri_controller.dart';

class UpdateIstriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateIstriController>(
      () => UpdateIstriController(),
    );
  }
}
