## **Dart学习笔记:**
## **目录：**
### 语法基础知识：
-------------
### 变量：
--------------
创建变量并初始化：  
`var name = "Bob"`  
变量存储的是引用。名为`name`的变量包含对值为`Bob`的`String`对象的引用.  
变量`name`的类型被推断为`String`，但你可以通过指定来更改它。如果对象不受单一类型的限制，请指定`Object`类型（或必要时指定 dynamic）  
`Object name = "Bob";`  
即使变量或表达式的类型可以从上下文中推断出来，你也可以显式的指定其类型，这可以使代码更易读或可维护，并防止错误：  
`String name = "Bob";`
>注意：遵循编码风格指南，即对局部变量使用`var`而不是类型注解  
---------
**空安全**：  
`Dart` 语言强制执行严格的空安全。  
空安全可以防止由于无意中访问被设置为`null`的变量而导致的错误。这种错误称为空指针引用错误。当访问一个表达式（该表达式求值为`null`）的属性或调用其方法时，就会发生空指针引用错误。此规则的一个例外是当`null`支持属性或方法时，例如`toString()`或`hashCode`.通过空安全性，`Dart`编译器可以在编译时检测到这些潜在错误。
例如，假设您要找到一个 `int` 变量 `i` 的绝对值。如果 `i` 为`null`，调用 `i.abs()` 会导致空指针引用错误。在其他语言中，这样做可能会导致运行时错误，但 `Dart` 的编译器禁止这种操作。因此，`Dart` 应用程序不会导致运行时错误。
空安全性引入的三个关键变化：  
1. 当你为变量，参数或其他相关组件指定类型时，你可以控制该类型是否允许值为`null`，要启用可空性，可以在类型声明末尾添加`？`
```
String ? name  // Nullable type.Can be "null" or String
String name // Non-nullable type,cannot be "null" but can be Strings
```
2. 你必须在使用变量之前初始化它们。可空变量默认为`null`,所以它们默认被初始化。`Dart`不会为非可空类型设置初始值。它强制你设置一个初始值。`Dart`不允许你设置一个未初始化的变量。这避免了你访问属性或调用方法,其中接收者的类型可以是`null`,但`null`不支持所用的方法或属性。  
3. 你不能在一个可空类型的表达式上访问属性或调用方法。同样的规则也适用于那些`null`支持的属性或方法,像`hashCode`或`toString()`。  

可靠的空安全性将运行时错误(`runtime errors`)改变为编辑时(` edit-time`)的分析错误。当一个非空变量出现以下情况时,空安全性会标记它:
- 没有使用非空值初始化。
- 被赋予了null值。  

这种检查允许你在部署应用程序之前修复这些错误

---
**默认值:**  
可空类型的未初始化变量具有初始值`null`.即使是数值类型的变量，最初也是`null`，因为在`Dart`中数字也像其他所有内容一样，都是对象。
```
int ? lineCount;
assert(lineCount == null);
```
对于空安全来讲，在使用不可空变量之前必须初始化它们：`int lineCount = 0;` 

不必在声明的地方初始化局部变量，但需要在使用之前为其赋值。例如:下面的代码是有效的，因为`Dart`可以在传递给`print()`时检测到`lineCount`为非空。

顶级变量和类变量是延迟初始化的。初始化代码在第一次使用变量时运行。

---
**延迟变量：**  
late修饰词有两个用法 ：  
- 声明一个不为null的变量，该变量在声明之后进行初始化。
- 延迟初始化变量。 

Dart的控制流分析通常可以检测到一个非空变量在使用前被设置了一个非空值,但有时会失败。两种常见情况是顶级变量和实例变量:Dart通常无法确定它们是否被设置,所以不会尝试去分析。  
如果你确定一个变量在使用前已经被设置了,但是Dart不这么认为,你可以通过将该变量标记为late来修复错误:
```
late String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```
>警告:如果未能初始化延迟变量，则在使用该变量时会出现运行时错误。  

当你将一个变量标记为`late`但在声明时初始化它时，初始化器会在第一次使用该变量时运行。这种延迟初始化在以下几种情况下很方便：
- 该变量可能不需要，且初始化它的成本很高
- 你正在初始化一个实例变量，并且它的初始化器需要访问`this`  

在下面的例子中。如果`temperature`变量从未被使用,那么昂贵的`readThermometer()`函数就永远不会被调用
```
class Thermostat {
  late final temperature = readThermometer(); // 懒加载初始化

  // ...
}
```
所以对于不确定是否需要的昂贵初始化，可以使用`late`关键字实现延迟并懒加载。

---
**Final和const :**  
如果从不打算更改变量，应该使用`final`或`const`来替代`var`作为类型的补充。`final`变量只能被设置一次，`const`变量是编译时常量。`const`是隐式`final`。
>提醒：实例变量可以是`final`,但不能是`const`.    

