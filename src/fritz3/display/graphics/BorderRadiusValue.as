package fritz3.display.graphics {
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusValue {
		
		public var horizontalRadius:DisplayValue;
		public var verticalRadius:DisplayValue;
		
		public function BorderRadiusValue ( horizontalRadius:DisplayValue = null, verticalRadius:DisplayValue = null ) {
			this.horizontalRadius = horizontalRadius || new DisplayValue(0);
			this.verticalRadius = verticalRadius || new DisplayValue(0);
		}
		
		final public function reset ( ):void {
			this.horizontalRadius.setAll(0, DisplayValueType.PIXEL);
			this.verticalRadius.setAll(0, DisplayValueType.PIXEL);
		}
		
		final public function invalidateWith ( source:BorderRadiusValue ):Boolean {
			var isInvalidated:Boolean = false;
			if (this.horizontalRadius.invalidateWith(source.horizontalRadius)) {
				isInvalidated = true;
			}
			if (this.verticalRadius.invalidateWith(source.verticalRadius)) {
				isInvalidated = true;
			}
			return isInvalidated;
		}
		
		CONFIG::debug
		final public function assertEquals ( source:BorderRadiusValue ):Boolean {
			return this.horizontalRadius.assertEquals(source.horizontalRadius) && this.verticalRadius.assertEquals(source.verticalRadius);
		}
		
		final public function toString ( ):String {
			return "BorderRadiusValue:{ HR: " + this.horizontalRadius + ", VR: " + this.verticalRadius + " }";
		}
		
	}

}