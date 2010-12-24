package fritz3.utils.tween {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Tweener {
		
		protected static var _engine:TweenEngine;
		
		public static function get engine ( ):TweenEngine {
			return _engine;
		}
		
		public static function set engine ( value:TweenEngine ):void {
			_engine = value;
		}
		
	}

}