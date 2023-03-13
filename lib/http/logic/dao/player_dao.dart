import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:spotify_desk_lyric/http/logic/request/spotify_lyrics_request.dart';
import 'package:spotify_desk_lyric/model/current_player_model.dart';
import 'package:spotify_desk_lyric/util/global.dart';

import '../../../controller/player_controller.dart';
import '../../core/hi_net.dart';
import '../request/base_request.dart';
import '../request/spotify_player_request.dart';
import 'login_dao.dart';

class PlayerDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static PlayerController playerController = Get.find<PlayerController>();

  static getCurrentTrack() async {
    BaseRequest request;

    late var result;
    try {
      request = SpotifyPlayerRequest();
      result = await HiNet.getInstace().fire(request);
    } on Exception catch (e) {
      _logger.d(e);

      LoginDao.refreshToken();

      request = SpotifyPlayerRequest();
      result = await HiNet.getInstace().fire(request);
    }

    var name = result['item']['name'];
    var trackId = result['item']['id'];
    var progress = result['progress_ms'];
    var artist = result['item']['artists'][0]['name'];
    var img = result['item']['album']['images'][0]['url'];
    Global.currentPlayerModel = CurrentPlayerModel(name, trackId, progress, artist, img);

    playerController.artist = artist;
    playerController.name = name;
    playerController.img = img;

  }
}
