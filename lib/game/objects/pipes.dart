import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/objects/bird.dart';
import 'package:flappy_bird/game/utils.dart';

enum PipePosition{ top, bottom }

class PipeBody extends SpriteGroupComponent<PipePosition>{
    double bodyHeight, bodyWidth, yPosition;
    PipePosition pipePosition;
    Image pipeImage;

    PipeBody({required this.pipeImage, required this.pipePosition, required this.bodyHeight, required this.bodyWidth, required this.yPosition });
    
    @override
    FutureOr<void> onLoad() async{
        super.onLoad();
        sprites = {
            PipePosition.bottom: await __initBottom(),
            PipePosition.top: await __initTop()
        };
        height = bodyHeight;
        width = bodyWidth;
        position.y = yPosition;
        current = pipePosition;
    }

    Future<Sprite> __initBottom() async{
        return Sprite(pipeImage, srcPosition: Vector2(0, pipeImage.height / 2), srcSize: Vector2(pipeImage.width.toDouble(), pipeImage.height/2));
    }

    Future<Sprite> __initTop() async{
        return Sprite(pipeImage, srcPosition: Vector2(0, 0), srcSize: Vector2(pipeImage.width.toDouble(), pipeImage.height/2));
    }
}

class BottomPipe extends SpriteComponent with HasGameRef<FlappyBird>{
    double pipeHeight;
    Image pipeImage;
    
    BottomPipe({ required this.pipeImage, required this.pipeHeight });

    @override
  FutureOr<void> onLoad() {
      sprite = Sprite(pipeImage);
      position.y = game.size.y - pipeHeight - Utils.groundHeight;

      if(pipeHeight > pipeImage.height){
          double bodyHeight = pipeHeight - pipeImage.height;
          double bodyYPosition = pipeImage.height.toDouble();

          add(PipeBody(pipeImage: pipeImage, pipePosition: PipePosition.bottom, bodyWidth: pipeImage.width.toDouble(), bodyHeight: bodyHeight, yPosition: bodyYPosition));
      }

      add(RectangleHitbox());
  }
}

class TopPipe extends SpriteComponent with HasGameRef<FlappyBird>{
    double pipeHeight;
    Image pipeImage;
    
    TopPipe({ required this.pipeImage, required this.pipeHeight });

    @override
    FutureOr<void> onLoad() {
        sprite = Sprite(pipeImage);

        position.y = pipeHeight - pipeImage.height;

        if(pipeHeight > pipeImage.height){
            double bodyHeight = pipeHeight - pipeImage.height;
            double bodyYPosition = -bodyHeight;

            add(PipeBody(pipeImage: pipeImage, pipePosition: PipePosition.top, bodyWidth: pipeImage.width.toDouble(), bodyHeight: bodyHeight, yPosition: bodyYPosition));
        }

        add(RectangleHitbox());
    }
}

class Pipes extends PositionComponent with HasGameRef<FlappyBird> {
    final _random = Random();
    final Image pipeImage, pipeImageRotated;
    bool __running = true;
    bool get isRunning => __running;

    Pipes({ required this.pipeImage, required this.pipeImageRotated });
    
    @override
    Future<void> onLoad() async {
        position.x = game.size.x;

        final heightMinusGround = gameRef.size.y - Utils.groundHeight;
        final spacing = _random.nextInt(100) + 120;
        final centerY = 160 + _random.nextInt(350).toDouble();
        
        addAll([
            TopPipe(pipeImage: pipeImageRotated, pipeHeight: centerY - spacing / 2),
            BottomPipe(pipeImage: pipeImage, pipeHeight: heightMinusGround - (centerY + spacing / 2)),
        ]);
    }
    
    void updateScore() {
        game.findByKey<Bird>(ComponentKey.named('bird'))?.score += 1;
        FlameAudio.play("point.ogg");
    }

    void stop() => __running = false;
    void resume() => __running = true; 

    @override
    void update(double dt) {
        super.update(dt);
        if(__running){
            position.x -= Utils.gameSpeed.x * dt;
        }

        if (position.x < - pipeImage.width) {
            removeFromParent();
            updateScore();
        }
    }
}

class PipesLayer extends Component{
    late SpawnComponent __spawnComponent;
    late Image __pipeImage, __pipeImageRotated;

    PipesLayer(): super(key: ComponentKey.named("pipes-layer"));

    @override
    FutureOr<void> onLoad() async {
        __pipeImage = await AssetsLoader().loadImage("pipe-green.png");
        __pipeImageRotated = await AssetsLoader().loadImage("pipe-green-rotated.png");

        __spawnComponent = SpawnComponent(
            factory: (i) => Pipes(pipeImage: __pipeImage, pipeImageRotated: __pipeImageRotated),
            selfPositioning: true, period: Utils.pipeInterval,);

        add(__spawnComponent);
    }

    void pause(){
        for (var component in children) {
            if(component is Pipes){
                component.stop();
            }
        }
        __spawnComponent.timer.stop();
    }

    void reset(){
        for (var component in children) {
            if(component is Pipes){
                component.removeFromParent();
            }
        }
        __spawnComponent.timer.start();
    }
}