import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/utils.dart';

enum LogPosition{ top, bottom }

class PipeBody extends SpriteGroupComponent<LogPosition>{
    double bodyHeight, yPosition;
    LogPosition logPosition;

    PipeBody({required this.logPosition, required this.bodyHeight, required this.yPosition });
    
    @override
    FutureOr<void> onLoad() async{
        super.onLoad();
        sprites = {
            LogPosition.bottom: await __initBottom(),
            LogPosition.top: await __initTop()
        };
        height = bodyHeight;
        position.y = yPosition;
        current = logPosition;
    }

    Future<Sprite> __initBottom() async{
        Image logsImage = await Flame.images.load("pipe-green.png");

        return Sprite(logsImage, srcPosition: Vector2(0, logsImage.height / 2), srcSize: Vector2(logsImage.width.toDouble(), logsImage.height/2));
    }

    Future<Sprite> __initTop() async{
        Image logsImage = await Flame.images.load("pipe-green-rotated.png");

        return Sprite(logsImage, srcPosition: Vector2(0, 0), srcSize: Vector2(logsImage.width.toDouble(), logsImage.height/2));
    }

    @override
  void update(double dt) {
      super.update(dt);
      position.y = yPosition;
  }
}

class Log extends SpriteGroupComponent with HasGameRef<FlappyBird>{
    LogPosition logPosition;
    double logHeight;

    Log({ required this.logPosition, required this.logHeight });

    @override
    FutureOr<void> onLoad() async {
        sprites = {
            LogPosition.bottom: await __initBottom(),
            LogPosition.top: await __initTop()
        };

        addAll([RectangleHitbox()]);
    }
    
    Future<Sprite> __initBottom() async{
        Image logsImage = await Flame.images.load("pipe-green.png");

        Sprite sprite = Sprite(logsImage);
        position.y = gameRef.size.y - logHeight - Utils.groundHeight;

        add(PipeBody(logPosition: LogPosition.bottom, bodyHeight: logHeight - height, yPosition: position.y + height));

        return sprite;
    }

    Future<Sprite> __initTop() async{
        Image logsImage = await Flame.images.load("pipe-green-rotated.png");

        Sprite sprite = Sprite(logsImage);

        position.y = logHeight;
        add(PipeBody(logPosition: LogPosition.top, bodyHeight: logHeight - height, yPosition: -height));

        return sprite; 
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