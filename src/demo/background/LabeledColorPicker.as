package demo.background  {
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package demo.background
	 * 
	 * [Description]
	*/
	
	public class LabeledColorPicker extends Component {
		
		private static const LABEL_WIDTH:Number = 40;
		
		private var _label:String;
		private var _defaultHandler:Function;
		
		private var _labelComponent:Label;
		
		public function LabeledColorPicker ( parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null )  {
			_label = label;
			super(parent, xpos, ypos);
		}
		
		override protected function init(  ):void  {
			super.init();
			
			_labelComponent = new Label(this, 0, 0, _label);
		}
		
		override public function setSize( w:Number, h:Number ):void  {
			super.setSize(w, h);
			_labelComponent.setSize(LABEL_WIDTH, this.height);
			
		}
		
	}

}