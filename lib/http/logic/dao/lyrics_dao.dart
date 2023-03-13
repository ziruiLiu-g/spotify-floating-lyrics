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

  static getTrack(String trackName, String artist) async {
    BaseRequest request;
    request = SpotifyLyricsRequest("track.search?q_track=$trackName&q_artist=$artist&f_has_lyrics=1&apikey=${Global.mxmKey}");

    var result = await HiNet.getInstace().fire(request);

    _logger.d(result);
  }

  static getLyric(String trackId) async {
    BaseRequest request;
    request = SpotifyHeroKuAppRequest();
    
    request.add("trackid", trackId);

    try {
      var result = await HiNet.getInstace().fire(request);
      var lines = result['lines'] as List;
      var lyricsMap = {};

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
