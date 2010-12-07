package fritz3.display.layout.flexiblebox  {
	import fritz3.display.layout.Positionable;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.layout.flexiblebox
	 * 
	 * [Description]
	*/
	
	public interface FlexibleBoxElement extends Positionable {
		
		function get boxOrdinalGroup ( ):int
		function get boxFlex ( ):Number
		function get boxFlexGroup ( ):int
		
	}

}