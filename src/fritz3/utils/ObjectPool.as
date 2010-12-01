package fritz3.utils {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ObjectPool {
		
		private static var _pool:Dictionary = new Dictionary();
		
		public function ObjectPool() {
			
		}
		
		public static function getObject ( objectClass:Class ):Object {
			var pool:Array = _pool[objectClass];
			if (!pool) {
				_pool[objectClass] = pool = [];
			}
			
			var object:Object = pool.shift();
			if (!object) {
				object = new objectClass();
			}
			return object;
		}
		
		public static function releaseObject ( object:Object ):void {
			var pool:Array = _pool[object.constructor];
			pool.push(object);
		}
		
		
		
	}

}