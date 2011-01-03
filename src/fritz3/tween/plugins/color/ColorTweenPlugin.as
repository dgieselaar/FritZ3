package fritz3.tween.plugins.color {
	import fritz3.tween.core.FTween;
	import fritz3.tween.plugins.FTweenPlugin;
	import fritz3.utils.color.ColorUtil;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorTweenPlugin implements FTweenPlugin {
		
		protected static var _instance:ColorTweenPlugin;
		protected static var _colorDataPool:Array;
		
		{
			_instance = new ColorTweenPlugin();
			_colorDataPool = [];
		}
		
		public function ColorTweenPlugin ( ) {
			
		}
		
		public function onInit ( tween:FTween ):void {
			
		}
		
		public function onStart ( tween:FTween ):void {
			var colorData:ColorTweenData = getColorDataObject();
			var startColor:uint = uint(tween.from);
			var endColor:uint = uint(tween.to);
			
			colorData.startR = startColor >> 16;
			colorData.startG = (startColor >> 8) & 0xff;
			colorData.startB = startColor & 0xff;
			
			colorData.endR = endColor >> 16;
			colorData.endG = (endColor >> 8) & 0xff;
			colorData.endB = endColor & 0xff;
			
			tween.pluginData = colorData;
		}
		
		public function render ( tween:FTween, ratio:Number ):void {
			var data:ColorTweenData = ColorTweenData(tween.pluginData);
			tween.target[tween.propertyName] = ratio * (data.endR - data.startR) + data.startR << 16 ^ ratio * (data.endG - data.startG) + data.startG << 8 ^ ratio * (data.endB - data.startB) + data.startB;
		}
		
		public function onComplete ( tween:FTween ):void {
			
		}
		
		public function onRemove ( tween:FTween ):void {
			var colorData:ColorTweenData = ColorTweenData(tween.pluginData);
			_colorDataPool[_colorDataPool.length] = colorData;
		}
		
		protected function getColorDataObject ( ):ColorTweenData {
			return _colorDataPool.shift() || new ColorTweenData();
		}
		
		public static function get instance ( ):ColorTweenPlugin { return _instance; }
		
	}

}