package fritz3.style {
	import fritz3.base.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class PropertyData {
		
		public var prevNode:PropertyData;
		public var nextNode:PropertyData;
		
		public var propertyName:String;
		public var value:*;
		public var target:String;
		
		public function PropertyData ( ) {
			
		}
		
		public function clone ( target:PropertyData = null ):PropertyData {
			if (!target) {
				target = new PropertyData();
			}
			target.propertyName = this.propertyName;
			target.value = this.value;
			target.target = this.target;
			return target;
		}
		
		public function clear ( ):void {
			this.propertyName = null;
			this.value = undefined; 
			this.target = null;;
		}
		
	}

}