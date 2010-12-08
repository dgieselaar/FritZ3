package fritz3.display.core  {
	import fritz3.display.core.Addable;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
	import fritz3.style.StandardStyleSheetCollector;
	import fritz3.style.Stylable;
	import fritz3.style.StyleSheetCollector;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.core
	 * 
	 * [Description]
	*/
	
	public class StylableDisplayComponent extends InvalidatableDisplayComponent implements Stylable {
		
		protected var _styleSheetCollector:StyleSheetCollector;
		
		protected var _id:String;
		protected var _className:String;
		protected var _name:String;
		
		public function StylableDisplayComponent ( properties:Object = null )  {
			super(properties);
		}
		
		override protected function initializeDependencies ( ):void  {
			super.initializeDependencies();
			this.initializeStyleSheet();
		}
		
		override protected function setInvalidationMethodOrder ( ):void  {
			super.setInvalidationMethodOrder();
			_invalidationHelper.append(this.getStyle);
		}
		
		protected function initializeStyleSheet ( ):void {
			this.styleSheetCollector = new StandardStyleSheetCollector();
		}
		
		protected function setStyleSheetCollector ( styleSheetCollector:StyleSheetCollector ):void {
			if (_styleSheetCollector) {
				_styleSheetCollector.stylable = null;
			}
			_styleSheetCollector = styleSheetCollector;
			if (_styleSheetCollector) {
				_styleSheetCollector.stylable = this;
			}
		}
		
		protected function getStyle ( ):void {
			_styleSheetCollector.getStyle();
		}
		
		override public function onAdd ( ):void {
			super.onAdd();
			if (_styleSheetCollector && _styleSheetCollector is InvalidatableStyleSheetCollector) {
				InvalidatableStyleSheetCollector(_styleSheetCollector).invalidateCollector();
			}
			this.invalidateStyle();
		}
		
		public function invalidateStyle ( ):void {
			_invalidationHelper.invalidateMethod(this.getStyle);
		}
		
		protected function applyID ( ):void {
			if (_styleSheetCollector is InvalidatableStyleSheetCollector) {
				InvalidatableStyleSheetCollector(_styleSheetCollector).invalidateCollector();
			}
		}
		
		protected function applyName ( ):void {
			if (_styleSheetCollector is InvalidatableStyleSheetCollector) {
				InvalidatableStyleSheetCollector(_styleSheetCollector).invalidateCollector();
			}
		}
		
		protected function applyClassName ( ):void {
			if (_styleSheetCollector is InvalidatableStyleSheetCollector) {
				InvalidatableStyleSheetCollector(_styleSheetCollector).invalidateCollector();
			}
		}
		
		public function get styleSheetCollector ( ):StyleSheetCollector { return _styleSheetCollector; }
		public function set styleSheetCollector ( value:StyleSheetCollector ):void {
			if (_styleSheetCollector != value) {
				this.setStyleSheetCollector(value);
			}
		}
		
		public function get id ( ):String { return _id; }
		public function set id ( value:String ):void {
			if(_id != value) {
				_id = value;
				this.applyID();
			}
		}
		
		public function get className ( ):String { return _className; }
		public function set className ( value:String ):void {
			if(_className != value) {
				_className = value;
				this.applyClassName();
			}
		}
		
		override public function get name ( ):String { return _name; }
		override public function set name ( value:String ):void {
			if(_name != value) {
				_name = value;
				this.applyName();
			}
		}
		
		/*override public function toString():String {
			return "[object " + (super.toString().match(/\[object (.*?)\]/)[1]) + " { id: "+_id+", className: "+_className+", name: "+_name+" } ]";
		}*/
		
	}

}