package fritz3.display.button {
	import fritz3.state.IState;
	import fritz3.state.IValueState;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IStateButton extends IButton {
		
		function getStateObject ( stateID:String ):IValueState
		function setStateObject ( stateID:String, state:IValueState ):void
		
	}
	
}