创建和设置最终变量的示例:
```
final name = "Bob"; //没有类型注释
final String nickname = "Bob";
```  
不能对`final`的值进行修改:  
`name = "Alice"; // final的值只能被设置一次`  
对想要成为编译时常量的变量使用 `const`。如果`const`在类级别，将其标记为`static const`。在声明变量的位置，将值设置为编译时常量，例如数字或字符串文字、`const` 变量或常量算术运算的结果。
```
const bar = 1000000; 
const double atm = 1.01325*bar; //标准大气压
```
`const`关键字不仅仅用于声明常量变量。您还可以使用它来创建常量值，以及声明创建常量值的构造函数。任何变量都可以有常量值
```
var foo = const [];
final bar = const [];
const baz = [];   // 相当于const []
``` 
您可以从`const`声明的初始化表达式中省略 `const`，就像上面的`baz`一样。有关详细信息，请参阅不要重复使用 `const`  
您可以更改非最终、非常量变量的值，即使它曾经具有 const 值：  
`foo = [1, 2, 3]; // Was const []`  
您无法更改 const 变量的值  
`baz = [42]; // 无法为常量变量赋值 `  
可以改变非`final`，非`const`修饰的变量，即使它的值为编译时常量值。

---
**final的高级用法：**
当为`final`修饰的值赋予一个包含成员变量或方法的对象时：  
- 对象成员值能被修改，对于能够添加成员的类（如`List`,`Map`）则可以添加或删除成员
- 变量本身实例不能被修改
```
class Point{
  var x,y;
  Point(this.x,this.y){

  }
}

void main(){
  final p = Point(1, 2);
  // p = Point(3, 4); //报错，final修饰的变量不能调用调用Setter方法
  p.x = 2;  // 正常执行，修改的是变量的属性值，而不是变量引用的对象
  print(p.x); // 打印2

  var foo = const [];
  foo = [1,2,1];
  /* 此部分的代码重点在于var foo,一个正常变量可以随意赋值和修改，重点不在const[] ,
  所以不要纠结const[]是不可变的。[]和[1,2,1]是不同的对象*/
  print(foo); //打印[1,2,1];

  final baz = [1];
  // baz = [1,2,3,4]; // 出错，此调用修改了变量的实例，即[1]和[1,2,3,4]是不同的对象
  baz[0] = 2; // 正常执行，只修改了变量引用对象的成员变量的值
  print(baz); //打印[2]

  baz.add(1); //正常执行，向变量引用对象添加成员
  baz.add(2);
  print(baz); //打印[2,1,2]

  final Map<String,String> cache = <String,String>{}; 
  cache['key'] = 'value';
  cache['key2'] = 'value2';
  print(cache);  // 打印{key: value, key2: value2}

}

```
-----
### **内置类型：**  
Dart语言支持以下类型：
- Numbers(int,double)
- Strings(String)
- Booleans(bool)
- Records((value1,value2))
- Lists(List,also known as arrays)
- Sets(Set)
- Maps(Map)
- Runes(Runes;Often replaced by the characters API)
- Symbols(Symbol)
- The value null(Null) 

因为`Dart`中的每个变量都引用一个对象（类的实例），所以您通常可以使用构造函数来初始化变量。一些内置类型有自己的构造函数.  
其他一些类型在`Dart`中也扮演着重要的角色：  
- Object : 除Null之外所有Dart对象的父类
- Enum : 所有枚举类的超类
- Future and Stream : 用于异步支持
- Iterable : 用于for-in循环和同步生成器函数中
- Never : 指示表达式永远无法成功完成求值。最常用于总是抛出异常的函数。
- dynamic : 禁用静态检查。通常应该使用Object或Object ?来替代。
- void : 指示从未使用过某个值。通常用作返回类型  

Object、Object?、Null 和 Never 类在类层次结构中具有特殊的角色。在了解零安全性中了解这些角色。

---
**Numbers :**  
`Numbers`有两种类型：
- `int` : `int`类型的整数值不大于64位，具体取决于平台。
- `double` : 64位(双精度)浮点数 

