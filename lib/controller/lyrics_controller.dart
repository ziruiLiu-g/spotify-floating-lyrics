import 'package:get/get.dart';

class LyricsController extends GetxController {
  var _current = ''.obs;
  var _next = ''.obs;

  var _currentIndex = 0.obs;

  var _lyrics = [].obs;

  String get current => _current.value;
  set current(String s) => _current.value = s;

  String get next => _next.value;
  set next(String s) => _next.value = s;

  List get lyrics => _lyrics.value;
  set lyrics(List l) => _lyrics.value = l;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int i) => _currentIndex.value = i;

  @override
  void onInit() {
    super.onInit();
  }
}
