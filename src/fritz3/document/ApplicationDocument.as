package fritz3.document  {
	import flash.display.Sprite;
	import flash.events.Event;
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.StyleManager;
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
			InvalidationManager.init(stage);
			StyleManager.init();
		}
		
	}

}