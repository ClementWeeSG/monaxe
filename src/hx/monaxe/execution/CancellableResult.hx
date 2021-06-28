package monaxe.execution;

class CancellableResult<T> {
    public var cancel: Cancel;
    var isCancelled: Bool;
    var result: Null<T>;

    public function new(){
        this.result = null;
        this.isCancelled = false;
        this.cancel = () -> {
            if (!isCancelled) isCancelled = true;
            else throw "This value is cancelled already";
        };
    }

    public function set(answer: T){
        this.result = answer;
    }

    public function get(){
        return this.result; // TODO -- put in some blocking logic
    }

    
}