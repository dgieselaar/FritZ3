package fritz3.style {
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.InvalidatableStyleSheet;
	import fritz3.style.Stylable;
	import fritz3.style.StyleSheetNode;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StandardStyleSheet implements InvalidatableStyleSheet {
		
		protected var _stylable:Stylable;
		protected var _styleSheetIDs:Array = [];
		
		protected var _invalidatedCollector:Boolean;
		protected var _invalidatedState:Boolean;
		protected var _invalidatedNodes:Boolean;
		
		public function StandardStyleSheet ( properties:Object = null ) {
			super(properties);
		}
		
		protected function setStylable ( stylable:Stylable ):void {
			_stylable = stylable;
			this.invalidate();
		}
		
		protected function setStyleSheetIDs ( ids:Array ):void {
			_styleSheetIDs = ids;
			this.invalidateCollector();
		}
		
		protected function invalidate ( ):void {
			if (_stylable) {
				_stylable.invalidateStyle();
			}
		}
		
		public function invalidateNode ( styleSheetNode:StyleSheetNode ):void {
			_invalidatedNodes = true;
			this.invalidate();
		}
		
		public function getStyle ( ):void {
			
			if (_invalidatedCollector) {
				// collect style
			}
			
			if (_invalidatedNodes) {
				// cache nodes
			}
			
			if (_invalidatedState) {
				// apply style
			}
			
			_invalidatedCollector = _invalidatedState = _invalidatedNodes = false;
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
		
	}

}