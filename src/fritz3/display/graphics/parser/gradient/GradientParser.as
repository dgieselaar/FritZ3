package fritz3.display.graphics.parser.gradient {
	import flash.display.GraphicsGradientFill;
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
		
		public function getGradientData ( value:String ):GradientData {
			var data:GradientData = new GradientData();
			var match:Array = value.match(/(linear|radial)\s+([0-9]{1,3}\s+)?(.+)/);
			if (match) {
				var gradientFill:GraphicsGradientFill = new GraphicsGradientFill();
				gradientFill.type = match[1];
				var angle:Number = 90;
				if (match[2]) {
					angle = match[2];
				}
				var colors:Array = String(match[4]).split(",");
				var colorValue:String, color:uint, 
				for (var i:int, l:int = colors.length; i < l; ++i) {
					
				}
			}
			return data;
		}
		
		public static function get parser ( ):GradientParser { return _parser; }
		
	}

}