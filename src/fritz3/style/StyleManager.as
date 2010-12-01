package fritz3.style {
	import fritz3.utils.signals.FastSignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleManager {
		
		protected static var _firstNodeByID:Object = { };
		protected static var _lastNodeByID:Object = { };
		
		protected static var _onChange:IDispatcher = new FastSignal();
		
		public function StyleManager ( ) {
			
		}
		
		public static function reset ( ):void {
			
		}
		
		public static function getFirstNode ( styleSheetID:String = null ):StyleSheetNode {
			return _firstNodeByID[stylesheetID];
		}
		
		public static function get onChange ( ):ISignal {
			return ISignal(_onChange);
		}
		
	}

}