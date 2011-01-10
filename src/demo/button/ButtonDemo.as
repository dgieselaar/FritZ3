/**
* @mxmlc -o deploy/demo/button/fritz.swf -static-link-runtime-shared-libraries=true -include-libraries=assets/as3signals.swc
*/

package demo.button {
	import demo.DemoDocument;
	import fritz3.display.button.TextButton;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.document.ApplicationDocument;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.ObjectParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ButtonDemo extends DemoDocument {
		
		override protected function getEmbeddedStyleSheetURL ( ):String {
			return "demo/button/stylesheet.xml";
		}
		
		override protected function getEmbeddedUIURL ( ):String {
			return "demo/button/ui.xml";
		}
		
	}

}