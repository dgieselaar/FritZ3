package fritz3.display.core {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IAddable {
		
		function onAdd ( ):void
		
		function onRemove ( ):void
		
		function get parentComponent ( ):IAddable
		function set parentComponent ( value:IAddable ):void
		
	}

}