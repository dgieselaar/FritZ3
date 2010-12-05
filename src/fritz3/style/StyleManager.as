package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.StyleManagerInvalidationSignal;
	import fritz3.style.selector.Selector;
	import fritz3.style.selector.SelectorList;
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
			
			const children:XMLList = xml.children();
			var child:XML;
			var i:int = 0;
			const l:int = children.length();
			var rule:StyleRule;
			for (; i < l; ++i) {
				child = children[i];
				rule = getStyleRuleFromXML(child);
			}
			
			
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		protected static function getStyleRuleFromXML ( xml:XML ):StyleRule {
			var rule:StyleRule = new StyleRule();
			const children:XMLList = xml.children();
			var i:int = 0;
			const l:int = children.length();
			rule.selectorList = new SelectorList(xml.@where.toString());
			var child:XML, propertyName:String, propertyValue:*, target:String;
			var dotIndex:int;
			for (; i < l; ++i) {
				child = children[i];
				target = null;
				propertyName = child.@name;
				if ((dotIndex = propertyName.indexOf(".")) != -1) {
					target = propertyName.substr(0, dotIndex);
					propertyName = propertyName.substr(dotIndex+1);
				} 
				if (child.hasSimpleContent()) {
					propertyValue = getSimpleValue(child.toString());
				} else {
					propertyValue = child;
				}
			}
			return rule;
		}
		
		protected static function getSimpleValue ( string:String ):* {
			var value:* = string;
			switch(string) {
				case "NaN":
				value = NaN;
				break;
				
				case "Number.MAX_VALUE":
				value = Number.MAX_VALUE;
				break;
				
				case "Number.MIN_VALUE":
				value = Number.MIN_VALUE;
				break;
				
				case "null":
				value = null;
				break;
			}
			
			return value;	
		}
		
		public static function getFirstRule ( styleSheetID:String = null ):StyleRule {
			return _firstNodeByID[styleSheetID];
		}
		
		public static function get onChange ( ):StyleManagerInvalidationSignal {
			return _onChange;
		}
		
	}

}