package monaxe.reactive.observable;

import monaxe.reactive.observer.EventOrState;
import monaxe.execution.SerialAssignCancellable;

class FlattenTimer<T> extends haxe.Timer {
    var cancellable: SerialAssignCancellable;
    var advanceObs: Observer<T>;
    var isChildComplete: Bool;
    var nextChild: Null<Observable<T>>;
    var downS: Observer<T>;
    var parent: Flatten<T>;

    public function new(downS: Observer<T>, parent: Flatten<T>){
        super(100);
        this.cancellable = new SerialAssignCancellable();
        this.downS = downS;
        this.downS.onStart();
        isChildComplete = true;
        this.advanceObs = (evt: EventOrState<T>) -> switch evt {
            case Start: trace("Starting new Child");
            case Event(e): trace(e);downS.onData(e);
            case Error(msg): downS.onError(msg);
            case Complete: isChildComplete = true; trace("completed child");
        }
        this.nextChild = null;
        this.parent = parent;
    }

    override public function run(){ // a polling function
        trace("tick");
        if(isChildComplete){
            trace("Child Complete");
            trace(this.parent.isComplete);
            nextChild = this.parent.gatheredObservables.pop();
            trace(this.parent.gatheredObservables.length);
            if(nextChild!=null) {
                isChildComplete = false;
                trace("NEXT CHILD");
                cancellable.assign(nextChild.subscribe(advanceObs));
            } 
            else {
                trace("No more children");
                if(this.parent.isComplete) {
                    this.stop();
                    trace("parent complete");
                    this.downS.onComplete();
                }
                //else wait for next tick
            }
        }
    }

    public function getCancellable(){
        return {
            cancel: () -> this.cancel()
        }
    }

    public function cancel(){
        this.stop();
        this.cancellable.cancel();
    }
}