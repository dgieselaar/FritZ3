package fritz3.utils.tween.gtween.plugins {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ArrayTweenPlugin implements IGTweenPlugin {
		
		public static var enabled:Boolean = true;
		public static var instance:ArrayTweenPlugin;
		
		{
			instance = new ArrayTweenPlugin();
		}
		
		public function ArrayTweenPlugin ( ) {
			
		}
		
		public function init ( tween:GTween, name:String, value:Number ):Number {
			return NaN;
		}
		
		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {
			return NaN;
		}
		
	}

}