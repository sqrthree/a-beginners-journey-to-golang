# 字典

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
