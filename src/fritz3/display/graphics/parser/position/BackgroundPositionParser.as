package fritz3.display.graphics.parser.position  {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.layout.Align;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.graphics.parser
	 * 
	 * [Description]
	*/
	
	public class BackgroundPositionParser implements IPropertyParser {
		
		protected static var _parser:BackgroundPositionParser
		
		protected static var _cachedData:Object;
		
		{ 
			_cachedData = { };
			_parser = new BackgroundPositionParser();
		}
		
		public function BackgroundPositionParser (  )  {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getPositionData(value);
		}
		
		protected function getPositionData ( value:String ):BackgroundPositionData {
			var data:BackgroundPositionData = new BackgroundPositionData();
			
			var horizontalFloat:String = Align.CENTER, verticalFloat:String = Align.CENTER;
			var offsetX:Number = 0, offsetY:Number = 0;
			var offsetXValueType:String = DisplayValueType.PERCENTAGE;
			var offsetYValueType:String = DisplayValueType.PERCENTAGE;
			
			var match:Array = value.match(/(^((center|(left|right)|(top|bottom))\s*)?((\d+)(%|px)?)?$)|(^(((center|left|right)\s*)?((\d+)(%|px)?)?)\s*(((center|top|bottom)\s*)?((\d+)(%|px)?)?)$)/);
			var val:Number, valueType:String;
			var type:String;
			if (match && match[1] != undefined) {
				type = match[5] ? "vertical" : "horizontal";
				val = match[7];
				if (match[8] != undefined) {
					valueType = match[8];
				}
				switch(type) {
					case "horizontal":
					horizontalFloat = match[3];
					offsetX = val;
					offsetXValueType = valueType;
					break;
					
					case "vertical":
					verticalFloat = match[3];
					offsetY = val;
					offsetYValueType = valueType;
					break;
				}
			} else if (match && match[9] != undefined) {
				if (match[10] != undefined) {
					if (match[12] != undefined) {
						horizontalFloat = match[12];
					} else {
						horizontalFloat = Align.LEFT;
					}
					if (match[14] != undefined) {
						offsetX = match[14];
					}
					if (match[15] != undefined) {
						offsetXValueType = match[15];
					}
				}
				if (match[16] != undefined) {
					if (match[18] != undefined) {
						verticalFloat = match[18];
					} else {
						verticalFloat = Align.TOP;
					}
					if (match[20] != undefined) {
						offsetY = match[20];
					}
					if (match[21] != undefined) {
						offsetYValueType = match[21];
					}
				}
			}
			
			data.horizontalFloat = horizontalFloat;
			data.offsetX = new DisplayValue(offsetX, offsetXValueType);
			
			data.verticalFloat = verticalFloat;
			data.offsetY = new DisplayValue(offsetY, offsetYValueType);
			return data;
		}
		
		public static function get parser ( ):BackgroundPositionParser { return _parser; }
		
	}

}