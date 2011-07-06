package fritz3.display.layout {
	import fritz3.display.core.DisplayValue;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IPositionable {
		
		function get x ( ):Number
		function set x ( value:Number ):void
		
		function get y ( ):Number
		function set y ( value:Number ):void
		
		function get width ( ):Number
		function set width ( value:Number ):void
		
		function get height ( ):Number
		function set height ( value:Number ):void
		
		function get preferredWidth ( ):DisplayValue
		function get preferredHeight ( ):DisplayValue
		
		function get minimumWidth ( ):DisplayValue
		function get maximumWidth ( ):DisplayValue
		
		function get minimumHeight ( ):DisplayValue
		function get maximumHeight ( ):DisplayValue
		
		function get left ( ):DisplayValue
		function get top ( ):DisplayValue
		function get right ( ):DisplayValue
		function get bottom ( ):DisplayValue
		
		function get horizontalFloat ( ):String
		function get verticalFloat ( ):String
		
		function get marginLeft ( ):DisplayValue
		function get marginTop ( ):DisplayValue
		function get marginRight ( ):DisplayValue
		function get marginBottom ( ):DisplayValue
		
		function get registration ( ):String
		
	}
	
}