package fritz3.display.button {
	import flash.events.MouseEvent;
	import fritz3.display.text.TextComponent;
	import fritz3.state.SingleState;
	import fritz3.state.IState;
	import fritz3.state.IValueState;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TextButton extends TextComponent implements IStateButton {
		
		protected var _statesByID:Object = { };
		
		public function TextButton ( parameters:Object = null ) {
			super(parameters);
		}
		
		override protected function initializeDependencies():void {
			super.initializeDependencies();
			this.initializeStateObjects();
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			this.useHandCursor = true;
			this.mouseChildren = false;
		}
		
		protected function initializeStateObjects ( ):void {
			_statesByID = { };
			if (!this.getStateObject(ButtonState.HIGHLIGHTED)) {
				this.setStateObject(ButtonState.HIGHLIGHTED, new SingleState(ButtonState.HIGHLIGHTED));
			}
			if (!this.getStateObject(ButtonState.SELECTED)) {
				this.setStateObject(ButtonState.SELECTED, new SingleState(ButtonState.SELECTED));
			}
			if (!this.getStateObject(ButtonState.PRESSED)) {
				this.setStateObject(ButtonState.PRESSED, new SingleState(ButtonState.PRESSED));
			}
			if (!this.getStateObject(ButtonState.DISABLED)) {
				this.setStateObject(ButtonState.DISABLED, new SingleState(ButtonState.DISABLED));
			}
			
			this.syncStates();
		}
		
		protected function syncStates ( ):void {
			this.highlighted ? this.highlight() : this.lowlight();
			this.selected ? this.select() : this.deselect();
			this.pressed ? this.press() : this.release();
			this.disabled ? this.disable() : this.enable();
		}
		
		protected function onStateChange ( state:IState, oldValue:*, newValue:* ):void {
			this.invalidateCollector();
			
			switch(state.id) {
				case ButtonState.HIGHLIGHTED:
				Boolean(newValue) ? this.highlight() : this.lowlight();
				break;
				
				case ButtonState.SELECTED:
				Boolean(newValue) ? this.select() : this.deselect();
				break;
				
				case ButtonState.PRESSED:
				Boolean(newValue) ? this.press() : this.release();
				break;
				
				case ButtonState.DISABLED:
				Boolean(newValue) ? this.disable() : this.enable();
				break;
			}
		}
		
		protected function highlight ( ):void {
			
		}
		
		protected function lowlight ( ):void {
			
		}
		
		protected function select ( ):void {
			
		}
		
		protected function deselect ( ):void {
			
		}
		
		protected function press ( ):void {
			
		}
		
		protected function release ( ):void {
			
		}
		
		protected function enable ( ):void {
			this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			
			this.buttonMode = this.mouseEnabled = true;
		}
		
		protected function disable ( ):void {
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			
			this.buttonMode = this.mouseEnabled = false;
		}
		
		protected function onRollOver ( e:MouseEvent ):void {
			this.highlighted = true;
		}
		
		protected function onRollOut ( e:MouseEvent ):void {
			this.highlighted = false;
		}
		
		protected function onMouseDown ( e:MouseEvent ):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			this.pressed = true;
		}
		
		protected function onStageMouseUp ( e:MouseEvent ):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			this.pressed = false;
		}
		
		public function getStateObject ( stateID:String ):IValueState {
			return _statesByID[stateID];
		}
		
		public function setStateObject ( stateID:String, state:IValueState ):void {
			var oldState:IValueState = _statesByID[stateID];
			if (oldState) {
				oldState.onChange.remove(this.onStateChange);
			}
			_statesByID[stateID] = state;
			if (state) {
				state.onChange.add(this.onStateChange);
			}
		}
		
		public function get highlighted ( ):Boolean { return IValueState(this.getStateObject(ButtonState.HIGHLIGHTED)).value; }
		public function set highlighted ( value:Boolean ):void {
			IValueState(this.getStateObject(ButtonState.HIGHLIGHTED)).value = value;
		}
		
		public function get selected ( ):Boolean { return IValueState(this.getStateObject(ButtonState.SELECTED)).value; }
		public function set selected ( value:Boolean ):void {
			IValueState(this.getStateObject(ButtonState.SELECTED)).value = value;
		}
		
		public function get pressed ( ):Boolean { return IValueState(this.getStateObject(ButtonState.PRESSED)).value; }
		public function set pressed ( value:Boolean ):void {
			IValueState(this.getStateObject(ButtonState.PRESSED)).value = value;
		}
		
		public function get disabled ( ):Boolean { return IValueState(this.getStateObject(ButtonState.DISABLED)).value; }
		public function set disabled ( value:Boolean ):void {
			IValueState(this.getStateObject(ButtonState.DISABLED)).value = value;
		}
		
	}

}