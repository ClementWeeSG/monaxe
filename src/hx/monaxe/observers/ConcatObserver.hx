package monaxe.observers;

class ConcatObserver<T> implements Observer<T>{
    
    var first: Observer<T>;
    var second: Observer<T>;

    public function new(n: Observer<T>){
        this.first = n;
    }

	public function onData(item:T) {}

	public function onError(err:String) {}

	public function onComplete() {}
}