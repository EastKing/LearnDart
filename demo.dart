
void printTypeName1(object) {
  if (object is String) {
    print('String');
  } else if (object is int) { 
    print('int');
  } else {
    print('Unknown');
  }
}
void printTypeName(object) {
  if (object case String) {
    print('String'); 
  } else if (object case int) {
    print('int');
  } else {
    print('Unknown');
  } 
}
void main(){
  printTypeName("String");
  printTypeName1("String");
  List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// 创建一个包含所有偶数数字的列表
  List<int> evenNumbers = [for (int i in list) if (i % 2 case 0) i,];

// 输出 evenNumbers
  print(evenNumbers);
}