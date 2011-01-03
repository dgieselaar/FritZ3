package fritz3.utils.tween.ftween {
	import fritz3.style.transition.TransitionData;
	import fritz3.tween.core.FTweener;
	import fritz3.tween.easing.Cubic;
	import fritz3.tween.easing.Quad;
	import fritz3.tween.plugins.color.ColorTweenPlugin;
	import fritz3.tween.plugins.gradient.GradientTweenPlugin;
	import fritz3.utils.object.getClass;
	import fritz3.utils.tween.TweenEngine;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FTweenEngine implements TweenEngine {
		
		protected var _defaultEase:Function = Cubic.easeOut;
		protected var _easeFunctions:Object = { };
		
		public function FTweenEngine ( ) {
			FTweener.addPlugin([ 
			"color", "backgroundColor", "borderColor",
			"borderLeftColor", "borderTopColor",
			"borderRightColor", "borderBottomColor"
			], ColorTweenPlugin.instance);
			
			FTweener.addPlugin([ 
			"backgroundGradient", "borderGradient", 
			"borderLeftGradient", "borderTopGradient",
			"borderRightGradient", "borderBottomGradient"
			], GradientTweenPlugin.instance);
		}
		
		public function tween ( target:Object, propertyName:String, transitionData:TransitionData ):void {
			if (FTweener.hasTween(target, propertyName)) {
				FTweener.removeTween(target, propertyName);
			}
			FTweener.tween(target, propertyName, transitionData);
		}
		
		public function hasTween ( target:Object, propertyName:String ):Boolean {
			return FTweener.hasTween(target, propertyName);
		}
		
		public function removeTween ( target:Object, propertyName:String ):void {
			FTweener.removeTween(target, propertyName);
		}
		
		public function getEaseFunction ( string:String ):Function {
			return _easeFunctions[string] ||= this.parseEaseFunction(string);
		}
		
		protected function parseEaseFunction ( string:String ):Function {
			var indexOfDot:int = string.indexOf(".");
			return new (getClass(string.substr(0, indexOfDot)))()[string.substr(indexOfDot + 1)];
		}
		
		public function get defaultEaseFunction ( ):Function {
			return _defaultEase;
		}
		
	}

}