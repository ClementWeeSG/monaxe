package monaxe.execution;

import monaxe.execution.Cancellable.blankCancellable;

class SerialAssignCancellable{
    var cc: Cancellable;
    public var cancel: Cancel;
    public function new(){
        this.cc = blankCancellable;
        this.cancel = this.cc.cancel;
    }

    public function assign(cancellable: Cancellable){
        this.cc.cancel(); // make sure nothing is left loose
        this.cc = cancellable;
        this.cancel = this.cc.cancel;
    }
}