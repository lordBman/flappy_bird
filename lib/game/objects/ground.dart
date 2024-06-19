import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

class Ground extends ParallaxComponent<FlappyBird>{
    @override
    FutureOr<void> onLoad() async{
        final ground = await Flame.images.load("base.png");

        parallax = Parallax([
            ParallaxLayer(ParallaxImage(ground, fill: LayerFill.none), velocityMultiplier: Vector2.all(1)),
        ], baseVelocity: Vector2(Utils.gameSpeed.x, 0));

        position = Vector2(0, ground.height - Utils.groundHeight);
    }
}