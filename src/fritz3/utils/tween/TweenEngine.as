package fritz3.utils.tween {
	import fritz3.style.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface TweenEngine {
		
		function tween ( target:Object, transitionData:TransitionData ):void
		function hasTween ( target:Object, propertyName:String ):Boolean
		function removeTween ( target:Object, propertyName:String ):void
		
		function getEaseFunction ( string:String ):Function
		
		function get defaultEaseFunction ( ):Function
		
		
	}

}