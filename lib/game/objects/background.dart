import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

class Background extends ParallaxComponent<FlappyBird>{
    bool __running = true;
    bool get isRunning => __running;

    Background(): super(key: ComponentKey.named("background"));

    @override
    FutureOr<void> onLoad() async{
        final background = await AssetsLoader().loadImage("Sky.png");
        final clouds = await AssetsLoader().loadImage("Clouds.png");
        final buildings = await AssetsLoader().loadImage("Buildings.png");
        final trees = await AssetsLoader().loadImage("Trees.png");

        parallax = Parallax([
            ParallaxLayer(ParallaxImage(background), velocityMultiplier: Vector2.zero()),
            ParallaxLayer(ParallaxImage(clouds), velocityMultiplier: Vector2.zero()),
            ParallaxLayer(ParallaxImage(buildings), velocityMultiplier: Vector2.all(0.1)),
            ParallaxLayer(ParallaxImage(trees), velocityMultiplier: Vector2.all(0.5)),
        ], baseVelocity: Vector2(Utils.gameSpeed.x, 0));
    }

    void stop() => __running = false;
    void resume() => __running = true; 

    @override
    void update(double dt) {
        if(__running){
            super.update(dt);
        }
    }
}