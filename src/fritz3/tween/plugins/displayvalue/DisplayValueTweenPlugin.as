package fritz3.tween.plugins.displayvalue {
	import fritz3.display.core.DisplayValue;
	import fritz3.tween.core.FTween;
	import fritz3.tween.core.FTweener;
	import fritz3.tween.plugins.FTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayValueTweenPlugin implements FTweenPlugin {
		
		protected static var _displayValueDataPool:Array = [];
		protected static var _instance:DisplayValueTweenPlugin = new DisplayValueTweenPlugin();
		
		public function DisplayValueTweenPlugin ( ) {
			
		}
		
		public function onStart ( tween:FTween ):Boolean {
			var data:DisplayValueTweenData = getDisplayValueTweenDataObject();
			var fromDisplayValue:DisplayValue = DisplayValue(tween.from);
			var toDisplayValue:DisplayValue = DisplayValue(tween.to);
			if (fromDisplayValue.assertEquals(toDisplayValue)) {
				return false;
			}
			
			fromDisplayValue.setValueType(toDisplayValue.valueType);
			tween.target[tween.propertyName] = fromDisplayValue;
			
			data.from = fromDisplayValue.value;
			data.to = toDisplayValue.value;
			tween.pluginData = data;
			return true;
		}
		
		public function render ( tween:FTween, ratio:Number ):void {
			var data:DisplayValueTweenData = DisplayValueTweenData(tween.pluginData);
			var displayValue:DisplayValue = DisplayValue(tween.target[tween.propertyName]);
			displayValue.setValue((data.to - data.from) * ratio + data.from);
			tween.target[tween.propertyName] = displayValue;
		}
		
		public function onComplete ( tween:FTween ):void {
			
		}
		
		public function onRemove ( tween:FTween ):void {
			var data:DisplayValueTweenData = DisplayValueTweenData(tween.pluginData);
			if (data) {
				_displayValueDataPool[_displayValueDataPool.length] = data;
			}
		}
		
		protected static function getDisplayValueTweenDataObject ( ):DisplayValueTweenData {
			return _displayValueDataPool.length ? _displayValueDataPool.shift() : new DisplayValueTweenData();
		}
		
		public static function get instance ( ):DisplayValueTweenPlugin { return _instance; }
		
	}

}