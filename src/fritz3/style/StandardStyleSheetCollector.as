package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
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
			_invalidatedCollector = true;
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