package monaxe.reactive.observable;

class ArraySubscription<T> implements Subscription<T>{
    
    var arr: Array<T>;
    var id: Int;

    public function new(a: Array<T>){
        this.arr = a;
        this.id = -1;
    }

	public function requestOne(obs:Observer<T>) {
        id++;
        if (id==arr.length) obs.onComplete();
        else obs.onData(arr[id]);
    }

	public function requestAll(obs:Observer<T>) {
        obs.onStart();
        while (id<arr.length){
            id++;
            obs.onData(arr[id]);
        }
        obs.onComplete();
    }

	public function cancel(obs:Observer<T>) {
        obs.onError("This subscription cannot be cancelled!")
    }
}