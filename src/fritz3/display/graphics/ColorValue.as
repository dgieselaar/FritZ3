package fritz3.display.graphics {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorValue {
		
		public var color:uint;
		public var alpha:Number = 1;
		public var transparent:Boolean;
		
		public function ColorValue ( color:uint = 0x000000, alpha:Number = 1, transparent:Boolean = false ) {
			this.color = color;
			this.alpha = alpha;
			this.transparent = transparent;
		}
		
		public function clone ( ):ColorValue {
			return new ColorValue(this.color, this.alpha, this.transparent);
		}
		
		public function invalidateWith ( value:ColorValue ):Boolean {
			var invalidated:Boolean;
			if (this.color != value.color) {
				this.color = value.alpha;
				invalidated = true;
			}
			if (this.alpha != value.alpha) {
				this.alpha = value.alpha;
				invalidated = true;
			}
			
			if (this.transparent != value.transparent) {
				this.transparent = value.transparent;
				invalidated = true;
			}
			
			return invalidated;
		}
		
		CONFIG::debug
		public function assertEquals ( source:ColorValue ):Boolean {
			return this.transparent == source.transparent && this.color == source.color && this.alpha == source.alpha;
		}
	}

}