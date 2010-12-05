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
		
		public var firstNode:SimpleSelector;
		public var lastNode:SimpleSelector;
		
		public function Selector ( where:String )  {
			this.setWhere(where);
		}
		
		protected function setWhere ( where:String ):void {
			this.where = where;
			var match:Array, i:int, l:int;
			if (where == "*") {
				this.isUniversal = true;
				return;
			}
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
			if (this.isUniversal) {
				return true;
			}
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
			
			var node:SimpleSelector;
			while (node) {
				if (node is AttributeSelector) {
					if (!this.matchAttributeSelector(AttributeSelector(node), cache)) {
						return false;
					}
				} else if (node is StructuralSelector) {
					if (!cache.cachedChildProperties) {
						cache.cacheChildProperties();
					}
					if (!this.matchStructuralSelector(StructuralSelector(node), cache)) {
						return false;
					}
				}
				node = node.nextNode;
			}
			return true;
		}
		
		protected function matchAttributeSelector ( selector:AttributeSelector, cache:ObjectCache ):Boolean {
			if (!cache.object.hasOwnProperty(selector.propertyName)) {
				return false;
			}
			var inverted:Boolean = selector.inverted;
			var match:Boolean, length:int, needle:String, stringValue:String;
			switch(selector.type) {
				case AttributeSelectorType.BEGINS_WITH:
				match = (String(cache.getProperty(selector.propertyName)).indexOf(String(selector.value)) == 0);
				break;
				
				case AttributeSelectorType.ENDS_WITH:
				needle = String(selector.value);
				stringValue = cache.getProperty(selector.propertyName);
				match = stringValue.indexOf(needle) == stringValue.length - needle.length;
				break;
				
				case AttributeSelectorType.HAS:
				match = String(cache.getProperty(selector.propertyName)).indexOf(String(selector.value)) != -1;
				break;
				
				case AttributeSelectorType.IS:
				match = cache.getProperty(selector.propertyName) == selector.value;
				break;
				
				case AttributeSelectorType.IS_DEFINED:
				match = cache.object.hasOwnProperty(selector.value);
				break;
				
				case AttributeSelectorType.IS_SET:
				match = Boolean(cache.getProperty(selector.propertyName));
				break;
			}
			return match != inverted;
		}
		
		protected function matchStructuralSelector ( selector:StructuralSelector, cache:ObjectCache ):Boolean {
			var inverted:Boolean = selector.inverted;
			var match:Boolean;
			switch(selector.type) {
				case StructuralSelectorType.EMPTY:
				match = cache.empty;
				break;
				
				case StructuralSelectorType.FIRST_CHILD:
				match = cache.firstChild;
				break;
				
				case StructuralSelectorType.LAST_CHILD:
				match = cache.lastChild;
				break;
				
				case StructuralSelectorType.LAST_OF_TYPE:
				match = cache.lastOfType;
				break;
				
				case StructuralSelectorType.NTH_CHILD:
				match = cache.childIndex == selector.childIndex;
				break;
				
				case StructuralSelectorType.NTH_LAST_CHILD:
				match = cache.nthLastChild == selector.childIndex;
				break;
				
				case StructuralSelectorType.NTH_LAST_OF_TYPE:
				if (!cache.cachedAllSiblings) {
					cache.cacheAllSiblings();
				}
				match = cache.nthLastOfType == selector.childIndex;
				break;
				
				case StructuralSelectorType.NTH_OF_TYPE:
				if (!cache.cachedAllSiblings) {
					cache.cacheAllSiblings();
				}
				match = cache.nthOfType == selector.childIndex;
				break;
				
				case StructuralSelectorType.ONLY_CHILD:
				match = cache.onlyChild;
				break;
				
				case StructuralSelectorType.ONLY_OF_TYPE:
				if (!cache.cachedAllSiblings) {
					cache.cacheAllSiblings();
				}
				match = cache.onlyOfType;
				break;
			}
			return match != inverted;
		}
	}

}