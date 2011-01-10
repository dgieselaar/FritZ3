package fritz3.display.parser.size {
	import fritz3.base.parser.PropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class SizeParser implements PropertyParser {
		
		protected static var _parser:SizeParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new SizeParser();
			_cachedData = { };
		}
		
		public function SizeParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getSizeData(value);
		}
		
		protected function getSizeData ( value:String ):DisplayValue {
			var val:Number = NaN, valueType:String = DisplayValueType.PIXEL;
			var match:Array = value.match(/(auto)|((-?\d+)(%|px)?)/); 
			if (match) {
				if (match[1]) {
					val = NaN;
					valueType = DisplayValueType.AUTO;
				} else {
					val = match[3];
					if (match[4] != undefined) {
						valueType = match[4];
					}
				}
			}
			return new DisplayValue(val, valueType);
		}
		
		public static function get parser ( ):SizeParser { return _parser; }
		
	}

}