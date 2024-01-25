import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:spotify_desk_lyric/http/logic/request/spotify_lyrics_request.dart';
import 'package:spotify_desk_lyric/model/lyrics_model.dart';
import 'package:spotify_desk_lyric/util/global.dart';

import '../../../controller/lyrics_controller.dart';
import '../../core/hi_net.dart';
import '../request/base_request.dart';
import '../request/spotify_herokuapp_request.dart';
import '../request/spotify_player_request.dart';

class LyricsDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static final _lyricsController = Get.find<LyricsController>();

  static getLyric(String trackId) async {
    SpotifyHeroKuAppRequest request;
    request = SpotifyHeroKuAppRequest();
    request.trackId = trackId;
    
    request.add("format", "json");
    request.add("market", "from_token");

    try {
      var result = await HiNet.getInstace().fire(request);
      _logger.d(result);
      var lines = result['lyrics']['lines'] as List;
      var lyricsMap = {};


      _logger.d(lines);
      for (var line in lines) {
        lyricsMap[int.parse(line['startTimeMs'])] = line['words'];
      }
      Global.currentLyricsModel = LyricsModel(trackId, lyricsMap);

      _lyricsController.lyrics = Global.currentLyricsModel!.lyrics.entries.toList();

      _logger.d("lyrics loaded.");
    } on Exception {
      Global.currentLyricsModel = LyricsModel(trackId, {});
    }
  }
}
