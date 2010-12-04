package fritz3.document  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.addClassAlias;
	import fritz3.utils.object.hasClassAlias;
	import ru.etcs.utils.getDefinitionNames;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.document
	 * 
	 * [Description]
	*/
	
	public class ApplicationDocument extends DisplayComponentContainer {
		
		protected var _initialized:Boolean;
		
		public function ApplicationDocument ( properties:Object = null ) {
			super(properties);
			if (!stage) {
				this.addEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			} else {
				this.onAdd();
			}
		}
		
		override protected function initializeComponent ( ):void  {
			if (!stage || _initialized) {
				return;
			}
			_initialized = true;
			super.initializeComponent();
		}
		
		protected function onStageAdd ( e:Event ):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			this.onAdd();
		}
		
		override public function onAdd ( ):void  {
			super.onAdd();
			
			this.getClassDefinitions();
			InvalidationManager.init(stage);
			StyleManager.init();
		}
		
		protected function getClassDefinitions ( ):void {
			var definitions:Array = getDefinitionNames(stage.loaderInfo.bytes, true, false);
			var definition:String, alias:String, classObject:Class;
			for (var i:int, l:int = definitions.length; i < l; ++i) {
				definition = definitions[i];
				try {
					classObject = getDefinitionByName(definition) as Class;
					if (!classObject) {
						continue;
					}
					alias = definition.match(/(.*?::)?(.*?)$/)[2];
					// if alias is already registered, override when current 
					// class is part of FritZ3 package
					if (!hasClassAlias(alias) || definition.indexOf("fritz3") == 0) {
						addClassAlias(alias, classObject);
					}
				} catch ( error:Error ) {
					
				}
			}
		}
		
	}

}