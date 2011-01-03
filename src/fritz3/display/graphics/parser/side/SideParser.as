package fritz3.display.graphics.parser.side {
	import fritz3.style.PropertyParser;
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
			var data:SideData = new SideData();
			var all:Number = NaN;
			var first:Number = 0, second:Number = 0, third:Number = 0, fourth:Number = 0;
			var match:Array = value.match(/(\d+(px|%)?)/g);
			if (match) {
				var amount:Number, child:String, childMatch:Array; 
				for (var i:int, l:int = match.length; i < l; ++i) {
					child = match[i];
					childMatch = child.match(/(\d+)/);
					amount = childMatch[1];
					switch(i) {
						case 0:
						l > 1 ? first = amount : all = amount;
						break;
						
						case 1:
						second = amount;
						break;
						
						case 2:
						third = amount;
						break;
						
						case 3:
						fourth = amount;
						break;
					}
				}
				
				if (l == 2 || l == 3) {
					fourth = second;
				}
				if (l == 2) {
					third = first;
				}
			}
			data.all = all;
			data.first = first;
			data.second = second;
			data.third = third;
			data.fourth = fourth;
			return data;

		}
		
		public static function get parser ( ):SideParser { return _parser; }
		
	}

}