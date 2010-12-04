package fritz3.style.selector {
	import fritz3.base.collection.ItemCollection;
	import fritz3.display.core.Addable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class SelectorList {
		
		public var firstNode:Selector;
		public var lastNode:Selector;
		
		public var numSelectors:int;
		
		public function SelectorList ( where:String ) {
			var match:Array = where.match(/((.*?)\s+)|((.*?)(\s+[>+~]))|([^\s]+$)/g);
			if (!match) {
				throw new Error("Invalid Selector supplied in style rule: " + where);
			}
			
			var node:Selector, prevNode:Selector, relationship:String = null, relationshipIndicator:String;
			var selector:String, afterIndex:Array;
			for (var i:int, l:int = match.length; i < l; i++) {
				selector = match[i];
				match[i] = selector = selector.replace(/$\s+/, "").replace(/\s+$/, "");
				if (i & 1) {
					if (!selector.match(/^[>+~]$/)) {
						afterIndex = match.splice(i);
						match[i] = " ";
						match = match.concat(afterIndex);
						l++;
					}
				}
			}
			
			for (i = 0; i < l; ++i) {
				selector = match[i];
				if(i & 1) {
					switch(selector) {
						case ">":
						relationship = SelectorRelationship.CHILD;
						break;
						
						case " ":
						relationship = SelectorRelationship.DESCENDANT;
						break;
						
						case "+":
						relationship = SelectorRelationship.FOLLOWING;
						break;
						
						case "~":
						relationship = SelectorRelationship.FOLLOWING_IMMEDIATELY;
						break;
						
						default:
						relationship = null;
						break;
					}
				} else {
					node = new Selector(selector);
					if (prevNode) {
						node.prevNode = node;
						prevNode.nextNode = node;
					} else {
						this.firstNode = node;
					}
					node.relationship = relationship;
					this.numSelectors++;
				}
				prevNode = node;
			}
			this.lastNode = node;
			
			node = this.firstNode;
		}
		
		public function match ( object:Object ):Boolean {
			var node:Selector = this.lastNode;
			var objectToMatch:Object = object;
			
			if (node.prevNode && !(object is Addable)) {
				return false;
			}
			
			var addable:Addable = Addable(object), currentAddable:Addable = addable;
			var collection:ItemCollection, objectCache:ObjectCache = ObjectCache.getCache(object);
			
			while (node) {
				if (!object || !node.match(object)) {
					return false;
				}
				switch(node.relationship) {
					case SelectorRelationship.CHILD:
					currentAddable = currentAddable.parentComponent;
					break;
					
					case SelectorRelationship.DESCENDANT:
					currentAddable = currentAddable.parentComponent;
					break;
					
					case SelectorRelationship.PRECEDING:
					if (!objectCache.cachedAllSiblings) {
						objectCache.cacheAllSiblings();
					}
					break;
					
					case SelectorRelationship.PRECEDING_IMMEDIATELY:
					if (!objectCache.cachedDirectSiblings) {
						objectCache.cachedDirectSiblings();
					}
					break;
					
					case SelectorRelationship.FOLLOWING:
					if (!objectCache.cachedAllSiblings) {
						objectCache.cacheAllSiblings();
					}
					break;
					
					case SelectorRelationship.FOLLOWING_IMMEDIATELY:
					if (!objectCache.cachedDirectSiblings) {
						objectCache.cachedDirectSiblings();
					}
					break;
				}
				node = node.prevNode;
				currentAddable = currentAddable.parentComponent;
			}
			
			return true;
		}
		
		protected function matchSelector ( selector:Selector, object:Object ):void {
			
		}
		
	}

}