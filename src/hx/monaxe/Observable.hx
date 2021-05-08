package monaxe;

import monaxe.Cancellable.CancelFunction;

class Observable<T> {
    var doSub: Observer<T> -> CancelFunction<T>;

    public function new(subFn: Observer<T> -> CancelFunction<T>){
        this.doSub = subFn;
    }

    public function subscribe(observer: Observer<T>): CancelFunction<T>{
        return this.doSub(new SafeObserver(observer));
    }

    public function asSingle(){
        return new SingleSubscriptionObservable(this.doSub);
    }

    public function concat(next: Observable<T>){
        
    }

    static public function fromArray<T>(arr: Array<T>){
        return new Observable<T>(obs -> {
            var interrupted: Bool = false;
            for (i in 0...arr.length) {
                if(!interrupted)obs.onData(arr[i]);
            }
            obs.onComplete();
            return (obs) -> {
                interrupted = true;
                obs.onComplete();
            };
        });
    }
}

class SingleSubscriptionObservable<T> extends Observable<T>{
    var isSubscribed: Bool;

    public function new(subFn: Observer<T> -> CancelFunction<T>){
        super(subFn);
        this.isSubscribed = false;
    }

    override public function subscribe(observer: Observer<T>){
        return if (isSubscribed) {
            Cancellable.cancelled;
        }
        else super.subscribe(observer);
    }
}