package fritz3.display.graphics {
	import fritz3.base.injection.IInjectable;
	import fritz3.base.parser.IParsable;
	import fritz3.base.transition.ITransitionable;
	import fritz3.display.core.ICyclable;
	import fritz3.display.graphics.IDrawable;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class CSS3Background implements IRectangularBackground, IParsable, IInjectable, ITransitionable, ICyclable {
		
		protected var _drawable:IDrawable;
		
		public function CSS3Background ( ) {
		
		}
		
		public function draw ( displayObject:DisplayObject ):void {
			
		}
		
		public function setProperty ( propertyName:String, value:* ):void {
			
		}
		
		public function parseProperty ( propertyName:String, value:* ):void {
			
		}
		
		public function applyParsedProperties ( ):void {
			
		}
		
		protected function setDrawable ( value:IDrawable ):void {
			if (_drawable) {
				
			}
			
			_drawable = value;
			if (_drawable) {
				
			}
		}
		
		protected function applyWidth ( ):void {
			
		}
		
		protected function applyHeight ( ):void {
			
		}
		
		public function get width ( ):Number { return _width; }
		public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		public function get height ( ):Number { return _height; }
		public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
			}
		}
		
		public function get drawable ( ):IDrawable { return _drawable;
		public function set drawable ( value:IDrawable ):void {
			if (_drawable != value) {
				this.setDrawable(value);
			}
		}
	
	}

}