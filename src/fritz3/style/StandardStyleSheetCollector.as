package fritz3.style {
	import fritz3.base.injection.Injectable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
	import fritz3.style.selector.ObjectCache;
	import fritz3.style.Stylable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StandardStyleSheetCollector implements InvalidatableStyleSheetCollector {
		
		protected static var _propertyDataObjectPool:Array = [];
		
		protected var _disabled:Boolean = false;
		
		protected var _stylable:Stylable;
		protected var _styleSheetIDs:Array;
		protected var _hasOnChangeListener:Boolean;
		
		protected var _invalidatedCollector:Boolean;
		protected var _invalidatedState:Boolean;
		protected var _invalidatedRules:Boolean;
		
		protected var _styleRules:Array;
		protected var _firstNode:PropertyData;
		protected var _lastNode:PropertyData;
		
		protected var _dataByTarget:Object;
		
		public function StandardStyleSheetCollector ( properties:Object = null ) {
			_dataByTarget = { };
			for (var id:String in properties) {
				this[id] = properties[id];
			}
		}
		
		protected function applyDisabled ( ):void {
			this.setOnChangeListener();
		}
		
		protected function setStylable ( stylable:Stylable ):void {
			_stylable = stylable;
			this.setOnChangeListener();
			this.invalidate();
		}
		
		protected function setStyleSheetIDs ( ids:Array ):void {
			_styleSheetIDs = ids;
			this.invalidateCollector();
		}
		
		protected function invalidate ( ):void {
			if (_stylable && !_disabled) {
				_stylable.invalidateStyle();
			}
		}
		
		protected function setOnChangeListener ( ):void {
			if (_hasOnChangeListener && (!_stylable || _disabled)) {
				StyleManager.onChange.remove(this);
				_hasOnChangeListener = false;
			}
			if (!_hasOnChangeListener && (_stylable && !_disabled)) {
				StyleManager.onChange.add(this);
				_hasOnChangeListener = true;
			}
		}
		
		protected function onStyleManagerChange ( ):void {
			this.invalidateCollector();
		}
		
		protected function collectNodes ( ):void {
			var node:StyleRule, i:int, l:int;
			var rules:Array = _styleRules;
			l = rules ? rules.length : 0;
			for (i = 0; i < l; ++i) {
				node = rules[i];
				node.onChange.remove(this);
			}
			
			_styleRules = rules = [];
			
			var numRules:int = 0;
			var ids:Array = _styleSheetIDs, id:String;
			var stylable:Stylable = _stylable;
			if (!ids) {
				node = StyleManager.getFirstRule(StyleManager.DEFAULT_STYLESHEET_ID);
				while (node) {
					if (node.selectorList.match(stylable)) {
						node.onChange.add(this);
						rules[numRules++] = node;
					}
					node = node.nextNode;
				}
			} else {
				for (i = 0, l = ids.length; i < l; ++i) {
					id = ids[i];
					node = StyleManager.getFirstRule(id);
					while (node) {
						if (node.selectorList.match(stylable)) {
							node.onChange.add(this);
							rules[numRules++] = node;
						}
						node = node.nextNode;
					}
				}
			}
		}
		
		protected function cacheProperties ( ):void {
			var rules:Array = _styleRules;
			var rule:StyleRule;
			
			var node:PropertyData = _firstNode, nextNode:PropertyData;
			while (node) {
				nextNode = node.nextNode;
				poolPropertyDataObject(node);
				node = nextNode;
			}
			
			_dataByTarget = { };
			
			
			var ruleNode:PropertyData, prevNode:PropertyData;
			_firstNode = _lastNode = null;
			for (var i:int, l:int = rules ? rules.length : 0; i < l; ++i) {
				rule = rules[i];
				ruleNode = rule.firstNode;
				while (ruleNode) {
					node = getPropertyData(ruleNode.target, ruleNode.propertyName);
					if (!node) {
						node = getPropertyDataObject();
						node.prevNode = prevNode;
						if (prevNode) {
							prevNode.nextNode = node;
						} else {
							_firstNode = node;
						}
						_lastNode = prevNode = node;
					}
					node.propertyName = ruleNode.propertyName;
					node.target = ruleNode.target;
					node.value = ruleNode.value;
					ruleNode = ruleNode.nextNode;
				}
			}
		} 
		
		protected function applyStyle ( ):void {
			var node:PropertyData = _firstNode;
			var object:Object, target:Object, injectable:Injectable;
			var stylable:Stylable = _stylable;
			while (node) {
				target = node.target == null ? stylable : stylable[node.target];
				if (target is Injectable) {
					Injectable(target).setProperty(node.propertyName, node.value);
				} else {
					target[node.propertyName] = node.value;
				}
				node = node.nextNode;
			}
		}
		
		public function invalidateRule ( styleRule:StyleRule ):void {
			_invalidatedRules = true;
			this.invalidate();
		}
		
		public function getStyle ( ):void {
			
			if (_disabled) {
				return;
			}
			
			if (_invalidatedCollector) {
				this.collectNodes();
			}
			
			if (_invalidatedRules) {
				this.cacheProperties();
			}
			
			if (_invalidatedState || _invalidatedRules) {
				this.applyStyle();
			}
			
			_invalidatedCollector = _invalidatedState = _invalidatedRules = false;
		}
		
		public function invalidateCollector ( ):void {
			_invalidatedCollector = _invalidatedRules = true;
			this.invalidate();
		}
		
		public function invalidateState ( ):void {
			_invalidatedState = true;
			this.invalidate();
		}
		
		protected function getPropertyData ( target:Object, propertyName:String ):PropertyData {
			return _dataByTarget[target] ? _dataByTarget[target][propertyName] : null;
		}
		
		protected static function getPropertyDataObject ( ):PropertyData {
			return _propertyDataObjectPool.length ? _propertyDataObjectPool.shift() : new PropertyData();
		}
		
		protected static function poolPropertyDataObject ( propertyData:PropertyData ):void {
			propertyData.nextNode = propertyData.prevNode = null;
			propertyData.propertyName = propertyData.target = propertyData.value = null;
			_propertyDataObjectPool[_propertyDataObjectPool.length] = propertyData;
		}
		
		public function get stylable ( ):Stylable { return _stylable; }
		public function set stylable ( value:Stylable ):void {
			if (_stylable != value) {
				this.setStylable(value);
			}
		}
		
		public function get styleSheetIDs ( ):Array { return _styleSheetIDs; }
		public function set styleSheetIDs ( value:Array ):void {
			this.setStyleSheetIDs(value);
		}
		
		public function get disabled ( ):Boolean { return _disabled; }
		public function set disabled ( value:Boolean ):void {
			if(_disabled != value) {
				_disabled = value;
				this.applyDisabled();
			}
		}
		
	}

}