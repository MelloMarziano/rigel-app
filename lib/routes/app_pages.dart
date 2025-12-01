import 'package:get/get.dart';

import '../screens/home/home_binding.dart';
import '../screens/home/home_screen.dart';
import '../screens/inventario/inventario_binding.dart';
import '../screens/inventario/inventario_screen.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_binding.dart';
import '../screens/login/login_screen.dart';
import '../screens/profile/profile_binding.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/about_us/about_us_binding.dart';
import '../screens/about_us/about_us_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.ABOUT_US,
      page: () => const AboutUsScreen(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.INVENTARIO,
      page: () => const InventarioScreen(),
      binding: InventarioBinding(),
    ),
  ];
}
