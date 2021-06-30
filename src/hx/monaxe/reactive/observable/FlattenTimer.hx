package monaxe.reactive.observable;

import monaxe.execution.MultiAssignCancellable;
import haxe.ds.List;
import monaxe.reactive.observer.EventOrState;
import monaxe.execution.SerialAssignCancellable;
import monaxe.execution.Cancellable;

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
        isChildComplete = true;
        this.advanceObs = (evt: EventOrState<T>) -> switch evt {
            case Start: isChildComplete = false;
            case Event(e): downS.onData(e);
            case Error(msg): downS.onError(msg);
            case Complete: isChildComplete = true;
        }
        this.nextChild = null;
        this.parent = parent;
    }

    override public function run(){ // a polling function
        if(isChildComplete){
            nextChild = this.parent.gatheredObservables.pop();
            if(nextChild!=null)  cancellable.assign(nextChild.subscribe(advanceObs));
            else {
                if(this.parent.isComplete) {
                    stop();
                    downS.onComplete();
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