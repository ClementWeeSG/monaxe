package monaxe;

class SafeObserver<T> implements Observer<T>{

    var isComplete: Bool;
    var slave: Observer<T>;

    public function new(slave: Observer<T>){
        this.isComplete = false;
        this.slave = slave;
    }

    public function onData(item:T) {
        if(isComplete) this.slave.onError("Datasource has terminated!");
        else this.slave.onData(item);
    }

	public function onError(err:String) {
        slave.onError(err);
        if(!isComplete) isComplete = true;
    }

	public function onComplete() {
        this.isComplete = true;
        slave.onComplete();
    }
}