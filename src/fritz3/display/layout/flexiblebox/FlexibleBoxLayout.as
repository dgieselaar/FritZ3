package fritz3.display.layout.flexiblebox {
	import flash.display.DisplayObjectContainer;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Direction;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Orientation;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FlexibleBoxLayout implements RectangularLayout {
		
		protected var _rearrangable:Rearrangable;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _orient:String = Orientation.HORIZONTAL;
		protected var _direction:String = Direction.NORMAL;
		//protected var _ordinalGroup:Number = 1;
		protected var _align:String = Align.START
		protected var _gap:Number = 0;
		protected var _padding:Number = 0; 
		
		public function FlexibleBoxLayout ( ) {
			
		}
		
		protected function invalidate ( ):void {
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		protected function setRearrangable ( rearrangable:Rearrangable ):void {
			_rearrangable = rearrange;
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		public function rearrange ( container:DisplayObjectContainer, items:Array ):void {
			
		}
		
		public function get rearrangable ( ):Rearrangable { return _rearrangable; }
		public function set rearrangable ( value:Rearrangable ):void {
			if (_rearrangable != value) {
				this.setRearrangable(value);
			}
		}
		
		public function get width ( ):Number { return _width; }
		public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.invalidate();
			}
		}
		
		public function get height ( ):Number { return _height; }
		public function set height ( value:Number):void {
			if (_height != value) {
				_height = value;
				this.invalidate();
			}
		}
		
		public function get orient ( ):String { return _orient; }
		public function set orient ( value:String ):void {
			if (_orient) {
				_orient = value;
				this.invalidate();
			}
		}
		
		public function get direction ( ):String { return _direction; }
		public function set direction ( value:String ):void {
			if (_direction != value) {
				_direction = value;
				this.invalidate();
			}
		}
		
		public function get align ( ):String { return _align; }
		public function set align ( value:String ):void {
			if (_align != value) {
				_align = value;
				this.invalidate();
			}
		}
		
		public function get gap ( ):Number { return _gap; }
		public function set gap ( value:Number ):void {
			if (_gap != value) {
				_gap = value;
				this.invalidate();
			}
		}
		
		public function get padding ( ):Number { return _padding; }
		public function set padding ( value:Number ):void {
			if (_padding != value) {
				_padding = value;
				this.invalidate();
			}
		}
		
	}

}