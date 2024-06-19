import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

enum LogPosition{ top, bottom }

class Log extends SpriteComponent with HasGameRef<FlappyBird>{
    LogPosition logPosition;
    double logHeight;

    Log({ required this.logPosition, required this.logHeight });

    @override
    FutureOr<void> onLoad() async {
        Image logsImage = await Flame.images.load("pipe-green.png");

        sprite = Sprite(logsImage);
        height = logHeight;
        switch(logPosition){
            case LogPosition.bottom:
                position.y = gameRef.size.y - logHeight - Utils.groundHeight;
                break;
            case LogPosition.top:
                position.y = logHeight;
                position.x += width;
                angle = radians(180);
                break;
        }

        add(RectangleHitbox());
    }

    @override
    void update(double dt) {
        super.update(dt);
        position.x -= Utils.gameSpeed.x * dt;

        if (position.x < -game.size.x - width) {
          removeFromParent();
          //updateScore();R
        }
    }
}

class LogGroup extends PositionComponent with HasGameRef<FlappyBird> {
    final _random = Random();
    Timer interval = Timer(Utils.pipeInterval, repeat: true);
    
    @override
    Future<void> onLoad() async {
        position.x = game.size.x;

        interval.onTick = () {
            final heightMinusGround = gameRef.size.y - Utils.groundHeight;
            final spacing = 120 + _random.nextDouble() * (heightMinusGround / 3);
            final centerY = spacing + _random.nextDouble() * (heightMinusGround - spacing);
            
            addAll([
              Log(logPosition: LogPosition.top, logHeight: centerY - spacing / 2),
              Log(logPosition: LogPosition.bottom, logHeight: heightMinusGround - (centerY + spacing / 2)),
            ]);
        };
    }
    
    void updateScore() {
        //gameRef.bird.score += 1;
        //FlameAudio.play(Assets.point);
    }
    
    @override
    void update(double dt) {
        super.update(dt);
        interval.update(dt);
        
        /*if (gameRef.isHit) {
            removeFromParent();
            gameRef.isHit = false;
        }*/
    }
}