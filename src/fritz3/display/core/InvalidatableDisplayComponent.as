package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import fritz3.base.injection.Injectable;
	import fritz3.binding.Binding;
	import fritz3.invalidation.Invalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationManager;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidatableDisplayComponent extends Sprite implements Invalidatable, Injectable, Addable {
		
		protected var _invalidationHelper:InvalidationHelper;
		protected var _parameters:Object;
		
		protected var _properties:Object = { };
		
		protected var _propertyBindings:Object = { };
		
		protected var _parentComponent:Addable;
		
		public function InvalidatableDisplayComponent ( parameters:Object = null ) {
			super();
			_parameters = parameters;
			this.initializeComponent();
		}
		
		protected function initializeComponent ( ):void {
			this.initializeDependencies();
			this.setInvalidationMethodOrder();
			this.setDefaultProperties();
			this.applyParameters();
		}
		
		public function setProperty ( propertyName:String, value:*, parameters:Object = null ):void {
			var propertyBindings:Array = _propertyBindings[propertyName];
			var isSet:Boolean;
			if (propertyBindings) {
				for (var i:int, l:int = propertyBindings.length; i < l; ++i) {
					isSet = true;
					Binding(propertyBindings[i]).setProperty(propertyName, value);
				}
			}
			
			_properties[propertyName] = value;
			
			if (this.hasOwnProperty(propertyName)) {
				this[propertyName] = value;
			} else {
				if (!isSet) {
					throw new Error("Property " + propertyName + " not found  on " + this + " and there is no Binding registered.");
				}
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
		
		protected function setParentComponent ( parentComponent:Addable ):void {
			_parentComponent = parentComponent;
		}
		
		public function executeInvalidatedMethods():void{
			_invalidationHelper.executeInvalidatedMethods();
		}
		
		public function bindToProperty ( binding:Binding ):void {
			((_propertyBindings[binding.propertyName] ||= []) as Array).push(binding);
		}
		
		public function unbindFromProperty ( binding:Binding ):void {
			var propertyBindings:Array = _propertyBindings[binding.propertyName];
			var index:int;
			if (!propertyBindings || (index = _propertyBindings.indexOf(binding)) == -1) {
				throw new Error("Binding " + binding + " registered for " + this);
			}
			propertyBindings.splice(index, 1);
		}
		
		public function get priority ( ):int { return _invalidationHelper.priority; }
		public function set priority ( value:int ):void{
			_invalidationHelper.priority = value;
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