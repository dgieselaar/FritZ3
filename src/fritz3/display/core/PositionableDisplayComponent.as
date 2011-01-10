package fritz3.display.core  {
	import fritz3.base.parser.PropertyParser;
	import fritz3.base.transition.TransitionData;
	import fritz3.display.layout.flexiblebox.Collapsable;
	import fritz3.display.layout.flexiblebox.FlexibleBoxElement;
	import fritz3.display.layout.InvalidatablePositionable;
	import fritz3.display.layout.Positionable;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	import fritz3.display.parser.size.SizeParser;
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
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _preferredWidth:DisplayValue = new DisplayValue(0, DisplayValueType.AUTO);
		protected var _preferredHeight:DisplayValue = new DisplayValue(0, DisplayValueType.AUTO);
		
		protected var _minimumWidth:DisplayValue = new DisplayValue(NaN);
		protected var _maximumWidth:DisplayValue = new DisplayValue(NaN);
		protected var _minimumHeight:DisplayValue = new DisplayValue(NaN);
		protected var _maximumHeight:DisplayValue = new DisplayValue(NaN);
		
		protected var _left:DisplayValue = new DisplayValue(NaN);
		protected var _top:DisplayValue = new DisplayValue(NaN);
		protected var _right:DisplayValue = new DisplayValue(NaN);
		protected var _bottom:DisplayValue = new DisplayValue(NaN);
		
		protected var _margin:DisplayValue = new DisplayValue(0);
		protected var _marginLeft:DisplayValue = new DisplayValue(0);
		protected var _marginTop:DisplayValue = new DisplayValue(0);
		protected var _marginRight:DisplayValue = new DisplayValue(0);
		protected var _marginBottom:DisplayValue = new DisplayValue(0);
		
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
		
		override protected function setParsers ( ):void {
			super.setParsers();
			this.addParser("preferredWidth", SizeParser.parser);
			this.addParser("preferredHeight", SizeParser.parser);
			this.addParser("minimumWidth", SizeParser.parser);
			this.addParser("maximumWidth", SizeParser.parser);
			this.addParser("minimumHeight", SizeParser.parser);
			this.addParser("maximumHeight", SizeParser.parser);
			this.addParser("left", SizeParser.parser);
			this.addParser("top", SizeParser.parser);
			this.addParser("right", SizeParser.parser);
			this.addParser("bottom", SizeParser.parser);
			this.addParser("marginLeft", SizeParser.parser);
			this.addParser("marginTop", SizeParser.parser);
			this.addParser("marginRight", SizeParser.parser);
			this.addParser("marginBottom", SizeParser.parser);
			this.addParser("margin", SideParser.parser);
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
		
		override public function parseProperty ( propertyName:String, value:* ):void {
			switch(propertyName) {
				default:
				super.parseProperty(propertyName, value);
				break;
				
				case "width":
				this.parseProperty("preferredWidth", value);
				break;
				
				case "height":
				this.parseProperty("preferredHeight", value);
				break;
				
				case "preferredWidth":
				case "preferredHeight":
				case "minimumWidth":
				case "maximumWidth":
				case "minimumHeight":
				case "maximumHeight":
				case "left":
				case "top":
				case "right":
				case "bottom":
				case "marginLeft":
				case "marginTop":
				case "marginRight":
				case "marginBottom":
				this.parseSize(propertyName, value);
				break;
				
				case "margin":
				this.parseMargin(value);
				break;
			}
		}
		
		protected function parseSize ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser(propertyName);
			if (parser) {
				var displayValue:DisplayValue = DisplayValue(parser.parseValue(value)).clone();
				if (displayValue.valueType == DisplayValueType.AUTO) {
					displayValue.value = this.getAutoSize(propertyName);
				}
				this.cacheParsedProperty(propertyName, displayValue);
			}
		}
				
		protected function getAutoSize ( propertyName:String ):Number {
			return 0;
		}
		
		protected function parseMargin ( value:* ):void {
			var parser:PropertyParser = this.getParser("margin");
			if (parser) {
				var sideData:SideData = SideData(parser.parseValue(value));
				if (sideData.all) {
					var all:DisplayValue = sideData.all;
					this.cacheParsedProperty("marginLeft", all.clone());
					this.cacheParsedProperty("marginTop", all.clone());
					this.cacheParsedProperty("marginRight", all.clone());
					this.cacheParsedProperty("marginBottom", all.clone());
				} else {
					this.cacheParsedProperty("marginLeft", sideData.first.clone());
					this.cacheParsedProperty("marginTop", sideData.second.clone());
					this.cacheParsedProperty("marginRight", sideData.third.clone());
					this.cacheParsedProperty("marginBottom", sideData.fourth.clone());
				}
			}
		}
		
		override public function setTransition(propertyName:String, transitionData:TransitionData):void {
			switch(propertyName) {
				default:
				super.setTransition(propertyName, transitionData);
				break;
				
				case "margin":
				super.setTransition("margin", transitionData);
				super.setTransition("marginLeft", transitionData);
				super.setTransition("marginTop", transitionData);
				super.setTransition("marginRight", transitionData);
				super.setTransition("marginBottom", transitionData);
				break;
			}
		}
		
		protected function applyWidth ( ):void {
			
		}
		
		protected function applyHeight ( ):void {
			
		}
		
		protected function applyPreferredWidth ( ):void {
			this.invalidateDisplay();
		}
		
		protected function applyPreferredHeight ( ):void {
			this.invalidateDisplay();
		}
		
		protected function applyMinimumWidth ( ):void {
			this.invalidateDisplay();
		}
		
		protected function applyMaximumWidth ( ):void {
			this.invalidateDisplay();
		}
		
		protected function applyMinimumHeight ( ):void {
			this.invalidateDisplay();
		}
		
		protected function applyMaximumHeight ( ):void {
			this.invalidateDisplay();
		}
		
		override public function get width ( ):Number { return _width; }
		override public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		override public function get height ( ):Number { return _height; }
		override public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
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
		
		public function get preferredWidth ( ):DisplayValue { return _preferredWidth; }
		public function set preferredWidth ( value:DisplayValue ):void {
			if(_preferredWidth.invalidated || !_preferredWidth.assertEquals(value)) {
				_preferredWidth = value;
				_preferredWidth.invalidated = false;
				this.applyPreferredWidth();
			}
		}
		
		public function get preferredHeight ( ):DisplayValue { return _preferredHeight; }		
		public function set preferredHeight ( value:DisplayValue ):void {
			if(_preferredHeight.invalidated || !_preferredHeight.assertEquals(value)) {
				_preferredHeight = value;
				_preferredHeight.invalidated = false;
				this.applyPreferredHeight();
			}
		}
		
		public function get minimumWidth ( ):DisplayValue { return _minimumWidth; }
		public function set minimumWidth ( value:DisplayValue ):void {
			if(_minimumWidth.invalidated || !_minimumWidth.assertEquals(value)) {
				_minimumWidth = value;
				_minimumWidth.invalidated = false;
				this.applyMinimumWidth();
			}
		}
		
		public function get maximumWidth ( ):DisplayValue { return _maximumWidth; }
		public function set maximumWidth ( value:DisplayValue ):void {
			if(_maximumWidth.invalidated || !_maximumWidth.assertEquals(value)) {
				_maximumWidth = value;
				_maximumWidth.invalidated = false;
				this.applyMaximumWidth();
			}
		}
		
		public function get minimumHeight ( ):DisplayValue { return _minimumHeight; }
		public function set minimumHeight ( value:DisplayValue ):void {
			if(_minimumHeight.invalidated || !_minimumHeight.assertEquals(value)) {
				_minimumHeight = value;
				_minimumHeight.invalidated = false;
				this.applyMinimumHeight();
			}
		}
		
		public function get maximumHeight ( ):DisplayValue { return _maximumHeight; }
		public function set maximumHeight ( value:DisplayValue ):void {
			if(_maximumHeight.invalidated || !_maximumHeight.assertEquals(value)) {
				_maximumHeight = value;
				_maximumHeight.invalidated = false;
				this.applyMaximumHeight();
			}
		}
		
		public function get left ( ):DisplayValue { return _left; }
		public function set left ( value:DisplayValue ):void {
			if(_left.invalidated || !_left.assertEquals(value)) {
				_left = value;
				_left.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get top ( ):DisplayValue { return _top; }
		public function set top ( value:DisplayValue ):void {
			if(_top.invalidated || !_top.assertEquals(value)) {
				_top = value;
				_top.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get right ( ):DisplayValue { return _right; }
		public function set right ( value:DisplayValue ):void {
			if (_right.invalidated || !_right.assertEquals(value)) {
				_right = value;
				_right.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get bottom ( ):DisplayValue { return _bottom; }
		public function set bottom ( value:DisplayValue ):void {
			if (_bottom.invalidated || !_bottom.assertEquals(value)) {
				_bottom = value;
				_bottom.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get margin ( ):DisplayValue { return _margin; }
		public function set margin ( value:DisplayValue ):void {
			_margin = value;
			this.marginLeft = value.clone();
			this.marginTop = value.clone();
			this.marginRight = value.clone();
			this.marginBottom = value.clone();
		}
		
		public function get marginLeft ( ):DisplayValue { return _marginLeft; }
		public function set marginLeft ( value:DisplayValue ):void {
			if(_marginLeft.invalidated || !_marginLeft.assertEquals(value)) {
				_marginLeft = value;
				_marginLeft.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get marginTop ( ):DisplayValue { return _marginTop; }
		public function set marginTop ( value:DisplayValue ):void {
			if(_marginTop.invalidated || !_marginTop.assertEquals(value)) {
				_marginTop = value;
				_marginTop.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get marginRight ( ):DisplayValue { return _marginRight; }
		public function set marginRight ( value:DisplayValue ):void {
			if(_marginRight.invalidated || !_marginRight.assertEquals(value)) {
				_marginRight = value;
				_marginRight.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
		public function get marginBottom ( ):DisplayValue { return _marginBottom; }
		public function set marginBottom ( value:DisplayValue ):void {
			if(_marginBottom.invalidated || !_marginBottom.assertEquals(value)) {
				_marginBottom = value;
				_marginBottom.invalidated = false;
				this.invalidateDisplay();
			}
		}
		
	}

}