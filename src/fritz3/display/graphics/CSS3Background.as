package fritz3.display.graphics {
	import fritz3.base.injection.IInjectable;
	import fritz3.base.parser.IParsable;
	import fritz3.base.parser.IPropertyParser;
	import fritz3.base.parser.ParseHelper;
	import fritz3.base.transition.ITransitionable;
	import fritz3.base.transition.TransitionData;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.core.ICyclable;
	import fritz3.display.graphics.IDrawable;
	import flash.display.DisplayObject;
	import fritz3.display.graphics.parser.border.BorderRadiusCornerParser;
	import fritz3.display.graphics.parser.border.BorderRadiusData;
	import fritz3.display.graphics.parser.border.BorderRadiusParser;
	import fritz3.display.graphics.parser.color.ColorData;
	import fritz3.display.graphics.parser.color.ColorParser;
	import fritz3.display.parser.side.SideParser;
	import fritz3.style.PropertyData;
	import fritz3.utils.object.IReleasable;
	
	/**
	 * ...31
	 * @author Dario Gieselaar
	 */
	public class CSS3Background implements IRectangularBackground, IParsable, IInjectable, ITransitionable, ICyclable, IReleasable {
		
		protected var _drawable:IDrawable;
		
		protected var _parameters:Object;
		protected var _parsers:Object = { };
		
		protected var _parseHelper:ParseHelper;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _backgroundColor:ColorValue = new ColorValue();
		
		protected var _borderRadius:BorderRadiusValue = new BorderRadiusValue();
		protected var _borderTopLeftRadius:BorderRadiusValue = new BorderRadiusValue();
		protected var _borderTopRightRadius:BorderRadiusValue = new BorderRadiusValue();
		protected var _borderBottomRightRadius:BorderRadiusValue = new BorderRadiusValue();
		protected var _borderBottomLeftRadius:BorderRadiusValue = new BorderRadiusValue();
		
		protected var _borderWidth:DisplayValue = new DisplayValue();
		protected var _borderTopWidth:DisplayValue = new DisplayValue();
		protected var _borderLeftWidth:DisplayValue = new DisplayValue();
		protected var _borderBottomWidth:DisplayValue = new DisplayValue();
		protected var _borderRightWidth:DisplayValue = new DisplayValue();
		
		protected var _borderColor:ColorValue = new ColorValue();
		protected var _borderTopColor:ColorValue = new ColorValue();
		protected var _borderLeftColor:ColorValue = new ColorValue();
		protected var _borderBottomColor:ColorValue = new ColorValue();
		protected var _borderRightColor:ColorValue = new ColorValue();
		
		public function CSS3Background ( parameters:Object = null ) {
			_parameters = parameters || { };
			_parseHelper = new ParseHelper();
			this.setParsers();
			this.setDefaultValues();
			this.applyParameters();
		}
		
		protected function setParsers ( ):void {
			this.addParser("width", SideParser.parser);
			this.addParser("height", SideParser.parser);
			this.addParser("backgroundColor", ColorParser.parser);
			this.addParser("borderRadius", BorderRadiusParser.parser);
			this.addParser("borderTopLeftRadius", BorderRadiusCornerParser.parser);
			this.addParser("borderTopRightRadius", BorderRadiusCornerParser.parser);
			this.addParser("borderBottomRightRadius", BorderRadiusCornerParser.parser);
			this.addParser("borderBottomLeftRadius", BorderRadiusCornerParser.parser);
			//this.addParser("borderColor", ColorParser.parser);
		}
		
		protected function addParser ( propertyName:String, parser:IPropertyParser ):void {
			if (_parsers[propertyName]) {
				this.removeParser(propertyName, IPropertyParser(_parsers[propertyName]));
			}
			_parsers[propertyName] = parser;
		}
		
		protected function removeParser ( propertyName:String, parser:IPropertyParser ):void {
			delete _parsers[propertyName];
		}
		
		protected function getParser ( propertyName:String, parser:IPropertyParser ):IPropertyParser {
			return _parsers[propertyName];
		}
		
		protected function setDefaultValues ( ):void {
			this.backgroundColor = new ColorValue(0x000000, 1, true);
			this.width = 0;
			this.height = 0;
			this.backgroundWidth = new DisplayValue(100, DisplayValueType.PERCENTAGE);
			this.backgroundHeight = new DisplayValue(100, DisplayValueType.PERCENTAGE);
			this.borderRadius = new BorderRadiusValue();
			this.borderWidth = BorderWidth.MEDIUM.clone();
		}
		
		protected function applyParameters ( ):void {
			var parameters:Object = _parameters;
			for (var propertyName:String in parameters) {
				this.parseProperty(propertyName, parameters[propertyName]);
			}
			this.applyParsedProperties();
		}
		
		public function setTransition ( propertyName:String, transitionData:TransitionData ):void {
			switch(propertyName) {
				default:
				_transitions[propertyName] = transitionData;
				break;
				
				case "opacity":
				this.setTransition("alpha", transitionData);
				break;
				
				case "borderRadius":
				this.setTransition("borderTopLeftRadius", transitionData);
				this.setTransition("borderTopRightRadius", transitionData);
				this.setTransition("borderBottomRightRadius", transitionData);
				this.setTransition("borderBottomLeftRadius", transitionData);
				break;
			}
		}
		
		public function parseProperty ( propertyName:String, value:* ):void {
			switch(propertyName) {
				default:
				this.cacheProperty(propertyName, value);
				break;
				
				case "opacity":
				this.cacheProperty("alpha", value);
				break;
				
				case "backgroundColor":
				this.parseBackgroundColor(value);
				break;
				
				case "borderRadius": case "borderTopLeftRadius": case "borderTopRightRadius": case "borderBottomRightRadius": case "borderBottomLeftRadius":
				this.parseBorderRadius(propertyName, value);
				break;
				
				/*case "borderColor":
				this.parseBorderColor(value);
				break;*/
			}
		}
		
		protected function cacheProperty ( propertyName:String, value:* ):void {
			_parseHelper.setProperty(propertyName, value);
		}
		
		public function setProperty ( propertyName:String, value:* ):void {
			_parameters[propertyName] = value;
			switch(propertyName) {
				default:
				this[propertyName] = value;
				break;
			}
		}
		
		public function applyParsedProperties ( ):void {
			var node:PropertyData = _parseHelper.firstNode;
			while (node) {
				this.setProperty(node.propertyName, node.value);
				node = node.nextNode;
			}
			_parseHelper.reset();
		}
		
		protected function parseBackgroundColor ( value:String ):void {
			var colorData:ColorValue = (this.getParser("backgroundColor") as IPropertyParser).parseValue(value) as ColorValue);
			this.cacheProperty("backgroundColor", colorData.clone());
		}
		
		protected function parseBorderRadius ( propertyName:String, value:String ):void {
			var parser:IPropertyParser;
			switch(propertyName) {
				case "borderRadius":
				parser = this.getParser("borderRadius");
				var borderRadiusData:BorderRadiusData = parser.parseValue(value) as BorderRadiusData;
				this.cacheProperty("borderTopLeftRadius", borderRadiusData.topLeft);
				this.cacheProperty("borderTopRightRadius", borderRadiusData.topRight);
				this.cacheProperty("borderBottomRightRadius", borderRadiusData.bottomRight);
				this.cacheProperty("borderBottomLeftRadius", borderRadiusData.bottomLeft);
				break;
				
				default:
				parser = this.getParser(propertyName);
				this.cacheProperty(propertyName, BorderRadiusValue(parser.parseValue(value)));
				break;
			}
		}
		
		/*protected function parseBorderColor ( value:String ):void {
			var colorData:ColorData = (this.getParser("borderColor") as IPropertyParser).parseValue(value) as ColorData);
			// TODO: implement border color
		}*/
		
		public function invalidateGraphics ( ):void {
			if (_drawable) {
				_drawable.invalidateGraphics();
			}
		}
		
		public function draw ( displayObject:DisplayObject ):void {
			
		}
		
		protected function setDrawable ( value:IDrawable ):void {
			if (_drawable) {
				
			}
			
			_drawable = value;
			if (_drawable) {
				
			}
		}
		
		protected function applyWidth ( ):void {
			this.invalidateGraphics();
		}
		
		protected function applyHeight ( ):void {
			this.invalidateGraphics();
		}
		
		public function releaseObject ( ):void {
			
			for (var id:String in _parsers) {
				this.removeParser(id, _parsers[id]);
			}
			
			_width = 0;
			_height = 0;
			_parameters = { };
			this.drawable = null;
			_parseHelper.reset();
			
		}
		
		public function get width ( ):Number { return _width; }
		public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		public function get height ( ):Number { return _height; }
		public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
			}
		}
		
		public function get transparent ( ):Boolean { return _transparent; }
		public function set transparent ( value:Boolean ):void {
			if (_transparent != value) {
				_transparent = value;
				this.invalidateGraphics();
			}
		}
		
		public function get backgroundAlpha ( ):Boolean { return _backgroundAlpha; }
		public function set backgroundAlpha ( value:Boolean ):void {
			if (_backgroundAlpha != value) {
				_backgroundAlpha = value;
				this.invalidateGraphics();
			}
		}
		
		public function get backgroundColor ( ):uint { return _backgroundColor; }
		public function set backgroundColor ( value:uint ):void {
			if (_backgroundColor != value) {
				_backgroundColor = value;
				this.invalidateGraphics();
			}
		}
		
		public function get borderRadius ( ):BorderRadiusValue { return _borderRadius; }
		public function set borderRadius ( value:BorderRadiusValue ):void {
			if (_borderRadius.invalidateWith(value)) {
				_borderTopLeftRadius.invalidateWith(value);
				_borderTopRightRadius.invalidateWith(value);
				_borderBottomRightRadius.invalidateWith(value);
				_borderBottomLeftRadius.invalidateWith(value);
				this.invalidateGraphics();
			}
		}
		
		public function get borderTopLeftRadius ( ):BorderRadiusValue { return _borderTopLeftRadius; }
		public function set borderTopLeftRadius ( value:BorderRadiusValue ):void {
			if (_borderTopLeftRadius.invalidateWith(value)) {
				_borderRadius.horizontalRadius.setValue(NaN, null);
				_borderRadius.verticalRadius.setValue(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderTopRightRadius ( ):BorderRadiusValue { return _borderTopRightRadius; }
		public function set borderTopRightRadius ( value:BorderRadiusValue ):void {
			if (_borderTopRightRadius.invalidateWith(value)) {
				_borderRadius.horizontalRadius.setValue(NaN, null);
				_borderRadius.verticalRadius.setValue(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderBottomRightRadius ( ):BorderRadiusValue { return _borderBottomRightRadius; }
		public function set borderBottomRightRadius ( value:BorderRadiusValue ):void {
			if (_borderBottomRightRadius.invalidateWith(value)) {
				_borderRadius.horizontalRadius.setValue(NaN, null);
				_borderRadius.verticalRadius.setValue(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderBottomLeftRadius ( ):BorderRadiusValue { return _borderBottomLeftRadius; }
		public function set borderBottomLeftRadius ( value:BorderRadiusValue ):void {
			if (_borderBottomLeftRadius.invalidateWith(value)) {
				_borderRadius.horizontalRadius.setValue(NaN, null);
				_borderRadius.verticalRadius.setValue(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderWidth ( ):DisplayValue { return _borderWidth; }
		public function set borderWidth ( value:DisplayValue ):void {
			if (_borderWidth.invalidateWith(value)) {
				_borderTopWidth.invalidateWith(value);
				_borderLeftWidth.invalidateWith(value);
				_borderBottomWidth.invalidateWith(value);
				_borderRightWidth.invalidateWith(value);
				this.invalidateGraphics();
			}
		}
		
		public function get borderTopWidth ( ):DisplayValue { return _borderTopWidth; }
		public function set borderTopWidth ( value:DisplayValue ):void {
			if (_borderTopWidth.invalidateWith(value)) {
				_borderWidth.setAll(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderLeftWidth ( ):DisplayValue { return _borderLeftWidth; }
		public function set borderLeftWidth ( value:DisplayValue ):void {
			if (_borderLeftWidth.invalidateWith(value)) {
				_borderWidth.setAll(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderBottomWidth ( ):DisplayValue { return _borderBottomWidth; }
		public function set borderBottomWidth ( value:DisplayValue ):void {
			if (_borderBottomWidth.invalidateWidth(value)) {
				_borderWidth.setAll(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get borderRightWidth ( ):DisplayValue { return _borderRightWidth; }
		public function set borderRightWidth ( value:DisplayValue ):void {
			if (_borderRightWidth.invalidateWith(value)) {
				_borderWidth.setAll(NaN, null);
				this.invalidateGraphics();
			}
		}
		
		public function get drawable ( ):IDrawable { return _drawable;
		public function set drawable ( value:IDrawable ):void {
			if (_drawable != value) {
				this.setDrawable(value);
			}
		}
	
	}

}