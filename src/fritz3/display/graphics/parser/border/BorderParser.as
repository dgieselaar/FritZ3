package fritz3.display.graphics.parser.border {
	import fritz3.display.graphics.Border;
	import fritz3.display.graphics.BorderPosition;
	import fritz3.display.graphics.LineStyle;
	import fritz3.style.PropertyParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderParser implements PropertyParser {
		
		protected static var _parser:BorderParser;
		protected static var _cachedData:Object;
		
		protected static var _cachedShorthands:Object;
		protected static var _defaultBorder:Border;
		
		{
			_parser = new BorderParser();
			_cachedData = { };
			_cachedShorthands = { };
			
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
			var match:Array = value.match(/((\d+)(%|px))(\s+([0-9xXA-Fa-f]+)|none)?(\s+(\d{1,3})%)?(\s+(solid|dashed|dotted))?(\s+(inside|outside|center))?/g);
			if (match) {
				var child:String;
				switch(match.length) {
					case 1:
					borderData.border = this.getBorder(match[0]);
					break;
					
					case 2:
					borderData.borderLeft = borderData.borderRight = this.getBorder(match[0]);
					borderData.borderTop = borderData.borderBottom = this.getBorder(match[1]);
					break;
					
					case 3:
					borderData.borderLeft = this.getBorder(match[0]);
					borderData.borderRight = this.getBorder(match[2]);
					borderData.borderTop = borderData.borderBottom = this.getBorder(match[1]);
					break;
					
					case 4:
					borderData.borderLeft = this.getBorder(match[0]);
					borderData.borderTop = this.getBorder(match[1]);
					borderData.borderRight = this.getBorder(match[2]);
					borderData.borderBottom = this.getBorder(match[3]);
					break;
				}
			} else {
				borderData.border = _defaultBorder;
			}
			return borderData;
		}
		
		protected function getBorder ( value:String ):Border {
			return _cachedShorthands[value] ||= this.createShorthand(value);
		}
		
		protected function createShorthand ( value:String ):Border {
			var border:Border = new Border();
			var match:Array = value.match(/((\d+)(%|px)?)(\s+([0-9xXA-Fa-f]+)|(none))?(\s+(\d{1,3})%)?(\s+(solid|dashed|dotted))?(\s+(inside|outside|center))?/);
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
		
		public static function get parser ( ):BorderParser { return _parser; }
		
	}

}