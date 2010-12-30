package fritz3.display.text.layout {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextLayout implements RectangularLayout {
		
		protected var _parameters:Object;
		protected var _rearrangable:Rearrangable;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _autoWidth:Boolean;
		protected var _autoHeight:Boolean;
		
		protected var _padding:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingRight:Number = 0;
		
		protected var _horizontalAlign:String = Align.LEFT;
		protected var _verticalAlign:String = Align.TOP;
		
		public function TextLayout ( parameters:Object = null ) {
			_parameters = parameters;
			for (var id:String in parameters) {
				this[id] = parameters[id];
			}
		}
		
		protected function setRearrangable ( value:Rearrangable ):void {
			_rearrangable = value;
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		protected function invalidate ( ):void {
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		public function rearrange ( container:DisplayObjectContainer, items:Array ):void {
			var textField:DisplayObject = items[0];
			var x:Number = _paddingLeft, y:Number = _paddingTop;
			if (!_autoWidth) {
				var childWidth:Number = textField.width;
				var availableWidth:Number = _width - _paddingLeft - _paddingBottom;
				switch(_horizontalAlign) {
					default:
					case Align.LEFT:
					x = _paddingLeft;
					break;
					
					case Align.CENTER:
					x = _paddingLeft + availableWidth / 2 - childWidth / 2;
					break;
					
					case Align.RIGHT:
					x = _paddingLeft + availableWidth - childWidth;
					break;
				}
			}
			
			if (!_autoHeight) {
				var childHeight:Number = textField.height;
				var availableHeight:Number = _height - _paddingTop - _paddingBottom;
				switch(_verticalAlign) {
					default:
					case Align.TOP:
					y = _paddingTop;
					break;
					
					case Align.CENTER:
					y = _paddingTop + availableHeight / 2 - childHeight / 2;
					break;
					
					case Align.BOTTOM:
					y = _paddingTop + availableHeight - childHeight;
					break;
				}
			}
			textField.x = x, textField.y = y;
		}
		
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
		public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
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
		
		public function get paddingTop ( ):Number { return _paddingTop; }
		public function set paddingTop ( value:Number ):void {
			if (_paddingTop != value) {
				_paddingTop = value;
				this.invalidate()
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
		
		public function get horizontalAlign ( ):String { return _horizontalAlign; }
		public function set horizontalAlign ( value:String ):void {
			if (_horizontalAlign != value) {
				_horizontalAlign = value;
				this.invalidate();
			}
		}
		
		public function get verticalAlign ( ):String { return _verticalAlign; }
		public function set verticalAlign ( value:String ):void {
			if (_verticalAlign != value) {
				_verticalAlign = value;
				this.invalidate();
			}
		}
		
		public function get autoWidth ( ):Boolean { return _autoWidth; }
		public function set autoWidth ( value:Boolean ):void {
			if (_autoWidth != value) {
				_autoWidth = value;
				this.invalidate();
			}
		}
		
		public function get autoHeight ( ):Boolean { return _autoHeight; }
		public function set autoHeight ( value:Boolean ):void {
			if (_autoHeight != value) {
				_autoHeight = value;
				this.invalidate();
			}
		}
		
	}

}