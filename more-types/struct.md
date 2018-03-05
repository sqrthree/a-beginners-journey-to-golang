# 结构体

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
