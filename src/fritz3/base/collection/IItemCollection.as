package fritz3.base.collection {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IItemCollection {
		
		function add ( item:Object ):Object
		function remove ( item:Object ):Object
		function addItemAt ( item:Object, index:uint ):Object
		function removeItemAt ( index:int ):Object 
		
		function getItemAt ( index:int ):Object
		function moveItemTo ( item:Object, index:uint ):Object
		function getItemIndex ( item:Object ):int
		
		function hasItem ( item:Object ):Object
		function get numItems ( ):uint
		
		function getItems ( ):Array
		
	}

}