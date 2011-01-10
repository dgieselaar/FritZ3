package demo {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fritz3.display.button.TextButton;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.document.ApplicationDocument;
	import fritz3.state.SingleState;
	import fritz3.state.State;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.ObjectParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DemoDocument extends ApplicationDocument {
		
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
			return "demo/layout/stylesheet.xml";
		}
		
		protected function getEmbeddedUIURL ( ):String {
			return "demo/layout/ui.xml";
		}
		
	}

}