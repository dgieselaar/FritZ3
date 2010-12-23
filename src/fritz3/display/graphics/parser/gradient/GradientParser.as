package fritz3.display.graphics.parser.gradient {
	import flash.display.GraphicsGradientFill;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.gradient.GraphicsGradientColor;
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	import fritz3.style.PropertyParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GradientParser implements PropertyParser {
		
		protected static var _parser:GradientParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new GradientParser();
			_cachedData = { };
		}
		
		public function GradientParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getGradientData(value);
		}
		
		public function getGradientData ( value:String ):GraphicsGradientData {
			var data:GraphicsGradientData;
			var match:Array = value.match(/(linear|radial)(\s+([0-9]{1,3})\s+)?(\s*(\d+)(%|px)?\s+)?(.+)/);
			if (match) {
				data = new GraphicsGradientData();
				data.type = match[1];
				var focalPointRatio:Number = 0, focalPointRatioValueType:String = DisplayValueType.RATIO
				data.angle = match[3] || 90;
				if (data.type == "radial") {
					data.focalPointRatio = match[5] || 0;
					data.focalPointRatioValueType = match[6] || DisplayValueType.RATIO;
					if (match[7] == DisplayValueType.PERCENTAGE) {
						data.focalPointRatio = match[6] / 100;
						data.focalPointRatioValueType = DisplayValueType.RATIO;
					}
				} else {
					data.focalPointRatio = 0;
				}
				var colors:Array = String(match[7]).split(",");
				var colorValue:String, color:uint, alpha:Number, position:Number, positionValueType:String;
				var gradientColor:GraphicsGradientColor, gradientColorArray:Array = [];
				var colorMatch:Array;
				for (var i:int, l:int = colors.length; i < l; ++i) {
					colorValue = colors[i];
					colorMatch = colorValue.match(/([0-9xXA-Fa-f]+)(\s+(\d{1,3})%)?(\s+(\d+)(px|%)?)?/);
					if (!colorMatch) {
						continue;
					}
					
					color = uint(colorMatch[1]);
					alpha = (colorMatch[3] || 100) / 100;
					position = colorMatch[5] || (255 / (l - 1) * i);
					positionValueType = colorMatch[6] || DisplayValueType.RATIO;
					if (positionValueType == DisplayValueType.PERCENTAGE) {
						position = (position / 100) * 255;
						positionValueType = DisplayValueType.RATIO;
					}
					gradientColor = new GraphicsGradientColor();
					gradientColor.color = color, gradientColor.alpha = alpha, gradientColor.position = position, gradientColor.positionValueType = positionValueType;
					gradientColorArray.push(gradientColor);
				}
				data.gradientColors = gradientColorArray;
				data.invalidate();
			}
			return data;
		}
		
		public static function get parser ( ):GradientParser { return _parser; }
		
	}

}