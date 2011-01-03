package fritz3.tween.plugins.numeric {
	import fritz3.tween.core.FTween;
	import fritz3.tween.plugins.FTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class NumericTweenPlugin implements FTweenPlugin {
		
		public function NumericTweenPlugin ( ) {
			
		}
		
		public function onInit ( tween:FTween ):void {
			
		}
		
		public function onStart ( tween:FTween ):void {
			
		}
		
		public function render ( tween:FTween, ratio:Number ):void {
			var from:Number = Number(tween.from);
			var to:Number = Number(tween.to);
			tween.target[tween.propertyName] = (to - from) * ratio + from;
		}
		
		public function onComplete ( tween:FTween ):void {
			
		}
		
		public function onRemove ( tween:FTween ):void {
			
		}
		
	}

}