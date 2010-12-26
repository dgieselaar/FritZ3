package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import fritz3.base.injection.Injectable;
	import fritz3.binding.Binding;
	import fritz3.invalidation.Invalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.PropertyParser;
	import fritz3.style.transition.TransitionData;
	import fritz3.utils.tween.hasTween;
	import fritz3.utils.tween.removeTween;
	import fritz3.utils.tween.tween;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidatableDisplayComponent extends Sprite implements Invalidatable, Injectable, Addable {
		
		protected var _invalidationHelper:InvalidationHelper;
		protected var _priority:int;
		
		protected var _parameters:Object;
		
		protected var _properties:Object = { };
		
		protected var _propertyParsers:Object = {};
		
		protected var _parentComponent:Addable;
		
		public function InvalidatableDisplayComponent ( parameters:Object = null ) {
			super();
			_parameters = parameters;
			this.initializeComponent();
		}
		
		protected function initializeComponent ( ):void {
			this.initializeDependencies();
			this.setInvalidationMethodOrder();
			this.setParsers();
			this.setDefaultProperties();
			this.applyParameters();
		}
		
		public function setProperty ( propertyName:String, value:*, parameters:Object = null ):void {
			_properties[propertyName] = value;
			
			if (parameters && parameters.transition) {
				var transitionData:TransitionData = TransitionData(parameters.transition);
				tween(this, transitionData);
			} else {
				if (hasTween(this, propertyName)) {
					removeTween(this, propertyName);
				}
				this[propertyName] = value;
			}
		}
		
		public function onAdd ( ):void {
			
		}
		
		public function onRemove ( ):void {
			
		}
		
		protected function initializeDependencies ( ):void {
			this.initializeInvalidation();
		}
		
		protected function setInvalidationMethodOrder ( ):void {
			
		}
		
		protected function setParsers ( ):void {
			
		}
		
		protected function setDefaultProperties ( ):void {
			
		}
		
		protected function initializeInvalidation ( ):void {
			_invalidationHelper = new InvalidationHelper();
		}
		
		protected function applyParameters ( ):void {
			for (var name:String in _parameters) {
				this.setProperty(name, _parameters[name]);
			}
		}
		
		protected function addParser ( propertyName:String, parser:PropertyParser ):void {
			_propertyParsers[propertyName] = parser;
		}
		
		protected function getParser ( propertyName:String ):PropertyParser {
			return _propertyParsers[propertyName];
		}
		
		protected function removeParser ( propertyName:String ):void {
			delete _propertyParsers[propertyName];
		}
		
		protected function setPriority ( value:int ):void {
			_priority = value;
			_invalidationHelper.priority = value;
		}
		
		protected function setParentComponent ( parentComponent:Addable ):void {
			_parentComponent = parentComponent;
		}
		
		public function executeInvalidatedMethods():void{
			_invalidationHelper.executeInvalidatedMethods();
		}
		
		public function get priority ( ):int { return _priority; }
		public function set priority ( value:int ):void{
			if (_priority != value) {
				this.setPriority(value);
			}
		}
		
		public function get properties ( ):Object { return _properties; }
		
		public function get parentComponent ( ):Addable { return _parentComponent; }
		public function set parentComponent ( value:Addable ):void {
			if (_parentComponent != value) {
				this.setParentComponent(value);
			}
		}
	}

}