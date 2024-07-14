import 'package:flappy_bird/game/flappy_bird.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget{
    final FlappyBird __flappyBird;
    static const String id = 'mainMenu';

    const MainMenu({ super.key, required FlappyBird flappyBird }): __flappyBird = flappyBird;

    @override
    Widget build(BuildContext context) {
        __flappyBird.pauseEngine();
        
        return Scaffold(
            body: GestureDetector(
                onTap: () {
                    __flappyBird.overlays.remove('mainMenu');
                    __flappyBird.resumeEngine();
                },
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage( image: AssetImage('assets/images/menu.jpg'), fit: BoxFit.cover,),
                    ),
                    child: Image.asset('assets/images/message.png'),
                ),
            ),
        );
    }
}