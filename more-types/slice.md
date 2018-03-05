# 切片

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
