package fritz3.style.selector  {
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
			match = where.match(/\.([a-z0-9_\-]+)/);
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
			var cache:ObjectCache = ObjectCache.getCache(object);
			if (this.id && cache.id != this.id) {
				return false;
			}
			if (this.className && cache.className != this.className) {
				return false;
			}
			if (this.name && cache.name != this.name) {
				return false;
			}
			if (this.classObjectString) {
				if (!this.classObject) {
					this.classObject = getClass(this.classObjectString);
				}
				if (!(object is this.classObject)) {
					return false;
				}
			}
			return true;
		}
	}

}