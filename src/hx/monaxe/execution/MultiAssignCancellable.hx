package monaxe.execution;

import haxe.ds.List;
import monaxe.execution.Cancellable.blankCancellable;

class MultiAssignCancellable {
    private var cancellables: List<Cancellable>;
    
    public var cancel: Cancel;
    
    public function new(){
        this.cancellables = new List();
        this.cancel = () -> {
            for (task in cancellables){
                task.cancel();
                cancellables.remove(task);
            }
        }
    }

    public function add(cancellable: Cancellable){
        this.cancellables.add(cancellable);
    }
}