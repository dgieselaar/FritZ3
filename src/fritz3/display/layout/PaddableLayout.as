package fritz3.display.layout {
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface PaddableLayout extends RectangularLayout {
		
		function set paddingLeft ( value:Number ):void
		function set paddingTop ( value:Number ):void
		function set paddingRight ( value:Number ):void
		function set paddingBottom ( value:Number ):void
		
	}
	
}