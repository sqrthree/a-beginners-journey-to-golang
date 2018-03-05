# 复杂类型

## 指针

指针，是一个比较高级的概念。

我们之前接触了变量，知道变量是代表了一个东西。但是，变量存储在什么地方呢？在编程的世界里，一切东西都是存储在计算机的内存中的。那既然变量是存储在内存中，那自然是有一个地址来让我们可以在内存中访问到这个变量的。这个地址，即为指针。

也就是说，指针保存的是变量的内存地址。

想要创建一个指针我们可以这样做：

使用 `*T` 创建一个指向类型 `T` 的值的指针。

```go
// 创建一个指向类型 int 的值的指针 p。其零值是 `nil`。
var p *int
```

或者使用 `&` 符号会生成一个指向其作用对象的指针。

```go
var i int = 1
var p = &i // 指针 p 指向其作用对象变量 i。
```

创建了指针之后，应该怎么使用它呢？答案是通过使用 `*` 啦：

```go
fmt.Println(*p) // 通过指针 p 读取 i
*p = 2          // 通过指针 p 设置 i，此时，变量 i 的值就变成 2 啦
```

通过指针，我们可以直接修改原始作用对象的值。

我们来看一个比较复杂的例子：

```go
package main

import "fmt"

func main() {
	i, j := 42, 27

	p := &i         // 指针 p 指向变量 i
	fmt.Println(*p) // 通过指针 p 读取变量 i 的值。=> 42
	*p = 21         // 通过指针 p 设置变量 i 的值
	fmt.Println(i)  // => 21

	p = &j         // 将指针 p 修改为指向变量 j
	*p = *p + 3    // 通过指针 p 访问并修改变量 j
	fmt.Println(j) // => 30
}
```

我们会在稍后的章节中继续学习指针的使用场景。

## 数组

数组是一系列相同类型的值的组合。把一些相同类型的东西组合在一起，是为了我们方便对其进行批量处理或进行一些操作。

注意，不是一组数值的组合。数组中可以存放任意类型。

数组的语法为 `[n]T`，表示有 `n` 个类型均为 `T` 的值的组合。

```go
var students [3]string // 定义变量 students 是一个有 3 个字符串的数组
var numbers [5]int // 定义变量 numbers 是一个有 5 个整数的数组
```

我们从语法 `[n]T` 中可以看到数组的长度（`n`）是其类型的一部分，因此，数组一旦创建之后就不能改变大小。

既然数组不只是存放数值，那么为什么叫数组呢？

这是因为数组中的每一个值都有一个由从小到大的整数构成的“序号”，这个“序号”从 0 开始，按照其在数组中的顺序依次递增，我们称之为“索引”。“索引”是我们访问数组中的值的唯一方式。

通过“索引”，我们可以访问数组中任一位置上的元素，并对其进行操作。

“索引”是这么使用的：

```go
var a [2]string // 数组的长度为 2

a[0] = "Hello" // 设置数组中的第 0 个（“索引”从 0 开始）元素的值为 "Hello"。
a[1] = "World" // 设置数组中的第 1 个（“索引”从 0 开始）元素的值为 "World"。

fmt.Println(a[0], a[1]) // 通过“索引”获取数组中指定位置上的元素的值。
```

“索引”`[n]`其中的 `n` 值是支持变量的。

```
var a [2]string

a[0] = "Hello"
a[1] = "World"

var i int = 1

fmt.Println(a[i]) // "World"
```

如果访问数组中未曾赋值的元素，那么其值为该类型对应的“零值”。

```go
var a [3]int
fmt.Println(a[1]) // 0
```

如果访问或操作数组中超出数组长度的索引对应的元素，那么编译器会抛出一个错误。

```go
var a [3]int

fmt.Println(a[4]) // error
```

一个数组变量表示整个数组，当一个数组变量被赋值或者被传递的时候，实际上会复制整个数组为一个新数组。（为了避免复制数组，你可以传递一个指向数组的指针。）

在创建数组的时候也可以直接初始化数组中的值：

```go
var a = [2]int{
	1,
	2,
}

b := [2]string{
	"hello",
	"world",
}

fmt.Println(a)
fmt.Println(b)
```

当然，也可以让编译器自行统计数组字面值中元素的数目：

```go
a := [...]string{
	"hello",
	"world",
}
```

## slice

数组虽然有适用它们的地方，但是由于长度固定导致数组不够灵活，因此在 Go 代码中数组使用的并不多。所以，诞生了基于数组构建的 `slice`，提供了更强的功能和便利行。

`slice` 跟数组类似，可以指向一个序列的值，并且包含了长度信息。

但是 `slice` 的长度是不需要声明的，并且其长度可以发生改变。

`slice` 类型的表示法为 `[]T`：

```go
var a []int
```

要想创建一个元素类型为 `T` 的 `slice` 需要通过 `make` 函数：

```go
var a []string = make([]string, 2, 2)

a[0] = "hello"
a[1] = "world"
```

`make` 函数为 Go 语言提供的一个函数，其接受一个类型、一个长度和一个可选的容量（即最大长度，默认为指定的长度）参数。 调用 `make` 时，内部会分配一个数组，然后返回数组对应的 `slice`。

