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
>提醒： `Dart`推断列表的类型是`List<int>`.如果尝试将非整数的对象添加到此列表，分析器或运行时会引发错误。更多有关信息可以阅读类型推断。

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

---
### 泛型 :   
----
如果您查看 `API `文档中的基本数组类型 `List`，您会看到类型实际上是 `List<E>`。`<...>` 符号将 `List `标记为泛型（或参数化）类型——具有形式类型参数的类型。根据惯例，大多数类型变量都有单字母名称，如 `E`、`T`、`S`、`K` 和 `V`。  
- E : Element `List<E>`表示一个包含element类型元素  
- T : Type 表示类型
- S : Set `Set<S>`表示一个包含Set类型的集合
- K V : `Key Map<K, V>` 表示一个包含 Key 类型键和 Value 类型值的映射  

**为什么使用泛型？**  
泛型通常是强制类型安全所必需的，它们比仅仅让代码运行还能提供更多的好处：  
- 正确指定泛型会更好的生成代码  
- 可以使用泛型来减少代码重复  

如果仅打算让`list`包含`String`,你可将其声明为`List<String>`（读做字符串列表），这样你，你的同事以及工具都可以检测到向列表中分配一个非字符串可能是一个错误。下面是一个例子:
```
var names = <String>[];
names.addAll(["Seth","Kathy","Lars"]);
names.add(42); // error
```
使用泛型的另外一个原因是减少代码重复。泛型允许您在多个类型之间共享单个接口和实现，同时仍利用静态分析。例如，假设您创建了一个用于缓存对象的接口：  
```
abstract class Object{
  Object getByKey(String key);
  void setByKey(String key,Object value);
}
```  
你发现你需要一个字符串类型的此版本接口，所以你创建了另外一个接口：
```
abstract class StringCache{
  String getByKey(String key);
  void setByKey(String key, String value);
}
```  
最后，你决定要一个特定的数字版本...您明白了。  
泛型类型可以省去你创建这些接口的麻烦，相反，你可以创建一个带有类型参数的接口：  
```
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
```
在此代码中，T 是替代类型。它是一个占位符，您可以将其视为开发人员稍后定义的类型。

----------------------
**使用集合字面量：**

-----------------
`List`、`Set`和`Map`的字面量可以参数化。参数化字面量与您已经看到的字面量非常相似，但在开括号之前添加了 `<Type>`（对于`List`和`Set`）或 `<Key，Value>`（对于`Map`）。以下是使用类型字面量的示例 :
```
var names = <String>['Seth', 'Kathy', 'Lars'];
var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
var pages = <String, String>{
  'index.html': 'Homepage',
  'robots.txt': 'Hints for web robots',
  'humans.txt': 'We are people, not machines'
};
```
---
**将参数化类型与构造函数一起使用：**  
要在使用构造函数时指定一种或多种类型，请将类型放在类名后面的尖括号 (<...>) 中。例如：
```
// 创建一个String类型的集合，from方法将一个列表转换为集合。
var nameSet = Set<String>.from(names);
```
以下代码创建一个具有 `int`键和 `View `类型值的映射：
```
var views = Map<int, View>();
```
---
**通用集合以及包含的类型 ：**  
`Dart `泛型类型是具体化的，这意味着它们在运行时携带其类型信息。例如，您可以测试集合的类型:  
```
var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
print(names is List<String>); // true
```
>注意： 相比之下，`Java `中的泛型使用擦除，这意味着泛型类型参数在运行时被删除。在`Java`中，你可以测试一个对象是否是一个List，但你不能测试它是否是一个`List<String>`。  

---
**限制参数化类型：**  
当实现泛型类型时，你可能希望限制其作为参数提供的类型，以便参数必须是特定类型的子类型。你可以使用`extends`做到这一点：  
一个常见的案例是通过使其成为 Object 的子类（而不是默认的 Object？）来确保类型不可为 null。
```
// T必须是Object的子类型，这意味着Foo只能存储Object的子类型
class Foo<T extends Object> {
  // Any type provided to Foo for T must be non-nullable.
}
```
您可以使用 `extends `来扩展除了 `Object`以外的其他类型。以下是一个扩展 `SomeBaseClass` 的例子，以便可以对类型为 `T `的对象调用 `SomeBaseClass `的成员：:
```
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}
```
可以使用 `SomeBaseClass `或其任何子类型作为泛型参数: 
```
var someBaseClassFoo = Foo<SomeBaseClass>();
var extenderFoo = Foo<Extender>();
```
不指定通用参数也可以:
```
var foo = Foo();
print(foo); // Instance of 'Foo<SomeBaseClass>'
```
指定任何非 SomeBaseClass 类型都会导致错误:
```
// 静态检查错误
var foo = Foo<Object>();
```
---
**使用泛型方法：**  
方法和函数也允许类型参数:  
```
T first<T>(List<T> ts) {
  // Do some initial work or error checking, then...
  T tmp = ts[0];
  // Do some additional checking or processing...
  return tmp;
}
```
`first(<T>) `上的泛型类型参数允许您在多个地方使用类型参数 `T` : 
- 在函数的返回类型(T)中
- 在参数类型中`List<T>`
- 在局部变量的类型(T tmp)
-------
 
