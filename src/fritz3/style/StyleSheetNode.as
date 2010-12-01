package fritz3.style {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleSheetNode {
		
		public var prevNode:StyleSheetNode;
		public var nextNode:StyleSheetNode;
		
		public var firstNode:PropertyData;
		public var lastNode:PropertyData;
		
		protected var _properties:Object = { };
		
		public function StyleSheetNode ( ) {
			
		}
		
		public function invalidate ( ):void {
			
		}
		
		public function append ( propertyData:PropertyData ):void {
			var duplicate:PropertyData = this.getPropertyData(propertyData.propertyName, propertyData.target);
			if (duplicate) {
				this.remove(duplicate);
			}
			
			if (!this.firstNode) {
				this.firstNode = propertyData;
			}
			if (this.lastNode) {
				this.lastNode.nextNode = propertyData;
				propertyData.prevNode = this.lastNode;
			}
			this.lastNode = propertyData;
		}
		
		public function remove ( propertyData:PropertyData ):void {
			var prevNode:PropertyData = propertyData.prevNode, nextNode:PropertyData = propertyData.nextNode;
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			if (propertyData == this.firstNode) {
				this.firstNode = nextNode;
			}
			if (propertyData == this.lastNode) {
				this.lastNode = prevNode;
			}
			propertyData.prevNode = propertyData.nextNode = null;
		}
		
		protected function getPropertyData ( propertyName:String, target:String = null ):PropertyData {
			return _properties[target] ? _properties[target][propertyName] : null;
		}
		
	}

}