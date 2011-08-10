package fritz3.display.graphics.parser.border {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.BorderRadiusValue;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusParser implements IPropertyParser {
		
		protected static var _parser:BorderRadiusParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new BorderRadiusParser();
			_cachedData = { };
		}
		
		public function BorderRadiusParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getData(value);
		}
		
		protected function getData ( value:String ):BorderRadiusData {
			var regExp:RegExp = /^((?:\d+(?:px|%)?\s*){1,4})(?:\s*\/\s*((?:\d+(?:px|%)\s*){1,4}))?$/;
			var match:Array = value.match(regExp);
			if (!match) {
				return new BorderRadiusData();
			}
			
			var hResult:String = match[1];
			var vResult:String = match[2];
			
			var topLeftHValue:Number, topLeftHValueType:String;
			var topRightHValue:Number, topRightHValueType:String;
			var bottomRightHValue:Number, bottomRightHValueType:String;
			var bottomLeftHValue:Number, bottomLeftHValueType:String;
			
			var hRegExp:RegExp = /(\d+(px|%)?)/g;
			var result:String, subMatch:Array, val:Number, valueType:String;
			match = hResult.match(hRegExp);
			
			var i:int, l:int, j:int, m:int;
			for (i = 0, l = match.length; i < l; ++i) {
				result = match[i];
				subMatch = result.match(/(\d+)(px|%)?/);
				for (j = 0, m = subMatch.length; j < m; ++j) {
					val = subMatch[1];
					valueType = subMatch[2] || DisplayValueType.PIXEL;
					switch(i) {
						case 0:
						topLeftHValue = val;
						topLeftHValueType = valueType;
						break;
						
						case 1:
						topRightHValue = val;
						topRightHValueType = valueType;
						break;
						
						case 2:
						bottomRightHValue = val;
						bottomRightHValueType = valueType;
						break;
						
						case 3:
						bottomLeftHValue = val;
						bottomLeftHValueType = valueType;
						break;
					}
				}
			}
			
			if (isNaN(topRightHValue)) {
				topRightHValue = topLeftHValue;
				topRightHValueType = topLeftHValueType;
			}
			
			if (isNaN(bottomRightHValue)) {
				bottomRightHValue = topLeftHValue;
				bottomRightHValueType = topLeftHValueType;
			}
			
			if (isNaN(bottomLeftHValue)) {
				bottomLeftHValue = topRightHValue;
				bottomLeftHValueType = topRightHValueType;
			}
			
			var topLeftHValueObj:DisplayValue = new DisplayValue(topLeftHValue, topLeftHValueType);
			var topRightHValueObj:DisplayValue = new DisplayValue(topRightHValue, topRightHValueType);
			var bottomRightHValueObj:DisplayValue = new DisplayValue(bottomRightHValue, bottomRightHValueType);
			var bottomLeftHValueObj:DisplayValue = new DisplayValue(bottomLeftHValue, bottomLeftHValueType);
			
			var topLeftVValue:Number, topLeftVValueType:String;
			var topRightVValue:Number, topRightVValueType:String;
			var bottomRightVValue:Number, bottomRightVValueType:String;
			var bottomLeftVValue:Number, bottomLeftVValueType:String;
			
			if (!vResult) {
				topLeftVValue = topLeftHValue;
				topLeftVValueType = topLeftHValueType;
				topRightVValue = topRightHValue;
				topRightVValueType = topRightHValueType;
				bottomRightVValue = bottomRightHValue;
				bottomRightVValueType = bottomRightHValueType;
				bottomLeftVValue = bottomLeftHValue;
				bottomLeftVValueType = bottomLeftHValueType;
			} else {
				match = vResult.match(/(\d+(px|%)?)/g);
				for (i = 0, l = match.length; i < l; ++i) {
					result = match[i];
					subMatch = result.match(/(\d+)(px|%)?/);
					for (j = 0, m = subMatch.length; j < m; ++j) {
						val = subMatch[1];
						valueType = subMatch[2] || DisplayValueType.PIXEL;
						switch(i) {
							case 0:
							topLeftVValue = val;
							topLeftVValueType = valueType;
							break;
							
							case 1:
							topRightVValue = val;
							topRightVValueType = valueType;
							break;
							
							case 2:
							bottomRightVValue = val;
							bottomRightVValueType = valueType;
							break;
							
							case 3:
							bottomLeftVValue = val;
							bottomLeftVValueType = valueType;
							break;
						}
					}
				}
			}
			
			if (isNaN(topRightVValue)) {
				topRightVValue = topLeftVValue;
				topRightVValueType = topLeftVValueType;
			}
			
			if (isNaN(bottomRightVValue)) {
				bottomRightVValue = topLeftVValue;
				bottomRightVValueType = topLeftVValueType;
			}
			
			if (isNaN(bottomLeftVValue)) {
				bottomLeftVValue = topRightVValue;
				bottomLeftVValueType = topRightVValueType;
			}
			
			var topLeftVValueObj:DisplayValue = new DisplayValue(topLeftVValue, topLeftVValueType);
			var topRightVValueObj:DisplayValue = new DisplayValue(topRightVValue, topRightVValueType);
			var bottomRightVValueObj:DisplayValue = new DisplayValue(bottomRightVValue, bottomRightVValueType);
			var bottomLeftVValueObj:DisplayValue = new DisplayValue(bottomLeftVValue, bottomLeftVValueType);
			
			var topLeftValue:BorderRadiusValue = new BorderRadiusValue(topLeftHValueObj, topLeftVValueObj);
			var topRightValue:BorderRadiusValue = new BorderRadiusValue(topRightHValueObj, topRightVValueObj);
			var bottomRightValue:BorderRadiusValue = new BorderRadiusValue(bottomRightHValueObj, bottomRightVValueObj);
			var bottomLeftValue:BorderRadiusValue = new BorderRadiusValue(bottomLeftHValueObj, bottomLeftVValueObj);
			
			var data:BorderRadiusData = new BorderRadiusData(topLeftValue, topRightValue, bottomRightValue, bottomLeftValue);			
			return data;
			
		}
		
		
		public static function get parser ( ):BorderRadiusParser { return _parser; }
		
	}

}