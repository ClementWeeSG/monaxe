package monaxe.reactive;

import monaxe.execution.Cancel;

interface Subscription<T> {
    public function requestOne(obs: Observer<T>): Void;
    public function requestAll(obs: Observer<T>): Void;
    public function cancel(obs: Observer<T>): Void;
}