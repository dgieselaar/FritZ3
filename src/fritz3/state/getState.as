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
	
	public function getState ( id:String ):* {
		return StateManager.getState(id);
	}

}