package fritz3.style.selector  {
	import flash.utils.Dictionary;
	import fritz3.utils.object.addClassAlias;
	import fritz3.utils.object.getClass;
	import fritz3.utils.object.removeClassAlias;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.style
	 * 
	 * [Description]
	*/
	
	public class Selector {
		
		protected static var _objectCache:Dictionary = new Dictionary();
		protected static var _objectCachePool:Array = [];
		
		public var relationship:String;
		
		public var prevNode:Selector;
		public var nextNode:Selector;
		
		public var where:String;
		
		public var id:String;
		public var className:String;
		public var name:String;
		public var classObjectString:String;
		public var classObject:Class;
		public var isUniversal:Boolean;
		
		public function Selector ( where:String )  {
			this.setWhere(where);
		}
		
		protected function setWhere ( where:String ):void {
			this.where = where;
			var match:Array, i:int, l:int;
			match = where.match(/^([A-Za-z0-9]+)/);
			if (match) {
				this.classObjectString = match[1];
			}
			match = where.match(/#([a-z0-9_\-]+)/);
			if (match) {
				this.id = match[1];
			}
			match = where.match(/.([a-z0-9_\-]+)/);
			if (match) {
				this.className = match[1];
			}
			match = where.match(/@([a-z0-9_\-]+)/);
			if (match) {
				this.name = match[1];
			}
			
			if (this.classObjectString) {
				classObject = getClass(classObjectString);
			}
			
		}
		
		public function match ( object:Object ):Boolean {
			return false;
		}
		
		public static function clearCache ( ):void {
			for each(var cache:ObjectCache in _objectCache) {
				poolCacheObject(cache);
			}
			_objectCache = new Dictionary();
		}
		
		protected static function getCache ( object:Object ):ObjectCache {
			var cache:ObjectCache = _objectCache[object];
			if (!cache) {
				_objectCache[object] = cache = new ObjectCache();
				cache.setObject(cache);
			}
			return cache;
		}
		
		protected static function getCacheObject ( ):ObjectCache {
			return _objectCachePool.length ? _objectCachePool.shift() : new ObjectCache();
		}
		
		protected static function poolCacheObject ( cache:ObjectCache ):void {
			cache.invalidate();
			_objectCachePool[_objectCachePool.length] = cache;
		}		
	}

}