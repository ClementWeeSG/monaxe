package monaxe.reactive;

import monaxe.reactive.observable.Flatten;

abstract FlattenableObservable<T>(Observable<Observable<T>>){
    inline public function new(underlying: Observable<Observable<T>>){
        this = underlying;
    }

    public function flatten(): Observable<T>{
        return Flatten.flatten(this);
    }

    @:from
    static public function fromUnflattened<T>(underlying: Observable<Observable<T>>){
        return new FlattenableObservable(underlying);
    }


}