`int`和`double`都是`num`的子类型。`num` 类型包括 `+`、`-`、`/` 和 `*` 等基本运算符，您还可以在其中找到 `abs()`、`ceil()` 和 `Floor()` 等方法。除其他方法外。 （按位运算符，例如 `>>`，在`int`类中定义。）如果`num`及其子类型没有您正在寻找的内容，则`dart:math`库可能有。  
整数是没有小数点的数字。以下是定义整数文字的一些示例:  
```
var x = 1;
var hex = 0xDEADBEEF;
```
如果数字包含小数，则它是双精度数。以下是定义双文字的一些示例:  
```
var y = 1.1;
var exponents = 1.42e5;
```  
您还可以将变量声明为 num。如果这样做，变量可以同时具有整数和双精度值  
```
num x = 1; // x可以同时具备int和double的值
x += 2.5;
```
int类型可以自动转换成double类型  
```
double z = 1; // 相当于double类型的z = 1.0
```  
以下是字符串转换为数字的方法，反之亦然:
```
String转换成int类型
var one = int.parse("1")
String转换成double类型
var onePointOne = double.parse('1.1');
int转换成String类型：
String oneAsString = 1.toString();
double转换成String类型
String piAsString = 3.14159.toStringAsFixed(2);
```
int 类型指定传统的按位移位 (<<、>>、>>>)、补码 (~)、AND (&)、OR (|) 和 XOR (^) 运算符，这些运算符对于操作和屏蔽标志非常有用在位字段中。例如：
```
assert((3 << 1) == 6); // 0011 << 1 == 0110
assert((3 | 4) == 7); // 0011 | 0100 == 0111
assert((3 & 4) == 0); // 0011 & 0100 == 0000
//向左移动一位，相当于原值乘2.向右相当于原值除2
```
字面数值是编译时常量。许多算数表达式也是编译时常量，只要它们的操作数是计算结果为数字的编译时常量。
```
const a = 1000;
const b = 5;
const mul = a * b;
```
---
**Strings :**  
一个`Dart`字符串（`String`对象）包含一个`UTF-16`代码单元序列。您可以使用单引号或双引号来创建字符串.
```
var s1 = 'test'
var s2 = "test"
var s3 = 'I\'m OK'  //使用转义字符"\"
var s4 = "I'm OK" //双引号不需要使用转义字符
```
可以使用`${expression}`将表达式的值放入字符串中。如果表达式是标识符，则可以跳过`{}`。为了获取对象对应的字符串，`Dart`调用对象的`toString()`方法

>提示："=="运算符测试两个对象是否相等。如果两个字符串包含相同的代码单元序列，则它们是等效的 

可以使用相邻的字符串或`+`运算符连接字符串 : 
```
var s1 = 'String'
'concatenation'
'works even over line breaks.';
var s2 = 'The'+'operator'+'works,as well.';
```
可以使用单引号或双引号的三引号来创建多行字符串。
```
var s1 = '''
You can create 
multi-line strings like this one'''

var s2 = """
this is also a 
multi-line strings."""
```
在字符串前面添加 `r` 来创建原始字符串：  
```
var s = r"In a Raw String \n get special."
```
有关使用字符串的更多信息，请查看字符串和正则表达式。

---
**Booleans :**  
`Dart`使用`bool`类型表示布尔值。`Dart` 只有字面量 `true`and`false`是布尔类型,这两个对象都是编译时常量。  
`Dart`的类型安全意味着不能使用if(nonbooleanValue)或者assert(nonbooleanValue)。而应该像下面这样，明确的进行值检查：  
```
// 检查空字符串
var fullName = '';
assert(fullName.isEmpty);

// 检查0值
var hitPoints = 0;
assert(hitPoints <= 0);

// 检查null值
var unicorn;
assert(unicorn == null);

// 检查NaN
var iMeantToDoThis = 0/0;
assert(iMeantToDoThis.isNaN);
```
---
**Runes and grapheme clusters:**（待理解）

---
**Symbols :**（待理解）

---
**Records :**
>提醒：3.0以上版本才支持  

---
**Collections :**  
`Dart`内置对`list`s,`set`,`map`集合的支持。  
**Lists :**  
几乎所有的编程语言中，最常见的集合就是数组，或有序的对象组。在`Dart`中，数组是`List`对象,因此大多数人称其为列表  
`var list = [1,2,3];`
>提醒： Dart推断列表的类型是List<int>.如果尝试将非整数的对象添加到此列表，分析器或运行时会引发错误。更多有关信息可以阅读类型推断。

可以在`list`元素的最后一项添加一个逗号。此逗号不会影响集合，但可以防止复制黏贴错误  
`var list = ['car','Boat','Plane',];`  
列表的索引从`0`开始，其中`0`是第一个索引，`list.length-1`是最后一个值的索引。可以使用`.length`来获取列表的长度，并使用下标`([])`运算符访问列表的值。  
要创建一个编译时常量列表，只需要在列表前加`const`关键词。  
```
var constantList = const [1,2,3];
// constantList[1] = 1; //此行会报错
```
有关列表的更多信息，请参阅核心库列表部分.

---
**Sets :**  
`Set`是`Dart`中唯一的无序集合。`Dart `对集合的支持由集合字面量和`Set `类型提供.  
这是一个简单的dart集合，使用set字面量创建：  
`var person = {"name","age","address"};`  
>提醒：dart推断person的类型是`Set<String>`.如果尝试像集合中添加错误类型的值，分析器或运行时会引发错误。更多信息可以参考类型推断  

