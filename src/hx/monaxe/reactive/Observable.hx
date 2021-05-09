package monaxe.reactive;

import monaxe.reactive.observable.CancelInstances;
import monaxe.execution.Cancellable;
import monaxe.reactive.observer.Safe;
import monaxe.reactive.observer.EventOrState;
import monaxe.reactive.observable.Subscribe;

abstract Observable<T>(Subscribe<T>){

    inline public function new(unsafe: Subscribe<T>){
        this = unsafe;
    }

    public function subscribe(client: Observer<T>): Cancellable{
        var protected: Observer<T> = Safe.protect(client);
        return this(protected);
    }

    @:from
    static public function fromSubscribe<U>(unsafe: Subscribe<U>){
        return new Observable<U>(unsafe);
    }

    public function map<U>(fn: T -> U){
        return (obs: Observer<U>) -> {

            return subscribe( (event: EventOrState<T>) ->
            switch event {
                case Event(data): obs.onData(fn(data));
                case Start: obs.onStart;
                case Error(msg): obs.onError(msg);
                case Complete: obs.onComplete();
            }

            );

        }
    }

    //factories

    static public function fromArray<T>(arr: Array<T>): Observable<T>{
    return (obs: Observer<T>) -> {
        iterate(obs, arr, obs.onComplete);
        return {
            cancel: CancelInstances.cannotCancel(obs)
        }
    }

    }
    


    static function iterate<T>(obs:Observer<T>, arr:Array<T>, onComplete: Void -> Void, index: Int = 0) {
        if(arr.length==index){
            onComplete();
        } else {
            obs.onData(arr[index]);
            iterate(obs, arr, onComplete, index+1);
        }
    }
}