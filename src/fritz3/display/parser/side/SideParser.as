package fritz3.display.parser.side {
	import fritz3.base.parser.PropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.parser.size.SizeParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class SideParser implements PropertyParser {
		
		protected static var _parser:SideParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new SideParser();
			_cachedData = { };
		}
		
		public function SideParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getSideData(value);
		}
		
		protected function getSideData ( value:String ):SideData {
			var all:DisplayValue;
			var data:Array = [];
			var first:DisplayValue, second:DisplayValue, third:DisplayValue, fourth:DisplayValue;
			var match:Array = value.match(/(\d+(px|%)?)/g);
			if (match) {
				var displayValue:DisplayValue;
				for (var i:int, l:int = match.length; i < l; ++i) {
					displayValue = DisplayValue(SizeParser.parser.parseValue(match[i]));
					data[i] = displayValue;
				}
				switch(l) {
					case 1:
					all = data[0];
					break;
					
					case 2:
					first = third = data[0];
					second = fourth = data[1];
					break;
					
					case 3:
					first = data[0];
					second = fourth = data[1];
					third = data[2];
					break;
					
					case 4:
					first = data[0];
					second = data[1];
					third = data[2];
					fourth = data[3];
					break;
				}
			}
			var sideData:SideData = new SideData();
			sideData.all = all;
			sideData.first = first;
			sideData.second = second;
			sideData.third = third;
			sideData.fourth = fourth;
			return sideData;

		}
		
		public static function get parser ( ):SideParser { return _parser; }
		
	}

}