内置函数 `len` 和 `cap` 获取 `slice` 的长度和容量信息。

```go
len(a) // 2
cap(a) // 2
```

`slice` 也可以直接初始化其值：

```go
a := []string{
	"hello",
	"world",
}
```

`slice` 的零值是 `nil`。

一个 `nil` 的 `slice` 的长度和容量是 0。

```go
var z []int

fmt.Println(z, len(z), cap(z))
```

`slice` 可以重新切片，创建一个新的 `slice` 值指向**相同的数组**。

切片的语法为 `s[from:to]`，表示从原 `slice` `s` 中切出一个新的 `slice`，其中新 `slice` 中的值包含起始位置，但不包含结束位置。

```go
package main

import "fmt"

func main() {
	a := [5]string{"h", "e", "l", "l", "o",}
	b := a[1:4]

	fmt.Println(a)	// [h e l l o]
	fmt.Println(b)	// [e l l]
}
```

切片的开始和结束的索引都是可选的，它们分别默认为零和数组的长度。

```go
package main

import "fmt"

func main() {
	a := [5]string{"h", "e", "l", "l", "o",}
	b := a[1:]
	c := a[:3]
	d := a[:]

	fmt.Println(a)	// [h e l l o]
	fmt.Println(b)	// [e l l o]
	fmt.Println(c)	// [h e l]
	fmt.Println(d)	// [h e l l o]
}
```

切片操作并不复制切片指向的元素。它创建一个新的切片并复用原来切片的底层数组。因此，通过一个新切片修改元素会影响到原始切片的对应元素。

```go
package main

import "fmt"

func main() {
	a := [5]string{"h", "e", "l", "l", "o",}
	b := a[1:4]

	fmt.Println(a)	// [h e l l o]
	fmt.Println(b)	// [e l l]

	b[1] = "w"

	fmt.Println(a)	// [h e w l o]
	fmt.Println(b)  // [e w l]
}
```

除了对 `slice` 重新切片，我们还可以通过 `append` 函数向 `slice` 中添加元素。

```go
package main

import "fmt"

func main() {
	var a []string

	fmt.Println(a)	// [] 空

	b := append(a, "hello")

	fmt.Println(a)	// [] 空
	fmt.Println(b)	// [hello]
}
```

从上面的代码中我们可以发现，`append` 的结果是一个包含原 `slice` 所有元素加上新添加的元素的新 `slice`，所以我们需要定义一个变量来接收这个结果。

新添加的数据会被追加到新切片的尾部。

如果是要将一个切片追加到另一个切片尾部，需要使用 `...` 语法将第 2 个参数展开为参数列表。

```go
a := []string{"John", "Paul"}
b := []string{"George", "Ringo", "Pete"}

a = append(a, b...) // 等同于 "append(a, b[0], b[1], b[2])"
```

我们还可以通过 `copy` 函数来对 `slice` 进行复制操作。

`copy` 函数将源切片的元素复制到目的切片。它返回复制元素的数目，其用法为 `copy(target, source)`。

`copy` 函数也支持不同长度的切片之间的复制（它只复制较短切片的长度个元素）。此外，`copy` 函数可以正确处理源和目的切片有重叠的情况。

## map

`map` 是 Go 中一种非常有用的类型。一般翻译作“字典”。主要是用来表示键值对的无序集合的一种抽象数据类型。

“键值对” 其实就是 `key: value` 这种属性和值一一对应的一种形式。Go 中称键值对为“键 —— 元素对”。

“键值对” 总是“成对”出现的。

例如，小明有一些自己的特征数据，诸如姓名、性别、年龄此类，我们想要在程序中使用时，可以为这些数据分别定义一些变量来表示，但是随着属性的增多，会导致我们的程序变得臃肿和难以维护，这个时候 `map` 就排上用场啦。

因为 `map` 本身就是用来表示键值对形式的的无序集合，所以我们可以定义一个 `map` 就能包含其所有的信息，并很方便的进行获取和更新。

`map` 的格式为 `map[keyType]valueType`。

```go
// 定义一个名为 xiaoming 的 map 类型，并设置其键的类型为 string，值的类型为 string。
var xiaoming map[string]string
```

和 `slice` 类似，上面定义的 `map` 类型在使用之前需要通过 `make` 函数进行初始化：

```go
var xiaoming map[string]string

xiaoming = make(map[string]string)
```

读取或设置一个“属性（键）”需要通过 `[keyName]` 来进行：

```go
package main

import "fmt"

func main() {
	var xiaoming map[string]string

	xiaoming = make(map[string]string)

	xiaoming["name"] = "xiaoming"
	xiaoming["age"] = "18"
	xiaoming["gender"] = "male"

	fmt.Println(xiaoming["name"])	// => "xiaoming"
}
```

当然，你也可以在创建 `map` 的时候直接初始化其值：

```go
var xiaoming = map[string]string{
	"name": "xiaoming",
	"age": "18",
	"gender": "male",
}

// or
xiaohong := map[string]string{
	"name": "xiaohong",
	"age": "18",
	"gender": "female",
}
```

