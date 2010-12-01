package fritz3.style {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StandardStyleSheet implements StyleSheet {
		
		protected var _stylable:Stylable;
		protected var _stylesheetID:String;
		
		public function StandardStyleSheet ( properties:Object = null ) {
			for (var id:String in properties) {
				this[id] = properties[id];
			}
		}
		
		public function getStyle ( ):void {
			
		}
		
		protected function applyStyleSheetID ( ):void {
			
		}
		
		protected function setStylable ( stylable:Stylable ):void {
			_stylable = stylable;
			if (_stylable) {
				_stylable.invalidateStyle();
			}
		}
		
		public function get styleSheetID ( ):String { return _stylesheetID; }
		public function set styleSheetID ( value:String ):void {
			if (_stylesheetID != value) {
				_stylesheetID = value;
				this.applyStyleSheetID();
			}
		}
		
		public function get stylable ( ):Stylable { return _stylable; }
		public function set stylable ( value:Stylable ):void {
			if (_stylable != value) {
				this.setStylable(value);
			}
		}
		
	}

}