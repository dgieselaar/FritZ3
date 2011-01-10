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
		
		public function GraphicsComponent ( properties:Object = null ) {
			super(properties);
		}
		
		override protected function initializeDependencies():void {
			super.initializeDependencies();
			this.initializeBackground();
		}
		
		override protected function setCyclePhase ( cyclePhase:String ):void {
			super.setCyclePhase(cyclePhase);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cyclePhase = cyclePhase;
			}
		}
		
		override protected function setCycle ( cycle:int ):void {
			super.setCycle(cycle);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cycle = cycle;
			}
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
		
		override protected function applyWidth ( ):void {
			if (_background is RectangularBackground) {
				RectangularBackground(_background).width = _width;
			}
		}
		
		override protected function applyHeight ( ):void {
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
				if (_background is Cyclable) {
					Cyclable(_background).cyclePhase = _cyclePhase;
					Cyclable(_background).cycle = _cycle;
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
		
	}

}