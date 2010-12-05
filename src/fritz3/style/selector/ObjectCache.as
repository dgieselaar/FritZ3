package fritz3.style.selector {
	import flash.utils.Dictionary;
	import fritz3.base.collection.ItemCollection;
	import fritz3.display.core.Addable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ObjectCache {
		
		protected static var _objectCache:Dictionary = new Dictionary();
		protected static var _objectCachePool:Array = [];
		
		public var object:Object;
		
		public var id:String;
		public var className:String;
		public var name:String;
		
		public var properties:Object;
		
		public var cachedChildProperties:Boolean;
		public var parentCollection:ItemCollection;
		public var onlyChild:Boolean;
		public var childIndex:int = -1;
		public var even:Boolean;
		public var parentNumChildren:int;
		public var lastChild:Boolean;
		public var firstChild:Boolean;
		public var empty:Boolean;
		
		public var cachedDirectSiblings:Boolean;
		public var prevSibling:Object;
		public var nextSibling:Object;
		
		public var cachedAllSiblings:Boolean;
		public var previousSiblings:Array;
		public var nextSiblings:Array;
		public var firstOfType:Boolean;
		public var lastOfType:Boolean;
		public var onlyOfType:Boolean;
		public var nthOfType:int;
		public var nthLastOfType:int;
		
		public function ObjectCache ( ) {
			
		}
		
		public function invalidate ( ):void {
			this.object = null;
			this.id = this.className = this.name = null;
			this.properties = { };
			
			this.cachedChildProperties = false;
			this.parentCollection = null;
			this.onlyChild = false;
			this.childIndex = -1;
			this.even = false;
			this.parentNumChildren = -1;
			this.lastChild = false;
			this.firstChild = false;
			this.empty = false;
			
			this.cachedDirectSiblings = false;
			this.prevSibling = false;
			this.nextSibling = false;
			
			this.cachedAllSiblings = false;
			this.previousSiblings = null;
			this.nextSiblings = null;
			this.firstOfType = false;
			this.lastOfType = false;
			this.onlyOfType = false;
			this.nthOfType = -1;
			this.nthLastOfType = -1;
		}
		
		public function setObject ( object:Object ):void {
			if (object.hasOwnProperty("id")) {
				this.id = object.id;
			}
			if (object.hasOwnProperty("className")) {
				this.className = object.className;
			}	
			if (object.hasOwnProperty("name")) {
				this.name = object.name
			}
		}
		
		public function cacheChildProperties ( ):void {
			if (this.object is Addable) {
				var parent:Addable = Addable(object).parentComponent;
				if (parent && parent is ItemCollection) {
					this.parentCollection = ItemCollection(parent);
					this.parentNumChildren = this.parentCollection.numItems;
					this.onlyChild = (this.parentNumChildren == 1);
					this.childIndex = this.parentCollection.getItemIndex(this.object);
					this.even = Boolean(this.childIndex & 1);
					this.firstChild = (this.childIndex == 0);
					this.lastChild = (this.childIndex == this.parentNumChildren - 1);
				}
			}
		}
		
		public function cacheDirectSiblings ( ):void {
			this.prevSibling = this.parentCollection.getItemAt(this.childIndex - 1);
			this.nextSibling = this.parentCollection.getItemAt(this.childIndex + 1);
			this.cachedDirectSiblings = true;
		}
		
		public function cacheAllSiblings ( ):void {
			this.cachedAllSiblings = true;
		}
		
		public function getProperty ( propertyName:String ):* {
			if (this.properties[propertyName] != undefined) {
				return this.properties[propertyName];
			}
			if (!this.object.hasOwnProperty(propertyName)) {
				return undefined;
			}
			return (this.properties[propertyName] = this.object[propertyName]);
		}
		
		public static function clearCache ( object:Object ):void {
			var cache:ObjectCache = _objectCache[object];
			poolCacheObject(cache);
			delete _objectCache[object];
		}
		
		public static function getCache ( object:Object ):ObjectCache {
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