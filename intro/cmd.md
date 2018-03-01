# Go 命令行

Go 语言自带有一套完整的命令行操作工具，你可以通过在命令行中执行 `go` 来查看它们：

```
Go is a tool for managing Go source code.

Usage:

	go command [arguments]

The commands are:

	build       compile packages and dependencies
	clean       remove object files and cached files
	doc         show documentation for package or symbol
	env         print Go environment information
	bug         start a bug report
	fix         update packages to use new APIs
	fmt         gofmt (reformat) package sources
	generate    generate Go files by processing source
	get         download and install packages and dependencies
	install     compile and install packages and dependencies
	list        list packages
	run         compile and run Go program
	test        test packages
	tool        run specified go tool
	version     print Go version
	vet         report likely mistakes in packages

Use "go help [command]" for more information about a command.

Additional help topics:

	c           calling between Go and C
	buildmode   build modes
	cache       build and test caching
	filetype    file types
	gopath      GOPATH environment variable
	environment environment variables
	importpath  import path syntax
	packages    package lists
	testflag    testing flags
	testfunc    testing functions

Use "go help [topic]" for more information about that topic.
```

这些命令对于我们平时开发时非常有用，接下来我们来了解一些常用命令：

## go get

用于动态获取远程仓库中的代码包及其依赖，并进行安装。这个命令实际上分为两步：第一步是下载源码包，第二步是执行 `go install` 安装。下载源码包的 go 工具会自动根据不同的域名调用不同的源码工具。例如下载 Github 上的代码包时则是利用系统的 Git 工具。

所以为了 `go get` 能正常工作，你必须确保安装了合适的源码管理工具。另外，`go get` 支持自定义域名的功能，具体参见 `go help remote`。

常用参数：

- `-u` - 强制使用网络去更新包和它的依赖包
- `-d` - 只下载不安装
- `-fix` - 在获取源码之后先运行fix，然后再去做其他的事情
- `-t` - 同时也下载需要为运行测试所需要的包
- `-v` - 显示执行的命令

## go run

直接从源码文件运行编译任务并执行编译文件。

## go build

这个命令主要用来编译代码，Go 是一门编译型语言，因此需要将源码编译为二进制文件之后才能执行。该命令即可将源码文件编译为对应的二进制文件。若有必要，会同时编译与之相关联的包。

- 如果是普通包（后续介绍），当执行 `go build` 之后，它不会产生任何文件。如果需要在 `$GOPATH/pkg` 下生成相应的文件，则需要执行 `go install` 命令完成。
- 如果是 `main` 包，当执行 `go build` 之后，它就会在当前目录下生成一个可执行文件。如果需要在 `$GOPATH/bin` 下生成相应的文件，需要执行 `go install`，或者使用 `go build -o 路径`。
- 如果某个项目文件夹下有多个文件，而你只想编译某个文件，可以在 `go build` 之后加上文件名，例如 `go build hello.go`，`go build` 命令默认会编译当前目录下的所有 `go` 文件。
- 可以通过 `-o NAME` 的方式指定 `go build` 命令编译之后的文件名，默认是 `package` 名（非 `main` 包），或者是第一个源文件的文件名（`main` 包）。
- `go build` 会忽略目录下以“_”或“.”开头的 `go` 文件。

## go clean

移除当前源码包和关联源码包里面编译生成的文件。

## go fmt

Go 语言有标准的书写风格，不按照此风格的代码将不能编译通过，为了减少浪费在排版上的时间，`go fmt` 命令可以帮你格式化你写好的代码文件，使你写代码的时候不需要关心格式，你只需要在写完之后执行 `go fmt filename.go`，你的代码就被修改成了标准格式。

## go install

编译和安装包及其依赖。在内部实际上分成了两步操作：第一步是生成结果文件(可执行文件或者包)，第二步会把编译好的结果移到 `$GOPATH/pkg` 或者 `$GOPATH/bin` 中。

## go test

读取源码目录下面名为 `*_test.go` 的文件，生成并自动运行测试用的可执行文件。

- `-bench regexp` - 执行相应的 benchmarks。
- `-cover` - 开启测试覆盖率。
- `-run regexp` - 只运行 `regexp` 匹配的函数。
- `-v` - 显示测试的详细命令。

## go tool

一些有用的工具集合。常用的有：

- `go tool fix .` 用来修复以前老版本的代码到新版本。
- `go tool vet directory|file` 用来分析当前目录的代码是否都是正确的代码，例如函数里面提前 `return` 导致出现了无用代码之类的。

## godoc

为 `go` 程序自动提取和生成文档，或者查看某个 package 的文档。

例如，查看 `fmt` 的文档，使用 `godoc fmt` 即可。

支持查看包中的某个函数，例如 `godoc fmt Printf`。

支持使用 `-http` 参数开启一个本地服务，用于展示 golang.org 的上的官方文档。例如：`godoc -http=:8080`。

完整的文档列表请查看 [golang.google.cn/cmd/go](https://golang.google.cn/cmd/go/)。
