package demo {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.CSMSettings;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextColorType;
	import flash.text.TextDisplayMode;
	import flash.text.TextRenderer;
	import fritz3.display.button.TextButton;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.document.ApplicationDocument;
	import fritz3.state.SingleState;
	import fritz3.state.IState;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.ObjectParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DemoDocument extends ApplicationDocument {
		
		[Embed(source = '../../assets/fonts/HelveticaLTStd-Roman.otf', fontName = 'Helvetica', embedAsCFF = 'false', mimeType = 'application/x-font')]
		protected static var Regular:Class;
		
		[Embed(source = '../../assets/fonts/HelveticaLTStd-Bold.otf', fontName = 'Helvetica', embedAsCFF = 'false', fontWeight = 'bold', mimeType = 'application/x-font')]
		protected static var Bold:Class;
		
		{
			Font.registerFont(Regular);
			Font.registerFont(Bold);
			TextRenderer.setAdvancedAntiAliasingTable("Helvetica", FontStyle.BOLD, TextColorType.LIGHT_COLOR, [ new CSMSettings(16, 0.45,-0.45) ]);
		}
		
		public function DemoDocument ( parameters:Object = null ) {
			super(parameters);
		}
		
		override public function onAdd ( ):void {
			super.onAdd();
			var textButton:TextButton, graphicsComponent:GraphicsComponent;
			
			var styleURL:String = stage.loaderInfo.parameters.styleURL != undefined ? stage.loaderInfo.parameters.styleURL : this.getEmbeddedStyleSheetURL();
			var uiURL:String = stage.loaderInfo.parameters.uiURL != undefined ? stage.loaderInfo.parameters.uiURL : this.getEmbeddedUIURL();
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onStyleComplete);
			urlLoader.load(new URLRequest(styleURL));
			
			function onStyleComplete ( e:Event ):void {
				StyleManager.parseXML(XML(urlLoader.data));
				
				urlLoader.removeEventListener(Event.COMPLETE, onStyleComplete);
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onUIComplete);
				urlLoader.load(new URLRequest(uiURL));
			}
			
			var doc:ApplicationDocument = this;
			
			function onUIComplete ( e:Event ):void {
				ObjectParser.parseXMLChildren(doc, XML(urlLoader.data).children());
				urlLoader.removeEventListener(Event.COMPLETE, onUIComplete);
			}
			
		}
		
		protected function getEmbeddedStyleSheetURL ( ):String {
			return "demo/casper/stylesheet.xml";
		}
		
		protected function getEmbeddedUIURL ( ):String {
			return "demo/casper/ui.xml";
		}
		
	}

}