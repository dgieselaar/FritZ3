package fritz3.utils.log {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	
	
	public function log ( logLevel:int, where:Object, message:Object ):void {
		if (Logger.engine) {
			Logger.engine.log(logLevel, where, message);
		} else {
			var logLevelString:String;
			switch(logLevel) {
				case LogLevel.DEBUG:
				logLevelString = "DEBUG";
				break;
				
				case LogLevel.WARN:
				logLevelString = "WARN";
				break;
				
				case LogLevel.ERROR:
				logLevelString = "ERROR";
				break;
				
				case LogLevel.FATAL:
				logLevelString = "FATAL";
				break;
			}
			trace(logLevelString + " " + where + ": " + message);
		}
	}

}