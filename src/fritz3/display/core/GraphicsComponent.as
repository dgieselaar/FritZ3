package fritz3.display.core {
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.RectangularBackground;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GraphicsComponent extends PositionableDisplayComponent implements Drawable {
		
		protected var _background:Background;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function GraphicsComponent ( properties:Object = null ) {
			super(properties);
		}
		
		override protected function initializeDependencies():void {
			super.initializeDependencies();
			this.initializeBackground();
		}
		
		override protected function setInvalidationMethodOrder():void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.draw, this.dispatchDisplayInvalidation);
		}
		
		protected function draw ( ):void {
			_background.draw(this);
		}
		
		protected function initializeBackground ( ):void {
			this.background = new BoxBackground();
		}
		
		protected function applyWidth ( ):void {
			this.invalidateDisplay();
			if (_background is RectangularBackground) {
				RectangularBackground(_background).width = _width;
			}
		}
		
		protected function applyHeight ( ):void {
			this.invalidateDisplay();
			if (_background is RectangularBackground) {
				RectangularBackground(_background).height = _height;
			}
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
		
		public function invalidateGraphics ( ):void {
			_invalidationHelper.invalidateMethod(this.draw);
		}
		
		public function get background ( ):Background { return _background; }
		public function set background ( value:Background ):void {
			if (_background != value) {
				this.setBackground(value);
			}
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
		
	}

}