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
			match = where.match(/#([A-Za-z0-9_\-]+)/);
			if (match) {
				this.id = match[1];
			}
			match = where.match(/\.([A-Za-z0-9_\-]+)/);
			if (match) {
				this.className = match[1];
			}
			match = where.match(/@([A-Za-z0-9_\-]+)/);
			if (match) {
				this.name = match[1];
			}
			
			if (this.classObjectString) {
				classObject = getClass(classObjectString);
			}
			
			var node:SimpleSelector, prevNode:SimpleSelector;
			
			var attributeMatches:Array = where.match(/\[.*?\]/g);
			var attributeSelector:String;
			for (i = 0, l = attributeMatches ? attributeMatches.length : 0; i < l; ++i) {
				attributeSelector = attributeMatches[i];
				attributeSelector = attributeSelector.substring(1, attributeSelector.length - 1);
				node = this.getAttributeSelector(attributeSelector);
				if (prevNode) {
					prevNode.nextNode = node;
					node.prevNode = prevNode;
				} else {
					this.firstNode = this.lastNode = node;
				}
				prevNode = node;
			}
			
			var structuralMatches:Array = where.match(/:([^:\[]+)/g), structuralSelector:String;
			for (i = 0, l = structuralMatches ? structuralMatches.length : 0; i < l; ++i) {
				structuralSelector = structuralMatches[i];
				structuralSelector = structuralSelector.substr(1);
				node = this.getStructuralSelector(structuralSelector);
				if (prevNode) {
					prevNode.nextNode = node;
					node.prevNode = prevNode;
				} else {
					this.firstNode = this.lastNode = node;
				}
				prevNode = node;
			}
		}
		
		protected function getAttributeSelector ( selector:String ):SimpleSelector {
			var attributeSelector:AttributeSelector = new AttributeSelector();
			var match:Array = selector.match(/^(!)?([A-Za-z0-9\-]+)(([\^\*\$])?(!)?=(")?(.*?)(")?)?$/);
			if (!match) {
				throw new Error("Invalid AttributeSelector defined: " + selector);
			}
			
			var propertyName:String = match[2];
			
			var inverted:Boolean;
			var attributeType:String;
			if(match[3]) {
				inverted = match[5] == "!";
				switch(match[4]) {
					default:
					attributeType = AttributeSelectorType.IS;
					break;
					
					case "^":
					attributeType = AttributeSelectorType.BEGINS_WITH;
					break;
					
					case "$":
					attributeType = AttributeSelectorType.ENDS_WITH;
					break;
					
					case "*":
					attributeType = AttributeSelectorType.HAS;
					break;
				}
			} else {
				attributeType = AttributeSelectorType.IS_DEFINED;
				inverted = match[1] == "!";
			}
			
			attributeSelector.propertyName = propertyName;
			attributeSelector.type = attributeType;
			if (match[7] != undefined) {			
				var value:* = match[7];
				if (String(value).match(/^\d+$/) && match[6] != undefined && match[8] != undefined) {
					value = Number(value);
				}
				attributeSelector.value = value;
			}
			attributeSelector.inverted = inverted;
			return attributeSelector;
		}
		
		protected function getStructuralSelector ( selector:String ):SimpleSelector {
			var propertyName:String, type:String = selector, inverted:Boolean, match:Array, childIndex:int;
			if (type.indexOf("!") == 0) {
				inverted = true;
				type = type.substr(1);
			} 
			
			if((match = type.match(/(.*?)\((\d+)\)$/))) {
				type = match[1];
				childIndex = match[2];
			}
			var simpleSelector:SimpleSelector, attributeSelector:AttributeSelector, structuralSelector:StructuralSelector;
			switch(type) {
				case StructuralSelectorType.EMPTY:  
				case StructuralSelectorType.FIRST_CHILD:
				case StructuralSelectorType.FIRST_OF_TYPE:
				case StructuralSelectorType.LAST_CHILD:
				case StructuralSelectorType.LAST_OF_TYPE:
				case StructuralSelectorType.NTH_CHILD:
				case StructuralSelectorType.NTH_LAST_CHILD:
				case StructuralSelectorType.NTH_LAST_OF_TYPE:
				case StructuralSelectorType.NTH_OF_TYPE:
				case StructuralSelectorType.ONLY_CHILD:
				case StructuralSelectorType.ONLY_OF_TYPE:
				simpleSelector = structuralSelector = new StructuralSelector();
				structuralSelector.childIndex = childIndex;
				break;
				
				default:
				simpleSelector = attributeSelector = new AttributeSelector();
				attributeSelector.propertyName = type;
				attributeSelector.type = AttributeSelectorType.IS_SET;
				type = AttributeSelectorType.IS_SET;
				break;
			}
			
			simpleSelector.type = type;
			simpleSelector.inverted = inverted;
			
			return simpleSelector;
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
			
			var node:SimpleSelector = this.firstNode;
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
			if (selector.type != AttributeSelectorType.IS_DEFINED && !cache.object.hasOwnProperty(selector.propertyName)) {
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
				match = cache.object.hasOwnProperty(selector.propertyName);
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