package fritz3.base.parser {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Parsable {
		
		function parseProperty ( propertyName:String, value:* ):void
		function applyParsedProperties ( ):void
		
	}

}