package fritz3.display.layout.flexiblebox {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Direction;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Orientation;
	import fritz3.display.layout.Positionable;
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
		protected var _align:String = Align.START
		protected var _gap:Number = 0;
		protected var _pack:String = Align.START;
		
		protected var _padding:Number = 0; 
		protected var _paddingTop:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingRight:Number = 0;
		
		protected var _lines:String = BoxLines.MULTIPLE;
		
		public function FlexibleBoxLayout ( ) {
			
		}
		
		protected function invalidate ( ):void {
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		protected function setRearrangable ( rearrangable:Rearrangable ):void {
			_rearrangable = rearrangable;
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		public function rearrange ( container:DisplayObjectContainer, items:Array ):void {
			var displayItems:Array = [];
			for (var i:int, l:int = items.length; i < l; ++i) {
				if (items[i] is DisplayObject) {
					displayItems[displayItems.length] = items[i];
				}
			}
			
			if (_orient == Orientation.VERTICAL) {
				this.layoutVertically(container, displayItems);
			} else {
				this.layoutHorizontally(container, displayItems);
			}
		}
		
		protected function layoutHorizontally ( container:DisplayObjectContainer, items:Array ):void {
			var positionable:Positionable, child:DisplayObject;
			
			for (var i:int, l:int = items.length; i < l; ++i) {
				child = items[i] as DisplayObject;
				if (child) {
					
				}
			}
		}
		
		protected function layoutVertically ( container:DisplayObjectContainer, items:Array ):void {
			
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
		
		public function get pack ( ):String { return _pack; }
		public function set pack ( value:String ):void {
			if(_pack != value) {
				_pack = value;
				this.invalidate();
			}
		}
		
		public function get padding ( ):Number { return _padding; }
		public function set padding ( value:Number ):void {
			if (_padding != value) {
				_padding = _paddingTop = _paddingLeft = _paddingBottom = _paddingRight = value;
				this.invalidate();
			}
		}
		
		public function get paddingTop ( ):Number { return _paddingTop; }
		public function set paddingTop ( value:Number ):void {
			if (_paddingTop != value) {
				_paddingTop = value;
				this.invalidate();
			}
		}
		
		public function get paddingLeft ( ):Number { return _paddingLeft; }
		public function set paddingLeft ( value:Number ):void {
			if (_paddingLeft != value) {
				_paddingLeft = value;
				this.invalidate();
			}
		}
		
		public function get paddingBottom ( ):Number { return _paddingBottom; }
		public function set paddingBottom ( value:Number ):void {
			if (_paddingBottom != value) {
				_paddingBottom = value;
				this.invalidate();
			}
		}
		
		public function get paddingRight ( ):Number { return _paddingRight; }
		public function set paddingRight ( value:Number ):void {
			if (_paddingRight != value) {
				_paddingRight = value;
				this.invalidate();
			}
		}
		
	}

}