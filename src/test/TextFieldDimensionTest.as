package test {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextFieldDimensionTest extends Sprite {
		
		public function TextFieldDimensionTest() {
			if (stage) {
				this.addEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			} else {
				this.init();
			}
		}
		
		protected function onStageAdd ( e:Event ):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			this.init();
		}
		
		protected function init ( ):void {
			var textField:TextField = new TextField();
			this.addChild(textField);
			
			textField.x = 100, textField.y = 100;
			textField.backgroundColor = 0xCCEE00;
			textField.background = true;
			textField.wordWrap = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "this is a really long string to test how the textField responds to TextFieldAutoSize.LEFT";
			textField.wordWrap = false;
			textField.width = textField.textWidth;
			textField.wordWrap = false;
			trace(textField.width);
			//textField.width = 300;
		}
		
	}

}