import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flappy_bird/game/objects/background.dart';
import 'package:flappy_bird/game/objects/bird.dart';
import 'package:flappy_bird/game/objects/ground.dart';
import 'package:flappy_bird/game/objects/logs.dart';
import 'package:flutter/widgets.dart';

class FlappyBird extends FlameGame  with KeyboardEvents, TapCallbacks, HasCollisionDetection{
    late Bird __bird;
    late TextComponent __score;
    bool isHit = false;

    @override
    FutureOr<void> onLoad() {
        camera.viewport = FixedResolutionViewport(resolution: Vector2(480, 800));
        __bird = Bird();
        __score = buildScore();

        addAll([ Background(), __bird,  Ground(), __score ]);

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
        __bird.fly();
    }

    /*@override
    void update(double dt) {
        super.update(dt);
        __score.text = 'Score: ${__bird.score}';
    }*/
}