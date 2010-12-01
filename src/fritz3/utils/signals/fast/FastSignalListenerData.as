package fritz3.utils.signals.fast {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FastSignalListenerData {
		
		public var prevNode:FastSignalListenerData;
		public var nextNode:FastSignalListenerData;
		public var executeOnce:Boolean;
		public var method:Function;
		
		public function FastSignalListenerData () {
			
		}
		
	}

}