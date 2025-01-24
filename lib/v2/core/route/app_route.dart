import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teamlead/v2/core/dl/dependency_injection.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/featuers/authentication/view/login.dart';
import 'package:teamlead/v2/featuers/shared/splash/view/splash.dart';

class AppRoute {
  static List<GetPage> getPages = [
    GetPage(
      name: RouteName.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => const Login(),
    ),
  ];
}
