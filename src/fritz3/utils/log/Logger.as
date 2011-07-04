package fritz3.utils.log {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Logger {
		
		protected static var _instance:LogEngine;
		
		public static function get engine ( ):LogEngine { return _instance; }
		public static function set engine ( value:LogEngine ):void {
			_instance = value;
		}
		
	}

}