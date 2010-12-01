package fritz3.display.layout {
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Layout {
		
		function get items ( ):Array
		function set items ( value:Array ):void 
		
		function get target ( ):DisplayObjectContainer
		function set target ( value:DisplayObjectContainer ):void
		
		function rearrange ( ):void 
		
	}
	
}