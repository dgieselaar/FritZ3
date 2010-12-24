package fritz3.utils.tween {
	import fritz3.style.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
		
	public function tween ( target:Object, transitionData:TransitionData):void {
		Tweener.engine.tween(target, transitionData);
	}

}