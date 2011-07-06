package fritz3.utils.tween {
	import fritz3.base.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface ITweenEngine {
		
		function tween ( target:Object, propertyName:String, transitionData:TransitionData ):void
		function hasTween ( target:Object, propertyName:String ):Boolean
		function removeTween ( target:Object, propertyName:String ):void
		
		function getEaseFunction ( string:String ):Function
		
		function get defaultEaseFunction ( ):Function
		
		
	}

}