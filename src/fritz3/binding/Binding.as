package fritz3.binding {
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Binding {
		
		function get propertyName ( ):String
		
		function setProperty ( propertyName:String, value:*, parameters:Object = null ):void
		
	}
	
}