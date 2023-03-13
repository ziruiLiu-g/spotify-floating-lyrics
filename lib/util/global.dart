import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:spotify_desk_lyric/controller/lyrics_controller.dart';
import 'package:spotify_desk_lyric/controller/player_controller.dart';
import 'package:spotify_desk_lyric/model/token_model.dart';

import '../model/current_player_model.dart';
import '../model/lyrics_model.dart';
import 'local_storage.dart';

class Global {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static init() async {
    await LocalStorage.preInit();
    _logger.i('Global init SharedPreferences.');

    Get.put<LyricsController>(LyricsController());
    Get.put<PlayerController>(PlayerController());
  }

  static const html = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <title>Grant Access to Flutter</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
          html, body { margin: 0; padding: 0; }
      
          main {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
          }
      
          #icon {
            font-size: 96pt;
          }
      
          #text {
            padding: 2em;
            max-width: 260px;
            text-align: center;
          }
      
          #button a {
            display: inline-block;
            padding: 6px 12px;
            color: white;
            border: 1px solid rgba(27,31,35,.2);
            border-radius: 3px;
            background-image: linear-gradient(-180deg, #34d058 0%, #22863a 90%);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
          }
      
          #button a:active {
            background-color: #279f43;
            background-image: none;
          }
        </style>
      </head>
      <body>
        <main>
          <div id="icon">&#x1F3C7;</div>
          <div id="text">Press the button below to sign in using your localhost account.</div>
          
          <meta http-equiv="Refresh" content="0; URL=CALLBACK_URL_HERE" />
        </main>
      </body>
      </html>
      ''';
  // <div id="button"><a href="CALLBACK_URL_HERE">Sign in</a></div>


  static late TokenModel tokenInstance;

  static late CurrentPlayerModel currentPlayerModel;

  static LyricsModel? currentLyricsModel;

  static late String clientId;

  static late String clientSecret;
}