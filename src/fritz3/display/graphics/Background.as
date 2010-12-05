package fritz3.display.graphics {
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * The Background interface defines a single method (<code>draw</code>)
	 * which triggers a redraw of the target supplied by the implementor.
	 * 
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.graphics
	 * 
	 * 
	 */
	
	public interface Background {
		
		/**
		 * This method signals the component to redraw.
		 * 
		 * @param 	displayObject	The DisplayObject which stores the graphics drawn by the Background class.
		 */
		
		function draw ( displayObject:DisplayObject ):void
		
		function set drawable ( value:Drawable ):void
		
	}
	
}