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
	
	public function setState ( id:String, value:* ):void {
		return StateManager.setState(id, value);
	}

}