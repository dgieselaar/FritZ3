package fritz3.utils.tween.ftween {
	import fritz3.base.transition.TransitionData;
	import fritz3.tween.core.FTween;
	import fritz3.tween.core.FTweener;
	import fritz3.tween.easing.Back;
	import fritz3.tween.easing.Bounce;
	import fritz3.tween.easing.Circ;
	import fritz3.tween.easing.Cubic;
	import fritz3.tween.easing.Elastic;
	import fritz3.tween.easing.Expo;
	import fritz3.tween.easing.Linear;
	import fritz3.tween.easing.Quad;
	import fritz3.tween.easing.Quart;
	import fritz3.tween.easing.Quint;
	import fritz3.tween.easing.Sine;
	import fritz3.tween.easing.Strong;
	import fritz3.tween.plugins.color.ColorTweenPlugin;
	import fritz3.tween.plugins.displayvalue.DisplayValueTweenPlugin;
	import fritz3.tween.plugins.gradient.GradientTweenPlugin;
	import fritz3.utils.object.getClass;
	import fritz3.utils.tween.ITweenEngine;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FTweenEngine implements ITweenEngine {
		
		protected var _defaultEase:Function = Cubic.easeOut;
		protected var _easeFunctions:Object = { };
		
		public function FTweenEngine ( ) {
			Back, Bounce, Circ, Cubic, Elastic, Quad, Quart, Quint, Expo, Linear, Sine, Strong;
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
			
			FTweener.addPlugin([
			"preferredWidth", "preferredHeight",
			"minimumWidth", "minimumHeight", "maximumWidth", "maximumHeight",
			"margin", "marginLeft", "marginTop", "marginRight", "marginBottom",
			"padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
			"backgroundImageWidth", "backgroundImageHeight"
			], DisplayValueTweenPlugin.instance);
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
			return (getClass(string.substr(0, indexOfDot)))[string.substr(indexOfDot + 1)];
		}
		
		public function get defaultEaseFunction ( ):Function {
			return _defaultEase;
		}
		
	}

}