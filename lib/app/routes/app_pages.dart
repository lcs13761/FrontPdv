import 'package:get/get.dart';

import 'package:lustore/app/modules/addProduct/add_product_binding.dart';
import 'package:lustore/app/modules/addProduct/add_product_view.dart';
import 'package:lustore/app/modules/categories/categories_binding.dart';
import 'package:lustore/app/modules/categories/categories_view.dart';
import 'package:lustore/app/modules/config/config_binding.dart';
import 'package:lustore/app/modules/config/config_view.dart';
import 'package:lustore/app/modules/forget_password/forget_password_binding.dart';
import 'package:lustore/app/modules/forget_password/forget_password_view.dart';
import 'package:lustore/app/modules/home/home_binding.dart';
import 'package:lustore/app/modules/home/home_view.dart';
import 'package:lustore/app/modules/login/login_binding.dart';
import 'package:lustore/app/modules/login/login_view.dart';
import 'package:lustore/app/modules/products/products_binding.dart';
import 'package:lustore/app/modules/products/products_view.dart';
import 'package:lustore/app/modules/reports/reports_binding.dart';
import 'package:lustore/app/modules/reports/reports_view.dart';
import 'package:lustore/app/modules/splash/splash_binding.dart';
import 'package:lustore/app/modules/splash/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => const HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.PRODUCTS,
        page: () => const ProductsView(),
        binding: ProductsBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.ADD_PRODUCT,
        page: () => const AddProductView(),
        binding: AddProductBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.REPORTS,
        page: () => const ReportsView(),
        binding: ReportsBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.CATEGORIES,
        page: () => const CategoriesView(),
        binding: CategoriesBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.CONFIG,
        page: () => const ConfigView(),
        binding: ConfigBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
      transition: Transition.fadeIn
    ),
  ];
}
