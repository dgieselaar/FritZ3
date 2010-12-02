package fritz3.style {
	import fritz3.style.invalidation.StyleManagerInvalidationSignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleManager {
		
		public static const DEFAULT_STYLESHEET_ID:String = null;
		
		protected static var _firstNodeByID:Object = { };
		protected static var _lastNodeByID:Object = { };
		
		protected static var _onChange:StyleManagerInvalidationSignal = new StyleManagerInvalidationSignal();
		
		public function StyleManager ( ) {
			
		}
		
		public static function reset ( ):void {
			
		}
		
		public static function getFirstNode ( styleSheetID:String = null ):StyleRule {
			return _firstNodeByID[styleSheetID];
		}
		
		public static function get onChange ( ):StyleManagerInvalidationSignal {
			return _onChange;
		}
		
	}

}