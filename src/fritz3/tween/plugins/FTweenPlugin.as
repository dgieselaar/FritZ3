package fritz3.tween.plugins {
	import fritz3.tween.core.FTween;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface FTweenPlugin {
		
		function onStart ( tween:FTween ):Boolean
		function render ( tween:FTween, ratio:Number ):void
		function onComplete ( tween:FTween ):void
		function onRemove ( tween:FTween ):void
		
	}
	
}