package fritz3.display.core.parser.margin {
	import fritz3.style.PropertyParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class MarginParser implements PropertyParser {
		
		protected static var _parser:PropertyParser;
		protected static var _cachedData:Object;
		
		{
			_cachedData = { };
			_parser = new MarginParser();
		}
		
		public function MarginParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getMarginData(value);
		}
		
		protected function getMarginData ( value:String ):MarginData {
			var data:MarginData = new MarginData();
			var margin:Number = NaN;
			var marginTop:Number = 0, marginLeft:Number = 0, marginBottom:Number = 0, marginRight:Number = 0;
			var match:Array = value.match(/(\d+(px|%)?)/g);
			if (match) {
				var marginAmount:Number, child:String, childMatch:Array; 
				for (var i:int, l:int = match.length; i < l; ++i) {
					child = match[i];
					childMatch = child.match(/(\d+)/);
					marginAmount = childMatch[1];
					switch(i) {
						case 0:
						l > 1 ? marginLeft = marginAmount : margin = marginAmount;
						break;
						
						case 1:
						marginTop = marginAmount;
						break;
						
						case 2:
						marginRight = marginAmount;
						break;
						
						case 3:
						marginBottom = marginAmount;
						break;
					}
					if (l == 2 || l == 3) {
						marginBottom = marginTop;
					}
					if (l == 2) {
						marginRight = marginLeft;
					}
				}
			}
			data.margin = margin;
			data.marginLeft = marginLeft;
			data.marginTop = marginTop;
			data.marginRight = marginRight;
			data.marginBottom = marginBottom;
			return data;
		}
		
		public static function get parser ( ):PropertyParser { return _parser; }
		
	}

}