/**
 * Created by yangboz on 11/9/15.
 */
package com.lookbackon.ds.aStar.isometric {
import flash.geom.Point;

public class IsometricHelper {

    /**
     * convert an isometric point to 2D
     * */
    public static function isoTo2D(pt:Point):Point {
        //gx=(2*isoy+isox)/2;
        //gy=(2*isoy-isox)/2
        var tempPt:Point = new Point(0, 0);
        tempPt.x = (2 * pt.y + pt.x) / 2;
        tempPt.y = (2 * pt.y - pt.x) / 2;
        return (tempPt);
    }

    /**
     * convert a 2d point to isometric
     * */
    public static function twoDToIso(pt:Point):Point {
        //gx=(isox-isoxy;
        //gy=(isoy+isox)/2
        var tempPt:Point = new Point(0, 0);
        tempPt.x = pt.x - pt.y;
        tempPt.y = (pt.x + pt.y) / 2;
        return (tempPt);
    }

    /**
     * convert a 2d point to specific tile row/column
     * */
    public static function getTileCoordinates(pt:Point, tileHeight:Number):Point {
        var tempPt:Point = new Point(0, 0);
        tempPt.x = Math.floor(pt.x / tileHeight);
        tempPt.y = Math.floor(pt.y / tileHeight);

        return (tempPt);
    }

    /**
     * convert specific tile row/column to 2d point
     * */
    public static function get2dFromTileCoordinates(pt:Point, tileHeight:Number):Point {
        var tempPt:Point = new Point(0, 0);
        tempPt.x = pt.x * tileHeight;
        tempPt.y = pt.y * tileHeight;

        return (tempPt);
    }

}
}
