package fritz3.utils.tween.gtween {
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fritz3.style.transition.TransitionData;
	import fritz3.style.transition.TransitionType;
	import fritz3.utils.object.getClass;
	import fritz3.utils.tween.gtween.plugins.ArrayTweenPlugin;
	import fritz3.utils.tween.gtween.plugins.ColorTweenPlugin;
	import fritz3.utils.tween.gtween.plugins.gradient.GradientTweenPlugin;
	import fritz3.utils.tween.ITweenEngine;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GTweenEngine implements ITweenEngine {
		
		protected var _easeFunctions:String;
		
		public function GTweenEngine ( ) {
			GTween.installPlugin(ColorTweenPlugin.instance, [ "backgroundColor", "borderColor", "color" ], false);
			GTween.installPlugin(ArrayTweenPlugin.instance, [ 
			"borderLineStyle",
			"borderLeftLineStyle",
			"borderTopLineStyle",
			"borderRightLineStyle",
			"borderBottomLineStyle"
			], false);
			GTween.installPlugin(GradientTweenPlugin.instance, [
			"backgroundGradient",
			"borderGradient",
			"borderLeftGradient",
			"borderTopGradient",
			"borderRightGradient",
			"borderBottomGradient"
			], false);
		}
		
		public function tween ( target:Object, propertyName:String, transitionData:TransitionData ):void {
			var value:Object = transitionData.value;
			var values:Object = { };
			var tween:GTween;
			var position:Number = 0;
			if ((tween = GTweener.getTween(target, propertyName))) {
				position = tween.position;
				this.removeTween(target, propertyName);
			}
			switch(transitionData.type) {
				case TransitionType.FROM:
				values[propertyName] = transitionData.from;
				tween = GTweener.from(target, transitionData.duration - (position * transitionData.duration), values, { ease: transitionData.ease, delay: transitionData.delay } );
				tween.position = position;
				break;
				
				case TransitionType.TO:
				values[propertyName] = transitionData.value;
				tween = GTweener.to(target, transitionData.duration, values, { ease: transitionData.ease, delay: transitionData.delay } );
				tween.position = position;
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