### 类型定义（Typedefs）:  
类型别名(`type alias`)(通常称为`typedef`,因为它使用关键字`typedef`来声明)是一种引用类型的简洁方式。下面是声明和使用名为`intList`的类型别名的示例:
```
typedef IntList = List<int>;
IntList il = [1,2,3];
```
类型别名可以有类型参数：
```
// 定义了一个ListMapper<x>的别名，等同于Map<X,List<X>>
typedef ListMapper<X> = Map<X, List<X>>;
// 定义了一个名为m1的Map<String,List<String>>类型变量
Map<String, List<String>> m1 = {}; // Verbose
// 定义了一个名为m2的ListMapper<String>类型变量
ListMapper<String> m2 = {}; // Same thing but shorter and clearer.
// m1和m2是相同的映射，但m2使用类型别名来简化代码，使用类型别名后，代码更简洁，也更容易理解。
```
>版本说明：2.13 之前，typedef 仅限于函数类型。使用新的 typedef 需要至少 2.13 的语言版本。

在大多数情况下，我们建议使用内联函数类型而不是函数的 typedef。然而，函数 typedef 仍然有用：
```
typedef Compare<T> = int Function(T a, T b);
int sort(int a, int b) => a - b;
void main() {
  assert(sort is Compare<int>); // True!
}
```
---
### Dart类型系统：
`Dart`语言是类型安全的：它使用静态类型检查和运行时检查的组合来确保变量的值始终与变量的静态类型匹配，有时也被称为健全类型。虽然类型是强制性的，但由于类型推断，类型注释是可选的。  
静态类型检查的好处之一是能够使用 Dart 的静态分析器在编译时查找错误。  
您可以通过向泛型类添加类型注释来修复大多数静态分析错误。最常见的泛型类是集合类型 List<T> 和 Map<K,V>。  
例如，在以下代码中，printInts() 函数打印一个整数列表，main() 创建一个列表并将其传递给 printInts()。
```
void printInts(List<int> a) => print(a);
void main(){
  // 该变量的类型是 List<dynamic>，初始值是一个空列表
  final list = [];
  list.add(1);
  list.add('2');
  // printInts()的参数类型是List<int>,这意味着list不能直接传给printInts()函数
  printInts(list);

}
```
前面的代码会在调用 `printInts(list)` 时导致列表（上面突出显示的）出现类型错误.  
`error - The argument type 'List<dynamic>' can't be assigned to the parameter type 'List<int>'. - argument_type_not_assignable`  
该错误突出显示从 `List<dynamic>`到 `List<int> `的不健全隐式转换。`List`变量具有静态类型`List<dynamic>`。这是因为初始化声明 `var list = [] `没有为分析器提供足够的信息来推断比动态更具体的类型参数。`printInts() `函数需要一个 `List<int> `类型的参数，这会导致类型不匹配。  
在创建列表时添加类型注释 `(<int>) `时（下面突出显示），分析器会抱怨字符串参数无法分配给 `int `参数。删除 `list.add('2') `中的引号会导致代码通过静态分析并且运行时不会出现错误或警告。
```
void printInts(List<int> a) => print(a);
void main() {
  final list = <int>[];
  list.add(1);
  list.add(2);
  printInts(list);
}
```
---
**什么是健全性？**
健全性是指确保程序不会进入某些无效状态。健全的类型系统意味着你永远不会进入到一个表达式的值与表达式的静态类型不匹配的状态。例如，如果一个表达式的静态类型是`String`，那么在运行时，你只能在求值时获得一个字符串。
`Dart `的类型系统，如 `Java `和 `C# `中的类型系统，是健全的。它使用静态检查（编译时错误）和运行时检查来强制执行这种健全性。例如，将 `String `赋值给 `int `是编译时错误。如果对象不是 `String`，则使用 `as String`将对象转换为 `String `会导致运行时错误。

