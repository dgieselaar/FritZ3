package fritz3.display.core {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	final public class DisplayValue {
		
		public var value:Number;
		public var valueType:String;
		
		public var invalidated:Boolean;
		
		public function DisplayValue ( value:Number = NaN, valueType:String = "px" ) {
			this.value = value, this.valueType = valueType;
		}
		
		final public function reset ( ):void {
			this.value = NaN;
			this.valueType = DisplayValueType.PIXEL;
		}
		
		final public function setValue ( value:Number ):void {
			if (this.value != value && !(value != value && this.value != this.value)) {
				this.value = value;
				this.invalidated = true;
			}
		}
		
		final public function setValueType ( valueType:String ):void {
			if (this.valueType != valueType) {
				this.valueType = valueType;
				this.invalidated = true;
			}
		}
		
		final public function setAll ( value:Number, valueType:String ):void {
			if (this.value != value && !(!(value == value) && !(this.value == this.value))) {
				this.value = value;
				this.invalidated = true;
			}
			if (this.valueType != valueType) {
				this.valueType = valueType;
				this.invalidated = true;
			}
		}
		
		final public function getComputedValue ( length:Number ):Number {
			if (this.valueType == DisplayValueType.PERCENTAGE) {
				return (this.value / 100) * length;
			}
			return this.value;
		}
		
		final public function clone ( ):DisplayValue {
			return new DisplayValue(this.value, this.valueType);
		}
		
		final public function invalidateWith ( source:DisplayValue ):Boolean {
			if (source == this) {
				return false;
			}
			var isDifferent:Boolean;
			var value:Number = source.value;
			if (this.value != value && !(!(value == value) && !(this.value == this.value))) {
				this.value = source.value;
				isDifferent = true;
			}
			if (this.valueType != source.valueType) {
				this.valueType = source.valueType;
				isDifferent = true;
			}
			return isDifferent;
		}
		
		CONFIG::debug
		public function toString ( ):String {
			return "{ " + this.value + "" + this.valueType + " }";
		}
		
		CONFIG::debug
		final public function assertEquals ( to:DisplayValue ):Boolean {
			if (this == to) {
				return true;
			}
			var value:Number = to.value;
			if (this.value != value && !(!(value == value) && !(this.value == this.value))) {
				return false;
			}
			if (this.valueType != to.valueType) {
				return false;
			}
			return true;
		}
		
	}

}