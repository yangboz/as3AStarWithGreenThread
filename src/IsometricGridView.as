/**
 * Created by yangboz on 11/9/15.
 */
package {
import com.lookbackon.ds.aStar.AStarNode;

/**
 * Serves as a visual representation of a grid of nodes used in a isometric path-finding solution.
 */
public class IsometricGridView extends GridView {

    public function IsometricGridView(grid:Grid) {
        super(grid);
    }

    /**
     * Draws the given grid, coloring each cell according to its state.
     */
    override public function drawGrid():void {
        graphics.clear();
        for (var i:int = 0; i < _grid.numCols; i++) {
            for (var j:int = 0; j < _grid.numRows; j++) {
                var node:AStarNode = _grid.getNode(i, j);
                graphics.lineStyle(0);
                graphics.beginFill(getColor(node));
                graphics.drawRect(i * _cellSize, j * _cellSize, _cellSize, _cellSize);
            }
        }
    }
}
}
