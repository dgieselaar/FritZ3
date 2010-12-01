package fritz3.invalidation {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidationData {
		
		public var firstMethod:InvalidatableMethod;
		public var lastMethod:InvalidatableMethod;
		public var priority:int;
		
		public var prevNode:InvalidationData;
		public var nextNode:InvalidationData;
		
		public var marked:Boolean;
		
		public function InvalidationData ( ) {
			
		}
		
	}

}