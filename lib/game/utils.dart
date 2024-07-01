import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'dart:math';

import 'package:flame/image_composition.dart';

class Utils{
    static final gameSpeed = Vector2(180, 280);
    static double groundHeight = 60.0;
    static const gravity = -100.0;
    static const pipeInterval = 1.5;
    static num degToRad(num deg)=> deg * (pi / 180.0);
}

class AssetsLoader{
    Map<String, Image> __imageAssets;

    AssetsLoader._(): __imageAssets = {};

    static final AssetsLoader _instance = AssetsLoader._();

    factory AssetsLoader(){
        return _instance;
    }

    Future<Image> loadImage(String fileName) async{
        if(__imageAssets.containsKey(fileName)){
            return __imageAssets[fileName]!;
        }

        Image image = await Flame.images.load(fileName);
        __imageAssets.addAll({ fileName: image });

        return image;
    }

    Future<void> loadAll() async{
        try{
            // load background assets
            await loadImage("Sky.png");
            await loadImage("Clouds.png");
            await loadImage("Buildings.png");
            await loadImage("Trees.png");  

            //load bird assets
            await loadImage("yellowbird-upflap.png");
            await loadImage("yellowbird-midflap.png");
            await loadImage("yellowbird-downflap.png");

            //load pipe assets
            await loadImage("pipe-green.png");
            await loadImage("pipe-green-rotated.png");
        }catch(ex){
            return Future.error(ex);
        }
    }
}