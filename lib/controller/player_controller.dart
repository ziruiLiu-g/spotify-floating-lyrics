import 'package:get/get.dart';

class PlayerController extends GetxController {
  var _img = ''.obs;
  var _artist = ''.obs;
  var _name = ''.obs;

  String get img => _img.value;
  set img(String s) => _img.value = s;

  String get artist => _artist.value;
  set artist(String s) => _artist.value = s;

  String get name => _name.value;
  set name(String s) => _name.value = s;

  @override
  void onInit() {
    super.onInit();
  }
}
