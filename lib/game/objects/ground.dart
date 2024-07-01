import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

class Ground extends ParallaxComponent<FlappyBird>{
    bool __running = true;
    bool get isRunning => __running;

    Ground(): super(key: ComponentKey.named("ground"));

    @override
    FutureOr<void> onLoad() async{
        final ground = await AssetsLoader().loadImage("base.png");

        parallax = Parallax([
            ParallaxLayer(ParallaxImage(ground, fill: LayerFill.none), velocityMultiplier: Vector2.all(1)),
        ], baseVelocity: Vector2(Utils.gameSpeed.x, 0));

        position = Vector2(0, ground.height - Utils.groundHeight);
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