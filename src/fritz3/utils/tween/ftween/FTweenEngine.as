package fritz3.utils.tween.ftween {
	import fritz3.style.transition.TransitionData;
	import fritz3.utils.tween.TweenEngine;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FTweenEngine implements TweenEngine {
		
		protected var _easeFunctions:Object = { };
		
		public function FTweenEngine() {
			
		}
		
		public function tween ( target:Object, transitionData:TransitionData ):void {
			
		}
		
		public function getEaseFunction ( string:String ):Function {
			return _easeFunctions[string] ||= this.parseEaseFunction(string);
		}
		
		protected function parseEaseFunction ( string:String ):Function {
			return null;
		}
		
		public function get defaultEaseFunction ( ):Function {
			return null;
		}
		
	}

}