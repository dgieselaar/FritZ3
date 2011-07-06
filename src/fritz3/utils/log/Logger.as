package fritz3.utils.log {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class Logger {
		
		protected static var _instance:ILogEngine;
		
		public static function get engine ( ):ILogEngine { return _instance; }
		public static function set engine ( value:ILogEngine ):void {
			_instance = value;
		}
		
	}

}