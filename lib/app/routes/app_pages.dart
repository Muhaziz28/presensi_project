import 'package:get/get.dart';

import '../modules/add_istri/bindings/add_istri_binding.dart';
import '../modules/add_istri/views/add_istri_view.dart';
import '../modules/add_personil/bindings/add_personil_binding.dart';
import '../modules/add_personil/views/add_personil_view.dart';
import '../modules/agama/bindings/agama_binding.dart';
import '../modules/agama/views/agama_view.dart';
import '../modules/all_presensi/bindings/all_presensi_binding.dart';
import '../modules/all_presensi/views/all_presensi_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/presensi_detail/bindings/presensi_detail_binding.dart';
import '../modules/presensi_detail/views/presensi_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/update_istri/bindings/update_istri_binding.dart';
import '../modules/update_istri/views/update_istri_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PERSONIL,
      page: () => const AddPersonilView(),
      binding: AddPersonilBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI_DETAIL,
      page: () => PresensiDetailView(),
      binding: PresensiDetailBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => const AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
    GetPage(
      name: _Paths.AGAMA,
      page: () => const AgamaView(),
      binding: AgamaBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_ISTRI,
      page: () => UpdateIstriView(),
      binding: UpdateIstriBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ISTRI,
      page: () => const AddIstriView(),
      binding: AddIstriBinding(),
    ),
  ];
}
