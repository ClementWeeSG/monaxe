package monaxe.reactive;

import monaxe.execution.MultiAssignCancellable;
import monaxe.execution.SerialAssignCancellable;
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

    public function subscribe(client: Observer<T>): Cancellable{
        var protected: Observer<T> = Safe.protect(client);
        return this(protected);
    }

    @:from
    static public function fromSubscribe<U>(unsafe: Subscribe<U>){
        return new Observable<U>(unsafe);
    }

    public function map<U>(fn: T -> U): Observable<U>{
        return (obs: Observer<U>) -> {
            return subscribe((evt)-> return switch(evt) {
                case Start: obs.onStart();
                case Event(item): obs.onData(fn(item));
                case Complete: obs.onComplete();
                case Error(msg): obs.onError(msg);
            });
        };
    }

    public function concat(next: Observable<T>): Observable<T>{
        return (downS: Observer<T>) -> {
            var serial = new SerialAssignCancellable();
            serial.assign(subscribe((evt) -> return switch (evt) {
                case Start: downS.onStart;
                case Event(item): downS.onData(item);
                case Error(msg): downS.onError(msg);
                case Complete: serial.assign(next.subscribe(downS));
            }));
            return serial;
        };
    }

    public function flatMap<U>(fn: T -> Observable<U>): Observable<U>{
        return obs -> {
            var accum: Observable<U> = empty();
            var multi = new MultiAssignCancellable();
            multi.add(subscribe(evt -> {
                switch (evt){
                    case Start: obs.onStart();
                    case Event(e): accum = accum.concat(fn(e));
                    case Error(msg): obs.onError(msg);
                    case Complete: obs.onComplete();
                }
            }));            
            multi.add(accum.subscribe(obs));
            return multi;
        };
    }

    //factories

    @:from    
    static public function fromArray<T>(arr: Array<T>): Observable<T>{
        return (obs: Observer<T>) -> return {
            obs.onStart();
            for(a in arr){
                obs.onData(a);
            }
            obs.onComplete();
            {cancel: () -> {}};
        };
    }

    static public function fromSingle<T>(item: T): Observable<T>{
        return (obs: Observer<T>) -> return {
            obs.onStart();
            obs.onData(item);
            obs.onComplete();
            {cancel: () -> {}};
        }
    }

    public static function empty<T>(): Observable<T> {return obs -> {
        obs.onComplete();
        blankCancellable;
    }}
}