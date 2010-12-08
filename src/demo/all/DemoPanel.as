package demo.all {
	import com.bit101.components.*;
	import flash.display.Sprite;
	import flash.events.Event;

	public class DemoPanel extends Sprite {
		
		private var _addComponentButton:PushButton;
		private var _styleSheetXMLInput:TextArea;
		private var myLabel:Label;
		private var _idLabel:Label;
		private var _idInputField:InputText;
		private var _classObjectLabel:Label;
		private var _classNameLabel:Label;
		private var _classNameInputfield:InputText;
		private var _nameLabel:Label;
		private var _removeComponentButton:PushButton;
		private var _nameInputField:InputText;
		private var _resetButton:PushButton;

		public function DemoPanel ( ) {
			_addComponentButton = new PushButton(this, 10, 320, "Add new component");
			_addComponentButton.width = 110;

			_styleSheetXMLInput = new TextArea(this, 10, 20, "");
			_styleSheetXMLInput.width = 230;
			_styleSheetXMLInput.height = 150;

			myLabel = new Label(this, 10, 0, "Stylesheet");
			myLabel.autoSize = false;

			_idLabel = new Label(this, 10, 200, "ID");
			_idLabel.autoSize = false;

			_idInputField = new InputText(this, 100, 200, "");
			_idInputField.width = 140;
			_idInputField.height = 20;

			_classObjectLabel = new Label(this, 10, 180, "No component selected");
			_classObjectLabel.autoSize = false;

			_classNameLabel = new Label(this, 10, 230, "Classname");
			_classNameLabel.autoSize = false;

			_classNameInputfield = new InputText(this, 100, 230, "");
			_classNameInputfield.width = 140;
			_classNameInputfield.height = 20;

			_nameLabel = new Label(this, 10, 260, "Name");
			_nameLabel.autoSize = false;

			_removeComponentButton = new PushButton(this, 10, 290, "Remove component");
			_removeComponentButton.width = 230;

			_nameInputField = new InputText(this, 100, 260, "");
			_nameInputField.width = 140;
			_nameInputField.height = 20;

			_resetButton = new PushButton(this, 130, 320, "Reset");
			_resetButton.width = 110;

		}
		
		override public function get width ( ):Number { return 250; }
		
		public function get addComponentButton ( ):PushButton { return _addComponentButton; }
		public function get removeComponentButton ( ):PushButton { return _removeComponentButton; }
		public function get resetButton ( ):PushButton { return _resetButton; }
		
		public function get styleSheetXMLInput ( ):TextArea { return _styleSheetXMLInput; }
		
		public function get idInputField ( ):InputText { return _idInputField; }
		public function get classNameInputfield ( ):InputText { return _classNameInputfield; }
		public function get nameInputField ( ):InputText { return _nameInputField; }
		
		
		
	}
}
