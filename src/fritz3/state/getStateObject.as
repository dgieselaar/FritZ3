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
	
	public function getStateObject ( id:String ):State {
		return StateManager.getStateObject(id);
	}

}