import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:spotify_desk_lyric/util/global.dart';
import 'package:spotify_desk_lyric/util/local_storage.dart';
import 'package:window_manager/window_manager.dart';

import 'controller/lyrics_controller.dart';
import 'controller/player_controller.dart';
import 'http/logic/dao/login_dao.dart';
import 'http/logic/dao/lyrics_dao.dart';
import 'http/logic/dao/player_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  windowManager.setAlwaysOnTop(true);

  Global.init().then(
    (e) {
      runApp(MyApp());
      doWhenWindowReady(() {
        final win = appWindow;
        const initialSize = Size(650, 250);
        win.minSize = Size(650, 150);
        win.size = initialSize;
        win.alignment = Alignment.center;
        win.title = "Custom window with Flutter";
        win.show();
      });
    },
  );
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
      ),
      darkTheme: ThemeData.dark().copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        // backgroundColor: Colors.transparent,
        body: WindowBorder(
          color: borderColor,
          width: 0,
          child: Row(
            children: [RightSide()],
          ),
        ),
      ),
    );
  }
}

const backgroundStartColor = Colors.transparent;
const backgroundEndColor = Colors.transparent;

class RightSide extends StatefulWidget {
  const RightSide({super.key});

  @override
  State<RightSide> createState() => _RightSideState();
}

class _RightSideState extends State<RightSide> {
  late LyricsController _lyricsController;
  late ItemScrollController _scrollController;
  late ItemPositionsListener itemPositionsListener;
  late PlayerController playerController;
  final clientidController = TextEditingController(text: LocalStorage.getInstance().get("clientId") == null ? "" : LocalStorage.getInstance().get("clientId") as String);
  final clientsecretController = TextEditingController(text: LocalStorage.getInstance().get("clientSecret") == null ? "" :  LocalStorage.getInstance().get("clientSecret") as String);

  late String _status;
  late Timer _timer;

  @override
  void initState() {
    _scrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    _lyricsController = Get.find<LyricsController>();
    playerController = Get.find<PlayerController>();

    startServer();

    Future.delayed(Duration.zero, () {
      _showCupertinoAlertDialog(
          context: context,
          title: "",
          content: "Please Enter Your SpotifyApi Client ID and Secret.",
          sureText: "Confirm");
      // _login();
    });
  }

  void _showCupertinoAlertDialog(
      {context,
      required String title,
      required String content,
      required String sureText}) {
    showDialog(
      context: context,
      builder: (cxt) {
        return AlertDialog(
          content: Column(
            children: [
              TextField(
                controller: clientidController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Client ID',
                ),
              ),
              TextField(
                controller: clientsecretController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Client Secret',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("确定"),
              onPressed: () {
                Global.clientId = clientidController.text;
                Global.clientSecret = clientsecretController.text;
                LocalStorage.getInstance().setString("clientId", clientidController.text);
                LocalStorage.getInstance().setString("clientSecret", clientsecretController.text);
                _login();
                Navigator.of(context).pop("确定");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 8888, shared: true);

    server.listen((req) async {
      setState(() {
        _status = 'Received request!';
      });

      req.response.headers.add('Content-Type', 'text/html');

      // Windows needs some callback URL on localhost
      req.response.write(
        (Platform.isWindows || Platform.isLinux)
            ? Global.html.replaceFirst(
                'CALLBACK_URL_HERE',
                '${req.uri}',
              )
            : Global.html.replaceFirst(
                'CALLBACK_URL_HERE',
                'foobar://${req.uri}',
              ),
      );

      await req.response.close();
    });
  }

  void _login() async {
    await LoginDao.login();
    await LoginDao.getToken();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      try {
        await PlayerDao.getCurrentTrack();
        if (Global.currentLyricsModel == null ||
            Global.currentLyricsModel!.trackId !=
                Global.currentPlayerModel.trackId) {
          await LyricsDao.getLyric(Global.currentPlayerModel.trackId);
        }
      } catch (e) {
        print(e);
      }

      var current = 0;
      for (var i = 0; i < _lyricsController.lyrics.length; i++) {
        var entry = _lyricsController.lyrics[i];
        if (entry.key < Global.currentPlayerModel.progress) {
          current = i;
        } else {
          break;
        }
      }

      if (current != _lyricsController.currentIndex) {
        _lyricsController.currentIndex = current;
        _scrollController.scrollTo(
            index: _lyricsController.currentIndex,
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
            alignment: 0.4);
      }
      // _scrollController.jumpTo(index: _lyricsController.currentIndex);
    });
  }

  Widget createLyricsView() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ScrollablePositionedList.separated(
        itemScrollController: _scrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: _lyricsController.lyrics.length,
        scrollDirection: Axis.vertical,
        // padding: EdgeInsets.only(right: 50),
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Obx(
            () => Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                textAlign: TextAlign.center,
                '${(_lyricsController.lyrics[index == -1 ? 0 : min(index, _lyricsController.lyrics.length)] as MapEntry).value}',
                maxLines: 1,
                style: _lyricsController.currentIndex == index
                    ? const TextStyle(
                        fontSize: 25,
                        shadows: [
                          Shadow(
                            offset: Offset(5.0, 5.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      )
                    : const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        shadows: [
                          Shadow(
                            offset: Offset(5.0, 5.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Padding(padding: EdgeInsets.symmetric(vertical: 0)),
      ),
    );
  }

  Future<Obx> get_player_img() async {
    return Obx(
      () => Container(
        child: Image.network(Global.currentPlayerModel.imgUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: playerController.img == ''
                            ? []
                            : [
                                Container(
                                  // color: Colors.red,
                                  height: constraints.maxHeight * 3 / 5,
                                  width: constraints.maxWidth * 1 / 4,
                                  child: Image.network(playerController.img),
                                ),
                                constraints.maxHeight > 200
                                    ? Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(playerController.name),
                                            Text(playerController.artist)
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                      ),
                      Container(
                        child: createLyricsView(),
                        height: constraints.maxHeight,
                        width: constraints.maxWidth * 3 / 4 - 50,
                      ),
                    ],
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // height: MediaQuery.of(context).size.height, // set this
                            child: MoveWindow(),
                          ),
                        ),
                        const WindowButtons()
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
