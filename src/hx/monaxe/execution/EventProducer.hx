package monaxe.execution;

/**
 * Event Producer Class - Internal Implementation for producing events
 */
class EventProducer<Event>{
    var consumers: haxe.ds.List<Event -> Void>;
  
  public function new(){
    this.consumers = new haxe.ds.List<Event -> Void>();
  }
  
  public function addConsumer(lis: Event -> Void){
    this.consumers.add(lis);
  }
  
  public function removeConsumer(lis: Event -> Void){
    this.consumers.remove(lis);
  }
  
  public function emit(event: Event){
    for (lis in consumers){
      lis(event);
    }
  }
}