package fritz3.display.layout {
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Positionable {
		
		function get x ( ):Number
		function set x ( value:Number ):void
		
		function get y ( ):Number
		function set y ( value:Number ):void
		
		function get width ( ):Number
		function set width ( value:Number ):void
		
		function get height ( ):Number
		function set height ( value:Number ):void
		
		function get minimumWidth ( ):Number
		function get maximumWidth ( ):Number
		
		function get minimumHeight ( ):Number
		function get maximumHeight ( ):Number
		
		function get top ( ):Number
		function get left ( ):Number
		function get bottom ( ):Number
		function get right ( ):Number
		
		function get horizontalFloat ( ):String
		function get verticalFloat ( ):String
		
		function get marginTop ( ):Number
		function get marginLeft ( ):Number
		function get marginBottom ( ):Number
		function get marginRight ( ):Number
		
		function get registration ( ):String
		
	}
	
}