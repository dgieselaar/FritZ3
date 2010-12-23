package fritz3.utils.object {
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	internal class ClassManager {
		
		protected static var _classByAlias:Object;
		
		{
			_classByAlias = { };
		}
		
		public function ClassManager ( ) {
		}
		
		public static function addClassAlias ( alias:String, classObject:Class ):void {
			_classByAlias[alias] = classObject;
		}
		
		public static function removeClassAlias ( alias:String ):void {
			delete _classByAlias[alias];
		}
		
		public static function hasClassAlias ( alias:String ):Boolean {
			return Boolean(_classByAlias[alias]);
		}
		
		public static function getClass ( alias:String ):Class {
			var classObject:Class = _classByAlias[alias];
			if (!classObject) {
				try {
					classObject = Class(getDefinitionByName(alias));
				} catch ( error:Error ) {
					if (!classObject) {
						classObject = getClassByAlias(alias);
					}
					if (!classObject) {
						throw error;
					}
				}
				_classByAlias[alias] = classObject;
			}
			return classObject;
		}
		
	}

}