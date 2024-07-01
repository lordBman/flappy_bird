import 'dart:async';
import 'dart:developer';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flappy_bird/game/objects/background.dart';
import 'package:flappy_bird/game/objects/bird.dart';
import 'package:flappy_bird/game/objects/ground.dart';
import 'package:flappy_bird/game/objects/pipes.dart';
import 'package:flappy_bird/game/utils.dart';
import 'package:flutter/painting.dart';

class FlappyBird extends FlameGame  with KeyboardEvents, TapCallbacks, HasCollisionDetection{
    late Bird __bird;
    late TextComponent __score;
    late Background __background;
    late PipesLayer __pipesLayer;
    late Ground __ground;

    bool isHit = false;

    @override
    FutureOr<void> onLoad() async{
        await AssetsLoader().loadAll().catchError((error)=> log(error.toString()));

        camera.viewport = FixedResolutionViewport(resolution: Vector2(480, 800));
        __bird = Bird();
        __score = buildScore();
        __background = Background();
        __ground = Ground();
        __pipesLayer = PipesLayer();

        addAll([ __background, __bird, __pipesLayer, __ground, __score]);
    }

    TextComponent buildScore() {
        return TextComponent(text: "00",
            position: Vector2(size.x / 2, size.y / 2 * 0.2),
            anchor: Anchor.center,
            textRenderer: TextPaint(style: const TextStyle(fontSize: 40, fontFamily: 'Game', fontWeight: FontWeight.bold),
        ));
    }

    @override
    void onTapDown(TapDownEvent event) {
        super.onTapDown(event);
        if(isHit){
            reset();
        }
        __bird.fly();
    }

    @override
    void update(double dt) {
        super.update(dt);
        __score.text = 'Score: ${__bird.score}';
    }

    void gameOver() {
        //FlameAudio.play(Assets.collision);
        isHit = true;
        //gameRef.overlays.add('gameOver');
        //game.pauseEngine();
        __background.stop();
        __pipesLayer.pause();
        __ground.stop();
    }

    void reset(){
        isHit = false;
        __background.resume();
        __pipesLayer.reset();
        __ground.resume();
        __bird.reset();
    }
}