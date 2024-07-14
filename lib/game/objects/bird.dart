import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';
import 'package:flutter/animation.dart';

enum BirdState { flapping, falling }

class Bird extends SpriteAnimationGroupComponent<BirdState> with HasGameReference<FlappyBird>, CollisionCallbacks{
    late Image __birdDownFlapImage, __birdMiddleFlapImage, __birdUpFlapImage;
    int score = 0;
    late final RotateEffect rotateEffect;
    bool isHit = false;

    late AudioPool __wingPool, __hitPool;

    Bird():super(key: ComponentKey.named('bird'),);

    Future<SpriteAnimation> get __flappingAnimation async {
        final birdWingUp = Sprite(__birdUpFlapImage);
        final birdWingCenter = Sprite(__birdMiddleFlapImage);
        final birdWingDown = Sprite(__birdDownFlapImage);

        return SpriteAnimation.spriteList([birdWingUp, birdWingCenter, birdWingDown], stepTime: 0.1, loop: true);
    }

    Future<SpriteAnimation> get __fallingAnimation async {
        final birdWingCenter = Sprite(__birdUpFlapImage);

        return SpriteAnimation.spriteList([ birdWingCenter], stepTime: 0.4);
    }

    @override
    FutureOr<void> onLoad() async{
        __birdUpFlapImage = await AssetsLoader().loadImage("yellowbird-upflap.png");
        __birdMiddleFlapImage = await AssetsLoader().loadImage("yellowbird-midflap.png");
        __birdDownFlapImage = await AssetsLoader().loadImage("yellowbird-downflap.png");

        __wingPool = await FlameAudio.createPool("wing.ogg",minPlayers: 2, maxPlayers: 4);
        __hitPool = await FlameAudio.createPool("hit.ogg",minPlayers: 2, maxPlayers: 4);

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
        bool isGrounded = position.y >= game.size.y - scaledSize.y - Utils.groundHeight;
        if(!isGrounded){
            position.y += Utils.gameSpeed.y * dt;
        }

        if (position.y < 0 || (isGrounded && !isHit)) {
            died;
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
        __wingPool.start();
        current = BirdState.flapping;
    }

    @override
    void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
        super.onCollisionStart(intersectionPoints, other);
        died();
    }

    void died(){
        if(!isHit){
            __hitPool.start();
        }
        isHit = true;
        game.gameOver();
    }

    void reset(){
        position = Vector2(60, game.size.y / 2 - scaledSize.y / 2);
        score = 0;
        isHit = false;
    }
}