package
{
	import com.godpaper.as3.utils.LogUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.logging.ILogger;
	
	[SWF(frameRate="60", width="1000", height="1000", backgroundColor="0xffffff")]
	public class Game extends Sprite
	{
		private var _cellSize:int = 10;
		private var _grid:Grid;
		private var _player:Sprite;
		private var _index:int;
		private var _path:Array;
		private var _line:Shape;
		/*Constants*/
		private static const NUM_OF_BLOCK:int = 1000;
		private static const NUM_OF_COLS:int = 100;
		private static const NUM_OF_ROWS:int = 100;
		private static const COLOR_OF_WALKABLE:uint = 0x00FF00;
		private static const COLOR_OF_PLAYER:uint = 0xff0000;
		private static const COLOR_OF_POINT_START:uint = 0xff0000;
		private static const COLOR_OF_POINT_END:uint = 0xff0000;
		private static const COLOR_OF_TRACE_LINE:uint = 0x0000ff;
		//Logger for time calculation
		private static const LOG:ILogger = LogUtil.getLogger(Game);
		//
		public function Game()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			makePlayer();
			makeGrid();
			_line=new Shape();
			addChild(_line);
			stage.addEventListener(MouseEvent.CLICK, onGridClick);
		}
		
		/**
		 * Creates the player sprite. Just a circle here.
		 */
		private function makePlayer():void
		{
			_player = new Sprite();
			_player.graphics.beginFill(COLOR_OF_PLAYER);
			_player.graphics.drawCircle(0, 0, 5);
			_player.graphics.endFill();
			_player.x = Math.random() * 600;
			_player.y = Math.random() * 600;
			addChild(_player);
		}
		
		/**
		 * Creates a grid with a bunch of random unwalkable nodes.
		 */
		private function makeGrid():void
		{
			_grid = new Grid(NUM_OF_COLS, NUM_OF_ROWS);
			for(var i:int = 0; i < NUM_OF_BLOCK; i++)
			{
				_grid.setWalkable(Math.floor(Math.random() * 100),
					Math.floor(Math.random() * 100),
					false);
			}
			drawGrid();
		}
		
		/**
		 * Draws the given grid, coloring each cell according to its state.
		 */
		private function drawGrid():void
		{
			graphics.clear();
			for(var i:int = 0; i < _grid.numCols; i++)
			{
				for(var j:int = 0; j < _grid.numRows; j++)
				{
					var node:Node = _grid.getNode(i, j);
					graphics.lineStyle(0);
					graphics.beginFill(getColor(node));
					graphics.drawRect(i * _cellSize, j * _cellSize, _cellSize, _cellSize);
				}
			}
		}
		
		/**
		 * Determines the color of a given node based on its state.
		 */
		private function getColor(node:Node):uint
		{
			if(!node.walkable) return 0;
			if(node == _grid.startNode) return COLOR_OF_POINT_START;
			if(node == _grid.endNode) return COLOR_OF_POINT_END;
			return COLOR_OF_WALKABLE;
		}
		
		/**
		 * Handles the click event on the GridView. Finds the clicked on cell and toggles its walkable state.
		 */
		private function onGridClick(event:MouseEvent):void
		{
			var xpos:int = Math.floor(mouseX / _cellSize);
			var ypos:int = Math.floor(mouseY / _cellSize);
			//avoid calculation
			if(!_grid.getNode(xpos, ypos).walkable) return;
			//
			_grid.setEndNode(xpos, ypos);
			
			xpos = Math.floor(_player.x / _cellSize);
			ypos = Math.floor(_player.y / _cellSize);
			_grid.setStartNode(xpos, ypos);
			
			drawGrid();
			findPath();
		}
		
		/**
		 * Creates an instance of AStar and uses it to find a path.
		 */
		private function findPath():void
		{
			var astar:AStar = new AStar();
			LOG.info("before astar running");
			var find:Boolean = astar.findPath(_grid);
			LOG.info("after astar running");
			if(find)
			{
				_path = astar.path;
				_index = 0;
				_line.graphics.clear();
				_line.graphics.lineStyle(4,0xFFFFFF,.8);
				_line.graphics.moveTo(_player.x, _player.y);
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/**
		 * Finds the next node on the path and eases to it.
		 */
		private function onEnterFrame(event:Event):void
		{
			var targetX:Number = _path[_index].x * _cellSize + _cellSize / 2;
			var targetY:Number = _path[_index].y * _cellSize + _cellSize / 2;
			var dx:Number = targetX - _player.x;
			var dy:Number = targetY - _player.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			if(dist < 1)
			{
				_index++;
				if(_index >= _path.length)
				{
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			else
			{
				_player.x += dx * .5;
				_player.y += dy * .5;
			}
			_line.graphics.lineStyle(5,COLOR_OF_TRACE_LINE);
			_line.graphics.lineTo(_player.x, _player.y);
		}
	}
}