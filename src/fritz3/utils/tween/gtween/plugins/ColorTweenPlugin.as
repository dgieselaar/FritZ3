package fritz3.utils.tween.gtween.plugins {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	import fritz3.utils.color.ColorUtil;
	/**w
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorTweenPlugin implements IGTweenPlugin {
		
		public static var enabled:Boolean = true;
		public static var instance:ColorTweenPlugin;
		
		{
			instance = new ColorTweenPlugin();
		}
		
		public function ColorTweenPlugin ( ) {
			
		}
		
		public function init ( tween:GTween, name:String, value:Number ):Number {
			return value;
		}
		
		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number{
			var startR:uint = initValue >> 16;
			var startG:uint = (initValue >> 8) & 0xff;
			var startB:uint = initValue & 0xff;
			
			var endValue:uint = initValue + rangeValue;
			
			var endR:uint = endValue >> 16;
			var endG:uint = (endValue >> 8) & 0xff;
			var endB:uint = endValue & 0xff;
			
			var color:uint = ratio * (endR - startR) + startR << 16 ^ ratio * (endG - startG) + startG << 8 ^ ratio * (endB - startB) + startB;
			tween.target[name] = color;
			return NaN;
		}
		
	}

}