package fritz3.display.graphics.parser.repeat {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.graphics.BackgroundImageRepeat;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BackgroundRepeatParser implements IPropertyParser {
		
		protected static var _parser:BackgroundRepeatParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new BackgroundRepeatParser();
			_cachedData = { };
		}
		
		public function BackgroundRepeatParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getRepeatData(value);
		}
		
		public function getRepeatData ( value:String ):BackgroundRepeatData {
			var data:BackgroundRepeatData = new BackgroundRepeatData();
			var repeatX:String = BackgroundImageRepeat.NO_REPEAT, repeatY:String = BackgroundImageRepeat.NO_REPEAT;
			
			var match:Array = value.match(/(repeat-x|repeat-y|(repeat|space|round|no-repeat){1,2})/g);
			if (match) {
				var val:String;
				for (var i:int, l:int = match.length; i < l; ++i) {
					val = match[i];
					switch(val) {
						default:
						if (i == 0) {
							repeatX = repeatY = val;
						} else {
							repeatY = val;
						}
						break;
						
						case "repeat-x":
						repeatX = BackgroundImageRepeat.REPEAT;
						break;
						
						case "repeat-y":
						repeatY = BackgroundImageRepeat.REPEAT;
						break;
					}
				}
			}
			
			data.repeatX = repeatX, data.repeatY = repeatY;
			return data;
		}
		
		public static function get parser ( ):BackgroundRepeatParser { return _parser; }
		
	}

}