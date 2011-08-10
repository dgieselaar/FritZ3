package fritz3.display.graphics.parser.border {
	import fritz3.display.core.DisplayValue;
	import fritz3.display.graphics.BorderRadiusValue;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusData {
		
		public var topLeft:BorderRadiusValue;
		public var topRight:BorderRadiusValue;
		public var bottomRight:BorderRadiusValue;
		public var bottomLeft:BorderRadiusValue;
		
		public function BorderRadiusData ( topLeft:BorderRadiusValue = null, topRight:BorderRadiusValue = null, bottomRight:BorderRadiusValue = null, bottomLeft:BorderRadiusValue = null ) {
			this.topLeft = topLeft || new BorderRadiusValue();
			this.topRight = topRight || new BorderRadiusValue();
			this.bottomRight = bottomRight || new BorderRadiusValue();
			this.bottomLeft = bottomLeft || new BorderRadiusValue();
		}
		
		CONFIG::debug
		public function assertEquals ( source:BorderRadiusData ):Boolean {
			return this.topLeft.assertEquals(source.topLeft) && this.topRight.assertEquals(source.topRight) && this.bottomRight.assertEquals(source.bottomRight) && this.bottomLeft.assertEquals(source.bottomLeft);
		}
		
		CONFIG::debug
		public function toString ( ):String {
		return "BorderRadiusData: { TL: " + this.topLeft + ", TR: " + this.topRight + ", BR: " + this.bottomRight + ", BL: " + this.bottomLeft + " }";
		}
		
	}

}