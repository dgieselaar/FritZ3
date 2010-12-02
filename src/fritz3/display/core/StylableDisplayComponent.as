package fritz3.display.core  {
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
		
		public function StylableDisplayComponent ( properties:Object = null )  {
			super(properties);
		}
		
		override protected function initializeDependencies ( ):void  {
			super.initializeDependencies();
			this.initializeStyleSheet();
		}
		
		override protected function setInvalidationMethodOrder(  ):void  {
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
		
		public function invalidateStyle ( ):void {
			_invalidationHelper.invalidateMethod(this.getStyle);
		}
		
		public function get styleSheetCollector ( ):StyleSheetCollector { return _styleSheetCollector; }
		public function set styleSheetCollector ( value:StyleSheetCollector ):void {
			if (_styleSheetCollector != value) {
				this.setStyleSheetCollector(value);
			}
		}
		
	}

}