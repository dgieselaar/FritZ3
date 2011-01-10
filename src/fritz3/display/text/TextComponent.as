package fritz3.display.text {
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.engine.FontWeight;
	import flash.text.FontStyle;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fritz3.base.parser.PropertyParser;
	import fritz3.base.transition.TransitionData;
	import fritz3.display.core.Cyclable;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.core.MeasurableDisplayComponent;
	import fritz3.display.core.PositionableDisplayComponent;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.RectangularBackground;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.PaddableLayout;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	import fritz3.display.parser.size.SizeParser;
	import fritz3.display.text.layout.TextLayout;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextComponent extends MeasurableDisplayComponent implements Drawable, Rearrangable {
		
		protected var _background:Background;
		protected var _layout:Layout;
		protected var _textField:TextField;
		
		protected var _measuredTextWidth:Number = 0;
		protected var _measuredTextHeight:Number = 0;
		
		protected var _textFieldArray:Array;
		
		protected var _textFormat:TextFormat;
		protected var _styleSheet:StyleSheet;
		
		protected var _padding:DisplayValue = new DisplayValue(0);
		protected var _paddingTop:DisplayValue = new DisplayValue(0);
		protected var _paddingLeft:DisplayValue = new DisplayValue(0);
		protected var _paddingBottom:DisplayValue = new DisplayValue(0);
		protected var _paddingRight:DisplayValue = new DisplayValue(0);
		
		protected var _textStyleType:String = TextStyleType.TEXTFORMAT;
		
		protected var _antiAliasType:String = AntiAliasType.NORMAL;
		protected var _condenseWhite:Boolean = false;
		protected var _css:String;
		protected var _displayAsPassword:Boolean = false;
		protected var _embedFonts:Boolean = false;
		protected var _gridFitType:String = GridFitType.PIXEL;
		protected var _maxChars:int = 0;
		protected var _multiline:Boolean = false;
		protected var _restrict:String = null;
		protected var _scrollH:int;
		protected var _scrollV:int;
		protected var _sharpness:Number = 0;
		protected var _text:String = null;
		protected var _thickness:Number = 0;
		protected var _type:String = TextFieldType.DYNAMIC;
		protected var _wordWrap:Boolean = false;
		
		protected var _blockIndent:Number = 0;
		protected var _bullet:Boolean = false;
		protected var _color:uint;
		protected var _fontFamily:String;
		protected var _fontWeight:String = FontWeight.NORMAL;
		protected var _fontSize:Number = 12;
		protected var _fontStyle:String = FontStyle.REGULAR;
		protected var _indent:Number = 0;
		protected var _letterSpacing:Number = 0;
		protected var _kerning:Boolean = false;
		protected var _tabStops:Array = null;
		protected var _target:String = null;
		protected var _url:String = null;
		protected var _textAlign:String = TextFormatAlign.LEFT;
		protected var _textDecoration:String = TextDecoration.NONE;
		
		public function TextComponent ( parameters:Object = null ) {
			super(parameters);
		}
		
		override protected function initializeDependencies ( ):void {
			super.initializeDependencies();
			this.initializeLayout();
			this.initializeBackground();
			this.initializeTextField();
			this.initializeTextFormatObject();
			this.initializeStyleSheetObject();
		}
		
		override protected function setCyclePhase ( cyclePhase:String ):void {
			super.setCyclePhase(cyclePhase);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cyclePhase = cyclePhase;
			}
			if (_layout && _layout is Cyclable) {
				Cyclable(_layout).cyclePhase = cyclePhase;
			}
		}
		
		override protected function setCycle ( cycle:int ):void {
			super.setCycle(cycle);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cycle = cycle;
			}
			if (_layout && _layout is Cyclable) {
				Cyclable(_layout).cycle = cycle;
			}
		}
		
		override protected function setParsers ( ):void {
			super.setParsers();
			this.addParser("padding", SideParser.parser);
			this.addParser("paddingLeft", SizeParser.parser);
			this.addParser("paddingTop", SizeParser.parser);
			this.addParser("paddingRight", SizeParser.parser);
			this.addParser("paddingBottom", SizeParser.parser);
		}
		
		protected function initializeLayout ( ):void {
			this.layout = new TextLayout();
		}
		
		protected function initializeBackground ( ):void {
			this.background = new BoxBackground();
		}
		
		protected function initializeTextField ( ):void {
			this.textField = new TextField();
		}
		
		protected function initializeTextFormatObject ( ):void {
			_textFormat = new TextFormat();
		}
		
		protected function initializeStyleSheetObject ( ):void {
			_styleSheet = new StyleSheet();
		}
		
		override protected function setInvalidationMethodOrder ( ):void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.parseStyle, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertBefore(this.applyStyle, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertBefore(this.formatTextField, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertBefore(this.rearrange, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertBefore(this.measureDimensions, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertBefore(this.draw, this.dispatchDisplayInvalidation);
		}
		
		override protected function setDefaultProperties ( ):void {
			super.setDefaultProperties();
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.embedFonts = true;
			this.multiline = true;
		}
		
		override public function parseProperty ( propertyName:String, value:* ):void {
			switch(propertyName) {
				default:
				super.parseProperty(propertyName, value);
				break;
				
				case "padding":
				this.parsePadding(propertyName, value);
				break;
				
				case "paddingLeft":
				case "paddingTop":
				case "paddingRight":
				case "paddingBottom":
				this.parseSize(propertyName, value);
				break;
			}
		}
		
		override public function setTransition(propertyName:String, transitionData:TransitionData):void {
			switch(propertyName) {
				default:
				super.setTransition(propertyName, transitionData);
				break;
				
				case "padding":
				super.setTransition("padding", transitionData);
				super.setTransition("paddingLeft", transitionData);
				super.setTransition("paddingTop", transitionData);
				super.setTransition("paddingBottom", transitionData);
				super.setTransition("paddingRight", transitionData);
				break;
			}
		}
		
		protected function parsePadding ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser("padding");
			if (parser) {
				var sideData:SideData = SideData(parser.parseValue(value));
				if (sideData.all) {
					var all:DisplayValue = sideData.all;
					this.cacheParsedProperty("paddingLeft", all.clone());
					this.cacheParsedProperty("paddingTop", all.clone());
					this.cacheParsedProperty("paddingRight", all.clone());
					this.cacheParsedProperty("paddingBottom", all.clone());
				} else {
					this.cacheParsedProperty("paddingLeft", sideData.first.clone());
					this.cacheParsedProperty("paddingTop", sideData.second.clone());
					this.cacheParsedProperty("paddingRight", sideData.third.clone());
					this.cacheParsedProperty("paddingBottom", sideData.fourth.clone());
				}
			}
		}
		
		protected function setBackground ( background:Background ):void {
			if (_background) {
				_background.drawable = null;
			}
			
			this.graphics.clear();
			
			_background = background;
			if (_background) {
				_background.drawable = this;
				if (_background is RectangularBackground) {
					RectangularBackground(_background).width = _width;
					RectangularBackground(_background).height = _height;
				}
				
				if (_background is Cyclable) {
					Cyclable(_background).cyclePhase = _cyclePhase;
					Cyclable(_background).cycle = _cycle;
				}
			}
		}
		
		protected function setLayout ( layout:Layout ):void {
			if (_layout) {
				_layout.rearrangable = null;
			}
			
			_layout = layout;
			if (_layout) {
				_layout.rearrangable = this;
				if (_layout is RectangularLayout) {
					RectangularLayout(_layout).width = _width;
					RectangularLayout(_layout).height = _height;
					RectangularLayout(_layout).autoWidth = _preferredWidth.valueType == DisplayValueType.AUTO;
					RectangularLayout(_layout).autoHeight = _preferredHeight.valueType == DisplayValueType.AUTO;
				}
				this.setLayoutPadding();
				if (_layout is Cyclable) {
					Cyclable(_layout).cyclePhase = _cyclePhase;
					Cyclable(_layout).cycle = _cycle;
				}
			}
		}
		
		protected function setTextField ( textField:TextField ):void {
			if (_textField) {
				this.removeChild(_textField);
			}
			_textField = textField;
			if (_textField) {
				this.addChild(_textField);
			}
			
			_textFieldArray = [ textField ];
		}
		
		protected function parseStyle ( ):void {
			// TODO: convert stylesheet <-> textformat
		}
		
		protected function applyStyle ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textField.defaultTextFormat = _textFormat;
				break;
				
				case TextStyleType.STYLESHEET:
				_textField.styleSheet = _styleSheet;
				break;
			}
		}
		
		protected function formatTextField ( ):void {
			_textField.htmlText = this.getFormattedString();
			
			// TODO: use _width if available
			
			var availableWidth:Number = Math.max(0, _width - _paddingLeft.getComputedValue(_width) - _paddingRight.getComputedValue(_width));
			if (_wordWrap) {
				_textField.wordWrap = false;
				_textField.width = Math.min(_textField.textWidth + 4, availableWidth);
				_textField.wordWrap = true;
			} else {
				_textField.width = Math.min(_textField.textWidth + 4, availableWidth);
			}
			
			var availableHeight:Number = _height - _paddingTop.getComputedValue(_height) - _paddingBottom.getComputedValue(_height);
			_textField.height = Math.min(_textField.textHeight + 6, availableHeight);
			
			var textWidth:Number = _textField.textWidth, textHeight:Number = _textField.textHeight;
			if (textWidth != _measuredTextHeight || textHeight != _measuredTextHeight) {
				_invalidationHelper.invalidateMethod(this.rearrange);
				_invalidationHelper.invalidateMethod(this.measureDimensions);
			}
			
			_measuredTextWidth = textWidth;
			_measuredTextHeight = textHeight;
		}
		
		protected function rearrange ( ):void {
			_layout.rearrange(this, _textFieldArray);
		}
		
		override protected function getMeasuredWidth ( ):Number {
			return _textField.textWidth + 4 + _paddingLeft.getComputedValue(_width) + _paddingRight.getComputedValue(_width);
		}
		
		override protected function getMeasuredHeight ( ):Number {
			return _textField.textHeight + 6 + _paddingTop.getComputedValue(_height) + _paddingBottom.getComputedValue(_height);
		}
		
		protected function draw ( ):void {
			_background.draw(this);
		}
		
		protected function determineStyleType ( ):String {
			var styleType:String = TextStyleType.TEXTFORMAT;
			
			var spanMatch:Array;
			if (_text.indexOf("<span") > 0 || ((spanMatch = _text.match(/<span/)) && spanMatch.length >= 2) || _text.match(/<a(.*?)>/)) {
				styleType = TextStyleType.STYLESHEET;
			}
			
			return styleType;
		}
		
		protected function getFormattedString ( ):String {
			var formattedString:String = _text;
			if (_textStyleType == TextStyleType.STYLESHEET) {
				formattedString = "<p>" + formattedString + "</p>";
			}
			return formattedString;
		}
		
		public function invalidateGraphics ( ):void {
			_invalidationHelper.invalidateMethod(this.draw);
		}
		
		public function invalidateLayout ( ):void {
			_invalidationHelper.invalidateMethod(this.rearrange);
		}
		
		protected function setDependenciesWidth ( ):void {
			if (_layout && _layout is RectangularLayout) {
				var autoWidth:Boolean = _preferredWidth.valueType == DisplayValueType.AUTO;
				RectangularLayout(_layout).autoWidth = autoWidth;
				RectangularLayout(_layout).width = _width;
			}
			
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).width = _width;
			}
		}
		
		protected function setDependenciesHeight ( ):void {
			if (_layout && _layout is RectangularLayout) {
				var autoHeight:Boolean = _preferredHeight.valueType == DisplayValueType.AUTO;
				RectangularLayout(_layout).autoHeight = autoHeight;
				RectangularLayout(_layout).height = _height;
			}
			
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).height = _height;
			}
		}
		
		override protected function applyWidth ( ):void {
			super.applyWidth();
			_invalidationHelper.invalidateMethod(this.formatTextField);
			this.setDependenciesWidth();
		}
		
		override protected function applyHeight ( ):void {
			super.applyHeight();
			_invalidationHelper.invalidateMethod(this.formatTextField);
			
			this.setDependenciesHeight();
		}
		
		protected function applyPadding ( ):void {
			this.setLayoutPadding();
			_invalidationHelper.invalidateMethod(this.measureDimensions);
		}

		protected function setLayoutPadding ( ):void {
			if (_layout && _layout is PaddableLayout) {
				var layout:PaddableLayout = PaddableLayout(_layout);
				layout.paddingLeft = _paddingLeft.getComputedValue(_width);
				layout.paddingTop = _paddingTop.getComputedValue(_height);
				layout.paddingRight = _paddingRight.getComputedValue(_width);
				layout.paddingBottom = _paddingBottom.getComputedValue(_height);
			}
		}		
		
		protected function applyAntiAliasType ( ):void {
			_textField.antiAliasType = _antiAliasType;
		}
		
		protected function applyCondenseWhite ( ):void {
			_textField.condenseWhite = _condenseWhite;
		}
		
		protected function applyCSS ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_styleSheet.clear();
				_styleSheet.parseCSS(_css);
				var style:Object = _styleSheet.getStyle("p");
				for (var id:String in style) {
					switch(id) {
						default:
						this[id] = style[id];
						break;
						
						case "marginLeft":
						case "marginRight":
						break;
						
						case "textIndent":
						this.indent = style[id];
						break;
					}
					this[id] = style[id];
				}
				_styleSheet.clear();
				break;
				
				case TextStyleType.STYLESHEET:
				_styleSheet.clear();
				_styleSheet.parseCSS(_css);
				break;
			}
			
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyDisplayAsPassword ( ):void {
			_textField.displayAsPassword = _displayAsPassword;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyEmbedFonts ( ):void {
			_textField.embedFonts = _embedFonts;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyGridFitType ( ):void {
			_textField.gridFitType = _gridFitType;
		}
		
		protected function applyMaxChars ( ):void {
			_textField.maxChars = _maxChars;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyMultiline ( ):void {
			_textField.multiline = _multiline;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyRestrict ( ):void {
			_textField.restrict = _restrict;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyScrollH ( ):void {
			_textField.scrollH = _scrollH;
		}
		
		protected function applyScrollV ( ):void {
			_textField.scrollV = _scrollV;
		}
		
		protected function applySharpness ( ):void {
			_textField.sharpness = _sharpness;
		}
		
		protected function applyThickness ( ):void {
			_textField.thickness = _thickness;
		}
		
		protected function applyText ( ):void {
			var styleType:String = this.determineStyleType();
			if (_textStyleType != styleType) {
				_textStyleType = styleType;
				_invalidationHelper.invalidateMethod(this.parseStyle);
				_invalidationHelper.invalidateMethod(this.applyStyle);
			}
			
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyType ( ):void {
			_textField.type = _type;
			this.invalidateCollector();
		}
		
		protected function applyWordWrap ( ):void {
			_textField.wordWrap = _wordWrap;
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyBlockIndent ( ):void {
			_textFormat.blockIndent = _blockIndent;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyBullet ( ):void {
			_textFormat.bullet = _bullet;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyFontFamily ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.font = _fontFamily;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.fontFamily = _fontFamily;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyColor ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.color = _color;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.color = _color;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyFontWeight ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.bold = _fontWeight == FontWeight.BOLD;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.fontWeight = _fontWeight;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyFontSize ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.size = _fontSize;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.fontSize = _fontSize;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyFontStyle ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.italic = _fontStyle == FontStyle.ITALIC;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.fontStyle = _fontStyle;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyIndent ( ):void {
			_textFormat.indent = _indent;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyLetterSpacing ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.letterSpacing = _letterSpacing;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.letterSpacing = _letterSpacing;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyKerning ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.kerning = _kerning;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.kerning = _kerning;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyTabStops ( ):void {
			_textFormat.tabStops = _tabStops;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyTarget ( ):void {
			_textFormat.target = _target;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyURL ( ):void {
			_textFormat.target = _target;
			if (_textStyleType == TextStyleType.TEXTFORMAT) {
				_invalidationHelper.invalidateMethod(this.applyStyle);
				_invalidationHelper.invalidateMethod(this.formatTextField);
			}
		}
		
		protected function applyTextAlign ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.align = _textAlign;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.textAlign = _textAlign;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		protected function applyTextDecoration ( ):void {
			switch(_textStyleType) {
				case TextStyleType.TEXTFORMAT:
				_textFormat.underline = _textDecoration == TextDecoration.UNDERLINE;
				break;
				
				case TextStyleType.STYLESHEET:
				var obj:Object = _styleSheet.getStyle("p");
				obj.textDecoration = _textDecoration;
				_styleSheet.setStyle("p", obj);
				break;
			}
			_invalidationHelper.invalidateMethod(this.applyStyle);
			_invalidationHelper.invalidateMethod(this.formatTextField);
		}
		
		override public function get width ( ):Number { return _width; }
		override public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		public function get background ( ):Background { return _background; }
		public function set background ( value:Background ):void {
			if (_background != value) {
				this.setBackground(value);
			}
		}
		
		public function get layout ( ):Layout { return _layout; }
		public function set layout ( value:Layout ):void {
			if (_layout != value) {
				this.setLayout(value);
			}
		}
		
		public function get textField ( ):TextField { return _textField; }
		public function set textField ( value:TextField ):void {
			if (_textField != value) {
				this.setTextField(value);
			}
		}
		
		override public function get height ( ):Number { return _height; }
		override public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
			}
		}
		
		public function get padding ( ):DisplayValue { return _padding; }
		public function set padding ( value:DisplayValue ):void {
			_padding = value;
			this.paddingLeft = value.clone();
			this.paddingTop = value.clone();
			this.paddingRight = value.clone();
			this.paddingBottom = value.clone();
		}
		
		public function get paddingLeft ( ):DisplayValue { return _paddingLeft; }
		public function set paddingLeft ( value:DisplayValue ):void {
			if (_paddingLeft.invalidated || !_paddingLeft.assertEquals(value)) {
				_paddingLeft = value;
				_paddingLeft.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingTop ( ):DisplayValue { return _paddingTop; }
		public function set paddingTop ( value:DisplayValue ):void {
			if (_paddingTop.invalidated || !_paddingTop.assertEquals(value)) {
				_paddingTop = value;
				_paddingTop.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingRight ( ):DisplayValue { return _paddingRight; }
		public function set paddingRight ( value:DisplayValue ):void {
			if (_paddingRight.invalidated || ! _paddingRight.assertEquals(value)) {
				_paddingRight = value;
				_paddingRight.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingBottom ( ):DisplayValue { return _paddingBottom; }
		public function set paddingBottom ( value:DisplayValue ):void {
			if (_paddingBottom.invalidated || !_paddingBottom.assertEquals(value)) {
				_paddingBottom = value;
				_paddingBottom.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get antiAliasType ( ):String { return _antiAliasType; }
		public function set antiAliasType ( value:String ):void {
			if (_antiAliasType != value) {
				_antiAliasType = value;
				this.applyAntiAliasType();
			}
		}
		
		public function get condenseWhite ( ):Boolean { return _condenseWhite; }
		public function set condenseWhite ( value:Boolean ):void {
			if (_condenseWhite != value) {
				_condenseWhite = value;
				this.applyCondenseWhite();
			}
		}
		
		public function get css ( ):String { return _css; }
		public function set css ( value:String ):void {
			if (_css != value) {
				_css = value;
				this.applyCSS();
			}
		}
		
		public function get displayAsPassword ( ):Boolean { return _displayAsPassword; }
		public function set displayAsPassword ( value:Boolean ):void {
			if (_displayAsPassword != value) {
				_displayAsPassword = value;
				this.applyDisplayAsPassword();
			}
		}
		
		public function get embedFonts ( ):Boolean { return _embedFonts; }
		public function set embedFonts ( value:Boolean ):void {
			if (_embedFonts != value) {
				_embedFonts = value;
				this.applyEmbedFonts();
			}
		}
		
		public function get gridFitType ( ):String { return _gridFitType; }
		public function set gridFitType ( value:String ):void {
			if (_gridFitType != value) {
				_gridFitType = value;
				this.applyGridFitType();
			}
		}
		
		public function get maxChars ( ):int { return _maxChars; }
		public function set maxChars ( value:int ):void {
			if (_maxChars != value) {
				_maxChars = value;
				this.applyMaxChars();
			}
		}
		
		public function get multiline ( ):Boolean { return _multiline; }
		public function set multiline ( value:Boolean ):void {
			if (_multiline != value) {
				_multiline = value;
				this.applyMultiline();
			}
		}
		
		public function get restrict ( ):String { return _restrict; }
		public function set restrict ( value:String ):void {
			if (_restrict != value) {
				_restrict = value;
				this.applyRestrict();
			}
		}
		
		public function get scrollH ( ):int { return _scrollH; }
		public function set scrollH ( value:int ):void {
			if (_scrollH != value) {
				_scrollH = value;
				this.applyScrollH();
			}
		}
		
		public function get scrollV ( ):int { return _scrollV; }
		public function set scrollV ( value:int ):void {
			if (_scrollV != value) {
				_scrollV = value;
				this.applyScrollV();
			}
		}
		
		public function get sharpness ( ):Number { return _sharpness; }
		public function set sharpness ( value:Number ):void {
			if (_sharpness != value) {
				_sharpness = value;
				this.applySharpness();
			}
		}
		
		public function get text ( ):String { return _text; }
		public function set text ( value:String ):void {
			if (_text != value) {
				_text = value;
				this.applyText();
			}
		}
		
		public function get thickness ( ):Number { return _thickness; }
		public function set thickness ( value:Number ):void {
			if (_thickness != value) {
				_thickness = value;
				this.applyThickness();
			}
		}
		
		public function get type ( ):String { return _type; }
		public function set type ( value:String ):void {
			if (_type != value) {
				_type = value;
				this.applyType();
			}
		}
		
		public function get wordWrap ( ):Boolean { return _wordWrap; }
		public function set wordWrap ( value:Boolean ):void {
			if (_wordWrap != value) {
				_wordWrap = value;
				this.applyWordWrap();
			}
		}
		
		public function get blockIndent ( ):Number { return _blockIndent; }
		public function set blockIndent ( value:Number ):void {
			if (_blockIndent != value) {
				_blockIndent = value;
				this.applyBlockIndent();
			}
		}
		
		public function get bullet ( ):Boolean { return _bullet; }
		public function set bullet ( value:Boolean ):void {
			if (_bullet != value) {
				_bullet = value;
				this.applyBullet();
			}
		}
		
		public function get fontFamily ( ):String { return _fontFamily; }
		public function set fontFamily ( value:String ):void {
			if (_fontFamily != value) {
				_fontFamily = value;
				this.applyFontFamily();
			}
		}
		
		public function get color ( ):uint { return _color; }
		public function set color ( value:uint ):void {
			if (_color != value) {
				_color = value;
				this.applyColor();
			}
		}
		
		public function get fontWeight ( ):String { return _fontWeight; }
		public function set fontWeight ( value:String ):void {
			if (_fontWeight != value) {
				_fontWeight = value;
				this.applyFontWeight();
			}
		}
		
		public function get fontSize ( ):Number { return _fontSize; }
		public function set fontSize ( value:Number ):void {
			if (_fontSize != value) {
				_fontSize = value;
				this.applyFontSize();
			}
		}
		
		public function get fontStyle ( ):String { return _fontStyle; }
		public function set fontStyle ( value:String ):void {
			if (_fontStyle != value) {
				_fontStyle = value;
				this.applyFontStyle();
			}
		}
		
		public function get indent ( ):Number { return _indent; }
		public function set indent ( value:Number ):void {
			if (_indent != value) {
				_indent = value;
				this.applyIndent();
			}
		}
		
		public function get letterSpacing ( ):Number { return _letterSpacing; }
		public function set letterSpacing ( value:Number ):void {
			if (_letterSpacing != value) {
				_letterSpacing = value;
				this.applyLetterSpacing();
			}
		}
		
		public function get kerning ( ):Boolean { return _kerning; }
		public function set kerning ( value:Boolean ):void {
			if (_kerning != value) {
				_kerning = value;
				this.applyKerning();
			}
		}
		
		public function get tabStops ( ):Array { return _tabStops; }
		public function set tabStops ( value:Array ):void {
			if (_tabStops != value) {
				_tabStops = value;
				this.applyTabStops();
			}
		}
		
		public function get target ( ):String { return _target; }
		public function set target ( value:String ):void {
			if (_target != value) {
				_target = value;
				this.applyTarget();
			}
		}
		
		public function get url ( ):String { return _url; }
		public function set url ( value:String ):void {
			if (_url != value) {
				_url = value;
				this.applyURL();
			}
		}
		
		public function get textAlign ( ):String { return _textAlign; }
		public function set textAlign ( value:String ):void {
			if (_textAlign != value) {
				_textAlign = value;
				this.applyTextAlign();
			}
		}
		
		public function get textDecoration ( ):String { return _textDecoration; }
		public function set textDecoration ( value:String ):void {
			if (_textDecoration != value) {
				_textDecoration = value;
				this.applyTextDecoration();
			}
		}
		
	}

}