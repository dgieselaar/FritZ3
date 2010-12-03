package fritz3.style.selector  {
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
		public var classObject:Class;
		
		public function Selector ( where:String )  {
			this.setWhere(where);
		}
		
		protected function setWhere ( where:String ):void {
			this.where = where;
		}
		
		public function match ( object:Object ):Boolean {
			return false;
		}
		
	}

}