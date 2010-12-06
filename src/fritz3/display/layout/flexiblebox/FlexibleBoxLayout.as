package fritz3.display.layout.flexiblebox {
	import flash.display.DisplayObjectContainer;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Direction;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Orientation;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FlexibleBoxLayout implements Layout {
		
		protected var _orient:String = Orientation.HORIZONTAL;
		protected var _direction:String = Direction.NORMAL;
		//protected var _ordinalGroup:Number = 1;
		protected var _align:String = Align.START
		protected var _gap:Number = 0;
		protected var _padding:Number = 0; 
		
		public function FlexibleBoxLayout ( ) {
			
		}
		
		public function rearrange ( container:DisplayObjectContainer, items:Array ):void {
			
		}
		
	}

}