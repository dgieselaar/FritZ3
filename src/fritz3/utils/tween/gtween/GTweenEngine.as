package fritz3.utils.tween.gtween {
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fritz3.style.transition.TransitionData;
	import fritz3.style.transition.TransitionType;
	import fritz3.utils.object.getClass;
	import fritz3.utils.tween.gtween.plugins.ColorPlugin;
	import fritz3.utils.tween.TweenEngine;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GTweenEngine implements TweenEngine {
		
		protected var _easeFunctions:String;
		
		public function GTweenEngine ( ) {
			GTween.installPlugin(ColorPlugin.instance, [ "backgroundColor", "borderColor", "color" ], false);
		}
		
		public function tween ( target:Object, transitionData:TransitionData ):void {
			var value:Object = transitionData.value;
			var values:Object = { };
			switch(transitionData.type) {
				case TransitionType.FROM:
				values[transitionData.propertyName] = transitionData.from;
				GTweener.from(target, transitionData.duration, values, { ease: transitionData.ease, delay: transitionData.delay } );
				break;
				
				case TransitionType.TO:
				values[transitionData.propertyName] = transitionData.value;
				GTweener.to(target, transitionData.duration, values, { ease: transitionData.ease, delay: transitionData.delay } );
				break;
			}
		}
		
		public function hasTween ( target:Object, propertyName:String ):Boolean {
			return Boolean(GTweener.getTween(target, propertyName));
		}
		
		public function removeTween ( target:Object, propertyName:String ):void {
			var tween:GTween = GTweener.getTween(target, propertyName);
			if (tween) {
				GTweener.remove(tween);
				tween.end();
			}
		}
		
		public function getEaseFunction ( string:String ):Function {
			return _easeFunctions[string] ||= this.parseEaseFunction(string);
		}
		
		protected function parseEaseFunction ( string:String ):Function {
			var indexOfDot:int = string.indexOf(".");
			return new (getClass(string.substr(0, indexOfDot)))()[string.substr(indexOfDot + 1)];
		}
		
		public function get defaultEaseFunction ( ):Function { return Quadratic.easeOut; }
		
	}

}