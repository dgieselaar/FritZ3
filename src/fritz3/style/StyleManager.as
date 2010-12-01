package fritz3.style {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleManager {
		
		protected static var _firstNodeByID:Object = { };
		protected static var _lastNodeByID:Object = { };
		
		public function StyleManager ( ) {
			
		}
		
		public static function reset ( ):void {
			
		}
		
		public static function getFirstNode ( styleSheetID:String = null ):StyleSheetNode {
			return _firstNodeByID[stylesheetID];
		}
		
	}

}