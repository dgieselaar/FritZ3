package fritz3.display.core {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Addable {
		
		function onAdd ( ):void
		
		function onRemove ( ):void
		
		function get parentComponent ( ):Addable
		function set parentComponent ( value:Addable ):void
		
	}

}