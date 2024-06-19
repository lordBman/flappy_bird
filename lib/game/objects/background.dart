import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

class Background extends ParallaxComponent<FlappyBird>{
    @override
    FutureOr<void> onLoad() async{
        final background = await Flame.images.load("Sky.png");
        final clouds = await Flame.images.load("Clouds.png");
        final buildings = await Flame.images.load("Buildings.png");
        final trees = await Flame.images.load("Trees.png");

        parallax = Parallax([
            ParallaxLayer(ParallaxImage(background), velocityMultiplier: Vector2.zero()),
            ParallaxLayer(ParallaxImage(clouds), velocityMultiplier: Vector2.zero()),
            ParallaxLayer(ParallaxImage(buildings), velocityMultiplier: Vector2.all(0.1)),
            ParallaxLayer(ParallaxImage(trees), velocityMultiplier: Vector2.all(0.5)),
        ], baseVelocity: Vector2(Utils.gameSpeed.x, 0));
    }
}