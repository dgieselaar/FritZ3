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
		
		override public function onAdd ( ):void  {
			super.onAdd();
			
			var styleSheetXML:XML = XML(new StyleSheetXML());
			StyleManager.parseXML(styleSheetXML);
			
			var textComponent:TextButton = new TextButton( { id: "1" } );
			this.add(textComponent);
			
			//this.add(new GraphicsComponent( { id: "2" } ));
			//this.add(new GraphicsComponent( { id: "3" } ));
			//this.add(new GraphicsComponent( { id: "4" } ));
			//this.add(new GraphicsComponent( { id: "5" } ));
			
			
		}
		
	}
	
}
