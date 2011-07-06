package fritz3.state {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	
	/**
	 * [Description]
	 * 
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package casper.system.state
	 */
	
	public class StateCollection implements IState {
		
		protected var _id:String;
		protected var _states:Object;
		
		
		// TODO: listen for & propagate changes
		
		public function StateCollection ( id:String ) {
			_id = id;
			_states = { };
		}
		
		public function addState ( state:IState ):IState {
			return _states[state.id] ||= state;
		}
		
		public function removeState ( state:IState ):void {
			delete _states[state.id];
		}
		
		public function getStateObject ( id:String ):IState {
			return _states[id] as IState;
		}
		
		public function getState ( id:String ):* {
			var state:SingleState = this.getStateObject(id) as SingleState;
			return state ? state.value : undefined;
		}
		
		public function hasState ( id:String ):Object {
			return (_states[id] != undefined);
		}
		
		public function setState ( id:String, value:Object ):void {
			var state:SingleState = this.getStateObject(id) as SingleState;	
			if (!state) throw new Error("State [" + id + "] not found in StateCollection [" + _id + "].");
			else state.value = value;
		}
		
		public function getStates ( ):Object {
			return _states;
		}
		
		public function get id ( ):String { return _id; }
		
	}
	
}