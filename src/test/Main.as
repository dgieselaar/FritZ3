package test {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fritz3.display.button.TextButton;
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.display.core.InvalidatableDisplayComponent;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.utils.getGradientMatrix;
	import fritz3.display.layout.Align;
	import fritz3.display.text.TextComponent;
	import fritz3.document.ApplicationDocument;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.StandardStyleSheetCollector;
	import fritz3.style.StyleManager;
	import fritz3.utils.math.MathUtil;
	import fritz3.utils.object.ObjectParser;
	import fritz3.utils.signals.fast.FastSignal;
	import ru.etcs.utils.getDefinitionNames;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Main extends ApplicationDocument {
	 
		[Embed(source = '../../assets/demo/main/stylesheet.xml', mimeType="application/octet-stream")]
		private var StyleSheetXML:Class;
		
		[Embed(source = '../../assets/demo/main/ui.xml', mimeType="application/octet-stream")]
		private var UIXML:Class;
		
		public function Main():void {
		}
		
		override public function onAdd ( ):void  {
			super.onAdd();
			
			var textButton:TextButton, graphicsComponent:GraphicsComponent;
			
			var styleSheetXML:XML = XML(new StyleSheetXML());
			StyleManager.parseXML(styleSheetXML);
			
			var uiXML:XML = XML(new UIXML());
			ObjectParser.parseXMLChildren(this, uiXML.children());
			
			/*var bg:Shape = new Shape();
			this.add(bg);
			
			var graphics:Graphics = bg.graphics;
			
			var width:Number = 100, height:Number = 20, ellipseSize:Number = 5;
			graphics.beginFill(0xFF68EB, 1);
			graphics.drawRoundRect(0, 0, width, height, ellipseSize, ellipseSize);
			graphics.endFill();
			
			var borderLeft:Number = 1, borderTop:Number = 2;
			
			var from:Point, to:Point, controlPoint:Point, target:Point;
			
			graphics.beginFill(0x000000, 0.5);
			graphics.moveTo(0, height/2);
			graphics.lineTo(0, ellipseSize / 2);
			
			from = new Point(0, ellipseSize / 2);
			to = new Point(ellipseSize / 2, 0);
			controlPoint = new Point(0, 0);
			target = MathUtil.getPointOnCurve(from, to, controlPoint, 0.5);
			controlPoint = MathUtil.getControlPoint(from, to, controlPoint, 0, 0.5);
			
			graphics.curveTo(controlPoint.x, controlPoint.y, target.x, target.y);
			
			from = new Point(borderLeft, ellipseSize / 2);
			to = new Point(ellipseSize / 2, borderTop);
			controlPoint = new Point(borderLeft, borderTop);
			target = MathUtil.getPointOnCurve(from, to, controlPoint, 0.5);
			controlPoint = MathUtil.getControlPoint(from, to, controlPoint, 0, 0.5);
			
			graphics.lineTo(target.x, target.y);
			graphics.curveTo(controlPoint.x, controlPoint.y, from.x, from.y);
			graphics.lineTo(borderLeft, height / 2);
			graphics.lineTo(0, height / 2);
			
			graphics.endFill();
			
			this.scaleX = this.scaleY = 5;*/
		}
		
	}
	
}
