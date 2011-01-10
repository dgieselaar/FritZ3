package fritz3.display.graphics.parser.border {
	import flash.utils.Dictionary;
	import fritz3.base.parser.PropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.graphics.Border;
	import fritz3.display.graphics.BorderPosition;
	import fritz3.display.graphics.LineStyle;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderParser implements PropertyParser {
		
		protected static var _parser:BorderParser;
		protected static var _cachedData:Object;
		
		protected static var _cachedShorthands:Object;
		protected static var _cachedByDisplayValue:Dictionary;
		protected static var _defaultBorder:Border;
		
		{
			_parser = new BorderParser();
			_cachedData = { };
			_cachedShorthands = { };
			
			_cachedByDisplayValue = new Dictionary();
			
			_defaultBorder = new Border();
			_defaultBorder.borderSize = 0;
			_defaultBorder.borderAlpha = 1;
			_defaultBorder.borderColor = 0x000000;
			_defaultBorder.borderPosition = BorderPosition.CENTER;
		}
		
		public function BorderParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getBorderData(value);
		}
		
		protected function getBorderData ( value:String ):BorderData {
			var borderData:BorderData = new BorderData();
			var border:Border;
			if (value == "none") {
				borderData.border = _defaultBorder;
				return borderData;
			}
			var match:Array = value ? value.match(/^(\s*(\d+)(%|px)?){1,4}$/) : null;
			if (match) {
				var data:SideData = SideData(SideParser.parser.parseValue(value));
				if (data.all) {
					borderData.border = this.getBorderByDisplayValue(data.all);
				} else {
					borderData.borderLeft = this.getBorderByDisplayValue(data.first);
					borderData.borderTop = this.getBorderByDisplayValue(data.second);
					borderData.borderRight = this.getBorderByDisplayValue(data.third);
					borderData.borderBottom = this.getBorderByDisplayValue(data.fourth);
				}
			} else {
				borderData.border = this.getBorder(value);
				if (!borderData.border) {
					borderData.border = _defaultBorder;
				}
			}
			return borderData;
		}
		
		protected function getBorder ( value:String ):Border {
			return _cachedShorthands[value] ||= this.createShorthand(value);
		}
		
		protected function createShorthand ( value:String ):Border {
			var match:Array = value ? value.match(/((\d+)(%|px)?)(\s+([0-9xXA-Fa-f]+)|(none))?(\s+(\d{1,3})%)?(\s+(solid|dashed|dotted))?(\s+(inside|outside|center))?/) : null;
			if (!match) {
				return _defaultBorder;
			}
			var border:Border = new Border();
			var size:Number = match[2];
			var color:Object;
			if (match[6] == "none") {
				color = null;
			} else {
				color = uint(match[5]);
			}
			var alpha:Number = 1;
			if (match[7] != undefined) {
				alpha = match[8] / 100;
			}
			var lineStyle:Array;
			switch(match[10]) {
				default:
				lineStyle = LineStyle.SOLID;
				break;
				// TODO: map to dashed/dotted
			}
			var borderPosition:String = match[12] || BorderPosition.CENTER;
			
			border.borderSize = size;
			border.borderColor = color;
			border.borderAlpha = alpha;
			border.borderPosition = borderPosition;
			border.borderLineStyle = lineStyle;
			return border;
		}
		
		protected function getBorderByDisplayValue ( displayValue:DisplayValue ):Border {
			return _cachedByDisplayValue[displayValue.value] ||= this.createBorderByDisplayValue(displayValue);
		}
		
		protected function createBorderByDisplayValue ( displayValue:DisplayValue ):Border {
			var border:Border = _defaultBorder.clone();
			border.borderSize = displayValue.value;
			return border;
		}
		
		public static function get parser ( ):BorderParser { return _parser; }
		
	}

}