package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
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
		
		protected static var _onChange:StyleManagerInvalidationSignal;
		protected static var _invalidationHelper:InvalidationHelper;
		
		public function StyleManager ( ) {
			
		}
		
		public static function init ( ):void {
			_onChange = new StyleManagerInvalidationSignal();
			_invalidationHelper = new InvalidationHelper();
			_invalidationHelper.append(dispatchChange);
			_invalidationHelper.priority = int.MAX_VALUE;
		}
		
		public static function reset ( ):void {
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		protected static function dispatchChange ( ):void {
			_onChange.dispatch();
		}
		
		public static function addRule ( styleRule:StyleRule ):void {
			
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		public static function removeRule ( styleRule:StyleRule ):void {
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		public static function parseXML ( xml:XML ):void {
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		public static function getFirstRule ( styleSheetID:String = null ):StyleRule {
			return _firstNodeByID[styleSheetID];
		}
		
		public static function get onChange ( ):StyleManagerInvalidationSignal {
			return _onChange;
		}
		
	}

}