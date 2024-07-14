import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/screens/game_over.dart';
import 'package:flappy_bird/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.setOrientation(DeviceOrientation.portraitUp);
    Flame.device.fullScreen();
    
    FlappyBird flappyBird = FlappyBird();
    runApp(GameWidget(
        game: flappyBird,
        initialActiveOverlays: const [MainMenu.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenu(flappyBird: flappyBird),
          'gameOver': (context, _) => GameOver(flappyBird: flappyBird),
        }
    ));
}