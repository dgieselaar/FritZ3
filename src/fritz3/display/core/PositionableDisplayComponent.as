package fritz3.display.core  {
	import fritz3.display.layout.flexiblebox.Collapsable;
	import fritz3.display.layout.flexiblebox.FlexibleBoxElement;
	import fritz3.display.layout.InvalidatablePositionable;
	import fritz3.display.layout.Positionable;
	import fritz3.utils.signals.MonoSignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.core
	 * 
	 * [Description]
	*/
	
	public class PositionableDisplayComponent extends StylableDisplayComponent implements InvalidatablePositionable, Collapsable, FlexibleBoxElement {
		
		protected var _top:Number = NaN;
		protected var _left:Number = NaN;
		protected var _bottom:Number = NaN;
		protected var _right:Number = NaN;
		
		protected var _minimumWidth:Number = NaN;
		protected var _maximumWidth:Number = NaN;
		protected var _minimumHeight:Number = NaN;
		protected var _maximumHeight:Number = NaN;
		
		protected var _margin:Number = 0;
		protected var _marginTop:Number = 0;
		protected var _marginLeft:Number = 0;
		protected var _marginBottom:Number = 0;
		protected var _marginRight:Number = 0;
		
		protected var _registration:String;
		protected var _horizontalFloat:String;
		protected var _verticalFloat:String;
		
		protected var _collapsed:Boolean;
		
		protected var _onDisplayInvalidation:IDispatcher;
		
		protected var _boxOrdinalGroup:int = 1;
		protected var _boxFlex:Number = 0;
		protected var _boxFlexGroup:int = 1;
		
		public function PositionableDisplayComponent ( properties:Object = null )  {
			super(properties);
		}
		
		override protected function initializeDependencies(  ):void  {
			super.initializeDependencies();
			this.initializeDisplayInvalidationSignal();
		}
		
		override protected function setInvalidationMethodOrder(  ):void  {
			super.setInvalidationMethodOrder();
			_invalidationHelper.append(this.dispatchDisplayInvalidation);
		}
		
		protected function initializeDisplayInvalidationSignal ( ):void {
			_onDisplayInvalidation = new MonoSignal();
		}
		
		protected function dispatchDisplayInvalidation ( ):void {
			_onDisplayInvalidation.dispatch(this);
		}
		
		public function invalidateDisplay ( ):void {
			_invalidationHelper.invalidateMethod(this.dispatchDisplayInvalidation);
		}
		
		protected function applyMinimumWidth ( ):void {
		}
		
		protected function applyMaximumWidth ( ):void {
		}
		
		protected function applyMinimumHeight ( ):void {
		}
		
		protected function applyMaximumHeight ( ):void {
		}
		
		public function get top ( ):Number { return _top; }
		public function set top ( value:Number ):void {
			if (_top != value) {
				_top = value;
				this.invalidateDisplay();
			}
		}
		
		public function get left ( ):Number { return _left; }
		public function set left ( value:Number ):void {
			if (_left != value) {
				_left = value;
				this.invalidateDisplay();
			}
		}
		
		public function get bottom ( ):Number { return _bottom; }
		public function set bottom ( value:Number ):void {
			if (_bottom != value) {
				_bottom = value;
				this.invalidateDisplay();
			}
		}
		
		public function get right ( ):Number { return _right; }
		public function set right ( value:Number ):void {
			if (_right != value) {
				_right = value;
				this.invalidateDisplay();
			}
		}
		
		public function get margin ( ):Number { return _margin; }
		public function set margin ( value:Number ):void {
			if (_margin != value) {
				_margin = _marginTop = _marginLeft = _marginBottom = _marginRight = value;
				this.invalidateDisplay();
			}
		}
		
		public function get marginTop ( ):Number { return _marginTop; }
		public function set marginTop ( value:Number ):void {
			if (_marginTop != value) {
				_marginTop = value;
				this.invalidateDisplay();
			}
		}
		
		public function get marginLeft ( ):Number { return _marginLeft; }
		public function set marginLeft ( value:Number ):void {
			if (_marginLeft != value) {
				_marginLeft = value;
				this.invalidateDisplay();
			}
		}
		
		public function get marginBottom ( ):Number { return _marginBottom; }
		public function set marginBottom ( value:Number ):void {
			if (_marginBottom != value) {
				_marginBottom = value;
				this.invalidateDisplay();
			}
		}
		
		public function get marginRight ( ):Number { return _marginRight; }
		public function set marginRight ( value:Number ):void {
			if (_marginRight != value) {
				_marginRight = value;
				this.invalidateDisplay();
			}
		}
		
		public function get registration ( ):String { return _registration; }
		public function set registration ( value:String ):void {
			if (_registration != value) {
				_registration = value;
				this.invalidateDisplay();
			}
		}
		
		public function get horizontalFloat ( ):String { return _horizontalFloat; }
		public function set horizontalFloat ( value:String ):void {
			if (_horizontalFloat != value) {
				_horizontalFloat = value;
				this.invalidateDisplay();
			}
		}
		
		public function get verticalFloat ( ):String { return _verticalFloat; }
		public function set verticalFloat ( value:String ):void {
			if (_verticalFloat != value) {
				_verticalFloat = value;
				this.invalidateDisplay();
			}
		}
		
		public function get minimumWidth ( ):Number { return _minimumWidth; }
		public function set minimumWidth ( value:Number ):void {
			if (_minimumWidth != value) {
				_minimumWidth = value;
				this.applyMinimumWidth();
			}
		}
		
		public function get maximumWidth ( ):Number { return _maximumWidth; }
		public function set maximumWidth ( value:Number ):void {
			if (_maximumWidth != value) {
				_maximumWidth = value;
				this.applyMaximumWidth();
			}
		}
		
		public function get minimumHeight ( ):Number { return _minimumHeight; }
		public function set minimumHeight ( value:Number ):void {
			if (_minimumHeight != value) {
				_minimumHeight = value;
				this.applyMinimumHeight();
			}
		}
		
		public function get maximumHeight ( ):Number { return _maximumHeight; }
		public function set maximumHeight ( value:Number ):void {
			if (_maximumHeight != value) {
				_maximumHeight = value;
				this.applyMaximumHeight();
			}
		}
		
		public function get boxOrdinalGroup ( ):int { return _boxOrdinalGroup; }
		public function set boxOrdinalGroup ( value:int ):void {
			if(_boxOrdinalGroup != value) {
				_boxOrdinalGroup = value;
				this.invalidateDisplay();
			}
		}
		
		public function get boxFlex ( ):Number { return _boxFlex; }
		public function set boxFlex ( value:Number ):void {
			if(_boxFlex != value) {
				_boxFlex = value;
				this.invalidateDisplay();
			}
		}
		
		public function get boxFlexGroup ( ):int { return _boxFlexGroup; }
		public function set boxFlexGroup ( value:int ):void {
			if(_boxFlexGroup != value) {
				_boxFlexGroup = value;
				this.invalidateDisplay();
			}
		}
	
		public function get collapsed ( ):Boolean { return _collapsed; }
		public function set collapsed ( value:Boolean ):void {
			if(_collapsed != value) {
				_collapsed = value;
				this.invalidateDisplay();
			}
		}
		
		public function get onDisplayInvalidation ( ):ISignal { return ISignal(_onDisplayInvalidation); }
		
	}

}