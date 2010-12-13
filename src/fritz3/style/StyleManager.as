package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationPriorityTreshold;
	import fritz3.style.invalidation.StyleManagerInvalidationSignal;
	import fritz3.style.selector.ObjectCache;
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
		
		protected static var _firstNodeByID:Object;
		protected static var _lastNodeByID:Object;
		
		protected static var _onChange:StyleManagerInvalidationSignal;
		protected static var _invalidationHelper:InvalidationHelper;
		
		{
			_firstNodeByID = { };
			_lastNodeByID = { };
			_onChange = new StyleManagerInvalidationSignal();
			_invalidationHelper = new InvalidationHelper();
			_invalidationHelper.append(dispatchChange);
			_invalidationHelper.priority = InvalidationPriorityTreshold.DISPLAY_INVALIDATION + 1;
		}
		
		public function StyleManager ( ) {
			
		}
		
		public static function reset ( ):void {
			_invalidationHelper.invalidateMethod(dispatchChange);
			_invalidationHelper.invalidateMethod(clearObjectCache);
		}
		
		protected static function dispatchChange ( ):void {
			_onChange.dispatch();
		}
		
		protected static function clearObjectCache ( ):void {
			ObjectCache.clearCache();
		}
		
		public static function addRule ( styleRule:StyleRule ):void {
			var styleSheetID:String = styleRule.styleSheetID;
			var lastNode:StyleRule = _lastNodeByID[styleSheetID];
			if (!lastNode) {
				_firstNodeByID[styleSheetID] = styleRule;
			} else {
				lastNode.nextNode = styleRule;
				styleRule.prevNode = lastNode;
			}
			
			_lastNodeByID[styleSheetID] = styleRule;
			
			_invalidationHelper.invalidateMethod(dispatchChange);
		}
		
		public static function removeRule ( styleRule:StyleRule ):void {
			var styleSheetID:String = styleRule.styleSheetID;
			var prevNode:StyleRule = styleRule.prevNode, nextNode:StyleRule = styleRule.nextNode;
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			
			if (_firstNodeByID[styleSheetID] == styleRule) {
				_firstNodeByID[styleSheetID] = nextNode;
			}
			
			if (_lastNodeByID[styleSheetID] == styleRule) {
				_lastNodeByID[styleSheetID] = prevNode;
			}
			
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
				rule.styleSheetID = child.@styleSheetID != undefined ? child.@styleSheetID : null;
				addRule(rule);
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
			var dotIndex:int, data:PropertyData;
			for (; i < l; ++i) {
				child = children[i];
				target = null;
				propertyName = child.@name.toString().replace(/-[a-z]/g, replaceDash);
				if ((dotIndex = propertyName.indexOf(".")) != -1) {
					target = propertyName.substr(0, dotIndex);
					propertyName = propertyName.substr(dotIndex+1);
				} 
				if (child.hasSimpleContent()) {
					propertyValue = getSimpleValue(child.toString());
				} else {
					propertyValue = child;
				}
				data = new PropertyData();
				data.propertyName = propertyName;
				data.value = propertyValue;
				data.target = target;
				rule.append(data);
			}
			return rule;
		}
		
		protected static function replaceDash ( match:String, ...args ):String {
			return match.substr(1,1).toUpperCase();
		}
		
		protected static function getSimpleValue ( string:String ):* {
			var value:* = string;
			switch(string) {
				case "true":
				value = true;
				break;
				
				case "false":
				value = false;
				break;
				
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
			_invalidationHelper.invalidateMethod(clearObjectCache);
			return _firstNodeByID[styleSheetID];
		}
		
		public static function get onChange ( ):StyleManagerInvalidationSignal {
			return _onChange;
		}
		
	}

}