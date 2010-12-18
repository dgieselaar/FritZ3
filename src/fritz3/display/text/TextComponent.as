package fritz3.display.text {
	import flash.text.TextField;
	import fritz3.display.core.PositionableDisplayComponent;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.RectangularBackground;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextComponent extends PositionableDisplayComponent implements Drawable {
		
		protected var _background:Background;
		protected var _textField:TextField;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _dispatchedWidth:Number = 0;
		protected var _dispatchedHeight:Number = 0;
		
		protected var _padding:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingRight:Number = 0;
		
		protected var _css:String;
		
		public function TextComponent ( parameters:Object = null ) {
			super(parameters);
		}
		
		override protected function initializeDependencies ( ):void {
			super.initializeDependencies();
			this.initializeBackground();
			this.initializeTextField();
		}
		
		protected function initializeBackground ( ):void {
			this.background = new BoxBackground();
		}
		
		protected function initializeTextField ( ):void {
			this.textField = new TextField();
		}
		
		override protected function setInvalidationMethodOrder():void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.draw, this.dispatchDisplayInvalidation);
		}
		
		protected function setBackground ( background:Background ):void {
			if (_background) {
				_background.drawable = null;
			}
			
			this.graphics.clear();
			
			_background = background;
			if (_background) {
				_background.drawable = this;
				if (_background is RectangularBackground) {
					RectangularBackground(_background).width = _width;
					RectangularBackground(_background).height = _height;
				}
			}
		}
		
		protected function setTextField ( textField:TextField ):void {
			if (_textField) {
				this.removeChild(_textField);
			}
			_textField = textField;
			if (_textField) {
				this.addChild(_textField);
			}
		}
		
		protected function applyWidth ( ):void {
			if (_width != _dispatchedWidth) {
				this.invalidateDisplay();
			}
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).width = _width;
			}
		}
		
		protected function applyHeight ( ):void {
			if (_height != _dispatchedHeight) {
				this.invalidateDisplay();
			}
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).height = _height;
			}
		}
		
		protected function determineStyleType ( ):void {
			
		}
		
		protected function draw ( ):void {
			_background.draw(this);
		}
		
		override protected function dispatchDisplayInvalidation ( ):void {
			super.dispatchDisplayInvalidation();
			_dispatchedWidth = _width, _dispatchedHeight = _height;
		}
		
		public function invalidateGraphics ( ):void {
			_invalidationHelper.invalidateMethod(this.draw);
		}
		
		override public function get width ( ):Number { return _width; }
		override public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		override public function get height ( ):Number { return _height; }
		override public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
			}
		}
		
		public function get textField ( ):TextField { return _textField; }
		public function set textField ( value:TextField ):void {
			if (_textField != value) {
				this.setTextField(value);
			}
		}
	}

}