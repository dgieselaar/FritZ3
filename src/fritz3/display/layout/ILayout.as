package fritz3.display.layout {
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface ILayout {
		
		function rearrange ( container:DisplayObjectContainer, items:Array ):void
		
		function set rearrangable ( value:IRearrangable ):void
		
	}
	
}