package fritz3.base.parser {
	import fritz3.style.PropertyData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ParseHelper {
		
		protected static var _propertyDataPool:Array;
		
		public var firstNode:PropertyData;
		public var lastNode:PropertyData;
		
		public var nodesByPropertyName:Object;
		
		{
			_propertyDataPool = [];
		}
		
		public function ParseHelper ( ) {
			this.nodesByPropertyName = { };
		}
		
		public function setProperty ( propertyName:String, value:* ):void {
			var node:PropertyData = this.nodesByPropertyName[propertyName];
			if (!node) {
				node = getNodeObject();
				node.propertyName = propertyName;
				this.nodesByPropertyName[propertyName] = node;
				if (this.lastNode) {
					this.lastNode.nextNode = node;
					node.prevNode = this.lastNode;
				} else {
					this.firstNode = node;
				}
				this.lastNode = node;
			} 
			
			node.value = value;
		}
		
		public function reset ( ):void {
			var node:PropertyData = this.firstNode, nextNode:PropertyData;
			while (node) {
				nextNode = node.nextNode;
				node.prevNode = node.nextNode = null;
				node.propertyName = null;
				node.value = undefined;
				_propertyDataPool[_propertyDataPool.length] = node;
				node = nextNode;
			}
			this.firstNode = this.lastNode = null;
			this.nodesByPropertyName = { };
		}
		
		protected static function getNodeObject ( ):PropertyData {
			return _propertyDataPool.shift() || new PropertyData();
		}
		
	}

}