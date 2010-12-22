package fritz3.display.button {
	import fritz3.state.State;
	import fritz3.state.ValueState;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface StateButton extends Button {
		
		function getStateObject ( stateID:String ):ValueState
		function setStateObject ( stateID:String, state:ValueState ):void
		
	}
	
}