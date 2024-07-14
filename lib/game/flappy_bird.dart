import 'dart:async';
import 'dart:developer';

import 'package:flutter/painting.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';

import 'package:flappy_bird/game/objects/background.dart';
import 'package:flappy_bird/game/objects/bird.dart';
import 'package:flappy_bird/game/objects/ground.dart';
import 'package:flappy_bird/game/objects/pipes.dart';
import 'package:flappy_bird/game/utils.dart';

class FlappyBird extends FlameGame  with KeyboardEvents, TapCallbacks, HasCollisionDetection{
    late Bird __bird;
    late TextComponent __score;
    late Background __background;
    late PipesLayer __pipesLayer;
    late Ground __ground;

    @override
    FutureOr<void> onLoad() async{
        await AssetsLoader().loadAll().catchError((error)=> log(error.toString()));

        __bird = Bird();
        __score = buildScore();
        __background = Background();
        __ground = Ground();
        __pipesLayer = PipesLayer();

        world.addAll([ __background, __bird, __pipesLayer, __ground, __score]);
        camera = CameraComponent.withFixedResolution(world: world, width: Utils.gameWorldWidth, height: Utils.gameWorldHeight,);
        camera.moveBy(Vector2(Utils.gameWorldWidth / 2, Utils.gameWorldHeight / 2));
    }

    TextComponent buildScore() {
        return TextComponent(text: "00",
            position: Vector2(Utils.gameWorldWidth / 2, Utils.gameWorldHeight / 2 * 0.2),
            anchor: Anchor.center,
            textRenderer: TextPaint(style: const TextStyle(fontSize: 40, fontFamily: 'Game', fontWeight: FontWeight.bold),
        ));
    }

    @override
    void onTapDown(TapDownEvent event) {
        super.onTapDown(event);
        __bird.fly();
    }

    @override
    void update(double dt) {
        super.update(dt);
        __score.text = 'Score: ${__bird.score}';
    }

    void gameOver() {
        overlays.add('gameOver');
        //game.pauseEngine();
        __background.stop();
        __pipesLayer.pause();
        __ground.stop();
    }

    void reset(){
        __background.resume();
        __pipesLayer.reset();
        __ground.resume();
        __bird.reset();
    }
}