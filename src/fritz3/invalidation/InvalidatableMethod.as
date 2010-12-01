package fritz3.invalidation {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidatableMethod {
		
		public var invalidated:Boolean;
		public var args:Array;
		public var method:Function;
		
		public var nextNode:InvalidatableMethod;
		public var prevNode:InvalidatableMethod;
		
		public function InvalidatableMethod ( method:Function ) {
			this.method = method;
		}
		
		public function execute ( ):void {
			this.method.apply(null, args);
			this.args = null;
			this.invalidated = false;
		}
		
	}

}