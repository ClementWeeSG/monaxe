package monaxe.reactive.observable;

class SingleSubscription<T> implements Subscription<T>{

    var item: T;

    public function new(t: T){
        this.item = t;
    }
    
	public function requestOne(obs:Observer<T>):Void {
		obs.onData(item);
	}

	public function requestAll(obs:Observer<T>) {
        requestOne(obs);
        obs.onComplete();
    }

	public function cancel(obs: Observer<T>) {
        obs.onError("This cannot be cancelled!");
    }
}