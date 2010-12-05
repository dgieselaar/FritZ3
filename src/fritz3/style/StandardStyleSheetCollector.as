package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
	import fritz3.style.selector.ObjectCache;
	import fritz3.style.Stylable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StandardStyleSheetCollector implements InvalidatableStyleSheetCollector {
		
		protected var _disabled:Boolean = false;
		
		protected var _stylable:Stylable;
		protected var _styleSheetIDs:Array;
		protected var _hasOnChangeListener:Boolean;
		
		protected var _invalidatedCollector:Boolean;
		protected var _invalidatedState:Boolean;
		protected var _invalidatedRules:Boolean;
		
		protected var _styleRules:Array;
		
		public function StandardStyleSheetCollector ( properties:Object = null ) {
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
			
			ObjectCache.getCache(this);
			
			var numRules:int = 0;
			var ids:Array = _styleSheetIDs, id:String;
			var stylable:Stylable = _stylable;
			if (!ids) {
				node = StyleManager.getFirstRule(StyleManager.DEFAULT_STYLESHEET_ID);
				while (node) {
					if (node.selectorList.match(stylable)) {
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
							rules[numRules++] = node;
						}
						node = node.nextNode;
					}
				}
			}
			
			ObjectCache.clearCache(this);
		}
		
		protected function cacheProperties ( ):void {
			
		} 
		
		protected function applyStyle ( ):void {
			
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