创建空`Set`.使用前面带有类型参数的`{}`,或将`{}`分配给`Set`类型的变量:
```
var names = <String>{};
Set <String> names = {}  //也可以正常创建
var names = {} //创建的是一个map
```
使用`add()`或`addAll()`将元素添加到现有集合：
```
var elements = <String>{};
elements.add("a");
elements.addAll(person);
```
使用`.length`获取集合的长度：`elements.length;`  
创建一个编译时常量集合，在集合字面量前加`const`关键词。
```
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
// constantSet.add('helium'); // This line will cause an error.
```
有关集合的更多信息，参考核心库的集合部分

---
**Maps :**  
一般来说，`map`是一个将键和值关联起来的对象。键和值都可以是任何类型的对象.`key`只能出现一次，`value`可以重复，即`key`是唯一的。`Dart`通过`map`字面量和`map`类型来支持`map`。  

通过`map`字面量创建`map`:  
```
var gifts = {
  // Key:    Value
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings'
};

var nobleGases = {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};
``` 
>提醒：`Dart` 推断`gifts` 的类型为`Map<String, String>`，`nobleGases`的类型为`Map<int, String>`。如果您尝试向任一映射添加错误类型的值，分析器或运行时会引发错误。有关更多信息，请阅读类型推断.  

通过`map`构造函数创建：
```
var gifts = Map<String, String>();
gifts['first'] = 'partridge';
gifts['second'] = 'turtledoves';
gifts['fifth'] = 'golden rings';

var nobleGases = Map<int, String>();
nobleGases[2] = 'helium';
nobleGases[10] = 'neon';
nobleGases[18] = 'argon';
```
>提醒:如果你是`C#`或`java`语言过来的，你可能希望看到是`new Map()`而不仅仅是`Map()`.在 `Dart`中，`new` 关键字是可选的。有关详细信息，请参阅使用构造函数.  

使用下标赋值运算符`[]=`将新的键值对添加到现有Map中：
```
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds'; // Add a key-value pair
```
使用下标赋值运算符检索值：
```
var gifts = {'first': 'partridge'};
assert(gifts['first'] == 'partridge');
```
如果查询`map`中没有的键，则返回`null`:
```
var gifts = {'first': 'partridge'};
assert(gifts['fifth'] == null);
```
使用`.length`属性获取键值对的个数：
```
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```
要创建一个编译时常量的`map`，在`map`字面量前加`const`关键词：
```
final constantMap = const {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};

// constantMap[2] = 'Helium'; // 会出现报错，const修饰的常量不能修改。
```
有关`map`的更多信息，请参考核心库的`map`部分。

---
**操作符：**
Dart支持在`List`,`Set`字面量,`Map`中使用扩展运算符`spread operator (...)`和空安全扩展运算符`null-aware spread operator (...?)`。扩展运算符提供了一种简洁的将多个值插入到集合的方法。
- 扩展运算符： `（...）`是` Dart `中一种特殊的操作符，可以将一个集合中的所有元素展开到另一个集合中。
- 空安全扩展运算符`（...?）`是`Dart `中一种新的操作符，可以避免在展开一个可能为空的集合时引发错误。

举例：可以使用扩展运算符，将一个列表的所有值插入到另外一个列表。
```
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```
如果扩展运算符右侧的表达式可能为 null，则可以使用支持 null 的扩展运算符 (...?) 来避免异常：  
```
var list2 = [0, ...?list];
assert(list2.length == 1);
```
有关更多扩展运算符的介绍，参阅扩展运算符提案

---
**控制流操作符：**  
`Dart `提供了 `collection if `和 `collection for `操作符，用于在`List`、`Map`和`Set字面量`中使用条件`（if）`和`（for）`来构建集合。  
1. 使用`collection if`来创建包含三个或四个元素的列表：
  ```
  // 当promoActive为True时，Outlet添加到列表中，否则舍弃
  var nav = ['Home', 'Furniture', 'Plants', if (promoActive) 'Outlet'];
  ```  
2. `Dart `还支持在集合字面量中使用 `if-case`:
  ```
  // 如果login的值等于Manager，则添加Inventory到列表中，否则舍弃
  var nav = ['Home', 'Furniture', 'Plants', if (login case 'Manager') 'Inventory'];
  ```
3. 使用`collection for `操作符，在添加到列表之前做操作：
  ```
  var listOfInts = [1, 2, 3];
  var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
  assert(listOfStrings[1] == '#1');
  ```
有关使用`集合 if`和 `for` 的更多详细信息和示例，请参阅控制流集合提案.
