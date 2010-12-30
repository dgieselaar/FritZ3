package fritz3.display.layout {
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface RectangularLayout extends Layout {
		
		function set width ( value:Number ):void
		function set height ( value:Number ):void
		
		function set autoWidth ( value:Boolean ):void
		function set autoHeight ( value:Boolean ):void
		
	}
	
}