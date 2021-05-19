package monaxe.reactive;

import monaxe.reactive.observable.*;
import haxe.ds.Vector;
import monaxe.execution.Pair;
import monaxe.reactive.observable.CancelInstances;
import monaxe.execution.Cancellable;
import monaxe.reactive.observer.Safe;
import monaxe.reactive.observer.EventOrState;
import monaxe.reactive.observable.Subscribe;

abstract Observable<T>(Subscribe<T>){

    inline public function new(unsafe: Subscribe<T>){
        this = unsafe;
    }

    public function subscribe(client: Observer<T>): Subscription<T>{
        var protected: Observer<T> = Safe.protect(client);
        return this(protected);
    }

    @:from
    static public function fromSubscribe<U>(unsafe: Subscribe<U>){
        return new Observable<U>(unsafe);
    }

    public function map<U>(fn: T -> U): Observable<U>{
        return (obs: Observer<U>) -> {

            return null;

        }
    }

    //factories

    static public function fromArray<T>(arr: Array<T>): Observable<T>{
    return (obs: Observer<T>) -> new ArraySubscription<T>(arr);
}

/**
 * Return an Observable that only provides a single element, then completes
 * @param item the item to put inside the Observable
 */
static public function fromSingle<T>(item: T): Observable<T>{
        return (obs: Observer<T>) -> {
            var s = new SingleSubscription(item);
            s.requestAll(obs);
            s;
    }

    

    }

    /**
     * Create an Observable of type T linked to a Source.
     * @src The source to link to 
     */
    static public function link<T>(src: Source<T>):Observable<T>{
        //var id = -1;
        var subscribers = new List<Observer<T>>();
        src.onData = eod -> {
            for (s in subscribers){
                 s.onData(eod);
             }
        };
        src.onComplete = () -> {
            for (s in subscribers){
                s.onComplete();
            }
        };
        src.onError = msg -> {
            for (s in subscribers){
                s.onError(msg);
            }
        }
        return ((obs: Observer<T>) -> {
            subscribers.add(obs);
            null;
        });
    }

    static public function singleSubscription<T>(observable: Observable<T>): Observable<T>{
        var isSubscribed = false;
        return (obs: Observer<T>) -> {
            if(isSubscribed){
                obs.onError("Source cannot be subscribed twice!");
                null;
            } else {
                isSubscribed = true;
                observable.subscribe(obs);
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