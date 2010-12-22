package fritz3.state  {
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.state
	 * 
	 * [Description]
	*/
	
	public function removeState ( state:State ):void {
		return StateManager.singleton().removeState(state);
	}

}