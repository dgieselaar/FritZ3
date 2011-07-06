package fritz3.utils.tween {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Tweener {
		
		protected static var _engine:ITweenEngine;
		
		public static function get engine ( ):ITweenEngine {
			return _engine;
		}
		
		public static function set engine ( value:ITweenEngine ):void {
			_engine = value;
		}
		
	}

}