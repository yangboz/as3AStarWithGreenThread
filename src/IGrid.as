/**
 * Created by yangboz on 11/10/15.
 */
package {
import com.lookbackon.ds.aStar.AStarNode;

public interface IGrid {

    ////////////////////////////////////////
    // public methods
    ////////////////////////////////////////

    /**
     * Returns the node at the given coords.
     * @param x The x coord.
     * @param y The y coord.
     */
    function getNode(x:int, y:int):AStarNode;

    /**
     * Sets the node at the given coords as the end node.
     * @param x The x coord.
     * @param y The y coord.
     */
    function setEndNode(x:int, y:int):void;

    /**
     * Sets the node at the given coords as the start node.
     * @param x The x coord.
     * @param y The y coord.
     */
    function setStartNode(x:int, y:int):void;

    /**
     * Sets the node at the given coords as walkable or not.
     * @param x The x coord.
     * @param y The y coord.
     */
    function setWalkable(x:int, y:int, value:Boolean):void;

    ////////////////////////////////////////
    // getters / setters
    ////////////////////////////////////////

    /**
     * Returns the end node.
     */
    function get endNode():AStarNode;

    /**
     * Returns the number of columns in the grid.
     */
    function get numCols():int;

    /**
     * Returns the number of rows in the grid.
     */
    function get numRows():int;

    /**
     * Returns the start node.
     */
    function get startNode():AStarNode;
}
}
