import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.setOrientation(DeviceOrientation.portraitUp);
    Flame.device.fullScreen();
    
    FlappyBird flappyBird = FlappyBird();
    runApp(GameWidget(game: flappyBird));
}