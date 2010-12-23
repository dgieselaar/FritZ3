package fritz3.display.graphics {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.InterpolationMethod;
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
	import fritz3.binding.AccessType;
	import fritz3.binding.Binding;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.gradient.GraphicsGradientColor;
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	import fritz3.display.graphics.parser.gradient.GradientParser;
	import fritz3.display.graphics.parser.position.BackgroundPositionData;
	import fritz3.display.graphics.parser.position.BackgroundPositionParser;
	import fritz3.display.graphics.parser.repeat.BackgroundRepeatData;
	import fritz3.display.graphics.parser.repeat.BackgroundRepeatParser;
	import fritz3.display.graphics.parser.size.BackgroundSizeData;
	import fritz3.display.graphics.parser.size.BackgroundSizeParser;
	import fritz3.display.graphics.utils.getGradientMatrix;
	import fritz3.display.layout.Align;
	import fritz3.invalidation.Invalidatable;
	import fritz3.style.PropertyParser;
	import fritz3.utils.assets.AssetLoader;
	import fritz3.utils.assets.image.ImageAssetLoader;
	import fritz3.utils.assets.image.ImageAssetManager;
	import fritz3.utils.object.getClass;
	import fritz3.utils.object.ObjectPool;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BoxBackground implements RectangularBackground, Injectable {
		
		protected var _drawable:Drawable;
		protected var _parameters:Object;
		
		protected var _parsers:Object = { };
		
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
		
		protected var _border:Number = 0;
		protected var _borderPosition:String = BorderPosition.CENTER;
		protected var _borderTop:Number = 0;
		protected var _borderLeft:Number = 0;
		protected var _borderBottom:Number = 0;
		protected var _borderRight:Number = 0;
		protected var _borderAlpha:Number = 1;
		protected var _borderColor:Object;
		protected var _borderGradient:GraphicsGradientData;
		protected var _borderOffset:Number = 0;
		protected var _borderLineStyle:Array = LineStyle.SOLID;
		
		protected var _backgroundImage:DisplayObject;
		protected var _backgroundImageAlpha:Number = 1;
		
		protected var _backgroundImageHorizontalFloat:String = Align.LEFT;
		protected var _backgroundImageVerticalFloat:String = Align.TOP;
		
		protected var _backgroundImageOffsetX:Number = 0;
		protected var _backgroundImageOffsetY:Number = 0;
		protected var _backgroundImageOffsetXValueType:String = DisplayValueType.PIXEL;
		protected var _backgroundImageOffsetYValueType:String = DisplayValueType.PIXEL;
		
		protected var _backgroundImageWidth:Number = 0;
		protected var _backgroundImageHeight:Number = 0;
		protected var _backgroundImageWidthValueType:String = DisplayValueType.AUTO;
		protected var _backgroundImageHeightValueType:String = DisplayValueType.AUTO;
		
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
			this.setParsers()
			this.setDefaultProperties();
			this.applyParameters();
		}
		
		protected function setParsers ( ):void {
			this.addParser("backgroundPosition", BackgroundPositionParser.parser);
			this.addParser("backgroundSize", BackgroundSizeParser.parser);
			this.addParser("backgroundRepeat", BackgroundRepeatParser.parser);
			this.addParser("backgroundGradient", GradientParser.parser);
			this.addParser("borderGradient", GradientParser.parser);
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
			
		}
		
		protected function applyParameters ( ):void {
			var value:*;
			for (var name:String in _parameters) {
				this[name] = _parameters[name];
			}
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
			
			var leftOffset:Number = !isNaN(_borderLeft) ? (this.getBorderOffset(_borderLeft) + _borderLeft / 2) : 0;
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
			}
			
		}
		
		protected function drawSingleBorder ( ):void {
			
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
		}
		
		protected function setLineStyle ( thickness:Number):void {
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
		
		protected function getBorderOffset ( borderThickness:Number ):Number {
			if (isNaN(borderThickness)) {
				return 0;
			}
			var offset:Number = _borderOffset;
			switch(_borderPosition) {
				case BorderPosition.INSIDE:
				offset += borderThickness * -0.5;
				break;
				
				case BorderPosition.OUTSIDE:
				offset += borderThickness * 0.5;
				break;
			}
			return offset;
		}
		
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
				switch(_backgroundImageWidthValueType) {
					default:
					case DisplayValueType.AUTO:
					width = imageWidth;
					break;
					
					case DisplayValueType.PIXEL:
					width = _backgroundImageWidth;
					break;
					
					case DisplayValueType.PERCENTAGE:
					width = (_backgroundImageWidth / 100) * _width;
					break;
				}
				
				switch(_backgroundImageHeightValueType) {
					default:
					case DisplayValueType.AUTO:
					height = imageHeight;
					break;
					
					case DisplayValueType.PIXEL:
					height = _backgroundImageHeight;
					break;
					
					case DisplayValueType.PERCENTAGE:
					height = (_backgroundImageHeight / 100) * _height;
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
			
			var offsetX:Number = 0;
			spaceToDistribute = Math.max(0, _width - width);
			switch(_backgroundImageOffsetXValueType) {
				default:
				case DisplayValueType.PIXEL:
				offsetX = _backgroundImageOffsetX;
				break;
				
				case DisplayValueType.PERCENTAGE:
				offsetX = (_backgroundImageOffsetY / 100) * spaceToDistribute;
				break;
			}
			
			var offsetY:Number = 0;
			spaceToDistribute = Math.max(0, _height - height);
			switch(_backgroundImageOffsetYValueType) {
				default:
				case DisplayValueType.PIXEL:
				offsetY = _backgroundImageOffsetY;
				break;
				
				case DisplayValueType.PERCENTAGE:
				offsetY = (_backgroundImageOffsetY / 100) * spaceToDistribute;
				break;
			}
			
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
				var bottomRightCorner:Number = Math.max(0, _bottomLeftCorner - Math.max(_width - (x + width), _height - (y + height)));
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
		
		public function getLineBitmapPattern ( width:Number, height:Number ):BitmapData {
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
			
			this.fillLineBitmap(graphics, width, height);
			
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
			
		}
		
		public function setProperty ( propertyName:String, value:*, parameters:Object = null ):void {
			switch(propertyName) {
				default:
				this[propertyName] = value;
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
				
				case "borderGradient":
				this.parseBorderGradient(value);
				break;
			}
		}
		
		protected function parseBackground ( value:String ):void {
			
		}
		
		protected function parseBackgroundImage ( value:String ):void {
			var match:Array = value.match(/^(url|resource|none|null)\("?(.*?)"?\)$/);
			if (!match) {
				this.backgroundImage = null;
			}
			
			value = match[2];
			
			if (match[1] == "url") {
				this.backgroundImageURL = value;
			} else if (match[1] == "resource") {
				this.backgroundImage = new (getClass(value));
			} else {
				this.backgroundImage = null;
			}
		}
		
		protected function parseBackgroundPosition ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundPosition");
			if (parser) {
				var data:BackgroundPositionData = BackgroundPositionData(parser.parseValue(value));
				this.backgroundImageHorizontalFloat = data.horizontalFloat;
				this.backgroundImageOffsetX = data.offsetX;
				this.backgroundImageOffsetXValueType = data.offsetXValueType;
				
				this.backgroundImageVerticalFloat = data.verticalFloat;
				this.backgroundImageOffsetY = data.offsetY;
				this.backgroundImageOffsetYValueType = data.offsetYValueType;
			}
		}
		
		protected function parseBackgroundSize ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundSize");
			if (parser) {
				var data:BackgroundSizeData = BackgroundSizeData(parser.parseValue(value));
				
				this.backgroundImageScaleMode = data.backgroundImageScaleMode;
				this.backgroundImageWidth = data.backgroundImageWidth;
				this.backgroundImageWidthValueType = data.backgroundImageWidthValueType;
				
				this.backgroundImageHeight = data.backgroundImageHeight;
				this.backgroundImageHeightValueType = data.backgroundImageHeightValueType;
			}
		}
		
		protected function parseBackgroundRepeat ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundRepeat");
			if (parser) {
				var data:BackgroundRepeatData = BackgroundRepeatData(parser.parseValue(value));
				this.backgroundImageRepeatX = data.repeatX;
				this.backgroundImageRepeatY = data.repeatY;
			}
		}
		
		protected function parseBackgroundGradient ( value:String ):void {
			var parser:PropertyParser = this.getParser("backgroundGradient");
			if (parser) {
				var data:GraphicsGradientData = GraphicsGradientData(parser.parseValue(value));
				this.backgroundGradient = data;
			}
		}
		
		protected function parseBorderGradient ( value:String ):void {
			var parser:PropertyParser = this.getParser("borderGradient");
			if (parser) {
				var data:GraphicsGradientData = GraphicsGradientData(parser.parseValue(value));
				this.borderGradient = data;
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
		
		public function get border ( ):Number { return _border; }
		public function set border ( value:Number ):void {
			if (_border != value) {
				_border = value;
				_borderLeft = _borderRight = _borderTop = _borderBottom = value;
				this.invalidate();
			}
		}
		
		public function get borderPosition ( ):String { return _borderPosition; }
		public function set borderPosition ( value:String ):void {
			if (_borderPosition != value) {
				_borderPosition = value;
				this.invalidate();
			}
		}
		
		public function get borderTop ( ):Number { return _borderTop; }
		public function set borderTop ( value:Number ):void {
			if (_borderTop != value) {
				_borderTop = value;
				this.invalidate();
			}
		}
		
		public function get borderLeft ( ):Number { return _borderLeft; }
		public function set borderLeft ( value:Number ):void {
			if (_borderLeft != value) {
				_borderLeft = value;
				this.invalidate();
			}
		}
		
		public function get borderBottom ( ):Number { return _borderBottom; }
		public function set borderBottom ( value:Number ):void {
			if (_borderBottom != value) {
				_borderBottom = value;
				this.invalidate();
			}
		}
		
		public function get borderRight ( ):Number { return _borderRight; }
		public function set borderRight ( value:Number ):void {
			if (_borderRight != value) {
				_borderRight = value;
				this.invalidate();
			}
		}
		
		public function get borderAlpha ( ):Number { return _borderAlpha; }
		public function set borderAlpha ( value:Number ):void {
			if (_borderAlpha != value) {
				_borderAlpha = value;
				this.invalidate();
			}
		}
		
		public function get borderColor ( ):Object { return _borderColor; }
		public function set borderColor ( value:Object ):void {
			if (_borderColor != value) {
				_borderColor = value;
				this.invalidate();
			}
		}
		
		public function get borderGradient ( ):GraphicsGradientData { return _borderGradient; }
		public function set borderGradient ( value:GraphicsGradientData ):void {
			_borderGradient = value;
			this.invalidate();
		}
		
		public function get borderOffset ( ):Number { return _borderOffset; }
		public function set borderOffset ( value:Number ):void {
			if (_borderOffset != value) {
				_borderOffset = value;
				this.invalidate();
			}
		}
		
		public function get borderLineStyle ( ):Array { return _borderLineStyle; }
		public function set borderLineStyle ( value:Array ):void {
			if (_borderLineStyle != value) {
				_borderLineStyle = value;
				this.invalidate();
			}
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
		
		public function get backgroundImageOffsetX ( ):Number { return _backgroundImageOffsetX; }
		public function set backgroundImageOffsetX ( value:Number ):void {
			if (_backgroundImageOffsetX != value) {
				_backgroundImageOffsetX = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageOffsetY ( ):Number { return _backgroundImageOffsetY; }	
		public function set backgroundImageOffsetY ( value:Number ):void {
			if (_backgroundImageOffsetY != value) {
				_backgroundImageOffsetY = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageOffsetXValueType ( ):String { return _backgroundImageOffsetXValueType; }
		public function set backgroundImageOffsetXValueType ( value:String ):void {
			if (_backgroundImageOffsetXValueType != value) {
				_backgroundImageOffsetXValueType = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageOffsetYValueType ( ):String { return _backgroundImageOffsetYValueType; }
		public function set backgroundImageOffsetYValueType ( value:String ):void {
			if (_backgroundImageOffsetYValueType != value) {
				_backgroundImageOffsetYValueType = value;
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
		
		public function get backgroundImageWidth ( ):Number { return _backgroundImageWidth; }
		public function set backgroundImageWidth ( value:Number ):void {
			if (_backgroundImageWidth != value) {
				_backgroundImageWidth = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageHeight ( ):Number { return _backgroundImageHeight; }
		public function set backgroundImageHeight ( value:Number ):void {
			if (_backgroundImageHeight != value) {
				_backgroundImageHeight = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageWidthValueType ( ):String { return _backgroundImageWidthValueType; }
		public function set backgroundImageWidthValueType ( value:String ):void {
			if (_backgroundImageWidthValueType != value) {
				_backgroundImageWidthValueType = value;
				this.invalidate();
			}
		}
		
		public function get backgroundImageHeightValueType ( ):String { return _backgroundImageHeightValueType; }
		public function set backgroundImageHeightValueType ( value:String ):void {
			if (_backgroundImageHeightValueType != value) {
				_backgroundImageHeightValueType = value;
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
	}

}