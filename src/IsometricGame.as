/**
 * Created by yangboz on 11/9/15.
 */
package {
import com.lookbackon.ds.isometric.IsometricHelper;
import com.senocular.utils.KeyObject;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

public class IsometricGame extends Sprite {
    public function IsometricGame() {
        this.createLevel();
        addChild(bg);
        addChild(overlayContainer);
    }

    /**
     * Creates the player sprite. Just a circle here.
     */
    private static const COLOR_OF_PLAYER:uint = 0xff0000;

    private static function makePlayer():DisplayObject {
        var _player:Sprite = new Sprite();
        _player.graphics.beginFill(COLOR_OF_PLAYER);
        _player.graphics.drawCircle(0, 0, 5);
        _player.graphics.endFill();
        _player.x = Math.random() * 600;
        _player.y = Math.random() * 600;
        return _player;
//        addChild(_player);
    }

    private static function makeHeroPointer(color:uint):Sprite {
        var _player:Sprite = new Sprite();
        _player.graphics.beginFill(color);
        _player.graphics.drawCircle(0, 0, 5);
        _player.graphics.endFill();
        _player.x = Math.random() * 600;
        _player.y = Math.random() * 600;
        return _player;
//        addChild(_player);
    }

    private static function makeHero(color:uint):MovieClip {
        var _player:MovieClip = new MovieClip();
        _player.graphics.beginFill(color);
        _player.graphics.drawCircle(0, 0, 5);
        _player.graphics.endFill();
        _player.x = Math.random() * 600;
        _player.y = Math.random() * 600;
        return _player;
//        addChild(_player);
    }

    private static function makeTile(color:uint):MovieClip {
        var _player:MovieClip = new MovieClip();
        _player.graphics.beginFill(color);
        _player.graphics.drawCircle(0, 0, 5);
        _player.graphics.endFill();
        _player.x = Math.random() * 600;
        _player.y = Math.random() * 600;
        return _player;
//        addChild(_player);
    }

    // Uses senocular's KeyObject class
// http://www.senocular.com/flash/actionscript/?file=ActionScript_3.0/com/senocular/utils/KeyObject.as

    var levelData = [[1, 1, 1, 1, 1, 1],
        [1, 0, 0, 2, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1]];

    var tileWidth:uint = 50;
    var borderOffsetY:uint = 70;
    var borderOffsetX:uint = 275;

    var facing:String = "south";
    var currentFacing:String = "south";
//    var hero:MovieClip = new herotile();
    var hero:MovieClip = makeHero(0xff0000);
//    hero.clip.gotoAndStop(facing);
    var heroPointer:Sprite;
    var key:KeyObject = new KeyObject(stage);//Senocular KeyObject Class
    var heroHalfSize:uint = 20;

//the tiles
//    var grassTile:MovieClip = new TileMc();
    var grassTile:MovieClip = makeTile(0x00ff00);
//    grassTile.gotoAndStop(1);
//    var wallTile:MovieClip = new TileMc();
    var wallTile:MovieClip = makeTile(0x333333);
//    wallTile.gotoAndStop(2);

//the canvas
    var bg:Bitmap = new Bitmap(new BitmapData(650, 450));
//    addChild(bg);
    var rect:Rectangle = bg.bitmapData.rect;

//to handle depth
    var overlayContainer:Sprite = new Sprite();
//    addChild(overlayContainer);

//to handle direction movement
    var dX:Number = 0;
    var dY:Number = 0;
    var idle:Boolean = true;
    var speed:uint = 5;
    var heroCartPos:Point = new Point();
    var heroTile:Point = new Point();

//add items to start level, add game loop
    function createLevel() {
        var tileType:uint;
        for (var i:uint = 0; i < levelData.length; i++) {
            for (var j:uint = 0; j < levelData[0].length; j++) {
                tileType = levelData[i][j];
                placeTile(tileType, i, j);
                if (tileType == 2) {
                    levelData[i][j] = 0;
                }
            }
        }
        overlayContainer.addChild(heroPointer);
        overlayContainer.alpha = 0.5;
        overlayContainer.scaleX = overlayContainer.scaleY = 0.5;
        overlayContainer.y = 290;
        overlayContainer.x = 10;
        depthSort();
        addEventListener(Event.ENTER_FRAME, loop);
    }

//place the tile based on coordinates
    function placeTile(id:uint, i:uint, j:uint) {
        var pos:Point = new Point();
        if (id == 2) {

            id = 0;
            pos.x = j * tileWidth;
            pos.y = i * tileWidth;
            pos = IsometricHelper.twoDToIso(pos);
            hero.x = borderOffsetX + pos.x;
            hero.y = borderOffsetY + pos.y;
            //overlayContainer.addChild(hero);
            heroCartPos.x = j * tileWidth;
            heroCartPos.y = i * tileWidth;
            heroTile.x = j;
            heroTile.y = i;
//            heroPointer = new herodot();
            heroPointer = makeHeroPointer(0xffffff);
            heroPointer.x = heroCartPos.x;
            heroPointer.y = heroCartPos.y;

        }
//        var tile:MovieClip = new cartTile();
        var tile:MovieClip = makeTile(0x0000ff);
        tile.gotoAndStop(id + 1);
        tile.x = j * tileWidth;
        tile.y = i * tileWidth;
        overlayContainer.addChild(tile);
    }

//the game loop
    function loop(e:Event) {
        if (key.isDown(Keyboard.UP)) {
            dY = -1;
        }
        else if (key.isDown(Keyboard.DOWN)) {
            dY = 1;
        }
        else {
            dY = 0;
        }
        if (key.isDown(Keyboard.RIGHT)) {
            dX = 1;
            if (dY == 0) {
                facing = "east";
            }
            else if (dY == 1) {
                facing = "southeast";
                dX = dY = 0.5;
            }
            else {
                facing = "northeast";
                dX = 0.5;
                dY = -0.5;
            }
        }
        else if (key.isDown(Keyboard.LEFT)) {
            dX = -1;
            if (dY == 0) {
                facing = "west";
            }
            else if (dY == 1) {
                facing = "southwest";
                dY = 0.5;
                dX = -0.5;
            }
            else {
                facing = "northwest";
                dX = dY = -0.5;
            }
        }
        else {
            dX = 0;
            if (dY == 0) {
                //facing="west";
            }
            else if (dY == 1) {
                facing = "south";
            }
            else {
                facing = "north";
            }
        }
        if (dY == 0 && dX == 0) {
//            hero.clip.gotoAndStop(facing);
            idle = true;
        }
        else if (idle || currentFacing != facing) {
            idle = false;
            currentFacing = facing;
//            hero.clip.gotoAndPlay(facing);
        }
        if (!idle && isWalkable()) {
            heroCartPos.x += speed * dX;
            heroCartPos.y += speed * dY;
            heroPointer.x = heroCartPos.x;
            heroPointer.y = heroCartPos.y;

            var newPos:Point = IsometricHelper.twoDToIso(heroCartPos);
            //collision check
            hero.x = borderOffsetX + newPos.x;
            hero.y = borderOffsetY + newPos.y;
            heroTile = IsometricHelper.getTileCoordinates(heroCartPos, tileWidth);
            depthSort();
            //trace(heroTile);
        }
//        tileTxt.text = "Hero is on x: " + heroTile.x + " & y: " + heroTile.y;
        trace("Hero is on x: " + heroTile.x + " & y: " + heroTile.y);
    }

//check for collision tile
    function isWalkable():Boolean {
        var able:Boolean = true;
        var newPos:Point = new Point();
        newPos.x = heroCartPos.x + (speed * dX);
        newPos.y = heroCartPos.y + (speed * dY);
        switch (facing) {
            case "north":
                newPos.y -= heroHalfSize;
                break;
            case "south":
                newPos.y += heroHalfSize;
                break;
            case "east":
                newPos.x += heroHalfSize;
                break;
            case "west":
                newPos.x -= heroHalfSize;
                break;
            case "northeast":
                newPos.y -= heroHalfSize;
                newPos.x += heroHalfSize;
                break;
            case "southeast":
                newPos.y += heroHalfSize;
                newPos.x += heroHalfSize;
                break;
            case "northwest":
                newPos.y -= heroHalfSize;
                newPos.x -= heroHalfSize;
                break;
            case "southwest":
                newPos.y += heroHalfSize;
                newPos.x -= heroHalfSize;
                break;
        }
        newPos = IsometricHelper.getTileCoordinates(newPos, tileWidth);
        if (levelData[newPos.y][newPos.x] == 1) {
            able = false;
        } else {
            //trace("new",newPos);
        }
        return able;
    }

//sort depth & draw to canvas
    function depthSort() {
        bg.bitmapData.lock();
        bg.bitmapData.fillRect(rect, 0xffffff);
        var tileType:uint;
        var mat:Matrix = new Matrix();
        var pos:Point = new Point();
        for (var i:uint = 0; i < levelData.length; i++) {
            for (var j:uint = 0; j < levelData[0].length; j++) {
                tileType = levelData[i][j];
                //placeTile(tileType,i,j);

                pos.x = j * tileWidth;
                pos.y = i * tileWidth;
                pos = IsometricHelper.twoDToIso(pos);
                mat.tx = borderOffsetX + pos.x;
                mat.ty = borderOffsetY + pos.y;
                if (tileType == 0) {
                    bg.bitmapData.draw(grassTile, mat);
                } else {
                    bg.bitmapData.draw(wallTile, mat);
                }
                if (heroTile.x == j && heroTile.y == i) {
                    mat.tx = hero.x;
                    mat.ty = hero.y;
                    bg.bitmapData.draw(hero, mat);
                }

            }
        }
        bg.bitmapData.unlock();
//add character rectangle
    }

}
}