**健全性的好处：**  
健全的类型系统有几个好处：
- 在编译时发现类型相关的错误。 健全的类型系统强制代码对其类型明确无误，因此可能在运行时难以发现的类型相关错误会在编译时被发现。
- 代码更易读。 代码更容易阅读，因为您可以依赖值确实具有指定的类型。在健全的 `Dart `中，类型不能说谎。
- 代码更易维护。 使用健全的类型系统，当您更改一个代码块时，类型系统会警告您其他代码块刚刚发生了崩溃。
- 更好的提前编译 (`AOT`) 编译。 虽然没有类型也可以进行 `AOT `编译，但生成的代码效率要低得多。  

**通过静态分析的小技巧 :**  
大多数静态类型的规则都很容易理解，以下是一些不太明显的规则：  
- 在重写方法时，使用健全的返回类型.这意味着，重写方法的返回类型必须是其超类方法的返回类型的子类型。这可以确保代码的健全性，并防止错误在运行时发生.
- 在重写方法时，使用健全的参数类型.这意味着，重写方法的参数类型必须是其超类方法的参数类型的子类型。这可以确保代码的健全性，并防止错误在运行时发生。
- 不要将动态列表用作类型列表。这意味着，不要将类型为 `dynamic `的列表用作类型为 `List<T> `的列表。这可以防止错误在运行时发生。

让我们通过使用以下类型层次结构的示例来详细了解这些规则：  
Animal 子类：Alligator Cat :子类 Lion Maine Coon  HoneyBadger   

---
**重写方法时使用正确的返回类型：**
- 子类中方法的返回类型必须与超类中方法的返回类型相同或为其子类型。考虑`Anima`类中的`getter`方法:
```
class Animal{
  void chase(Animal a){...}
  Animal get parent => ...
}
```
Animal的getter方法返回了Animal类型。子类HoneyBadger中，可以使用HoneyBadger(或任何其他子类型)替换getter返回类型。但不允许使用不相关的类型。
```
class HoneyBadger extends Animal{
  // override 重写：子类对父类允许访问的方法的实现过程进行重新编写，返回值和形参都不能改变。即外壳不变，核心重写
  @override
  void chase(Animal a){...}
  @override
  HoneyBadger get parent => ...

}
```
---
**重写方法时使用正确的参数类型：**  
重写方法的参数必须具有与超类中相应参数相同的类型或超类型。不要通过用原始参数的子类型替换类型来“收紧”参数类型(参数类型“收紧”是指将参数类型由父类类型替换为子类类型)。
>注意:如果您有充分的理由使用子类型，则可以使用 `covariant `关键字  

使用Animal 类的chase(Animal) 方法：
```
class Animal{
  void chase(Animal a){...}
  Animal get parent => ...s
}
```
`chase() `方法接受一个 `Animal.HoneyBadger `会追逐任何东西。可以重写`chase()`方法来获取任何东西（`Object`）。
```
class HoneyBadger extends Animal{
  @override
  void chase(Object a){...}
  @override
  Animal get parent => ...
}
```
以下代码将`chase()`方法上的参数从`Animal`收紧到`Mouse`（`Animal`的子类）
```
// 编译时报错
class Mouse extends Animal {...}

class Cat extends Animal {
  @override
  void chase(Mouse x) { ... }
}
```
这段代码不是类型安全的，因为这样可能定义一只猫，让其去追鳄鱼。
```
Animal a = Cat();
a.chase(Alligator()); // Not type safe or feline safe
```
---
**不要将动态列表用作类型化列表：**  
当你想要一个包含不同种类内容的列表时，动态列表是很好的选择。然而，不能将动态列表用作类型化列表。  
该规则也适用于泛型类型的实例。  
下面的代码创建了一个Dog的动态列表，将其赋值给一个Cat类型的列表，这在静态分析时产生错误：
```
// 编译时产生错误
class Cat extends Animal { ... }

class Dog extends Animal { ... }

void main() {
  List<Cat> foo = <dynamic>[Dog()]; // Error
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
}
```
---
**运行时检查 :**
运行时检查可以处理编译时无法检测到的类型安全问题。  
例如，以下代码在运行时抛出异常，因为将狗列表转换为猫列表是错误的：
```
// 运行时错误
void main() {
  List<Animal> animals = [Dog()];
  List<Cat> cats = animals as List<Cat>;
}
```
---
**类型推断（Type inference）**  
分析器可以推断字段、方法、局部变量和大多数通用类型参数的类型。当分析器没有足够的信息来推断特定类型时，它会使用动态类型。  
下面是类型推断如何与泛型配合使用的示例。在此示例中，名为 Arguments 的变量保存一个映射，该映射将字符串键与各种类型的值配对。  
如果显式键入变量，则可以这样写：
```
Map<String, dynamic> arguments = {'argA': 'hello', 'argB': 42};
```
或者，您可以使用 var 或 Final，让 Dart 推断类型:
```
var arguments = {'argA': 'hello', 'argB': 42}; // Map<String, Object>
```
Map字面量从其条目推断其类型，然后变量从Map字面量的类型推断其类型。在此映射中，键都是字符串，但值具有不同的类型（String 和 int，它们具有 Object 的上限）。因此，映射字面量具有类型 Map<String, Object>，参数变量也具有该类型。

