package fritz3.base.injection {
	import fritz3.binding.Binding;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Injectable {
		
		function setProperty ( propertyName:String, value:*, parameters:Object = null ):void
		
	}

}