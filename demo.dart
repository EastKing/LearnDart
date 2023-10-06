class Animal{
  void chase(Animal a){
    print('Animal is chasing');
  }
}

class HoneyBadger extends Animal {
  @override
  void chase(Object a){
    print("HoneyBadger is chasing");
  }
  
}

class Mouse extends Animal {
  void chase(Animal a){
    print('Mouse is chasing');
  }
}

class Cat extends Animal {
  @override
  void chase(Animal x) { 
    print('Cat is chasing');
  }
} 

class Alligator extends Animal {
  @override
  void chase(Animal x) {
    print('Alligator is chasing');
  }
}
void main(){


  
  Animal a = HoneyBadger();
  a.chase(Alligator()); // Not type safe or feline safe.
}