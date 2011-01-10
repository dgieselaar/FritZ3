package demo.layout {
	import fritz3.display.button.TextButton;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.document.ApplicationDocument;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.ObjectParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class LayoutDemo extends ApplicationDocument {
		
		[Embed(source = '../../../assets/demo/layout/stylesheet.xml', mimeType="application/octet-stream")]
		private var StyleSheetXML:Class;
		
		[Embed(source = '../../../assets/demo/layout/ui.xml', mimeType="application/octet-stream")]
		private var UIXML:Class;
		
		public function LayoutDemo ( ) {
			
		}
		
		override public function onAdd():void {
			super.onAdd();
			
			var textButton:TextButton, graphicsComponent:GraphicsComponent;
			
			var styleSheetXML:XML = XML(new StyleSheetXML());
			StyleManager.parseXML(styleSheetXML);
			
			var uiXML:XML = XML(new UIXML());
			ObjectParser.parseXMLChildren(this, uiXML.children());
		}
		
	}

}