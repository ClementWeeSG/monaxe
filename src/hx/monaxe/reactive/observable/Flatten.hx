package monaxe.reactive.observable;

import monaxe.execution.MultiAssignCancellable;
import monaxe.execution.Cancellable;
import haxe.ds.List;

class Flatten<T> {

    public var gatheredObservables: List<Observable<T>>;
    public var isComplete: Bool;

    static public function flatten<T>(upS: Observable<Observable<T>>): Observable<T>{

        return (obs: Observer<T>) -> {
            var instance = new Flatten();
            var combined = new MultiAssignCancellable();
            combined.add(upS.subscribe(instance.subscriber(obs)));
            combined.add(instance.subscribe(obs));
            return combined;
        }
    }

    public function new(){
        this.gatheredObservables = new List();
        this.isComplete = false;
    }

    function doNothing(){}

    function subscribe(downS: Observer<T>): Cancellable{
        var timer = new FlattenTimer(downS, this);
        return timer.getCancellable();
    }

    public function subscriber(downS: Observer<T>): Observer<Observable<T>>{
        return evt -> 
        switch evt {
            case Start: doNothing();
            case Event(o): 
                trace("Received Child");
                this.gatheredObservables.add(o);
            case Complete: 
                isComplete = true;
                trace("Is Complete");
            case Error(msg): downS.onError(msg); // pipe errors directly to downStream
        }
    }
}