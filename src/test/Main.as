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
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.display.core.InvalidatableDisplayComponent;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.utils.getGradientMatrix;
	import fritz3.display.layout.Align;
	import fritz3.document.ApplicationDocument;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.StyleManager;
	import fritz3.utils.signals.fast.FastSignal;
	import ru.etcs.utils.getDefinitionNames;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Main extends ApplicationDocument {
	 
		[Embed(source = '../../assets/demo/stylesheet/stylesheet.xml', mimeType="application/octet-stream")]
		private var StyleSheetXML:Class;
		
		public function Main():void {
		}
		
		override public function onAdd(  ):void  {
			super.onAdd();
			
			/*var component:InvalidatableDisplayComponent = new InvalidatableDisplayComponent();
			this.addChild(component);
			
			var container:DisplayComponentContainer = new DisplayComponentContainer();
			this.addChild(container);*/
			
			var styleSheetXML:XML = XML(new StyleSheetXML());
			StyleManager.parseXML(styleSheetXML);
			
			var graphicsComponent:GraphicsComponent = new GraphicsComponent();
			var background:BoxBackground = graphicsComponent.background as BoxBackground;
			background.backgroundColor = 0xFF68EB;
			background.backgroundAlpha = 1;
			background.roundedCorners = 5;
			this.addChild(graphicsComponent);
			
			
			/*var background:BoxBackground = container.background;
			
			container.x = 50, container.y = 50;
			
			var lineStyle:Array = [ 3, 2];
			
			var background:BoxBackground = new BoxBackground( { width: 64, height: 64, roundedCorners: 3, backgroundColor: 0xEFEFEF, backgroundAlpha: 1 } );
			background.backgroundImage = new BackgroundImage() as DisplayObject;
			background.backgroundImageRepeatX = true;
			background.backgroundImageRepeatY = true;
			background.backgroundImageAntiAliasing = false;
			background.backgroundImageAlpha = 1;
			background.backgroundImageScaleGrid = new Rectangle(8, 8, 8, 8);
			background.draw(shape);
			
			shape.filters = [ new DropShadowFilter(0, 90, 0, 0.75, 2, 2, 1) ];
			
			
			shape.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			var p:Point;
			var catchMouseClickSize:Number = 9;
			function onMouseDown ( e:MouseEvent ):void {
				p = new Point(shape.mouseX, shape.mouseY);
				if(p.x >= (shape.width-catchMouseClickSize) && p.y >= (shape.height-catchMouseClickSize)) {
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
			
			function onMouseMove ( e:MouseEvent ):void {
				var currentPoint:Point = new Point(shape.mouseX, shape.mouseY);
				background.width = Math.max(24, background.width + (currentPoint.x - p.x));
				background.height = Math.max(24, background.height + (currentPoint.y - p.y));
				p = currentPoint;
				background.draw(shape);
			}
			
			function onMouseUp ( e:MouseEvent ):void {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			/*var source:BitmapData = (new BackgroundImage() as Bitmap).bitmapData.clone();
			var target:BitmapData = new BitmapData(72, 29, true, 0x33FF68EB);
			
			var m:Matrix = new Matrix(), clipRect:Rectangle = null;
			var dx:Number = 46, dy:Number  = 0;
			
			m.translate( 0, 0);
			m.scale(1,1);
			clipRect = new Rectangle(dx
			, 0, 26, 29);
			target.draw(source, m, null, null, clipRect);
			
			var bitmap:Bitmap = new Bitmap(target);
			bitmap.x = 100, bitmap.y = 100;
			this.addChild(bitmap);*/
			
			
			
		}
		
	}
	
}