从上面的例子中我们已经知道从 `map` 中获取一个元素的方法是 `m[key]`，设置一个元素的方法是 `m[key] = value`。

注意，设置一个元素时，如果该元素存在，那么直接修改其值，如果不存在，则会向 `map` 中插入一个元素。

除了获取和修改，我们还可以通过 `delete` 函数删除一个元素：

```go
package main

import "fmt"

func main() {
	var xiaoming = map[string]string{
		"name": "xiaoming",
		"age": "18",
		"gender": "male",
	}

	fmt.Println(xiaoming["age"])	// "18"

	delete(xiaoming, "age")

	fmt.Println(xiaoming["age"])	// ""
}
```

当从 `map` 中读取某个不存在的键时，其结果是 `map` 的元素类型的零值。

此外，我们还可以通过双赋值语法 `elem, ok = m[key]` 来检测某个键存在, 如果 `key` 在 `m` 中，`ok` 为 `true` 。否则 `ok` 为 `false`，并且 `elem` 是 `map` 的元素类型的零值。

```go
package main

import "fmt"

func main() {
	var xiaoming = map[string]string{
		"name": "xiaoming",
		"age": "18",
		"gender": "male",
	}

	age, ok := xiaoming["age"]

	fmt.Println(xiaoming["age"])	// "18"
	fmt.Println(age)	// "18"
	fmt.Println(ok)	// true
}
```

`map` 也是有长度的，`map` 值的长度表示了其中的“键——元素对”的数量，其零值的长度总是 0。

有一个细节不知你注意到了否，我们在定义 `age` 元素的值时使用的是字符串 `"18"` 而不是数字 `18`。

这是因为我们在定义 `map` 时需要显示的指定键和元素的类型，这也就意味着 `map` 中所有的键的类型是相同的，所有的元素值的类型也是相同的。

那如果我们确实想要 `name` 为 `string` 类型，`age` 为 `int` 类型呢？这就需要结构体来帮忙啦。

## 结构体

Go 语言允许我们可以声明新的类型，作为其它类型的属性或字段的容器。

例如，我们可以创建一个自定义类型 `person` 代表一个“人”。这个“人”拥有一些属性：姓名和年龄。这样的类型我们就称之为“结构体”（`struct`）:

```go
type person struct {
  name string	// 每个属性有自己的类型
  age int
}
```

简单的来说，一个结构体就是一些字段的集合。

在定义了一个结构体之后，我们该怎么来使用呢？很简单，直接定义一个变量并设置其类型为该结构体即可：

```go
package main

import "fmt"

type person struct {
	name string
	age int
	gender string
}

func main() {
	var xiaoming person

	fmt.Println(xiaoming)
}
```

我们还可以通过 `.` 直接对其进行属性操作：

```go
package main

import "fmt"

type person struct {
	name string
	age int
	gender string
}

func main() {
	var xiaoming person

	xiaoming.name = "xiaoming"
	xiaoming.age = 18
	xiaoming.gender = "male"

	fmt.Println(xiaoming.name)	// xiaoming
	fmt.Println(xiaoming.age)		// 18 (type: int)
	fmt.Println(xiaoming.gender)	// male
}
```

当然，也可以直接进行初始化赋值：

```go
package main

import "fmt"

type person struct {
	name   string
	age    int
	gender string
}

func main() {
	xiaoming := person{
		// 属性名不需要引号
		name: "xiaoming",
		age: 18,
		gender: "male",
	}

	fmt.Println(xiaoming.name)
	fmt.Println(xiaoming.age)
	fmt.Println(xiaoming.gender)
}
```

除了 `name: value` 的这种形式初始化之外，还有一种更简洁的方式 —— 按照属性的顺序初始化赋值：

```go
package main

import "fmt"

type coordinate struct {
	x int
	y int
}

func main() {
	// 省略属性名，按照属性的顺序依次赋值
	value := coordinate{1, 2}

	fmt.Println(value.x)
	fmt.Println(value.y)
}
```

结构体中的字段也可以通过结构体指针来访问。

```go
value := coordinate{1, 2}

p := &value

p.x = 2

fmt.Println(value.x)	// 2
```

结构体类型中的每个字段声明都需要独占一行。一般情况下，字段声明需由字段名称和表示字段类型的字面量组成。

还有一种只有类型字面量的无名称字段，称之为“嵌入字段”。当匿名字嵌入字段是一个 `struct` 的时候，那么这个 `struct` 所拥有的全部字段都被隐式地引入了当前定义的这个 `struct`。

```go
package main

import "fmt"

type Human struct {
  name string
  age int
}

type Man struct {
  Human
  speciality string
}

func main() {
  xiaoming := Man{Human{"xiaoming", 18}, "male"}

  fmt.Println(xiaoming.name)	// xiaoming
	fmt.Println(xiaoming.Human) // 不仅具有 Human 下的所有属性，还能通过 Human 字段访问对应的 struct
}
```

如果两个 `struct` 中存在相同的字段，则最外层的优先被使用。比如 `Human` 和 `Man` 都有 `gender` 属性，那么 `xiaoming` 访问的就是 `Man` 中的 `gender`。
