package demo.background  {
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package demo.background
	 * 
	 * [Description]
	*/
	
	public class LabeledSlider extends Component {
		
		private static const LABEL_WIDTH:Number = 30;
		private static const VALUE_WIDTH:Number = 20;
		private static const GAP:Number = 5;
		
		private var _label:String;
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _defaultHandler:Function;
		private var _labelComponent:Label;
		private var _minLabel:Label;
		private var _slider:Slider;
		private var _maxLabel:Label;
		
		
		public function LabeledSlider ( parent:DisplayObjectContainer = null, xPos:Number = 0, yPos:Number = 0, label:String = "", minValue:Number = 0, maxValue:Number = 10, defaultHandler:Function = null  )  {
			_label = label;
			_minValue = minValue;
			_maxValue = maxValue;
			_defaultHandler = defaultHandler;
			super(parent, xPos, yPos);
		}
		
		override protected function init(  ):void  {
			super.init();
			
			_labelComponent = new Label(this, 0, 0, _label);
			_minLabel = new Label(this, 0, 0, _minValue.toString());
			_slider = new Slider("horizontal", this, 0, 0, _defaultHandler);
			_slider.minimum = _minValue;
			_slider.maximum = _maxValue;
			_maxLabel = new Label(this, 0, 0, _maxValue.toString());
			
			
		}
		
		override protected function onInvalidate( event:Event ):void  {
			super.onInvalidate(event);
			
			_labelComponent.setSize(LABEL_WIDTH, this.height);
			_minLabel.setSize(VALUE_WIDTH, this.height);
			_maxLabel.setSize(VALUE_WIDTH, this.height);
			_slider.setSize(this.width - LABEL_WIDTH - VALUE_WIDTH * 2 - 3 * GAP, this.height);
			
			_labelComponent.x = 0;
			_slider.x = LABEL_WIDTH + VALUE_WIDTH + 2 * GAP;
			_slider.y = 2;
			_minLabel.x = _slider.x - GAP - _minLabel.textField.textWidth - 3;
			_maxLabel.x = this.width - VALUE_WIDTH;
			
		}
		
		public function get value ( ):Number { return _slider.value; }
		public function set value ( value:Number ):void {
			_slider.value = value;
		}
		
		public function get minValue ( ):Number { return _minValue; }
		
		public function get maxValue ( ):Number { return _maxValue; }
		
	}

}