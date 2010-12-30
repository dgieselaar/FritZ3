package fritz3.display.core.parser.padding {
	import fritz3.style.PropertyParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class PaddingParser implements PropertyParser {
		
		protected static var _parser:PropertyParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new PaddingParser();
			_cachedData = { };
		}
		
		public function PaddingParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getPaddingData(value);
		}
		
		protected function getPaddingData ( value:String ):PaddingData {
			var data:PaddingData = new PaddingData();
			var padding:Number = NaN;
			var paddingTop:Number = 0, paddingLeft:Number = 0, paddingBottom:Number = 0, paddingRight:Number = 0;
			var match:Array = value.match(/(\d+(px|%)?)/g);
			if (match) {
				var paddingAmount:Number, child:String, childMatch:Array; 
				for (var i:int, l:int = match.length; i < l; ++i) {
					child = match[i];
					childMatch = child.match(/(\d+)/);
					paddingAmount = childMatch[1];
					switch(i) {
						case 0:
						l > 1 ? paddingLeft = paddingAmount : padding = paddingAmount;
						break;
						
						case 1:
						paddingTop = paddingAmount;
						break;
						
						case 2:
						paddingRight = paddingAmount;
						break;
						
						case 3:
						paddingBottom = paddingAmount;
						break;
					}
					if (l == 2 || l == 3) {
						paddingBottom = paddingTop;
					}
					if (l == 2) {
						paddingRight = paddingLeft;
					}
				}
			}
			data.padding = padding;
			data.paddingLeft = paddingLeft;
			data.paddingTop = paddingTop;
			data.paddingRight = paddingRight;
			data.paddingBottom = paddingBottom;
			return data;
		}
		
		public static function get parser ( ):PropertyParser { return _parser; }
		
	}

}