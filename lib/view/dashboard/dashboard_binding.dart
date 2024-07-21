import 'package:get/get.dart';
import 'package:pustakaloka/controller/auth_controller.dart';
import 'package:pustakaloka/controller/category_controller.dart';
import 'package:pustakaloka/controller/dashboard_controller.dart';
import 'package:pustakaloka/controller/home_controller.dart';
import 'package:pustakaloka/controller/product_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(HomeController());
    Get.put(ProductController());
    Get.put(CategoryController());
    Get.put(AuthController());
  }
}