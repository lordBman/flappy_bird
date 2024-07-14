import 'package:flame/components.dart';
import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flappy_bird/game/objects/bird.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget{
    final FlappyBird __flappyBird;
    
    const GameOver({ super.key, required FlappyBird flappyBird}) : __flappyBird = flappyBird;

    void onRestart() {
        __flappyBird.reset();
        __flappyBird.overlays.remove('gameOver');
    }

    @override
    Widget build(BuildContext context) {
        Bird bird = __flappyBird.findByKey(ComponentKey.named("bird"))!;
        return Material( color: Colors.black38,
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min,children: [
                    Text('Score: ${bird.score}', style: const TextStyle( fontSize: 60, color: Colors.white, fontFamily: 'Game',),),
                    const SizedBox(height: 20),
                    Image.asset('assets/images/gameover.png'),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: onRestart,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Restart', style: TextStyle(fontSize: 20)),
                    ),
                ]),
            ),
        );
    }
}