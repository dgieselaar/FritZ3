package fritz3.display.graphics {
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Border {
		
		public var borderSize:Number;
		public var borderPosition:String;
		public var borderAlpha:Number;
		public var borderColor:Object;
		public var borderGradient:GraphicsGradientData;
		public var borderLineStyle:Array;
		
		public function Border ( ) {
			
		}
		
		public function clone ( ):Border {
			var border:Border = new Border();
			border.borderSize = this.borderSize;
			border.borderPosition = this.borderPosition;
			border.borderAlpha = this.borderAlpha;
			border.borderColor = this.borderColor;
			if (this.borderGradient) {
				border.borderGradient = this.borderGradient.clone();
			}
			border.borderLineStyle = this.borderLineStyle;
			return border;
		}
		
		public function isEqualTo ( border:Border ):Boolean {
			if (border == this) {
				return true;
			}
			
			return !this.borderGradient
			&& border.borderSize == this.borderSize 
			&& border.borderPosition == this.borderPosition
			&& border.borderAlpha == this.borderAlpha
			&& border.borderColor == this.borderColor
			&& border.borderLineStyle == this.borderLineStyle;
		}
		
	}

}