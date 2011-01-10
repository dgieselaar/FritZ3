package fritz3.display.graphics {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fritz3.base.injection.Injectable;
	import fritz3.base.parser.Parsable;
	import fritz3.base.parser.ParseHelper;
	import fritz3.base.parser.PropertyParser;
	import fritz3.base.transition.Transitionable;
	import fritz3.base.transition.TransitionData;
	import fritz3.base.transition.TransitionType;
	import fritz3.display.core.Cyclable;
	import fritz3.display.core.CyclePhase;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.gradient.GraphicsGradientColor;
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	import fritz3.display.graphics.parser.border.BorderData;
	import fritz3.display.graphics.parser.border.BorderParser;
	import fritz3.display.graphics.parser.gradient.GradientParser;
	import fritz3.display.graphics.parser.position.BackgroundPositionData;
	import fritz3.display.graphics.parser.position.BackgroundPositionParser;
	import fritz3.display.graphics.parser.repeat.BackgroundRepeatData;
	import fritz3.display.graphics.parser.repeat.BackgroundRepeatParser;
	import fritz3.display.graphics.parser.size.BackgroundSizeData;
	import fritz3.display.graphics.parser.size.BackgroundSizeParser;
	import fritz3.display.graphics.utils.getGradientMatrix;
	import fritz3.display.layout.Align;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	import fritz3.display.parser.size.SizeParser;
	import fritz3.invalidation.Invalidatable;
	import fritz3.style.PropertyData;
	import fritz3.utils.assets.AssetLoader;
	import fritz3.utils.assets.image.ImageAssetLoader;
	import fritz3.utils.assets.image.ImageAssetManager;
	import fritz3.utils.color.ColorUtil;
	import fritz3.utils.math.MathUtil;
	import fritz3.utils.object.getClass;
	import fritz3.utils.object.ObjectPool;
	import fritz3.utils.tween.hasTween;
	import fritz3.utils.tween.removeTween;
	import fritz3.utils.tween.tween;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BoxBackground implements RectangularBackground, Parsable, Injectable, Transitionable, Cyclable {
		
		protected var _drawable:Drawable;
		protected var _parameters:Object;
		
		protected var _parseHelper:ParseHelper;
		protected var _parsers:Object = { };
		
		protected var _transitions:Object = { };
		
		protected var _cyclePhase:String = CyclePhase.CONSTRUCTED;
		protected var _cycle:int;
		
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _backgroundColor:Object;
		protected var _backgroundAlpha:Number = 1;
		protected var _backgroundGradient:GraphicsGradientData;
		
		protected var _fillType:String = FillType.RECTANGLE;
		
		protected var _roundedCorners:Number = 0;
		protected var _topLeftCorner:Number = 0;
		protected var _topRightCorner:Number = 0;
		protected var _bottomLeftCorner:Number = 0;
		protected var _bottomRightCorner:Number = 0;
		
		protected var _border:Border;
		protected var _borderLeft:Border;
		protected var _borderTop:Border;
		protected var _borderRight:Border;
		protected var _borderBottom:Border;
		
		protected var _backgroundImage:DisplayObject;
		protected var _backgroundImageAlpha:Number = 1;
		
		protected var _backgroundImageHorizontalFloat:String = Align.LEFT;
		protected var _backgroundImageVerticalFloat:String = Align.TOP;
		
		protected var _backgroundImageOffsetX:DisplayValue = new DisplayValue(0);
		protected var _backgroundImageOffsetY:DisplayValue = new DisplayValue(0);
		
		protected var _backgroundImageWidth:DisplayValue = new DisplayValue(0, DisplayValueType.AUTO);
		protected var _backgroundImageHeight:DisplayValue = new DisplayValue(0, DisplayValueType.AUTO);
		
		protected var _backgroundImageScaleMode:String = BackgroundImageScaleMode.NONE;
		
		protected var _backgroundImageRepeatX:String;
		protected var _backgroundImageRepeatY:String;
		protected var _backgroundImageScaleGrid:Rectangle;
		protected var _backgroundImageColor:Object;
		protected var _backgroundImageAntiAliasing:Boolean = false;
		
		protected var _backgroundImageURL:String;
		protected var _backgroundImageLoader:ImageAssetLoader;
		
		protected var _graphics:Graphics;
		
		protected var _backgroundImageInvalidated:Boolean;
		protected var _backgroundBitmapData:BitmapData;
		
		protected var _linePatternData:BitmapData;
		
		public function BoxBackground ( parameters:Object = null ) {
			_parameters = parameters;
			_parseHelper = new ParseHelper();
			this.setParsers()
			this.setDefaultProperties();
			this.applyParameters();
		}
		
		protected function setParsers ( ):void {
			this.addParser("backgroundPosition", BackgroundPositionParser.parser);
			this.addParser("backgroundSize", BackgroundSizeParser.parser);
			this.addParser("backgroundRepeat", BackgroundRepeatParser.parser);
			this.addParser("backgroundGradient", GradientParser.parser);
			this.addParser("border", BorderParser.parser);
			this.addParser("borderGradient", GradientParser.parser);
			this.addParser("roundedCorners", SideParser.parser);
			this.addParser("topLeftCorner", SizeParser.parser);
			this.addParser("topRightCorner", SizeParser.parser);
			this.addParser("bottomLeftCorner", SizeParser.parser);
			this.addParser("bottomRightCorner", SizeParser.parser);
			this.addParser("backgroundImageOffsetX", SizeParser.parser);
			this.addParser("backgroundImageOffsetY", SizeParser.parser);
			this.addParser("backgroundImageWidth", SizeParser.parser);
			this.addParser("backgroundImageHeight", SizeParser.parser);
		}
		
		protected function addParser ( propertyName:String, parser:PropertyParser ):void {
			if (_parsers[propertyName]) {
				this.removeParser(propertyName, PropertyParser(_parsers[propertyName]));
			}
			_parsers[propertyName] = parser;
		}
		
		protected function removeParser ( propertyName:String, parser:PropertyParser ):void {
			delete _parsers[propertyName];
		}
		
		protected function getParser ( propertyName:String ):PropertyParser {
			return _parsers[propertyName];
		}
		
		protected function setDefaultProperties ( ):void {
			_border = new Border();
			_border.borderSize = 0;
			_border.borderColor = 0x000000;
			_border.borderAlpha = 1;
			_border.borderLineStyle = LineStyle.SOLID;
			_border.borderPosition = BorderPosition.CENTER;
			_borderLeft = _border.clone();
			_borderTop = _border.clone();
			_borderRight = _border.clone();
			_borderBottom  = _border.clone();
		}
		
		protected function applyParameters ( ):void {
			for (var name:String in _parameters) {
				this.parseProperty(name, _parameters[name]);
			}
			this.applyParsedProperties();
		}
		
		public function draw ( displayObject:DisplayObject ):void {
			var buffer:Shape;
			if (displayObject is Shape) {
				_graphics = Shape(displayObject).graphics;
			} else if (displayObject is Sprite) {
				_graphics = Sprite(displayObject).graphics;
			} else {
				buffer = Shape(ObjectPool.getObject(Shape));
				_graphics = buffer.graphics;
			}
			
			_graphics.clear();
			
			this.drawBackground();
			this.drawBackgroundImage();
			this.drawBorder();
			
			_graphics = null;
			if (buffer) {
				ObjectPool.releaseObject(buffer);
			}
		}
		
		protected function drawBackground ( ):void {
			
			if (_backgroundColor != null) {
				var backgroundColor:uint = uint(_backgroundColor);
				_graphics.beginFill(backgroundColor, _backgroundAlpha);
				this.drawOutline();
				_graphics.endFill();
			}
			
			if (_backgroundGradient != null) {
				var ratios:Array = _backgroundGradient.getRatios(_width, _height);
				var focalPointRatio:Number = _backgroundGradient.getFocalPointRatio(_width, _height);
				_graphics.beginGradientFill(_backgroundGradient.type, _backgroundGradient.colors, _backgroundGradient.alphas, ratios, getGradientMatrix(_width, _height, _backgroundGradient.angle), SpreadMethod.PAD, InterpolationMethod.RGB, focalPointRatio);
				this.drawOutline();
				_graphics.endFill();
			}
			
		}
		
		protected function drawBorder ( ):void {
			
			if (_fillType != FillType.RECTANGLE || (_border.isEqualTo(_borderLeft) && _border.isEqualTo(_borderTop) && _border.isEqualTo(_borderRight) && _border.isEqualTo(_borderBottom))) {
				this.drawSingleBorder();
			} else {
				this.drawSeparateBorders();
			}
		}
		
		protected function drawSingleBorder ( ):void {
			var borderSize:Number = _border.borderSize;
			
			if (!borderSize) {
				return;
			}
			
			var offset:Number = this.getBorderOffset(borderSize, _border.borderPosition);
			
			var x:Number = -offset, y:Number = -offset, width:Number = _width + 2 * offset, height:Number = _height + 2 * offset;
			
			if (_border.borderLineStyle == LineStyle.SOLID) {
				if (_border.borderColor != null) {
					this.setLineStyle(_border);
					this.drawOutline(x, y, width, height);
				}
				if (_border.borderGradient) {
					this.setLineGradientStyle(_border);
					this.drawOutline(x, y, width, height);
				}
			}
			// TODO: implement line styles
			/*else {
				this.setLinePatternStyle(_border);			
				this.drawOutline(x, y, width, height);
			}*/
			
			_graphics.lineStyle();
			
		}
		
		protected function drawSeparateBorders ( ):void {
			if (_borderLeft.borderSize) {
				if (_borderLeft.borderColor != null) {
					this.setLineStyle(_borderLeft, true);
					this.drawLeftBorder();
					_graphics.endFill();
				}
				if (_borderLeft.borderGradient) {
					this.setLineGradientStyle(_borderLeft, true);
					this.drawLeftBorder();
					_graphics.endFill();
				}
			}
			
			if (_borderTop.borderSize) {
				if (_borderTop.borderColor != null) {
					this.setLineStyle(_borderTop, true);
					this.drawTopBorder();
					_graphics.endFill();
				}
				if (_borderTop.borderGradient) {
					this.setLineGradientStyle(_borderTop, true);
					this.drawTopBorder();
					_graphics.endFill();
				}
			}
			
			if (_borderRight.borderSize) {
				if (_borderRight.borderColor != null) {
					this.setLineStyle(_borderRight, true);
					this.drawRightBorder();
					_graphics.endFill();
				}
				if (_borderRight.borderGradient) {
					this.setLineGradientStyle(_borderRight, true);
					this.drawRightBorder();
					_graphics.endFill();
				}
			}
			
			if (_borderBottom.borderSize) {
				if (_borderBottom.borderColor != null) {
					this.setLineStyle(_borderBottom, true);
					this.drawBottomBorder();
					_graphics.endFill();
				}
				if (_borderBottom.borderGradient) {
					this.setLineGradientStyle(_borderBottom, true);
					this.drawBottomBorder();
					_graphics.endFill();
				}
			}
			
			
		}
		
		protected function drawLeftBorder ( ):void {
			var graphics:Graphics = _graphics;
			var borderSize:Number = _borderLeft.borderSize;
			var position:String = _borderLeft.borderPosition;
			var width:Number = borderSize, height:Number = _height;
			var x:Number, y:Number;
			switch(position) {
				case BorderPosition.INSIDE:
				x = y = 0;
				break;
				
				case BorderPosition.CENTER:
				x = y = -borderSize / 2;
				height += borderSize;
				break;
				
				case BorderPosition.OUTSIDE:
				x = y = -borderSize;
				height += borderSize * 2;
				break;
			}
			
			
			var topLeftCorner:Number = _topLeftCorner;
			var bottomLeftCorner:Number = _bottomLeftCorner;
			
			var from:Point = new Point(), to:Point = new Point(), cp:Point = new Point();
			
			var leftBorderOffset:Number = this.getBorderOffset(_borderLeft.borderSize, _borderLeft.borderPosition, true);
			var topBorderOffset:Number = this.getBorderOffset(_borderTop.borderSize, _borderTop.borderPosition, true);
			var bottomBorderOffset:Number = this.getBorderOffset(_borderBottom.borderSize, _borderBottom.borderPosition, true);
			
			if(!topLeftCorner) {
				graphics.moveTo(x, -topBorderOffset);
				graphics.lineTo(x + width, -topBorderOffset + _borderTop.borderSize);
				graphics.lineTo(x + width, _height/2);
				graphics.lineTo(x, _height/2);
				graphics.lineTo(x, -topBorderOffset);
			} else {
				graphics.moveTo(x, _height/2);
				from.x = x, from.y = topLeftCorner;
				to.x = topLeftCorner, to.y = -topBorderOffset;
				cp.x = from.x, cp.y = to.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, topLeftCorner, _borderLeft.borderSize, _borderTop.borderSize, "horizontal", false, false);
				graphics.lineTo(x + width, _height / 2);
				graphics.lineTo(x, _height / 2);
			}
			
			if (!bottomLeftCorner) {
				graphics.moveTo(x, _height + bottomBorderOffset);
				graphics.lineTo(x + width, _height - y - _borderBottom.borderSize);
				graphics.lineTo(x + width, _height / 2);
				graphics.lineTo(x, _height / 2);
				graphics.lineTo(x, _height + bottomBorderOffset);
			} else {
				graphics.moveTo(x, _height/2);
				from.x = x, from.y = _height - bottomLeftCorner;
				to.x = bottomLeftCorner, to.y = _height + bottomBorderOffset;
				cp.x = from.x, cp.y = to.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, bottomLeftCorner, _borderLeft.borderSize, _borderBottom.borderSize, "horizontal", false, true);
				graphics.lineTo(x + width, _height / 2);
				graphics.lineTo(x, _height / 2);
			}
		}
		
		protected function drawTopBorder ( ):void {
			var graphics:Graphics = _graphics;
			var borderSize:Number = _borderTop.borderSize;
			var position:String = _borderTop.borderPosition;
			var width:Number = _width, height:Number = borderSize;
			var x:Number, y:Number;
			switch(position) {
				case BorderPosition.INSIDE:
				x = y = 0;
				break;
				
				case BorderPosition.CENTER:
				x = y = -borderSize / 2;
				width += borderSize;
				break;
				
				case BorderPosition.OUTSIDE:
				x = y = -borderSize;
				width += borderSize * 2;
				break;
			}
			
			
			var topLeftCorner:Number = _topLeftCorner;
			var topRightCorner:Number = _topRightCorner;
			
			var from:Point = new Point(), to:Point = new Point(), cp:Point = new Point();
			
			var leftBorderOffset:Number = this.getBorderOffset(_borderLeft.borderSize, _borderLeft.borderPosition, true);
			var topBorderOffset:Number = this.getBorderOffset(_borderTop.borderSize, _borderTop.borderPosition, true);
			var rightBorderOffset:Number = this.getBorderOffset(_borderRight.borderSize, _borderRight .borderPosition, true);
			
			if (!topLeftCorner) {
				graphics.moveTo( -leftBorderOffset, y);
				graphics.lineTo( -leftBorderOffset + _borderLeft.borderSize, y +height);
				graphics.lineTo(_width/2, y+height);
				graphics.lineTo(_width/2, y);
				graphics.lineTo(-leftBorderOffset, y);
			} else {
				graphics.moveTo(_width/2,y);
				from.x = topLeftCorner, from.y = y;
				to.x = -leftBorderOffset, to.y = topLeftCorner;
				cp.x = to.x, cp.y = from.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, topLeftCorner, _borderTop.borderSize, _borderLeft.borderSize, "vertical", false, false);
				graphics.lineTo(_width / 2, y + height);
				graphics.lineTo(_width / 2, y);
			}
			
			if (!topRightCorner) {
				graphics.moveTo(_width + rightBorderOffset, y);
				graphics.lineTo(_width + rightBorderOffset - _borderRight.borderSize, y + height);
				graphics.lineTo(_width / 2, y + height);
				graphics.lineTo(_width / 2, y);
				graphics.lineTo(_width - rightBorderOffset, y);
			} else {
				graphics.moveTo(_width / 2, y);
				from.x = _width - topRightCorner, from.y = y;
				to.x = _width + rightBorderOffset, to.y = topRightCorner;
				cp.x = to.x, cp.y = from.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, topRightCorner, _borderTop.borderSize, _borderRight.borderSize, "vertical", true, false);
				graphics.lineTo(_width / 2, y + height);
				graphics.lineTo(_width / 2, y);
			}
		}
		
		protected function drawRightBorder ( ):void {
			var graphics:Graphics = _graphics;
			var borderSize:Number = _borderRight.borderSize;
			var position:String = _borderRight.borderPosition;
			var width:Number = borderSize, height:Number = _height;
			var x:Number, y:Number;
			switch(position) {
				case BorderPosition.INSIDE:
				x = y = _width-borderSize;
				break;
				
				case BorderPosition.CENTER:
				x = y = _width - (borderSize / 2);
				height += borderSize;
				break;
				
				case BorderPosition.OUTSIDE:
				x = y = _width;
				height += borderSize * 2;
				break;
			}
			
			
			var topRightCorner:Number = _topRightCorner;
			var bottomRightCorner:Number = _bottomRightCorner;
			
			var from:Point = new Point(), to:Point = new Point(), cp:Point = new Point();
			
			var topBorderOffset:Number = this.getBorderOffset(_borderTop.borderSize, _borderTop.borderPosition, true);
			var rightBorderOffset:Number = this.getBorderOffset(_borderRight.borderSize, _borderRight.borderPosition, true);
			var bottomBorderOffset:Number = this.getBorderOffset(_borderBottom.borderSize, _borderBottom.borderPosition, true);
			
			if (!topRightCorner) {
				graphics.moveTo(x + width, -topBorderOffset);
				graphics.lineTo(x, -topBorderOffset + _borderTop.borderSize);
				graphics.lineTo(x, _height/2);
				graphics.lineTo(x + width, _height/2);
				graphics.lineTo(x + width, -topBorderOffset);
			} else {
				graphics.moveTo(x + width, _height / 2);
				from.x = x + width, from.y = topRightCorner;
				to.x = _width - topRightCorner, to.y = -topBorderOffset;
				cp.x = from.x, cp.y = to.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, topRightCorner, _borderRight.borderSize, _borderTop.borderSize, "horizontal", true, false);
				graphics.lineTo(x, _height / 2);
				graphics.lineTo(x + width, _height / 2);
			}
			
			if (!bottomRightCorner) {
				graphics.moveTo(x + width, _height + bottomBorderOffset);
				graphics.lineTo(x, _height + bottomBorderOffset - _borderBottom.borderSize);
				graphics.lineTo(x, _height / 2);
				graphics.lineTo(x + width, _height / 2);
				graphics.lineTo(x + width, _height + bottomBorderOffset);
			} else {
				graphics.moveTo(x + width, _height / 2);
				from.x = x + width, from.y = _height - bottomRightCorner;
				to.x = _width - bottomRightCorner, to.y = _height + bottomBorderOffset;
				cp.x = from.x, cp.y = to.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, bottomRightCorner, _borderRight.borderSize, _borderBottom.borderSize, "horizontal", true, true);
				graphics.lineTo(x, _height / 2);
				graphics.lineTo(x + width, _height / 2);
			}
		}
		
		protected function drawBottomBorder ( ):void {
			var graphics:Graphics = _graphics;
			var borderSize:Number = _borderBottom.borderSize;
			var position:String = _borderBottom.borderPosition;
			var width:Number = _width, height:Number = borderSize;
			var y:Number;
			switch(position) {
				case BorderPosition.INSIDE:
				y = _height - borderSize;
				break;
				
				case BorderPosition.CENTER:
				y = _height - borderSize / 2;
				width += borderSize;
				break;
				
				case BorderPosition.OUTSIDE:
				y = _height;
				width += borderSize * 2;
				break;
			}
			
			
			var bottomLeftCorner:Number = _bottomLeftCorner;
			var bottomRightCorner:Number = _bottomRightCorner;
			
			var from:Point = new Point(), to:Point = new Point(), cp:Point = new Point();
			
			var leftBorderOffset:Number = this.getBorderOffset(_borderLeft.borderSize, _borderLeft.borderPosition, true);
			var bottomBorderOffset:Number = this.getBorderOffset(_borderBottom.borderSize, _borderBottom.borderPosition, true);
			var rightBorderOffset:Number = this.getBorderOffset(_borderRight.borderSize, _borderRight.borderPosition, true);
			
			if (!bottomLeftCorner) {
				graphics.moveTo( -leftBorderOffset, y + height);
				graphics.lineTo( -leftBorderOffset + _borderLeft.borderSize, y);
				graphics.lineTo(_width / 2, y);
				graphics.lineTo(_width / 2, y + height);
				graphics.lineTo( -leftBorderOffset, y + height);
			} else {
				graphics.moveTo(_width / 2, y + height);
				from.x = bottomLeftCorner, from.y = y + height;
				to.x = -leftBorderOffset, to.y = _height - bottomLeftCorner;
				cp.x = to.x, cp.y = from.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, bottomLeftCorner, _borderBottom.borderSize, _borderLeft.borderSize, "vertical", false, true);
				graphics.lineTo(_width / 2, y);
				graphics.lineTo(_width / 2, y + height);
			}
			
			if (!bottomRightCorner) {
				graphics.moveTo(_width + rightBorderOffset, y + height);
				graphics.lineTo(_width + rightBorderOffset - _borderRight.borderSize, y);
				graphics.lineTo(_width / 2, y);
				graphics.lineTo(_width / 2, y +height);
				graphics.lineTo(_width - rightBorderOffset, y + height);
			} else {
				graphics.moveTo(_width / 2, y + height);
				from.x = _width - bottomRightCorner, from.y = y + height;
				to.x = _width + rightBorderOffset, to.y = _height - bottomRightCorner;
				cp.x = to.x, cp.y = from.y;
				graphics.lineTo(from.x, from.y);
				this.drawBorderCurve(from, to, cp, bottomRightCorner, _borderBottom.borderSize, _borderRight.borderSize, "vertical", true, true);
				graphics.lineTo(_width / 2, y);
				graphics.lineTo(_width / 2, y + height);
			}
		}
		
		protected function drawBorderCurve ( from:Point, to:Point, controlPoint:Point, roundedCorners:Number, fromSize:Number, toSize:Number, orient:String, invertX:Boolean, invertY:Boolean ):void {
			var graphics:Graphics = _graphics;
			var target:Point, cp:Point;
			target = MathUtil.getPointOnCurve(from, to, controlPoint, 0.5);
			cp = MathUtil.getControlPoint(from, to, controlPoint, 0, 0.5);
			graphics.curveTo(cp.x, cp.y, target.x, target.y);
			
			if (orient == "horizontal") {
				from.x += invertX ? -fromSize : fromSize;
				to.x += invertX ? -fromSize : fromSize;
				from.y += invertY ? -toSize : toSize;
				to.y += invertY ? -toSize : toSize;
				controlPoint.x = invertX ? controlPoint.x - fromSize : controlPoint.x + fromSize;
				controlPoint.y = invertY ? controlPoint.y - toSize : controlPoint.y + toSize;
			} else {
				from.x += invertX ? -toSize : toSize;
				to.x += invertX ? -toSize : toSize;
				from.y += invertY ? -fromSize : fromSize;
				to.y += invertY ? -fromSize : fromSize;
				controlPoint.x = invertX ? controlPoint.x - toSize : controlPoint.x + toSize;
				controlPoint.y = invertY ? controlPoint.y - fromSize : controlPoint.y + fromSize;
			}
			
			target = MathUtil.getPointOnCurve(from, to, controlPoint, 0.5);
			cp = MathUtil.getControlPoint(from, to, controlPoint, 0, 0.5);
			
			graphics.lineTo(target.x, target.y);
			graphics.curveTo(cp.x, cp.y, from.x, from.y);
			
		}
		
		protected function setLineStyle ( border:Border, useFillMode:Boolean = false ):void {
			if(!useFillMode) {
				_graphics.lineStyle(border.borderSize, uint(border.borderColor), border.borderAlpha, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND);
			} else {
				_graphics.beginFill(uint(border.borderColor), border.borderAlpha);
			}
		}
		
		protected function setLineGradientStyle ( border:Border, useFillMode:Boolean = false ):void {
			var borderGradient:GraphicsGradientData = border.borderGradient;
			var width:Number = this.getBorderOffset(_borderLeft.borderSize, _borderLeft.borderPosition) + _width + this.getBorderOffset(_borderRight.borderSize, _borderRight.borderPosition);
			var height:Number = this.getBorderOffset(_borderTop.borderSize, _borderTop.borderPosition) + _height + this.getBorderOffset(_borderBottom.borderSize, _borderBottom.borderPosition);
			var ratios:Array = borderGradient.getRatios(width, height);
			if(!useFillMode) {
				_graphics.lineStyle(border.borderSize, 0, border.borderAlpha, true, LineScaleMode.NORMAL, CapsStyle.NONE);
				_graphics.lineGradientStyle(borderGradient.type, borderGradient.colors, borderGradient.alphas, ratios, getGradientMatrix(width, height, borderGradient.angle));
			} else {
				_graphics.beginGradientFill(borderGradient.type, borderGradient.colors, borderGradient.alphas, ratios, getGradientMatrix(width, height, borderGradient.angle));
			}
		}
		
		protected function getBorderOffset ( borderThickness:Number, position:String, useFillMode:Boolean = false ):Number {
			if (isNaN(borderThickness)) {
				return 0;
			}
			var offset:Number = 0;
			switch(position) {
				case BorderPosition.INSIDE:
				if (!useFillMode) {
					offset += borderThickness * -0.5;
				} else {
					offset += 0;
				}
				break;
				
				case BorderPosition.OUTSIDE:
				if (!useFillMode) {
					offset += borderThickness * 0.5;
				} else {
					offset += borderThickness;
				}
				break;
				
				case BorderPosition.CENTER:
				if (!useFillMode) {
					offset += 0;
				} else {
					offset += borderThickness / 2;
				}
				break;
			}
			return offset;
		}
	
		protected function nothing ( ):void {	
			/*var leftOffset:Number = !isNaN(_borderLeft) ? (this.getBorderOffset(_borderLeft) + _borderLeft / 2) : 0;
			var rightOffset:Number = !isNaN(_borderRight) ? (this.getBorderOffset(_borderRight) + _borderRight / 2) : 0;
			var topOffset:Number = !isNaN(_borderTop) ? (this.getBorderOffset(_borderTop) + _borderTop / 2) : 0;
			var bottomOffset:Number = !isNaN(_borderBottom) ? (this.getBorderOffset(_borderBottom) + _borderBottom / 2) : 0;
		
			var borderWidth:Number = Math.max(_width, leftOffset + _width + rightOffset);
			var borderHeight:Number = Math.max(_height, topOffset + _height + bottomOffset);
			
			var width:Number = this.getBorderOffset(_borderLeft) + _width + this.getBorderOffset(_borderRight);
			var height:Number = this.getBorderOffset(_borderTop) + _height + this.getBorderOffset(_borderBottom);
			
			if (_linePatternData) {
				_linePatternData.dispose();
				_linePatternData = null;
			}
			
			if (_borderLineStyle != LineStyle.SOLID) {
				
				_linePatternData = this.getLineBitmapPattern(borderWidth, borderHeight);
			}
			
			if (_border != _borderLeft) {
				_border = _borderLeft;
			}
			
			if (_fillType == FillType.ELLIPSE || (_border == _borderLeft && _border ==  _borderTop && _border == _borderBottom && _border == _borderRight)) {
				this.drawSingleBorder();
			} else {
				this.drawSeparateBorders();
			}*/
			
		}
		
		/*protected function drawSingleBorder ( ):void {
			
			if (!_border) {
				return;
			}
			
			
			var offset:Number = this.getBorderOffset(_border);
			
			var x:Number = -offset, y:Number = -offset, width:Number = _width + 2 * offset, height:Number = _height + 2 * offset;
			
			if (_borderLineStyle == LineStyle.SOLID) {
				if (_borderColor != null) {
					this.setLineStyle(_border);
					this.drawOutline(x, y, width, height);
				}
				if (_borderGradient) {
					this.setLineGradientStyle(_border);
					this.drawOutline(x, y, width, height);
				}
			} else {
				this.setLinePatternStyle(_border);			
				this.drawOutline(x, y, width, height);
			}
			
			_graphics.lineStyle();
			
			
		}
		
		protected function drawSeparateBorders ( ):void {
			var offset:Number;
			
			var graphics:Graphics = _graphics;
			
			var isSolidLineStyle:Boolean = (_borderLineStyle == LineStyle.SOLID);
			
			if (_borderTop) {
				offset = this.getBorderOffset(_borderTop);
				
				if (isSolidLineStyle) {
					this.setLineStyle(_borderTop);	
					graphics.moveTo(0, -offset); graphics.lineTo(_width, -offset);
					if (_borderGradient) {
						this.setLineGradientStyle(_borderTop);
						graphics.moveTo(0, -offset); graphics.lineTo(_width, -offset);
					}
				} else {
					this.setLinePatternStyle(_borderTop);
					graphics.moveTo(0, -offset); graphics.lineTo(_width, -offset);
				}
				
			}
			
			if (_borderRight) {
				offset = this.getBorderOffset(_borderRight);
				
				if (isSolidLineStyle) {
					this.setLineStyle(_borderRight);	
					if (!_borderTop) { graphics.moveTo(_width+offset, 0); } else { graphics.lineTo(_width+offset, -offset); } graphics.lineTo(_width+offset, _height);
					if (_borderGradient) {
						this.setLineGradientStyle(_borderRight);
						if (!_borderTop) { graphics.moveTo(_width+offset, 0); } else { graphics.lineTo(_width+offset, -offset); } graphics.lineTo(_width+offset, _height);
					}
				} else {
					this.setLinePatternStyle(_borderRight);
					if (!_borderTop) { graphics.moveTo(_width+offset, 0); } else { graphics.lineTo(_width+offset, -offset); } graphics.lineTo(_width+offset, _height);
				}
				
			}
			
			if (_borderBottom) {
				offset = this.getBorderOffset(_borderBottom);
				
				if (isSolidLineStyle) {
					this.setLineStyle(_borderBottom);	
					if (!_borderRight) { graphics.moveTo(_width, height); } else { graphics.lineTo(_width+offset, height); } graphics.lineTo(0, height);
					if (_borderGradient) {
						this.setLineGradientStyle(_borderBottom);
						if (!_borderRight) { graphics.moveTo(_width, height); } else { graphics.lineTo(_width+offset, height); } graphics.lineTo(0, height);
					}
				} else {
					this.setLinePatternStyle(_borderBottom);
					if (!_borderRight) { graphics.moveTo(_width, height); } else { graphics.lineTo(_width+offset, height); } graphics.lineTo(0, height);
				}
				
				
				
			}
				
			if (_borderLeft) {
				offset = this.getBorderOffset(_borderLeft);
				if (isSolidLineStyle) {
					this.setLineStyle(_borderLeft);	
					if (!_borderBottom) { graphics.moveTo(-offset, height); } else { graphics.lineTo(-offset, height); } graphics.lineTo(-offset,0);
					if (_borderGradient) {
						this.setLineGradientStyle(_borderLeft);
						if (!_borderBottom) { graphics.moveTo(-offset, height); } else { graphics.lineTo(-offset, height); } graphics.lineTo(-offset,0);
					}
				} else {
					this.setLinePatternStyle(_borderLeft);
					if (!_borderBottom) { graphics.moveTo(-offset, height); } else { graphics.lineTo(-offset, height); } graphics.lineTo(-offset,0);
				}
				
				graphics.lineStyle();
			}
		}*/
		
		/*protected function setLineStyle ( thickness:Number):void {
			_graphics.lineStyle(thickness, uint(_borderColor), _borderAlpha, true, LineScaleMode.NORMAL, CapsStyle.NONE);
		}
		
		protected function setLineGradientStyle ( thickness:Number ):void {
			_graphics.lineStyle(thickness, 0, _borderAlpha, true, LineScaleMode.NORMAL, CapsStyle.NONE);
			var ratios:Array = _borderGradient.getRatios(_width, _height);
			_graphics.lineGradientStyle(_borderGradient.type, _borderGradient.colors, _borderGradient.alphas, ratios, getGradientMatrix(_width,_height,_borderGradient.angle));
		}
		
		protected function setLinePatternStyle ( thickness:Number ):void {
			_graphics.lineStyle(thickness, 0, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE);
			var m:Matrix = new Matrix();
			var translateX:Number = !isNaN(_borderLeft) ? -(this.getBorderOffset(_borderLeft) + _borderLeft / 2) : 0;
			var translateY:Number = !isNaN(_borderTop) ? -(this.getBorderOffset(_borderTop) + _borderTop / 2) : 0;
			m.translate(translateX, translateY);
			_graphics.lineBitmapStyle(_linePatternData, m, false, false);
		}
		
		*/
		
		protected function drawBackgroundImage ( ):void {
			
			if (!_backgroundImage) {
				if (_backgroundBitmapData) {
					_backgroundBitmapData.dispose();
					_backgroundBitmapData = null;
				}
				_backgroundImageInvalidated = false;
				return;
			}
			
			if (_backgroundImageInvalidated) {
				this.getBackgroundImageBitmap();
			}
			
			_backgroundImageInvalidated = false;
			
			if (_backgroundBitmapData) {
				this.drawBackgroundBitmap();
			}
			
		}
		
		protected function drawBackgroundBitmap ( ):void {
			var graphics:Graphics = _graphics;
			
			var rect:Rectangle = this.getBackgroundDimensions();
			var data:BitmapData = this.processBitmapData(rect);
			var m:Matrix = new Matrix();
			m.translate(rect.x, rect.y);
			graphics.beginBitmapFill(data, m, true, _backgroundImageAntiAliasing);
			rect.x = Math.max(0, rect.x);
			rect.y = Math.max(0, rect.y);
			rect.width = Math.min(_width, rect.width + rect.x) - rect.x;
			rect.height = Math.min(_height, rect.height + rect.y) - rect.y;
			this.drawOutline(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
			
			
			/*var m:Matrix = new Matrix();
			m.translate(p.x, p.y);
			graphics.beginBitmapFill(_backgroundBitmapData, m, true, _backgroundImageAntiAliasing);
			
			var width:Number = _backgroundImageRepeatX != BackgroundImageRepeat.NO_REPEAT ? _width : _backgroundBitmapData.width;
			var height:Number = _backgroundImageRepeatY != BackgroundImageRepeat.NO_REPEAT ? _height : _backgroundBitmapData.height;
			if(_backgroundImageRepeatX && _backgroundImageRepeatY) {
				this.drawOutline(p.x, p.y, width, height);
			} else {
				graphics.drawRect(p.x, p.y, width, height);
			}
			graphics.endFill();*/
			
		}
		
		protected function processBitmapData ( rect:Rectangle ):BitmapData {
			var data:BitmapData;
			var scaleX:Number = 1, scaleY:Number = 1, spaceX:Number = 0, spaceY:Number = 0;
			
			var imageWidth:Number = _backgroundImage.width, imageHeight:Number = _backgroundImage.height;
			
			var numX:int = Math.floor(rect.width / imageWidth);
			var numY:int = Math.floor(rect.height / imageHeight);
			
			switch(_backgroundImageRepeatX) {
				default:
				case BackgroundImageRepeat.NO_REPEAT:
				scaleX = rect.width / imageWidth;
				break;
				
				case BackgroundImageRepeat.REPEAT:
				scaleX = 1;
				break;
				
				case BackgroundImageRepeat.SPACE:
				scaleX = 1;
				spaceX = (rect.width - (numX * imageWidth)) / (numX - 1);
				break;
				
				case BackgroundImageRepeat.ROUND:
				scaleX = rect.width / numX / imageWidth;
				break;
			}
			
			switch(_backgroundImageRepeatY) {
				default:
				case BackgroundImageRepeat.NO_REPEAT:
				scaleY = rect.height / imageHeight;
				break;
				
				case BackgroundImageRepeat.REPEAT:
				scaleY = 1;
				break;
				
				case BackgroundImageRepeat.SPACE:
				scaleY = 1;
				spaceY = (rect.height - (numY * imageHeight)) / (numY - 1);
				break;
				
				case BackgroundImageRepeat.ROUND:
				scaleY = rect.height / numY / imageHeight;
				break;
			}
			
			var ct:ColorTransform = new ColorTransform();
			if (_backgroundImageColor) {
				ct.color = uint(_backgroundImageColor);
			}
			ct.alphaMultiplier = _backgroundImageAlpha;
			
			if (scaleX != 1 || scaleY != 1 || spaceX || spaceY) {
				data = new BitmapData(imageWidth * scaleX + spaceX, imageHeight * scaleY + spaceY, true, 0x00FFFFFF);
				var m:Matrix = new Matrix();
				m.scale(scaleX, scaleY);
				data.draw(_backgroundBitmapData, m, ct, null, null, _backgroundImageAntiAliasing);
			} else {
				data = _backgroundBitmapData;
				data.colorTransform(rect, ct);
			}
			
			return data;
		}
		
		protected var _dimensions:Rectangle = new Rectangle();
		
		protected function getBackgroundDimensions ( ):Rectangle {
			var width:Number, height:Number, scale:Number;
			var imageWidth:Number = _backgroundImage.width, imageHeight:Number = _backgroundImage.height;
			if (_backgroundImageScaleMode == BackgroundImageScaleMode.CONTAIN) {
				scale = _width / imageWidth > _height / imageHeight ? _width / imageWidth : _height / imageHeight;
				width = imageWidth * scale, height = imageHeight * scale;
			} else if (_backgroundImageScaleMode == BackgroundImageScaleMode.COVER) {
				scale = _width / imageWidth < _height / imageHeight ? _width / imageWidth : _height / imageHeight;
				width = imageWidth * scale, height = imageHeight * scale;
			} else {			
				switch(_backgroundImageWidth.valueType) {
					default:
					width = _backgroundImageWidth.getComputedValue(_width);
					break;
					
					case DisplayValueType.AUTO:
					width = imageWidth;
					break;
				}
				
				switch(_backgroundImageHeight.valueType) {
					default:
					height = _backgroundImageHeight.getComputedValue(_height);
					break;
					
					case DisplayValueType.AUTO:
					height = imageHeight;
					break;
				}

			}
			
			if (_backgroundImageRepeatX == BackgroundImageRepeat.ROUND && _backgroundImageScaleMode == BackgroundImageScaleMode.NONE) {
				width = Math.round(width / imageWidth) * imageWidth;
			}
			
			if (_backgroundImageRepeatY == BackgroundImageRepeat.ROUND && _backgroundImageScaleMode == BackgroundImageScaleMode.NONE) {
				height = Math.round(height / imageHeight) * imageHeight;
			}
			
			var spaceToDistribute:Number;
			
			spaceToDistribute = Math.max(0, _width - width);
			var offsetX:Number = _backgroundImageOffsetX.getComputedValue(spaceToDistribute);
			
			spaceToDistribute = Math.max(0, _height - height);
			var offsetY:Number = _backgroundImageOffsetY.getComputedValue(spaceToDistribute);
			
			var x:Number = 0;
			switch(_backgroundImageHorizontalFloat) {
				default:
				case Align.LEFT:
				x = 0 + offsetX;
				break;
				
				case Align.CENTER:
				x = _width / 2 - width / 2 + offsetX;
				break;
				
				case Align.RIGHT:
				x = _width - width - offsetX;
				break;
			}
			
			var y:Number = 0;
			switch(_backgroundImageVerticalFloat) {
				default:
				case Align.TOP:
				y = 0 + offsetY;
				break;
				
				case Align.CENTER:
				y = _height / 2 - height / 2 + offsetY;
				break;
				
				case Align.BOTTOM:
				y = _height - height - offsetY;
				break;
			}
			
			_dimensions.x = x, _dimensions.y = y, _dimensions.width = width, _dimensions.height = height;
			return _dimensions;
		}
		
		protected function drawOutline ( x:Number = 0, y:Number = 0, width:Number = NaN, height:Number = NaN ):void {
			if (isNaN(width)) {
				width = _width;
			}
			if (isNaN(height)) {
				height = _height;
			}
			
			if (!(width > 0 && height > 0)) {
				return;
			}
			
			switch(_fillType) {
				case FillType.RECTANGLE:
				var roundedCorners:Number = _roundedCorners;
				var topLeftCorner:Number = Math.max(0, _topLeftCorner - Math.max(x,y));
				var topRightCorner:Number = Math.max(0, _topRightCorner - Math.max(_width - (x+width), y));
				var bottomLeftCorner:Number = Math.max(0, _bottomLeftCorner - Math.max(x,_height - (y+height)));
				var bottomRightCorner:Number = Math.max(0, _bottomRightCorner - Math.max(_width - (x + width), _height - (y + height)));
				if (roundedCorners || topLeftCorner || topRightCorner || bottomLeftCorner || bottomRightCorner) {
					_graphics.drawRoundRectComplex(x, y, width, height, topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner);
				} else {
					_graphics.drawRect(x, y, width, height);
				}
				break;
				
				case FillType.ELLIPSE:
				if (_width == _height) {
					_graphics.drawCircle(width / 2 + x, width / 2 + y, width / 2);
				} else {
					_graphics.drawEllipse(x, y, width, height);
				}
				break;
			}
		}
		
		protected function setDrawable ( drawable:Drawable ):void {
			_drawable = drawable;
			if (_drawable) {
				_drawable.invalidateGraphics();
			}
		}
		
		protected function invalidate ( ):void {
			if (_drawable) {
				_drawable.invalidateGraphics();
			}
		}
		
		protected function invalidateBackgroundImage ( ):void {
			_backgroundImageInvalidated = true;
		}
		
		protected function getBackgroundImageBitmap ( ):void {
			if (_backgroundImage is Bitmap) {
				this.processBackgroundImageBitmap();
			} else {
				this.processBackgroundImageVector();
			}
		}
		
		protected function processBackgroundImageBitmap ( ):void {
			var bitmap:Bitmap = Bitmap(_backgroundImage);
			var bitmapData:BitmapData = bitmap.bitmapData;
			_backgroundBitmapData = bitmapData.clone();
		}
		
		protected function getScaledBitmapData ( source:BitmapData ):BitmapData {
			
			var width:Number = _backgroundImageRepeatX ? _width : source.width;
			var height:Number = _backgroundImageRepeatY ? _height : source.height;
			
			var target:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			var sourceX1:Number = _backgroundImageScaleGrid.x, sourceX2:Number = sourceX1 + _backgroundImageScaleGrid.width;
			var sourceY1:Number = _backgroundImageScaleGrid.y, sourceY2:Number = sourceY1 + _backgroundImageScaleGrid.height;
			
			var targetX1:Number = sourceX1, targetX2:Number = width - (source.width - sourceX2);
			var targetY1:Number = sourceY1, targetY2:Number = height - (source.height - sourceY2);
			
			var scaleX:Number = (targetX2 - targetX1) / (sourceX2 - sourceX1);
			var scaleY:Number = (targetY2 - targetY1) / (sourceY2 - sourceY1);
			
			var m:Matrix = new Matrix(), rect:Rectangle;
			
			rect = new Rectangle();
			
			/*
			 * [x][ ][ ]
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 */
			rect.x = 0, rect.y = 0;
			rect.width = targetX1, rect.height = targetY1;
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][x][ ]
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 */
			rect.x = targetX1, rect.y = 0;
			rect.width = targetX2 - targetX1;
			rect.height = targetY1;
			m.translate(-sourceX1+(sourceX1/scaleX),0);
			m.scale(scaleX, 1);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][x]
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 */
			rect.x = targetX2, rect.y = 0;
			rect.width = width - targetX2, rect.height = targetY1;
			m.identity();
			m.translate(targetX2-sourceX2, 0);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [x][ ][ ]
			 * [ ][ ][ ]
			 */
			rect.x = 0, rect.y = targetY1;
			rect.width = targetX1, rect.height = targetY2 - targetY1;
			m.identity();
			m.translate(0, -sourceY1 + (sourceY1 / scaleY));
			m.scale(1, scaleY);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [ ][x][ ]
			 * [ ][ ][ ]
			 */
			rect.x = targetX1, rect.y = targetY1;
			rect.width = targetX2 - targetX1, rect.height = targetY2 - targetY1;
			m.identity();
			m.translate( -sourceX1 + (sourceX1 / scaleX), -sourceY1 + (sourceY1 / scaleY));
			m.scale(scaleX, scaleY);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [ ][ ][x]
			 * [ ][ ][ ]
			 */
			rect.x = targetX2, rect.y = targetY1;
			rect.width = width - targetX2, rect.height = targetY2 - targetY1;
			m.identity();
			m.translate( targetX2-sourceX2, -sourceY1 + (sourceY1 / scaleY));
			m.scale(1, scaleY);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 * [x][ ][ ]
			 */
			rect.x = 0, rect.y = targetY2;
			rect.width = targetX1, rect.height = height - targetY2;
			m.identity();
			m.translate(0, targetY2-sourceY2);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 * [ ][x][ ]
			 */
			rect.x = targetX1, rect.y = targetY2;
			rect.width = targetX2 - targetX1, rect.height = height - targetY2;
			m.identity();
			m.translate(-sourceX1 + (sourceX1 / scaleX), targetY2-sourceY2);
			m.scale(scaleX, 1);
			target.draw(source, m, null, null, rect);
			
			/*
			 * [ ][ ][ ]
			 * [ ][ ][ ]
			 * [ ][ ][x]
			 */
			rect.x = targetX2, rect.y = targetY2;
			rect.width = width - targetX2, rect.height = height - targetY2;
			m.identity();
			m.translate(targetX2-sourceX2, targetY2-sourceY2);
			target.draw(source, m, null, null, rect);
			
			return target;
			
		}
		
		protected function processBackgroundImageVector ( ):void {
			// TODO: Implement
		}
		
		/*public function getLineBitmapPattern ( width:Number, height:Number ):BitmapData {
			var shape:Shape = Shape(ObjectPool.getObject(Shape));
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			var x:Number = 0, y:Number = 0, size:Number;
			var graphics:Graphics = shape.graphics;
			var ix:int, iy:int, l:int = _borderLineStyle.length;
			
			
			if (_borderColor != null) {
				var borderColor:uint = uint(_borderColor);
				graphics.beginFill(borderColor, _borderAlpha);
				this.fillLineBitmap(graphics, width, height);	
			}
			
			graphics.endFill();
			
			if (_borderGradient != null) {
				var ratios:Array = _borderGradient.getRatios(_width, _height);
				graphics.beginGradientFill(_borderGradient.type, _borderGradient.colors, _borderGradient.alphas, ratios, getGradientMatrix(width, height, _borderGradient.angle));
			}
			
			//this.fillLineBitmap(graphics, width, height);
			
			bitmapData.draw(shape, null, null, null, null, false);
			graphics.endFill();
			graphics.clear();
			ObjectPool.releaseObject(shape);
			return bitmapData;
		}
		
		protected function fillLineBitmap ( graphics:Graphics, width:Number, height:Number ):void {
			var size:Number, x:Number = 0, y:Number = 0, offset:Number, i:int;
			var l:int = _borderLineStyle.length;
			
			if (_borderLeft) {
				for (i = 0, x = 0, y = 0; y < height; ) {
					size = _borderLineStyle[i % l];
					if ((i & 1) == 0) {
						graphics.drawRect(x, y, _borderLeft, size);
					}
					y += size;
					++i;
				}
			}
			
			if (_borderTop) {
				for (i = 0, x = 0, y = 0; x < width; ) {
					size = _borderLineStyle[i % l];
					if ((i & 1) == 0) {
						graphics.drawRect(x, y, size, _borderTop);
					}
					x += size;
					++i;
				}
			}
			
			if(_borderRight) {
				for (i = 0, x = width, y = 0; y < height; ) {
					size = _borderLineStyle[i % l];
					if ((i & 1) == 0) {
						graphics.drawRect(x-_borderRight, y, _borderRight, size);
					}	
						y += size;
					++i;
				}
			}
			
			if (_borderBottom) {
				for (i = 0, x = 0, y = height; x < width; ) {
					size = _borderLineStyle[i % l];
					if ((i & 1) == 0) {
						graphics.drawRect(x, y-_borderBottom, size, _borderBottom);
					}
					x += size;
					++i;
				}
			}
			
		}*/
		
		public function parseProperty ( propertyName:String, value:* ):void {
			switch(propertyName) {
				default:
				this.cacheParsedProperty(propertyName, value);
				break;
				
				case "background":
				this.parseBackground(value);
				break;
				
				case "backgroundImage":
				this.parseBackgroundImage(value);
				break;
				
				case "backgroundPosition":
				this.parseBackgroundPosition(value);
				break;
				
				case "backgroundSize":
				this.parseBackgroundSize(value);
				break;
				
				case "backgroundRepeat":
				this.parseBackgroundRepeat(value);
				break;
				
				case "backgroundGradient":
				this.parseBackgroundGradient(value);
				break;
				
				case "border":
				case "borderLeft":
				case "borderTop":
				case "borderRight":
				case "borderBottom":
				this.parseBorder(propertyName, value);
				break;
				
				case "borderGradient":
				case "borderLeftGradient":
				case "borderTopGradient":
				case "borderRightGradient":
				case "borderBottomGradient":
				this.parseBorderGradient(propertyName, value);
				break;
				
				case "roundedCorners":
				this.parseRoundedCorners(value);
				break;
				
				case "topLeftCorner":
				case "topRightCorner":
				case "bottomLeftCorner":
				case "bottomRightCorner":
				case "borderLeftSize":
				case "borderTopSize":
				case "borderRightSize":
				case "borderBottomSize":
				this.parsePixelValue(propertyName, value);
				break;
			}
		}
		
		protected function cacheParsedProperty ( propertyName:String, value:* ):void {
			_parseHelper.setProperty(propertyName, value);
		}
		
		public function applyParsedProperties ( ):void {
			var node:PropertyData = _parseHelper.firstNode;
			while (node) {
				this.setProperty(node.propertyName, node.value);
				node = node.nextNode;
			}
			_parseHelper.reset();
		}
		
		public function setTransition ( propertyName:String, transitionData:TransitionData ):void {
			switch(propertyName) {
				default:
				_transitions[propertyName] = transitionData;
				break;
				
				case "border":
				_transitions['border'] = transitionData;
				this.setTransition("borderLeft", transitionData);
				this.setTransition("borderTop", transitionData);
				this.setTransition("borderRight", transitionData);
				this.setTransition("borderBottom", transitionData);
				break;
				
				case "borderAlpha":
				_transitions['borderAlpha'] = transitionData;
				this.setTransition("borderLeftAlpha", transitionData);
				this.setTransition("borderTopAlpha", transitionData);
				this.setTransition("borderRightAlpha", transitionData);
				this.setTransition("borderBottomAlpha", transitionData);
				break;
				
				case "borderColor":
				_transitions['borderColor'] = transitionData;
				this.setTransition("borderLeftColor", transitionData);
				this.setTransition("borderTopColor", transitionData);
				this.setTransition("borderRightColor", transitionData);
				this.setTransition("borderBottomColor", transitionData);
				break;
				
				case "borderSize":
				_transitions['borderSize'] = transitionData;
				this.setTransition("borderLeftSize", transitionData);
				this.setTransition("borderTopSize", transitionData);
				this.setTransition("borderBottomSize", transitionData);
				this.setTransition("borderRightSize", transitionData);
				break;
				
				case "borderGradient":
				_transitions['borderGradient'] = transitionData;
				this.setTransition("borderLeftGradient", transitionData);
				this.setTransition("borderTopGradient", transitionData);
				this.setTransition("borderRightGradient", transitionData);
				this.setTransition("borderBottomGradient", transitionData);
				break;
				
				case "borderLeft":
				_transitions['borderLeft'] = transitionData;
				this.setTransition("borderLeftAlpha", transitionData);
				this.setTransition("borderLeftColor", transitionData);
				this.setTransition("borderLeftSize", transitionData);
				break;
				
				case "borderTop":
				_transitions['borderTop'] = transitionData;
				this.setTransition("borderTopAlpha", transitionData);
				this.setTransition("borderTopColor", transitionData);
				this.setTransition("borderTopSize", transitionData);
				break;s
				
				case "borderRight":
				_transitions['borderRight'] = transitionData;
				this.setTransition("borderRightAlpha", transitionData);
				this.setTransition("borderRightColor", transitionData);
				this.setTransition("borderRightSize", transitionData);
				break;
				
				case "borderBottom":
				_transitions['borderBottom'] = transitionData;
				this.setTransition("borderBottomAlpha", transitionData);
				this.setTransition("borderBottomColor", transitionData);
				this.setTransition("borderBottomSize", transitionData);
				break;
				
				case "roundedCorners":
				_transitions['roundedCorners'] = transitionData;
				this.setTransition("topLeftCorner", transitionData);
				this.setTransition("topRightCorner", transitionData);
				this.setTransition("leftBottomCorner", transitionData);
				this.setTransition("rightBottomCorner", transitionData);
				break;
				
				case "backgroundPosition":
				_transitions['backgroundPosition'] = transitionData;
				this.setTransition("backgroundImageOffsetX", transitionData);
				this.setTransition("backgroundImageOffsetY", transitionData);				
				break;
				
				case "backgroundSize":
				_transitions['backgroundSize' ] = transitionData;
				this.setTransition("backgroundImageWidth", transitionData);
				this.setTransition("backgroundImageHeight", transitionData);
				break;
				
			}
		}
		
		public function setProperty ( propertyName:String, value:* ):void {
			var transitionData:TransitionData = _transitions[propertyName];
			if (!transitionData || transitionData.cyclePhase != _cyclePhase ) {	
				if (hasTween(this, propertyName)) {
					removeTween(this, propertyName);
				}
				this[propertyName] = value;
			} else {
				if (transitionData.type == TransitionType.TO) {
					transitionData.value = value;
				}
				switch(propertyName) {
					case "borderPosition":
					case "borderLeftPosition":
					case "borderTopPosition":
					case "borderRightPosition":
					case "borderBottomPosition":
					this[propertyName] = value;
					break;
					
					case "borderLineStyle":
					case "borderLeftLineStyle":
					case "borderTopLineStyle":
					case "borderRightLineStyle":
					case "borderBottomLineStyle":
					this[propertyName] = value;
					break;
					
					default:
					tween(this, propertyName, transitionData);
					break;
				}
				
			}
		}
		
		protected function parseBackground ( value:String ):void {
			
		}
		
		protected function parseBackgroundImage ( value:String ):void {
			var match:Array = value.match(/^(url|resource|none|null)\("?(.*?)"?\)$/);
			if (!match) {
				this.cacheParsedProperty("backgroundImage", null);
			}
			
			value = match[2];
			
			if (match[1] == "url") {
				this.cacheParsedProperty("backgroundImageURL", value);
			} else if (match[1] == "resource") {
				this.cacheParsedProperty("backgroundImage", new (getClass(value)));
			} else {
				this.cacheParsedProperty("backgroundImage", null)
			}
		}
		
		protected function parseBackgroundPosition ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundPosition");
			if (parser) {
				var data:BackgroundPositionData = BackgroundPositionData(parser.parseValue(value));
				this.cacheParsedProperty("backgroundImageHorizontalFloat", data.horizontalFloat);
				this.cacheParsedProperty("backgroundImageOffsetX", data.offsetX.clone());
				this.cacheParsedProperty("backgroundImageVerticalFloat", data.verticalFloat);
				this.cacheParsedProperty("backgroundImageOffsetY", data.offsetY.clone());
			}
		}
		
		protected function parseBackgroundSize ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundSize");
			if (parser) {
				var data:BackgroundSizeData = BackgroundSizeData(parser.parseValue(value));
				this.cacheParsedProperty("backgroundImageScaleMode", data.backgroundImageScaleMode);
				this.cacheParsedProperty("backgroundImageWidth", data.backgroundImageWidth.clone());
				this.cacheParsedProperty("backgroundImageHeight", data.backgroundImageHeight.clone());
			}
		}
		
		protected function parseBackgroundRepeat ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundRepeat");
			if (parser) {
				var data:BackgroundRepeatData = BackgroundRepeatData(parser.parseValue(value));
				this.cacheParsedProperty("backgroundImageRepeatX", data.repeatX);
				this.cacheParsedProperty("backgroundImageRepeatY", data.repeatY);
			}
		}
		
		protected function parseBackgroundGradient ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundGradient");
			if (parser) {
				var data:GraphicsGradientData = GraphicsGradientData(parser.parseValue(value));
				this.cacheParsedProperty("backgroundGradient", data ? data.clone() : null);
			}
		}
		
		protected function parseBorder ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser("border");
			if (parser) {
				var data:BorderData = BorderData(parser.parseValue(value));
				var border:Border;
				switch(propertyName) {
					case "border":
					if (data.border) {
						border = data.border;
						this.applyToBorder(border.clone(), "Left");
						this.applyToBorder(border.clone(), "Top");
						this.applyToBorder(border.clone(), "Right");
						this.applyToBorder(border.clone(), "Bottom");
					} else {
						if ((border = data.borderLeft)) {
							this.cacheParsedProperty("borderLeftSize", border.borderSize);
						}
						if ((border = data.borderTop)) {
							this.cacheParsedProperty("borderTopSize", border.borderSize);
						}
						if ((border = data.borderRight)) {
							this.cacheParsedProperty("borderRightSize", border.borderSize);
						}
						if ((border = data.borderBottom)) {
							this.cacheParsedProperty("borderBottomSize", border.borderSize);
						}
					}
					break;
					
					case "borderLeft":
					this.applyToBorder(data.border, "Left");
					break;
					
					case "borderTop":
					this.applyToBorder(data.border, "Top");
					break;
					
					case "borderRight":
					this.applyToBorder(data.border, "Right");
					break;
					
					case "borderBottom":
					this.applyToBorder(data.border, "Bottom");
					break;
				}
			}
		}
		
		protected function applyToBorder ( border:Border, side:String = "" ):void {
			this.cacheParsedProperty("border" + side + "Size", border.borderSize);
			this.cacheParsedProperty("border" + side + "Color", border.borderColor);
			this.cacheParsedProperty("border" + side + "Alpha", border.borderAlpha);
			this.cacheParsedProperty("border" + side + "Position", border.borderPosition);
			this.cacheParsedProperty("border" + side + "LineStyle", border.borderLineStyle);
		}
		
		protected function parseBorderGradient ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser("borderGradient");
			if (parser) {
				var data:GraphicsGradientData = GraphicsGradientData(parser.parseValue(value));
				if (data) {
					data = data.clone();
				}
				if (propertyName == "borderGradient") {
					this.cacheParsedProperty("borderLeftGradient", data);
					this.cacheParsedProperty("borderTopGradient", data ? data.clone() : null);
					this.cacheParsedProperty("borderBottomGradient", data ? data.clone() : null);
					this.cacheParsedProperty("borderRightGradient", data ? data.clone() : null);
				} else {
					this.cacheParsedProperty(propertyName, data);
				}
			}
		}
		
		protected function parseRoundedCorners ( value:String ):void {
			var parser:PropertyParser = this.getParser("roundedCorners");
			if (parser) {
				var data:SideData = SideData(parser.parseValue(value));
				if (data.all) {
					var val:Number = data.all.value;
					this.cacheParsedProperty("topLeftCorner", val);
					this.cacheParsedProperty("topRightCorner", val);
					this.cacheParsedProperty("bottomLeftCorner", val);
					this.cacheParsedProperty("bottomRightCorner", val);
				} else {
					this.cacheParsedProperty("topLeftCorner", data.first.value);
					this.cacheParsedProperty("topRightCorner", data.second.value);
					this.cacheParsedProperty("bottomLeftCorner", data.third.value);
					this.cacheParsedProperty("bottomRightCorner", data.fourth.value);
				}
			}
		}
		
		protected function parsePixelValue ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser(propertyName);
			if (parser) {
				var displayValue:DisplayValue = DisplayValue(parser.parseValue(value));
				this.cacheParsedProperty(propertyName, displayValue.value);
			}
		}
		
		protected function setBackgroundImage ( displayObject:DisplayObject ):void {
			_backgroundImage = displayObject;
			this.backgroundImageURL = null;
			this.invalidate();
			this.invalidateBackgroundImage();
		}
		
		protected function setBackgroundImageURL ( url:String ):void {
			if (_backgroundImageLoader) {
				this.removeLoader(_backgroundImageLoader);
				_backgroundImageLoader = null;
			}
			
			_backgroundImageURL = url;
			if (url) {
				if (ImageAssetManager.hasImage(url)) {
					this.backgroundImage = ImageAssetManager.getImage(url);
					_backgroundImageURL = url;
				} else {
					_backgroundImageLoader = ImageAssetManager.loadImage(url);
					_backgroundImageLoader.onComplete.add(this.onBackgroundImageLoadComplete);
					_backgroundImageLoader.onError.add(this.onBackgroundImageLoadError);
				}
			}
		}
		
		protected function removeLoader ( assetLoader:AssetLoader ):void {
			assetLoader.onComplete.remove(this.onBackgroundImageLoadComplete);
			assetLoader.onError.remove(this.onBackgroundImageLoadError);
		}
		
		protected function onBackgroundImageLoadComplete ( assetLoader:AssetLoader ):void {
			this.backgroundImage = DisplayObject(assetLoader.data);
			_backgroundImageURL = assetLoader.request.url;
			
			this.removeLoader(assetLoader);
			_backgroundImageLoader = null;
		}
		
		protected function onBackgroundImageLoadError ( assetLoader:AssetLoader ):void {
			this.removeLoader(assetLoader);
			_backgroundImageLoader = null;
		}
		
		public function get width ( ):Number { return _width; }
		public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.invalidate();
			}
		}
		
		public function get height ( ):Number { return _height; }
		public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.invalidate();
			}
		}
		
		public function get backgroundColor ( ):Object { return _backgroundColor; }
		public function set backgroundColor ( value:Object ):void {
			if (_backgroundColor != value) {
				_backgroundColor = value;
				this.invalidate();
			}
		}
		
		public function get backgroundAlpha ( ):Number { return _backgroundAlpha; }
		public function set backgroundAlpha ( value:Number ):void {
			if (_backgroundAlpha != value) {
				_backgroundAlpha = value;
				this.invalidate();
			}
		}
		
		public function get backgroundGradient ( ):GraphicsGradientData { return _backgroundGradient; }
		public function set backgroundGradient ( value:GraphicsGradientData ):void {
			_backgroundGradient = value;
			this.invalidate();
		}
		
		public function get fillType ( ):String { return _fillType; }
		public function set fillType ( value:String ):void {
			if (_fillType != value) {
				_fillType = value;
				this.invalidate();
			}
		}
		
		public function get roundedCorners ( ):Number { return _roundedCorners; }
		public function set roundedCorners ( value:Number ):void {
			if (_roundedCorners != value) {
				_roundedCorners = value;
				_topLeftCorner = _topRightCorner = _bottomLeftCorner = _bottomRightCorner = value;
				this.invalidate();
			}
		}
		
		public function get topLeftCorner ( ):Number { return _topLeftCorner; }
		public function set topLeftCorner ( value:Number ):void {
			if (_topLeftCorner != value) {
				_topLeftCorner = value;
				this.invalidate();
			}
		}
		
		public function get topRightCorner ( ):Number { return _topRightCorner; }
		public function set topRightCorner ( value:Number ):void {
			if (_topRightCorner != value) {
				_topRightCorner = value;
				this.invalidate();
			}
		}
		
		public function get bottomLeftCorner ( ):Number { return _bottomLeftCorner; }
		public function set bottomLeftCorner ( value:Number ):void {
			if (_bottomLeftCorner != value) {
				_bottomLeftCorner = value;
				this.invalidate();
			}
		}
		
		public function get bottomRightCorner ( ):Number { return _bottomRightCorner; }
		public function set bottomRightCorner ( value:Number ):void {
			if (_bottomRightCorner != value) {
				_bottomRightCorner = value;
				this.invalidate();
			}
		}
		
		public function get borderSize ( ):Number { return _border.borderSize; }
		public function set borderSize ( value:Number ):void {
			_border.borderSize = value;
			this.borderLeftSize = this.borderTopSize = this.borderRightSize = this.borderBottomSize = value;
		}
		
		public function get borderLeftSize ( ):Number { return _borderLeft.borderSize; }
		public function set borderLeftSize ( value:Number ):void {
			if (_borderLeft.borderSize != value) {
				_borderLeft.borderSize = value;
				this.invalidate();
			}
		}
		
		public function get borderTopSize ( ):Number { return _borderTop.borderSize; }
		public function set borderTopSize ( value:Number ):void {
			if (_borderTop.borderSize != value) {
				_borderTop.borderSize = value;
				this.invalidate();
			}
		}
		
		public function get borderRightSize ( ):Number { return _borderRight.borderSize; }
		public function set borderRightSize ( value:Number ):void {
			if (_borderRight.borderSize != value) { 
				_borderRight.borderSize = value;
				this.invalidate();
			}
		}
		
		public function get borderBottomSize ( ):Number { return _borderBottom.borderSize; }
		public function set borderBottomSize ( value:Number ):void {
			if (_borderBottom.borderSize != value) {
				_borderBottom.borderSize = value;
				this.invalidate();
			}
		}
		
		public function get borderColor ( ):Object { return _border.borderColor; }
		public function set borderColor ( value:Object ):void {
			_border.borderColor = value;
			this.borderLeftColor = this.borderTopColor = this.borderRightColor = this.borderBottomColor = value;
		}
		
		public function get borderLeftColor ( ):Object { return _borderLeft.borderColor; }
		public function set borderLeftColor ( value:Object ):void {
			if (_borderLeft.borderColor != value) {
				_borderLeft.borderColor = value;
				this.invalidate();
			}
		}
		
		public function get borderTopColor ( ):Object { return _borderTop.borderColor; }
		public function set borderTopColor ( value:Object ):void {
			if (_borderTop.borderColor != value) {
				_borderTop.borderColor = value;
				this.invalidate();
			}
		}
		
		public function get borderRightColor ( ):Object { return _borderRight.borderColor; }
		public function set borderRightColor ( value:Object ):void {
			if (_borderRight.borderColor != value) {
				_borderRight.borderColor = value;
				this.invalidate();
			}
		}
		
		public function get borderBottomColor ( ):Object { return _borderBottom.borderColor; }
		public function set borderBottomColor ( value:Object ):void {
			if (_borderBottom.borderColor != value) {
				_borderBottom.borderColor = value;
				this.invalidate();
			}
		}
		
		public function get borderAlpha ( ):Number { return _border.borderAlpha; }
		public function set borderAlpha ( value:Number ):void {
			_border.borderAlpha = value;
			this.borderLeftAlpha = this.borderTopAlpha = this.borderRightAlpha = this.borderBottomAlpha = value;
		}
		
		public function get borderLeftAlpha ( ):Number { return _borderLeft.borderAlpha; }
		public function set borderLeftAlpha ( value:Number ):void {
			if (_borderLeft.borderAlpha != value) {
				_borderLeft.borderAlpha = value;
				this.invalidate();
			}
		}
		
		public function get borderTopAlpha ( ):Number { return _borderTop.borderAlpha; }
		public function set borderTopAlpha ( value:Number ):void {
			if (_borderTop.borderAlpha != value) {
				_borderTop.borderAlpha = value;
				this.invalidate();
			}
		}
		
		public function get borderRightAlpha ( ):Number { return _borderRight.borderAlpha; }
		public function set borderRightAlpha ( value:Number ):void {
			if (_borderRight.borderAlpha != value) {
				_borderRight.borderAlpha = value;
				this.invalidate();
			}
		}
		
		public function get borderBottomAlpha ( ):Number { return _borderBottom.borderAlpha; }
		public function set borderBottomAlpha ( value:Number ):void {
			if (_borderBottom.borderAlpha != value) {
				_borderBottom.borderAlpha = value;
				this.invalidate();
			}
		}
		
		public function get borderPosition ( ):String { return _border.borderPosition; }
		public function set borderPosition ( value:String ):void {
			_border.borderPosition = value;
			this.borderLeftPosition = this.borderTopPosition = this.borderRightPosition = this.borderBottomPosition = value;
		}
		
		public function get borderLeftPosition ( ):String { return _borderLeft.borderPosition; }
		public function set borderLeftPosition ( value:String ):void {
			if (_borderLeft.borderPosition != value) {
				_borderLeft.borderPosition = value;
				this.invalidate();
			}
		}
		
		public function get borderTopPosition ( ):String { return _borderTop.borderPosition; }
		public function set borderTopPosition ( value:String ):void {
			if (_borderTop.borderPosition != value) {
				_borderTop.borderPosition = value;
				this.invalidate();
			}
		}
		
		public function get borderRightPosition ( ):String { return _borderRight.borderPosition; }
		public function set borderRightPosition ( value:String ):void {
			if (_borderRight.borderPosition != value) {
				_borderRight.borderPosition = value;
				this.invalidate();
			}
		}
		
		public function get borderBottomPosition ( ):String { return _borderBottom.borderPosition; }
		public function set borderBottomPosition ( value:String ):void {
			if (_borderBottom.borderPosition != value) {
				_borderBottom.borderPosition = value;
				this.invalidate();
			}
		}
		
		public function get borderGradient ( ):GraphicsGradientData { return _border.borderGradient; }
		public function set borderGradient ( value:GraphicsGradientData ):void {
			_border.borderGradient = value;
			this.borderLeftGradient = this.borderTopGradient = this.borderRightGradient = this.borderBottomGradient = value;
		}
		
		public function get borderLeftGradient ( ):GraphicsGradientData { return _borderLeft.borderGradient; }
		public function set borderLeftGradient ( value:GraphicsGradientData ):void {
			_borderLeft.borderGradient = value;
			this.invalidate();
		}
		
		public function get borderTopGradient ( ):GraphicsGradientData { return _borderTop.borderGradient; }
		public function set borderTopGradient ( value:GraphicsGradientData ):void {
			_borderTop.borderGradient = value;
			this.invalidate();
		}
		
		public function get borderRightGradient ( ):GraphicsGradientData { return _borderRight.borderGradient; }
		public function set borderRightGradient ( value:GraphicsGradientData ):void {
			_borderRight.borderGradient = value;
			this.invalidate();
		}
		
		public function get borderBottomGradient ( ):GraphicsGradientData { return _borderBottom.borderGradient; }
		public function set borderBottomGradient ( value:GraphicsGradientData ):void {
			_borderBottom.borderGradient = value;
			this.invalidate();
		}
		
		public function get borderLineStyle ( ):Array { return _border.borderLineStyle; }
		public function set borderLineStyle ( value:Array ):void {
			_border.borderLineStyle = value;
			this.borderLeftLineStyle = this.borderTopLineStyle = this.borderRightLineStyle = this.borderBottomLineStyle = value;
		}
		
		public function get borderLeftLineStyle ( ):Array { return _borderLeft.borderLineStyle; }
		public function set borderLeftLineStyle ( value:Array ):void {
			_borderLeft.borderLineStyle = value;
			this.invalidate();
		}
		
		public function get borderTopLineStyle ( ):Array { return _borderTop.borderLineStyle; }
		public function set borderTopLineStyle ( value:Array ):void {
			_borderTop.borderLineStyle = value;
			this.invalidate();
		}
		
		public function get borderRightLineStyle ( ):Array { return _borderRight.borderLineStyle; }
		public function set borderRightLineStyle ( value:Array ):void {
			_borderRight.borderLineStyle = value;
			this.invalidate();
		}
		
		public function get borderBottomLineStyle ( ):Array { return _borderBottom.borderLineStyle; }
		public function set borderBottomLineStyle ( value:Array ):void {
			_borderBottom.borderLineStyle = value;
			this.invalidate();
		}
		
		public function get backgroundImage ( ):DisplayObject { return _backgroundImage; }
		public function set backgroundImage ( value:DisplayObject ):void {
			if (_backgroundImage != value) {
				this.setBackgroundImage(value);
			}
		}
		
		public function get backgroundImageAlpha ( ):Number { return _backgroundImageAlpha; }
		public function set backgroundImageAlpha ( value:Number ):void {
			if (_backgroundImageAlpha != value) {
				_backgroundImageAlpha = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageHorizontalFloat ( ):String { return _backgroundImageHorizontalFloat; }
		public function set backgroundImageHorizontalFloat ( value:String ):void {
			if (_backgroundImageHorizontalFloat != value) {
				_backgroundImageHorizontalFloat = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageVerticalFloat ( ):String { return _backgroundImageVerticalFloat; }
		public function set backgroundImageVerticalFloat ( value:String ):void {
			if (_backgroundImageVerticalFloat != value) {
				_backgroundImageVerticalFloat = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageOffsetX ( ):DisplayValue { return _backgroundImageOffsetX; }
		public function set backgroundImageOffsetX ( value:DisplayValue ):void {
			if (_backgroundImageOffsetX.invalidated || !_backgroundImageOffsetX.assertEquals(value)) {
				_backgroundImageOffsetX = value;
				_backgroundImageOffsetX.invalidated = false;
				this.invalidate();
			}
		}
		
		public function get backgroundImageOffsetY ( ):DisplayValue { return _backgroundImageOffsetY; }
		public function set backgroundImageOffsetY ( value:DisplayValue ):void {
			if (_backgroundImageOffsetY.invalidated || !_backgroundImageOffsetY.assertEquals(value)) {
				_backgroundImageOffsetY = value;
				_backgroundImageOffsetY.invalidated = false;
				this.invalidate();
			}
		}
		
		public function get backgroundImageRepeatX ( ):String { return _backgroundImageRepeatX; }
		public function set backgroundImageRepeatX ( value:String ):void {
			if (_backgroundImageRepeatX != value) {
				_backgroundImageRepeatX = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageRepeatY ( ):String { return _backgroundImageRepeatY; }
		public function set backgroundImageRepeatY ( value:String ):void {
			if (_backgroundImageRepeatY != value) {
				_backgroundImageRepeatY = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageScaleGrid ( ):Rectangle { return _backgroundImageScaleGrid; }
		public function set backgroundImageScaleGrid ( value:Rectangle ):void {
			if (_backgroundImageScaleGrid != value) {
				_backgroundImageScaleGrid = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageColor ( ):Object { return _backgroundImageColor; }
		public function set backgroundImageColor ( value:Object ):void {
			if(_backgroundImageColor != value) {
				_backgroundImageColor = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageAntiAliasing ( ):Boolean { return _backgroundImageAntiAliasing; }
		public function set backgroundImageAntiAliasing ( value:Boolean ):void {
			if (_backgroundImageAntiAliasing != value) {
				_backgroundImageAntiAliasing = value;
				this.invalidate();
				this.invalidateBackgroundImage();
			}
		}
		
		public function get backgroundImageURL ( ):String { return _backgroundImageURL; }
		public function set backgroundImageURL ( value:String ):void {
			if (_backgroundImageURL != value) {
				this.setBackgroundImageURL(value);
			}
		}
		
		public function get drawable ( ):Drawable { return _drawable; }
		public function set drawable ( value:Drawable ):void {
			if (_drawable != value) {
				this.setDrawable(value);
			}
		}
		
		public function get backgroundImageWidth ( ):DisplayValue { return _backgroundImageWidth; }
		public function set backgroundImageWidth ( value:DisplayValue ):void {
			if (_backgroundImageWidth.invalidated || !_backgroundImageWidth.assertEquals(value)) {
				_backgroundImageWidth = value;
				_backgroundImageWidth.invalidated = false;
				this.invalidate();
			}
		}
		
		public function get backgroundImageHeight ( ):DisplayValue { return _backgroundImageWidth; }
		public function set backgroundImageHeight ( value:DisplayValue ):void {
			if (_backgroundImageHeight.invalidated || !_backgroundImageHeight.assertEquals(value)) {
				_backgroundImageHeight = value;
				_backgroundImageHeight.invalidated = false;
				this.invalidate();
			}
		}
		
		public function get backgroundImageScaleMode ( ):String { return _backgroundImageScaleMode; }
		public function set backgroundImageScaleMode ( value:String ):void {
			if (_backgroundImageScaleMode != value) {
				_backgroundImageScaleMode = value;
				this.invalidate();
			}
		}
		
		public function get cyclePhase ( ):String { return _cyclePhase; }
		public function set cyclePhase ( value:String ):void {
			_cyclePhase = value;
		}
		
		public function get cycle ( ):int { return _cycle; }
		public function set cycle ( value:int ):void {
			_cycle = value;
		}
	}

}