package monaxe.observers;

class TraceObserver implements Observer<String>{    

	public function onData(item:String) {trace(item);}

	public function onError(err:Dynamic) {}

	public function onComplete() {}
}