---
**字段和方法推断 :**  
没有指定类型并且重写超类中的字段或方法的字段或方法将继承超类方法或字段的类型。  
没有声明或继承类型但使用初始值声明的字段将根据初始值获取推断类型。

---
**静态字段推断 :**
静态字段和变量从其初始值设定项推断出其类型。请注意，如果遇到循环，推理​​就会失败（也就是说，推断变量的类型取决于了解该变量的类型）

--- 
**局部变量推断 :**
局部变量类型是从其初始值设定项（如果有）推断出来的。不考虑后续分配。这可能意味着可能推断出过于精确的类型。如果是这样，您可以添加类型注释。
```
var x = 3; // x被推断为int类型
x = 4.0; // 静态编译时错误
```
修改为正确的
```
num x =3; // num类型可以是double或int
x = 4.0;
```
---
**参数类型推断：**  
构造函数调用和泛型方法调用的类型参数是根据出现上下文中的向下信息以及构造函数或泛型方法的参数中的向上信息的组合来推断的。如果推理没有达到您想要或期望的效果，您始终可以显式指定类型参数。
```
List<int> listOfInt = [];

// Inferred as if you wrote <double>[3.0].
var listOfDouble = [3.0];

// Inferred as Iterable<int>.
var ints = listOfDouble.map((x) => x.toInt());
```
在最后一个示例中，使用向下信息将 x 推断为 double。使用向上信息将闭包的返回类型推断为 int。 Dart 在推断 map() 方法的类型参数时使用此返回类型作为向上信息：<int>。

**替代类型：（Substituting types）**  
当您重写方法时，您正在将一种类型的某些内容（在旧方法中）替换为可能具有新类型的某些内容（在新方法中）。类似的，当您将参数传递给函数时，您正在将具有一种类型的内容（具有声明类型的参数）替换为具有另一种类型的内容(实际参数)。什么时候可以用具有子类型或超类型的东西替换具有一种类型的东西？  
在替换类型时，从消费者和生产者的胶角度考虑思考会有所帮助。消费者吸收一种类型，生产者生成一种类型。   
你可以将消费者的类型替换为超类型，将生产者的类型替换为子类型。  
下面示例是简单类型赋值和泛型类型赋值：  

**简单类型赋值：**  
将对象分配给对象时，什么时候可以用不同的类型替换一个类型？答案取决于该对象是消费者还是生产者。  
考虑以下类型层次结构：Animal > Alligator  Cat > Lion MaineCoon HoneyBadger  
考虑以下简单分配，其中Cat c是消费者，Cat()是生产者:Cat c = Cat();  
在使用位置上，可以安全的将使用特定类型(Cat)的内容替换为使用任何内容(Animal)的内容，因此将Cat c替换为以下内容是允许的，因为Animal是Cat的超类型：Animal c = Cat();  
但是使MaineCoon c替换Cat c会破坏类型安全，因为超类可能提供具有不同行为的Cat类型，例如Lion:    
在生产位置，用更具体的类型(MaineCoon)替换生成类型(Cat)的内容是安全的，因此，以下内容是允许的：Cat c = MaineCoon();

**泛型类型赋值：**  
泛型类型的规则相同吗？是的，考虑动物列表层次结构-Cat的List是Animal的List的子类型，并且是a的超类型MaineCoon的List。`List<Animal>` > `List<Cat>` > `List<MaineCoon>`。  
在以下的示例中，可以将Mainecoon的列表分配给myCats,因为`List<MaineCoon>`是`List<Cat>`的子类型：  
```
List<MaineCoon> myMaineCoons = ...
List<Cat> myCats = myMaineCoons;
```
如果像另一个方向走呢？您可以将`Animal`列表分配给`List<Cat>`吗？  
```
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals;
```
此分配未通过静态分析，因为它创建了隐式向下转型，而非 dynamic 类型（例如 Animal ）不允许这样做。  
要使此代码通过静态分析，可以使用显式强制转换。  
```
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals as List<Cat>;
```
不过显式强制转换在运行时可能扔会失败，具体取决于所转换列表的实际类型(myAnimals)  

**Method 方法：**  
当重写方法时，生产者和消费者规则仍然适用。例如：
```
class Animal{
  void chase(Animal a){}
  Animal get parent => ...
}
```
对于使用者（例如chase(Animal)方法），您可以将参数类型替换为超类型。对于生产者(例如parent getter方法)，您可以使用子类型替换返回类型。
