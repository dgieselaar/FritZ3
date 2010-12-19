package fritz3.display.text {
	import flash.text.AntiAliasType;
	import flash.text.engine.FontWeight;
	import flash.text.FontStyle;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import fritz3.display.core.PositionableDisplayComponent;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.RectangularBackground;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.display.text.layout.TextLayout;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextComponent extends PositionableDisplayComponent implements Drawable {
		
		protected var _background:Background;
		protected var _layout:Layout;
		protected var _textField:TextField;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _dispatchedWidth:Number = 0;
		protected var _dispatchedHeight:Number = 0;
		
		protected var _padding:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingRight:Number = 0;
		
		protected var _antiAliasType:String = AntiAliasType.NORMAL;
		protected var _autoSize:String = TextFieldAutoSize.NONE;
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
		}
		
		protected function initializeLayout ( ):void {
			
		}
		
		protected function initializeBackground ( ):void {
			this.background = new BoxBackground();
		}
		
		protected function initializeTextField ( ):void {
			this.textField = new TextField();
		}
		
		override protected function setInvalidationMethodOrder():void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.draw, this.dispatchDisplayInvalidation);
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.embedFonts = true;
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
					this.applyPadding();
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
		}
		
		protected function applyWidth ( ):void {
			if (_width != _dispatchedWidth) {
				this.invalidateDisplay();
			}
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).width = _width;
			}
		}
		
		protected function applyHeight ( ):void {
			if (_height != _dispatchedHeight) {
				this.invalidateDisplay();
			}
			if (_background && _background is RectangularBackground) {
				RectangularBackground(_background).height = _height;
			}
		}
		
		protected function applyPadding ( ):void {
			
		}
		
		protected function determineStyleType ( ):void {
			
		}
		
		protected function draw ( ):void {
			_background.draw(this);
		}
		
		override protected function dispatchDisplayInvalidation ( ):void {
			super.dispatchDisplayInvalidation();
			_dispatchedWidth = _width, _dispatchedHeight = _height;
		}
		
		public function invalidateGraphics ( ):void {
			_invalidationHelper.invalidateMethod(this.draw);
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
		
		public function get padding ( ):Number { return _padding; }
		public function set padding ( value:Number ):void {
			if (_padding != value) {
				_padding = _paddingTop = _paddingLeft = _paddingBottom = _paddingRight = value;
				this.applyPadding();
			}
		}
		
		public function get paddingTop ( ):Number { return _paddingTop; }
		public function set paddingTop ( value:Number ):void {
			if (_paddingTop != value) {
				_paddingTop = value;
				this.applyPadding();
			}
		}
		
		public function get paddingLeft ( ):Number { return _paddingLeft; }
		public function set paddingLeft ( value:Number ):void {
			if (_paddingLeft != value) {
				_paddingLeft = value;
				this.applyPadding();
			}
		}
		
		public function get paddingBottom ( ):Number { return _paddingBottom; }
		public function set paddingBottom ( value:Number ):void {
			if (_paddingBottom != value) {
				_paddingBottom = value;
				this.applyPadding();
			}
		}
		
		public function get paddingRight ( ):Number { return _paddingRight; }
		public function set paddingRight ( value:Number ):void {
			if (_paddingRight != value) {
				_paddingRight = value;
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
		
		public function get autoSize ( ):String { return _autoSize; }
		public function set autoSize ( value:String ):void {
			if (_autoSize != value) {
				_autoSize = value;
			}
		}
		
		public function get condenseWhite ( ):Boolean { return _condenseWhite; }
		
		public function set condenseWhite ( value:Boolean ):void {
			if (_condenseWhite != value) {
				_condenseWhite = value;
			}
		}
		
		public function get css ( ):String { return _css; }
		
		public function set css ( value:String ):void {
			if (_css != value) {
				_css = value;
			}
		}
		
		public function get displayAsPassword ( ):Boolean { return _displayAsPassword; }
		
		public function set displayAsPassword ( value:Boolean ):void {
			if (_displayAsPassword != value) {
				_displayAsPassword = value;
			}
		}
		
		public function get embedFonts ( ):Boolean { return _embedFonts; }
		
		public function set embedFonts ( value:Boolean ):void {
			if (_embedFonts != value) {
				_embedFonts = value;
			}
		}
		
		public function get gridFitType ( ):String { return _gridFitType; }
		
		public function set gridFitType ( value:String ):void {
			if (_gridFitType != value) {
				_gridFitType = value;
			}
		}
		
		public function get maxChars ( ):int { return _maxChars; }
		
		public function set maxChars ( value:int ):void {
			if (_maxChars != value) {
				_maxChars = value;
			}
		}
		
		public function get multiline ( ):Boolean { return _multiline; }
		
		public function set multiline ( value:Boolean ):void {
			if (_multiline != value) {
				_multiline = value;
			}
		}
		
		public function get restrict ( ):String { return _restrict; }
		
		public function set restrict ( value:String ):void {
			if (_restrict != value) {
				_restrict = value;
			}
		}
		
		public function get scrollH ( ):int { return _scrollH; }
		
		public function set scrollH ( value:int ):void {
			if (_scrollH != value) {
				_scrollH = value;
			}
		}
		
		public function get scrollV ( ):int { return _scrollV; }
		
		public function set scrollV ( value:int ):void {
			if (_scrollV != value) {
				_scrollV = value;
			}
		}
		
		public function get sharpness ( ):Number { return _sharpness; }
		
		public function set sharpness ( value:Number ):void {
			if (_sharpness != value) {
				_sharpness = value;
			}
		}
		
		public function get text ( ):String { return _text; }
		
		public function set text ( value:String ):void {
			if (_text != value) {
				_text = value;
			}
		}
		
		public function get thickness ( ):Number { return _thickness; }
		
		public function set thickness ( value:Number ):void {
			if (_thickness != value) {
				_thickness = value;
			}
		}
		
		public function get type ( ):String { return _type; }
		
		public function set type ( value:String ):void {
			if (_type != value) {
				_type = value;
			}
		}
		
		public function get wordWrap ( ):Boolean { return _wordWrap; }
		
		public function set wordWrap ( value:Boolean ):void {
			if (_wordWrap != value) {
				_wordWrap = value;
			}
		}
		
		public function get blockIndent ( ):Number { return _blockIndent; }
		
		public function set blockIndent ( value:Number ):void {
			if (_blockIndent != value) {
				_blockIndent = value;
			}
		}
		
		public function get bullet ( ):Boolean { return _bullet; }
		
		public function set bullet ( value:Boolean ):void {
			if (_bullet != value) {
				_bullet = value;
			}
		}
		
		public function get fontFamily ( ):String { return _fontFamily; }
		
		public function set fontFamily ( value:String ):void {
			if (_fontFamily != value) {
				_fontFamily = value;
			}
		}
		
		public function get color ( ):uint { return _color; }
		
		public function set color ( value:uint ):void {
			if (_color != value) {
				_color = value;
			}
		}
		
		public function get fontWeight ( ):String { return _fontWeight; }
		
		public function set fontWeight ( value:String ):void {
			if (_fontWeight != value) {
				_fontWeight = value;
			}
		}
		
		public function get fontSize ( ):Number { return _fontSize; }
		
		public function set fontSize ( value:Number ):void {
			if (_fontSize != value) {
				_fontSize = value;
			}
		}
		
		public function get fontStyle ( ):String { return _fontStyle; }
		
		public function set fontStyle ( value:String ):void {
			if (_fontStyle != value) {
				_fontStyle = value;
			}
		}
		
		public function get indent ( ):Number { return _indent; }
		
		public function set indent ( value:Number ):void {
			if (_indent != value) {
				_indent = value;
			}
		}
		
		public function get letterSpacing ( ):Number { return _letterSpacing; }
		
		public function set letterSpacing ( value:Number ):void {
			if (_letterSpacing != value) {
				_letterSpacing = value;
			}
		}
		
		public function get kerning ( ):Boolean { return _kerning; }
		
		public function set kerning ( value:Boolean ):void {
			if (_kerning != value) {
				_kerning = value;
			}
		}
		
		public function get tabStops ( ):Array { return _tabStops; }
		
		public function set tabStops ( value:Array ):void {
			if (_tabStops != value) {
				_tabStops = value;
			}
		}
		
		public function get target ( ):String { return _target; }
		
		public function set target ( value:String ):void {
			if (_target != value) {
				_target = value;
			}
		}
		
		public function get url ( ):String { return _url; }
		
		public function set url ( value:String ):void {
			if (_url != value) {
				_url = value;
			}
		}
		
		public function get textAlign ( ):String { return _textAlign; }
		
		public function set textAlign ( value:String ):void {
			if (_textAlign != value) {
				_textAlign = value;
			}
		}
		
		public function get textDecoration ( ):String { return _textDecoration; }
		
		public function set textDecoration ( value:String ):void {
			if (_textDecoration != value) {
				_textDecoration = value;
			}
		}
	}

}