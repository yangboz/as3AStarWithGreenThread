/**
 * Created by yangboz on 11/10/15.
 */
package {
import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IsoView;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

import com.gskinner.motion.GTween;

import eDpLib.events.ProxyEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class IsometricExamples extends Sprite {

    private var box:IIsoDisplayObject;
    private var scene:IsoScene;

    public function IsometricExamples() {
        //4
//        var box:IsoBox = new IsoBox();
//        box.styleType = RenderStyleType.SHADED;
////        box.faceColors = [0xff0000, 0x00ff00, 0x0000ff, 0xff0000, 0x00ff00, 0x0000ff]
////        box.faceAlphas = [.5, .5, .5, .5, .5, .5];
//        box.fills = [
//            new SolidColorFill(0xff0000, .5),
//            new SolidColorFill(0x00ff00, .5),
//            new SolidColorFill(0x0000ff, .5),
//            new SolidColorFill(0xff0000, .5),
//            new SolidColorFill(0x00ff00, .5),
//            new SolidColorFill(0x0000ff, .5)
//        ];
//        box.setSize(25, 30, 40);
//        box.moveTo(200, 0, 0);
//
//        var scene:IsoScene = new IsoScene();
//        scene.hostContainer = this;
//        scene.addChild(box);
//        scene.render();

        //5
//        var box:IsoBox = new IsoBox();
//        box.moveTo(15, 15, 0);
//
//        var grid:IsoGrid = new IsoGrid();
//
//        var scene:IsoScene = new IsoScene();
//        scene.addChild(box);
//        scene.addChild(grid);
//        scene.render();
//
//        var view:IsoView = new IsoView();
//        view.setSize(150, 100);
//        view.addScene(scene);
//
//        addChild(view);
        //6
//        var scene:IsoScene = new IsoScene();
//        scene.hostContainer = this;
//
//        var g:IsoGrid = new IsoGrid();
//        g.showOrigin = false;
//        scene.addChild(g);
//
//        var box:IsoBox = new IsoBox();
//        box.setSize(25, 25, 25);
//        box.moveBy(20, 20, 15); //feature request added
//        scene.addChild(box);
//
//        var factory:ClassFactory = new ClassFactory(DefaultShadowRenderer);
//        factory.properties = {shadowColor: 0x000000, shadowAlpha: 0.15, drawAll: false};
//        scene.styleRenderers = [factory];
//
//        scene.render();
//
//        var view:IsoView = new IsoView();
//        view.y = 50;
//        view.setSize(150, 100);
//        view.addScene(scene); //look in the future to be able to add more scenes
////        view.scene = scene; //look in the future to be able to add more scenes
//
//        addChild(view);
        //7
        scene = new IsoScene();

        var g:IsoGrid = new IsoGrid();
        g.showOrigin = false;
        g.addEventListener(MouseEvent.CLICK, grid_mouseHandler);
        scene.addChild(g);

        box = new IsoBox();
        box.setSize(25, 25, 25);
        scene.addChild(box);

        var view:IsoView = new IsoView();
        view.clipContent = false;
        view.y = 50;
        view.setSize(150, 100);
        view.addScene(scene); //look in the future to be able to add more scenes
//        view.scene = scene; //look in the future to be able to add more scenes
        addChild(view);

        scene.render();
    }

    private var gt:GTween;

    private function grid_mouseHandler(evt:ProxyEvent):void {
        var mEvt:MouseEvent = MouseEvent(evt.targetEvent);
        var pt:Pt = new Pt(mEvt.localX, mEvt.localY);
        IsoMath.screenToIso(pt);

        if (gt)
            gt.end();

        else {
            gt = new GTween();
            gt.addEventListener(Event.COMPLETE, gt_completeHandler);
        }

        gt.target = box;
        gt.duration = 0.5;
        gt.setValues({x: pt.x, y: pt.y});
        gt.autoPlay = true;

        if (!hasEventListener(Event.ENTER_FRAME))
            this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function gt_completeHandler(evt:Event):void {
        this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function enterFrameHandler(evt:Event):void {
        scene.render();
    }
}
}
