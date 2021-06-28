package monaxe.reactive;

import monaxe.execution.Cancel;
import monaxe.reactive.observer.*;

abstract Observer<T>(Observe<T>){
    public inline function new(o: Observe<T>){
        this = o;
    }

    @:from
    static public function fromObserve<T>(obs: Observe<T>){
        return new Observer<T>(obs);
    }

    inline public function onStart(){
        this(Start);
    }

    inline public function onData(item: T){
        this(Event(item));
    }

    inline public function onComplete(){
        this(Complete);
    }

    inline public function onError(msg: String){
        this(Error(msg));
    }

    static public function noStart<T>(base: Observer<T>): Observer<T>{
        function doNothing(){}
        return evt -> switch evt {
            case Start: doNothing();
            case Event(item): base.onData(item);
            case Complete: base.onComplete();
            case Error(msg): base.onError(msg);
        }
    }
}