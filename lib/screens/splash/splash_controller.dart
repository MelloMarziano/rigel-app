import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  String title = 'Rigel App';

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 600), () {
      final box = GetStorage();
      final user = box.read('user');
      if (user == null) {
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        Get.offAllNamed(AppRoutes.HOME);
      }
    });
  }
}
