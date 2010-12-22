package fritz3.state {
	
	/**
	 * [Description]
	 * 
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package casper.system
	 */
	
	internal class StateManager {
		
		protected static const GLOBAL:String = 'global';
		
		protected static var _collection:StateCollection;
		
		{
			_collection = new StateCollection(GLOBAL);
		}
		
		public static function getState ( stateID:String ):* {
			return _collection.getState(stateID);
		}
		
		public static function setState ( stateID:String, value:* ):void {
			_collection.setState(stateID, value);
		}
		
		public static function addState ( state:State ):State {
			return _collection.addState(state);
		}
		
		public static function removeState ( state:State ):void {
			_collection.removeState(state);
		}
		
		public static function getStateObject ( stateID:String ):State {
			return _collection.getStateObject(stateID);
		}
		
	}
	
}

class SingletonEnforcer {}