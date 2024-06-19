import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';
import 'package:flutter/animation.dart';

enum BirdState { flapping, falling }

class Bird extends SpriteAnimationGroupComponent<BirdState> with HasGameReference<FlappyBird>, CollisionCallbacks{
    late Image birdDownFlapImage, birdMiddleFlapImage, birdUpFlapImage;
    int score = 0;
    late final RotateEffect rotateEffect;

    Future<SpriteAnimation> get __flappingAnimation async {
        final birdWingUp = Sprite(birdUpFlapImage);
        final birdWingCenter = Sprite(birdMiddleFlapImage);
        final birdWingDown = Sprite(birdDownFlapImage);

        return SpriteAnimation.spriteList([birdWingUp, birdWingCenter, birdWingDown], stepTime: 0.1, loop: true);
    }

    Future<SpriteAnimation> get __fallingAnimation async {
        final birdWingCenter = Sprite(birdUpFlapImage);

        return SpriteAnimation.spriteList([ birdWingCenter], stepTime: 0.4);
    }

    @override
    FutureOr<void> onLoad() async{
        birdUpFlapImage = await Flame.images.load("yellowbird-upflap.png");
        birdMiddleFlapImage = await Flame.images.load("yellowbird-midflap.png");
        birdDownFlapImage = await Flame.images.load("yellowbird-downflap.png");

        scale = Vector2.all(1.4);
        position = Vector2(60, game.size.y / 2 - scaledSize.y / 2);

        add(RectangleHitbox.relative(Vector2.all(1), parentSize: scaledSize, position: position));

        current = BirdState.falling;
        animations = {
            BirdState.flapping : await __flappingAnimation,
            BirdState.falling: await __fallingAnimation
        };

        rotateEffect = RotateEffect.to( degrees2Radians * 23, EffectController(duration: 0.2, curve: Curves.decelerate));

        addAll([ CircleHitbox(), rotateEffect ]);
    }

    @override
    void update(double dt) {
        super.update(dt);
        position.y += Utils.gameSpeed.y * dt;
        if (position.y < 1) {
            gameOver();
        }else if(position.y >= game.size.y - scaledSize.y - Utils.groundHeight){
            gameOver();
        }
    }

    void fly() {
        if(contains(rotateEffect)){
            remove(rotateEffect);
        }
        add(MoveByEffect(Vector2(0, Utils.gravity), EffectController(duration: 0.2, curve: Curves.decelerate),
            onComplete: (){
              current = BirdState.falling;
            }
        ));
        add(RotateEffect.to( degrees2Radians * -23, EffectController(duration: 0.2, curve: Curves.decelerate),
          onComplete: () {
              rotateEffect.reset();
              add(rotateEffect);
          }
        ));
        //FlameAudio.play(Assets.flying);
        current = BirdState.flapping;
    }

    @override
    void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
        super.onCollisionStart(intersectionPoints, other);
        gameOver();
    }

    void gameOver() {
        //FlameAudio.play(Assets.collision);
        //game.isHit = true;
        //gameRef.overlays.add('gameOver');
        game.pauseEngine();
    }
}