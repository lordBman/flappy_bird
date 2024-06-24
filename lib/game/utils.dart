import 'package:flame/game.dart';
import 'dart:math';

class Utils{
    static final gameSpeed = Vector2(150, 280);
    static double groundHeight = 60.0;
    static const gravity = -100.0;
    static const pipeInterval = 1.5;
    static num degToRad(num deg)=> deg * (pi / 180.0);
}