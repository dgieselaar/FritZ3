package fritz3.display.graphics.parser.border {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.BorderRadiusValue;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusCornerParser implements IPropertyParser {
		
		protected static var _parser:BorderRadiusCornerParser = new BorderRadiusCornerParser();
		protected static var _cachedData:Object = { };
		
		public function BorderRadiusCornerParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getData(value);
		}
		
		protected function getData ( value:String ):BorderRadiusValue {
			var regExp:RegExp = /^\s*(?:(\d+)(px|%)?)\s*(?:(\d+)(px|%)?)?\s*$/;
			var match:Array = value.match(regExp);
			if (!match) {
				return new BorderRadiusValue();
			}
			
			var horizontalRadiusValue:Number = match[1];
			var horizontalRadiusValueType:String = match[2] || DisplayValueType.PIXEL;
			var verticalRadiusValue:Number, verticalRadiusValueType:String;
			if (match[3]) {
				verticalRadiusValue = match[3];
				verticalRadiusValueType = match[4] || DisplayValueType.PIXEL;
			} else {
				verticalRadiusValue = horizontalRadiusValue;
				verticalRadiusValueType = horizontalRadiusValueType;
			}
			var horizontalDisplayValue:DisplayValue = new DisplayValue(horizontalRadiusValue, horizontalRadiusValueType);
			var verticalDisplayValue:DisplayValue = new DisplayValue(verticalRadiusValue, verticalRadiusValueType);
			var borderRadiusValue:BorderRadiusValue = new BorderRadiusValue(horizontalDisplayValue, verticalDisplayValue);
			return borderRadiusValue;
		}
		
		public static function get parser ( ):BorderRadiusCornerParser { return _parser; }
		
	}

}