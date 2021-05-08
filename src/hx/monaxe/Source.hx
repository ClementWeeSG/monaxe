package monaxe;

interface Source<T> {
    function sendData(): Void;
    function stop(): Void;
    function nextData(): T;
}

abstract SourceOps<T>(Source<T>) {

    inline public function new(src: Source<T>){
        this = src;
    }

    public function nextTo(observer: Observer<T>){
        observer.onData(this.nextData());
    }

}