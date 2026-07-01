---
engine: knitr
knitr: true
syntax-definition: "./Assets/zig.xml"
---

```{r}
#| include: false
source("./zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "run"
)
```



:::: {.content-hidden when-format="epub"}
::: {.content-hidden when-format="pdf"}

# Welcome {.unnumbered}

Welcome! This is the initial page for the "Open Access" HTML version of the book "Introduction to Zig: a project-based book",
written by [Pedro Duarte Faria](https://pedro-faria.netlify.app/).
This is an open book that provides an introduction to the [Zig programming language](https://ziglang.org/),
which is a new general-purpose, and low-level language for building robust and optimal software.

## Support the project! {.unnumbered}

If you like this project, and you want to support it, you can buy a PDF, eBook or a physical copy
of the book, either at Amazon, or at Leanpub:

{{< include ./Assets/button.html >}}

{{< include ./Assets/leanpub-button.html >}}


### Sending donations directly

You can also donate some amount directly to the author of the project via:

- PayPal Donation.
- Revolut.

These are good ways to support directly the author of the project, which helps to foster
more contents like this, and it makes possible for the author to keep writing helpful tools and
materials for the community.

### PayPal

{{< include ./Assets/paypal-button.html >}}

### Revolut

You can send money via Swift Payment with the following bank and Swift details:

```
Recipient: Pedro Duarte Faria
BIC/SWIFT Code: REVOSGS2
Account number: 6124512226
Name and address of the bank: Revolut Technologies Singapore Pte. Ltd, 6 Battery Road, Floor 6-01, 049909, Singapore, Singapore
Corresponding BIC: CHASGB2L
```

If you do have a Revolut account, you can scan the following QR code:

{{< include ./Assets/revolut-button.html >}}

:::
::::


## About this book {.unnumbered}

This an open (i.e., open-source), technical and introductory book for the [Zig programming language](https://ziglang.org/),
which is a new general purpose, and low-level programming language for building optimal and robust software.

Official repository of the book: <https://github.com/pedropark99/zig-book>.

This book is designed for both beginners and experienced developers. It explores the exciting world of Zig through small
and simple projects (in a similar style to the famous "Python Crash Course" book from Eric Matthes).
Some of these projects are: a Base64 encoder/decoder, a HTTP Server and an image filter.

As you work through the book, you will learn:

- The syntax of the language, and how it compares to C, C++ and Rust.
- Data structures, memory allocators, filesystem and I/O.
- Optionals as a new paradigm to handle nullability.
- How to test and debug a Zig application.
- Errors as values, and how to handle them.
- How to build C and Zig code with the build system that is embedded into the language.
- Zig interoperability with C.
- Parallelism with threads and SIMD.
- And more.


## About the author {.unnumbered}

Pedro Duarte Faria has a bachelor's degree in Economics from the Federal University of Ouro Preto - Brazil.
Currently, he is a Senior Data Engineer at [DSM-Firmenich](https://www.dsm-firmenich.com)[^dsm], and
a Databricks Certified Associate Developer for Apache Spark 3.0.

[^dsm]: <https://www.dsm-firmenich.com>


The author has more than 4 years of experience in the data industry, developing data products, pipelines,
reports and analysis for research institutions and some of the largest companies in the
Brazilian financial sector, such as the BMG Bank, Sodexo and Pan Bank.

But Pedro is also a passionate software developer who loves to learn and teach about programming.
Although Pedro uses many different languages in his work, he is specialized in the R programming language, and have given several
lectures and courses about it, inside graduate centers (such as PPEA-UFOP^[<https://ppea.ufop.br/>]),
in addition to federal and state organizations (such as FJP-MG^[<http://fjp.mg.gov.br/>]).


Personal Website: <https://pedro-faria.netlify.app/>

Linkedin: <https://www.linkedin.com/in/pedro-faria-a68140209/>

Mastodon: [\@pedropark99\@fosstodon.org](https://fosstodon.org/@pedropark99)

Twitter (X): [\@PedroPark9](https://twitter.com/PedroPark9)

## License {.unnumbered}

Copyright © 2025 Pedro Duarte Faria. This book is licensed by the [CC-BY 4.0 Creative Commons Attribution 4.0 International Public License](https://creativecommons.org/licenses/by/4.0/)[^cc-license].

[^cc-license]: <https://creativecommons.org/licenses/by/4.0/>

![](Figures/creative-commoms-88x31.png){width=88px}


## Book compilation metadata {.unnumbered}

This book was compiled using the following versions of [Zig](https://ziglang.org) and [Quarto](https://quarto.org):

```{r}
#| echo: false
#| results: 'asis'
source("./Scripts/zig-quarto-versions.R")
```

## Book citation {.unnumbered}

You can use the following BibTex entry to cite this book:

```
@book{pedro2024,
    author = {Pedro Duarte Faria},
    title = {Introduction to Zig},
    subtitle = {a project-based book},
    month = {October},
    edition = {1},
    year = {2024},
    address = {Belo Horizonte},
    url = {https://github.com/pedropark99/zig-book}
}
```

## Corresponding author and maintainer {.unnumbered}

Pedro Duarte Faria

Contact: [pedropark99\@gmail.com](mailto:pedropark99@gmail.com)

Personal website: <https://pedro-faria.netlify.app/>


## Acknowledgments {.unnumbered}

This book is also a product of many conversations and exchanges that we had
with different people from the Zig community. I (Pedro Duarte Faria) am incredibly
grateful for these conversations, and also, for some direct contributions that we
had. Below we have a list of the people involved (name of the person with their usename in GitHub):

```{r}
#| echo: false
#| results: "asis"
c <- read.csv("Assets/contributors.txt")
n <- nrow(c)
user_names <- sprintf("(%s)", c$user_name)
user_names <- gsub("@", "\\\\@", user_names)
vec <- vector("character", n)
for (i in seq_len(n)) {
    vec[i] <- paste(c$name[i], user_names[i])
}
cat(paste(vec, collapse = ", "), sep = "\n")
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---


```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Introducing Zig

In this chapter, I want to introduce you to the world of Zig.
Zig is a very young language that is being actively developed.
As a consequence, its world is still very wild and to be explored.
This book is my attempt to help you on your personal journey for
understanding and exploring the exciting world of Zig.

I assume you have previous experience with some programming
language in this book, not necessarily with a low-level one.
So, if you have experience with Python, or Javascript, for example, it will be fine.
But, if you do have experience with low-level languages, such as C, C++, or
Rust, you will probably learn faster throughout this book.

## What is Zig?

Zig is a modern, low-level, and general-purpose programming language. Some programmers think of
Zig as a modern and better version of C.

In the author's personal interpretation, Zig is tightly connected with "less is more".
Instead of trying to become a modern language by adding more and more features,
many of the core improvements that Zig brings to the
table are actually about removing annoying behaviours/features from C and C++.
In other words, Zig tries to be better by simplifying the language, and by having more consistent and robust behaviour.
As a result, analyzing, writing and debugging applications become much easier and simpler in Zig, than it is in C or C++.

This philosophy becomes clear with the following phrase from the official website of Zig:

> "Focus on debugging your application rather than debugging your programming language knowledge".

This phrase is specially true for C++ programmers. Because C++ is a gigantic language,
with tons of features, and also, there are lots of different "flavors of C++". These elements
are what makes C++ so complex and hard to learn. Zig tries to go in the opposite direction.
Zig is a very simple language, more closely related to other simple languages such as C and Go.

The phrase above is still important for C programmers too. Because, even C being a simple
language, it's still hard sometimes to read and understand C code. For example, pre-processor macros in
C are a frequent source of confusion. Sometimes, they really make it hard to debug
C programs. Because macros are essentially a second language embedded in C that obscures
your C code. With macros, you are no longer 100% sure about which pieces
of the code are being sent to the compiler, i.e.
they obscure the actual source code that you wrote.

You don't have macros in Zig. In Zig, the code you write, is the actual code that gets compiled by the compiler.
You also don't have a hidden control flow happening behind the scenes. And, you also
don't have functions or operators from the standard library that make
hidden memory allocations behind your back.

By being a simpler language, Zig becomes much more clear and easier to read/write,
but at the same time, it also achieves a much more robust state, with more consistent
behaviour in edge situations. Once again, less is more.


## Hello world in Zig

We begin our journey in Zig by creating a small "Hello World" program.
To start a new Zig project in your computer, you simply call the `init` command
from the `zig` compiler.
Just create a new directory in your computer, then, init a new Zig project
inside this directory, like this:

```bash
mkdir hello_world
cd hello_world
zig init
```

```
info: created build.zig
info: created build.zig.zon
info: created src/main.zig
info: created src/root.zig
info: see `zig build --help` for a menu of options
```

### Understanding the project files {#sec-project-files}

After you run the `init` command from the `zig` compiler, some new files
are created inside of your current directory. First, a "source" (`src`) directory
is created, containing two files, `main.zig` and `root.zig`. Each `.zig` file
is a separate Zig module, which is simply a text file that contains some Zig code.

By convention, the `main.zig` module is where your main function lives. Thus,
if you are building an executable program in Zig, you need to declare a `main()` function,
which represents the entrypoint of your program, i.e., where the execution of your program begins.

However, if you are building a library (instead of an executable program), then,
the normal procedure is to delete this `main.zig` file and start with the `root.zig` module.
By convention, the `root.zig` module is the root source file of your library.

```bash
tree .
```

```
.
├── build.zig
├── build.zig.zon
└── src
    ├── main.zig
    └── root.zig

1 directory, 4 files
```

The `init` command also creates two additional files in our working directory:
`build.zig` and `build.zig.zon`. The first file (`build.zig`) represents a build script written in Zig.
This script is executed when you call the `build` command from the `zig` compiler.
In other words, this file contains Zig code that executes the necessary steps to build the entire project.


Low-level languages normally use a compiler to build your
source code into binary executables or binary libraries.
Nevertheless, this process of compiling your source code and building
binary executables or binary libraries from it, became a real challenge
in the programming world, once the projects became bigger and bigger.
As a result, programmers created "build systems", which are a second set of tools designed to make this process
of compiling and building complex projects, easier.

Examples of build systems are CMake, GNU Make, GNU Autoconf and Ninja,
which are used to build complex C and C++ projects.
With these systems, you can write scripts, which are called "build scripts".
They simply are scripts that describes the necessary steps to compile/build
your project.

However, these are separate tools, that do not
belong to C/C++ compilers, like `gcc` or `clang`.
As a result, in C/C++ projects, you have not only to install and
manage your C/C++ compilers, but you also have to install and manage
these build systems separately.

In Zig, we don't need to use a separate set of tools to build our projects,
because a build system is embedded inside the language itself.
We can use this build system to write small scripts in Zig,
which describe the necessary steps to build/compile our Zig project[^zig-build-system].
So, everything you need to build a complex Zig project is the
`zig` compiler, and nothing more.

[^zig-build-system]: <https://ziglang.org/learn/overview/#zig-build-system>.


The second generated file (`build.zig.zon`) is a JSON-like file, in which you can describe
your project, and also, declare a set of dependencies of your project that you want to fetch from the internet.
In other words, you can use this `build.zig.zon` file to include a list of external libraries in your project.

One possible way to include an external Zig library in your project, is to manually build
and install the library in your system, and just link your source code
with the library at the build step of your project.

However, if this external Zig library is available on GitHub for example,
and it has a valid `build.zig.zon` file in the root folder of the project,
which describes the project, you can easily include this library in
your project by simply listing this external library in your `build.zig.zon` file.

In other words, this `build.zig.zon` file works similarly to the `package.json`
file in Javascript projects, or the `Pipfile` file in Python projects,
or the `Cargo.toml` file in Rust projects. You can read more about this
specific file in a couple of articles on the internet[^zig-zon][^zig-zon2], and
you can also see the expected schema for this `build.zig.zon` file
in a documentation file inside the official repository of Zig[^zig-zon-schema].

[^zig-zon]: <https://zig.news/edyu/zig-package-manager-wtf-is-zon-558e>
[^zig-zon2]: <https://medium.com/@edlyuu/zig-package-manager-2-wtf-is-build-zig-zon-and-build-zig-0-11-0-update-5bc46e830fc1>
[^zig-zon-schema]: <https://codeberg.org/ziglang/zig/src/branch/master/doc/build.zig.zon.md>

### The file `root.zig` {#sec-root-file}

Let's take a look into the `root.zig` file.
You might have noticed that every line of code with an expression ends with a semicolon (`;`).
This follows the syntax of a C-family programming language[^c-family].

[^c-family]: <https://en.wikipedia.org/wiki/List_of_C-family_programming_languages>

Also, notice the `@import()` call at the first lines. We use this built-in function
to import functionality from other Zig modules into our current module.
Therefore, this `@import()` function works similarly to the `#include` pre-processor
in C or C++, or, to the `import` statement in Python or Javascript code.
In this example, we are importing the `std` module,
which gives you access to the Zig Standard Library.

In this `root.zig` file, we can also see how assignments (i.e., creating new objects)
are made in Zig. You can create a new object in Zig by using the syntax
`(const|var) name = value;`. In the example below, one of the constant objects
that are created is `std`. In @sec-assignments we talk more about objects in general.


```{zig}
#| auto_main: false
#| build_type: "ast"
//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

/// This is a documentation comment to explain the `printAnotherMessage` function below.
///
/// Accepting an `Io.Writer` instance is a handy way to write reusable code.
pub fn printAnotherMessage(writer: *Io.Writer) Io.Writer.Error!void {
    try writer.print("Run `zig build test` to run the tests.\n", .{});
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}
```

You can also notice in `root.zig` how comments are done in the language. In Zig there are three types of comments that you can write in your code:

- normal comments, which are lines that start with `//` and are completely ignored by the compiler.
- doc comments, which are lines that start with `///`, and they document the variable/type/whatever immediately follows that comment. These comments are actually used by the compiler to generate documentation for your code.
- top-level doc comments, which are lines that start with `//!` and are always present at the top (first lines) of the Zig module, and are used by the compiler to generate documentation about the entire module.


Also, functions in Zig are declared using the `fn` keyword.
In this `root.zig` module, we are declaring a function called `add()`, which has two arguments named `a` and `b`.
The function returns an integer of the type `i32` as result.


Zig is a strongly-typed language. There are some specific situations where you can (if you want to) omit
the type of an object in your code, if this type can be inferred by the `zig` compiler (we talk more
about that in @sec-type-inference). But there are other situations where you do need to be explicit.
For example, you do have to explicitly specify the type of each function argument, and also,
the return type of every function that you create in Zig.

We specify the type of an object or a function argument in Zig by
using a colon character (`:`) followed by the type after the name of this object/function argument.
With the expressions `a: i32` and `b: i32`, we know that both `a` and `b` arguments have type `i32`,
which is a signed 32 bit integer. In this part,
the syntax in Zig is identical to the syntax in Rust, which also specifies types by
using the colon character.

Lastly, we have the return type of the function at the end of the line, before we open
the curly braces to start writing the function's body. In the example above, this type is also
a signed 32 bit integer (`i32`) value.

Notice that we also have an `pub` keyword before the function declaration. This keyword
is transforming the `add()` function into a "public function from this module". Every function in your Zig
module is by default private to this Zig module and can only be called from within this module.
Unless, you explicitly mark this function as a public function with the `pub` keyword.

If you think about it, this `pub` keyword in Zig does essentially the opposite of what the `static` keyword
do in C/C++. By making a function "public" you allow other Zig modules to access and call this function.
A calling Zig module imports another module by using the `@import()` built-in function, which makes
all public functions from the imported module visible to the calling Zig module.
We talk more about this keyword at @sec-pub-keyword.

You can also see a `test` block inside `root.zig`. This is a block of unit tests to be executed.
You will learn more about these blocks at @sec-unittests.


### The `main.zig` file {#sec-main-file}

Now that we have learned a lot about Zig's syntax from the `root.zig` file,
let's take a look at the `main.zig` file.
A lot of the elements we saw in `root.zig` are also present in `main.zig`.
But there are some other elements that we haven't seen yet, so let's dive in.

First, look at the return type of the `main()` function in this file.
We can see a small change. The return type of the function (`void`) is accompanied by an exclamation mark (`!`).
This exclamation mark tells us that this `main()` function might return an error.

It's worth noting that, a `main()` function in Zig is allowed to return nothing (`void`),
or an unsigned 8-bit integer (`u8`) value[^u8-example], or an error. In other words, you can write your `main()` function in Zig
to return essentially nothing (`void`), or, if you prefer, you can also write a more C-like `main()` function,
which returns an integer value that usually serves as a "status code" for the process.

[^u8-example]: You can see an example of a `main()` function that returns a `u8` value in the `return-integer.zig` file, <https://github.com/pedropark99/zig-book/blob/main/ZigExamples/zig-basics/return-integer.zig>

In this example, the return type annotation of `main()` indicates that this function can either
return nothing (`void`), or return an error. This exclamation mark in the return type annotation
is an interesting and powerful feature of Zig. In summary, if you write a function and something inside
the body of this function might return an error, then, you are forced to:

- either add the exclamation mark to the return type of the function and make it clear that this function might return an error.
- explicitly handle this error inside the function.

In most programming languages, we normally handle (or deal with) an error through
a *try catch* pattern. Zig does have both `try` and `catch` keywords. But they work
a little differently than what you're probably used to in other languages.

If we look at the `main()` function below, you can see that we do have a `try` keyword
on the 5th line. But we do not have a `catch` keyword in this code.
In Zig, we use the `try` keyword to execute an expression that might return an error,
which, in this example, is the `stdout.print()` expression.

In essence, the `try` keyword executes the expression `stdout.print()`. If this expression
returns a valid value, then, the `try` keyword does absolutely nothing. It only passes the value forward.
It's like if this `try` keyword was never there. However, if the expression does return an error, then,
the `try` keyword will unwrap the error value, then, it returns this error from the function
and also prints the current stack trace to `stderr`.

This might sound weird to you if you come from a high-level language. Because in
high-level languages, such as Python, if an error occurs somewhere, this error is automatically
returned and the execution of your program will automatically stop even if you don't want
to stop the execution. You are obligated to face the error.


```{zig}
#| auto_main: false
#| build_type: "run"
#| results: "hide"
const std = @import("std");
const Writer = std.Io.File.Writer;

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = Writer.init(
        std.Io.File.stdout(),
        init.io,
        &stdout_buffer
    );
    const stdout = &stdout_writer.interface;
    try stdout.print("Hello, {s}!\n", .{"world"});
    try stdout.flush();
}
```

Another thing that you might have noticed in this code example, is that
the `main()` function is marked with the `pub` keyword. This is needed for every `main()`
function that you create in your Zig projects. So, you should always mark this function as
a "public function". Without it, the operating system will be unable to call this function,
and, therefore, to start your program.



### Compiling the entire project {#sec-compile-project}

Now that we have seen the file projects, and understood more about them, let's discuss
how you can actually compile your Zig code into actual executable or library files.
Let's begin with how you can compile the entire project at once.

Just as I described in @sec-project-files, as our project grows in size and
complexity, we usually prefer to organize the compilation and build process
of the project into a build script, using some sort of "build system".

In other words, as our project grows in size and complexity, we usually prefer to not
directly write build commands such as `build-exe`, `build-lib` and `build-obj` commands into the terminal.
Because they start to become harder and harder to write as the project grows.

In C/C++ projects, programmers normally opt to use CMake, Ninja, `Makefile` or `configure` scripts
to organize this process. However, in Zig, we have a native build system in the language itself.
So, we can write build scripts in Zig to compile and build Zig projects. Then, all we
need to do, is to call the `zig build` command to build our project.

So, when you execute the `zig build` command, the `zig` compiler will search
for a Zig module named `build.zig` inside your current directory, which
should be your build script, containing the necessary code to compile and
build your project. If the compiler does find this `build.zig` file in your directory,
then, the compiler will essentially execute a `zig run` command
over this `build.zig` file, to compile and execute this build
script, which in turn, will compile and build your entire project.


```bash
zig build
```


After you execute this "build project" command, a `zig-out` directory
is created in the root of your project directory, where you can find
the binary executables and libraries created from your Zig modules
accordingly to the build commands that you specified at `build.zig`.
We will talk more about the build system in Zig later in this book.

In the example below, I'm executing the binary executable
named `hello_world` that was generated by the compiler after the
`zig build` command.

```bash
./zig-out/bin/hello_world
```

```
Hello, world!
```



### Compiling your code into an executable file {#sec-compile-code}

You can compile your Zig code into a binary executable by running the `build-exe` command
from the `zig` compiler. You simply list all the Zig modules that you want to build after
the `build-exe` command, separated by spaces. In the example below, we are compiling a hypothetical
module named `foo.zig`.

```bash
zig build-exe src/foo.zig
```

Since we are building an executable, the `zig` compiler will look for a `main()` function
declared in any of the files that you list after the `build-exe` command. If
the compiler does not find a `main()` function declared somewhere, a
compilation error will be raised, warning about this mistake.

The `zig` compiler also offers a `build-lib` and `build-obj` commands, which work
the exact same way as the `build-exe` command. The only difference is that, they compile your
Zig modules into a portable C ABI library, or, into object files, respectively.

In the case of the `build-exe` command, a binary executable file is created by the `zig`
compiler in the root directory of your project.
If we take a look now at the contents of our current directory, with a simple `ls` command, we can
see the binary file called `foo` that was created by the compiler.

```bash
ls
```

```
build.zig  build.zig.zon  foo  src
```

If I execute this binary executable, I get the "Hello World" message in the terminal
, as we expected.

```bash
./foo
```

```
Hello, world!
```


### Compile and execute at the same time {#sec-compile-run-code}

In the previous section, I presented the `zig build-exe` command, which
compiles Zig modules into an executable file. However, this means that,
in order to execute the executable file, we have to run two different commands.
First, the `zig build-exe` command, and then, we call the executable file
created by the compiler.

But what if we wanted to perform these two steps,
all at once, in a single command? We can do that by using the `zig run`
command.

```bash
zig run src/foo.zig
```

```
Hello, world!
```


## How to learn Zig?

What are the best strategies to learn Zig?
First of all, of course this book will help you a lot on your journey through Zig.
But you will also need some extra resources if you want to be really good at Zig.

As a first tip, you can join a community with Zig programmers to get some help
, when you need it:

- Reddit forum: <https://www.reddit.com/r/Zig/>;
- Ziggit community: <https://ziggit.dev/>;
- Discord, Slack, Telegram, and others: <https://ziglang.org/community/>;

Now, one of the best ways to learn Zig is to simply read Zig code. Try
to read Zig code often, and things will become more clear.
A C/C++ programmer would also probably give you this same tip.
Because this strategy really works!

Now, where can you find Zig code to read?
I personally think that, the best way of reading Zig code is to read the source code of the
Zig Standard Library. The Zig Standard Library is available at the [`lib/std` folder](https://codeberg.org/ziglang/zig/src/branch/master/lib/std)[^zig-lib-std] on
the official GitHub repository of Zig. Access this folder, and start exploring the Zig modules.

Also, a great alternative is to read code from other large Zig
codebases, such as:

1. the [Javascript runtime Bun](https://github.com/oven-sh/bun)[^bunjs].
1. the [game engine Mach](https://github.com/hexops/mach)[^mach].
1. a [LLama 2 LLM model implementation in Zig](https://github.com/cgbur/llama2.zig/tree/main)[^ll2].
1. the [financial transactions database `tigerbeetle`](https://github.com/tigerbeetle/tigerbeetle)[^tiger].
1. the [command-line arguments parser `zig-clap`](https://github.com/Hejsil/zig-clap)[^clap].
1. the [UI framework `capy`](https://github.com/capy-ui/capy)[^capy].
1. the [Language Protocol implementation for Zig, `zls`](https://github.com/zigtools/zls)[^zls].
1. the [event-loop library `libxev`](https://github.com/mitchellh/libxev)[^xev].

[^xev]: <https://github.com/mitchellh/libxev>
[^zls]: <https://github.com/zigtools/zls>
[^capy]: <https://github.com/capy-ui/capy>
[^clap]: <https://github.com/Hejsil/zig-clap>
[^tiger]: <https://github.com/tigerbeetle/tigerbeetle>
[^ll2]: <https://github.com/cgbur/llama2.zig/tree/main>
[^mach]: <https://github.com/hexops/mach>
[^bunjs]: <https://github.com/oven-sh/bun>.

All these assets are available on GitHub,
and this is great, because we can use the GitHub search bar to our advantage,
to find Zig code that fits our description.
For example, you can always include `lang:Zig` in the GitHub search bar when you
are searching for a particular pattern. This will limit the search to only Zig modules.

[^zig-lib-std]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std>

Also, a great alternative is to consult online resources and documentation.
Here is a quick list of resources that I personally use from time to time to learn
more about the language each day:

- Zig Language Reference: <https://ziglang.org/documentation/master/>;
- Zig Standard Library Reference: <https://ziglang.org/documentation/master/std/>;
- Zig Guide: <https://zig.guide/>;
- Karl Seguin Blog: <https://www.openmymind.net/>;
- Zig News: <https://zig.news/>;
- Read the code written by one of the Zig core team members: <https://github.com/kubkon>;
- Some livecoding sessions are transmitted in the Zig Showtime Youtube Channel: <https://www.youtube.com/@ZigSHOWTIME/videos>;


Another great strategy to learn Zig, or honestly, to learn any language you want,
is to practice it by solving exercises. For example, there is a famous repository
in the Zig community called [Ziglings](https://ziglings.org)[^ziglings]
, which contains more than 100 small exercises that you can solve. It's a repository of
tiny programs written in Zig that are currently broken, and your responsibility is to
fix these programs, and make them work again.

[^ziglings]: <https://ziglings.org>.

A famous tech YouTuber known as *The Primeagen* also posted some videos (on YouTube)
where he solves these exercises from Ziglings. The first video is named
["Trying Zig Part 1"](https://www.youtube.com/watch?v=OPuztQfM3Fg&t=2524s&ab_channel=TheVimeagen)[^prime1].

[^prime1]: <https://www.youtube.com/watch?v=OPuztQfM3Fg&t=2524s&ab_channel=TheVimeagen>.

Another great alternative, is to solve the [Advent of Code exercises](https://adventofcode.com/)[^advent-code].
There are people that already took the time to learn and solve the exercises, and they posted
their solutions on GitHub as well, so, in case you need some resource to compare while solving
the exercises, you can look at these two repositories:

- <https://github.com/SpexGuy/Zig-AoC-Template>;
- <https://github.com/fjebaker/advent-of-code-2022>;

[^advent-code]: <https://adventofcode.com/>






## Creating new objects in Zig (i.e., identifiers) {#sec-assignments}

Let's talk more about objects in Zig. Readers that have past experience
with other programming languages might know this concept through
a different name, such as: "variable" or "identifier". In this book, I choose
to use the term "object" to refer to this concept.

To create a new object (or a new "identifier") in Zig, we use
the keywords `const` or `var`. These keywords specify if the object
that you are creating is mutable or not.
If you use `const`, then the object you are
creating is a constant (or immutable) object, which means that once you declare this object, you
can no longer change the value stored inside this object.

On the other side, if you use `var`, then, you are creating a variable (or mutable) object.
You can change the value of this object as many times you want. Using the
keyword `var` in Zig is similar to using the keywords `let mut` in Rust.

### Constant objects vs variable objects

In the code example below, we are creating a new constant object called `age`.
This object stores a number representing the age of someone. However, this code example
does not compile successfully. Because on the next line of code, we are trying to change the value
of the object `age` to 25.

The `zig` compiler detects that we are trying to change
the value of an object/identifier that is constant, and because of that,
the compiler will raise a compilation error, warning us about the mistake.

```{zig}
#| eval: false
const age = 24;
// The line below is not valid!
age = 25;
```

```
t.zig:10:5: error: cannot assign to constant
    age = 25;
      ~~^~~
```

So, if you want to change the value of your object, you need to transform your immutable (or "constant")
object into a mutable (or "variable") object. You can do that by using the `var` keyword.
This keyword stands for "variable", and when you apply this keyword to some object, you are
telling the Zig compiler that the value associated with this object might change at some point.

Thus, if we come back to the previous example, and change the declaration of the
`age` object to use the `var` keyword, then, the program gets compiled successfully.
Because now, the `zig` compiler detects that we are changing the value of an
object that allows this behaviour, because it's a "variable object".

However, if you take a look at the example below, you will notice that we have not only declared the
`age` object with the `var` keyword, but we also have explicitly annotated the data type
of the `age` object with the `u8` type this time. The basic idea is, when we use a variable/mutable object,
the Zig compiler ask for us to be more explicit with what we want, to be more clear
about what our code does. This translates into being more explicit about the data types that we want
to use in our objects.

Therefore, if you transform your object into a variable/mutable object, just remember to always
annotate the type of the object explicitly in your code. Otherwise, the Zig compiler might raise
a compilation error, asking you to transform your object back into a `const` object, or,
to give your object an "explicit type".


```{zig}
#| build_type: "run"
#| auto_main: true
var age: u8 = 24;
age = 25;
```


### Declaring without an initial value

By default, when you declare a new object in Zig, you must give it
an initial value. In other words, this means
that we have to declare, and, at the same time, initialize every object we
create in our source code.

On the other hand, you can, in fact, declare a new object in your source code,
and not give it an explicit value. But we need to use a special keyword for that,
which is the `undefined` keyword.

It's important to emphasize that, you should avoid using `undefined` as much as possible.
Because when you use this keyword, you leave your object uninitialized, and, as a consequence,
if for some reason, your code uses this object while it's uninitialized, then, you will definitely
have undefined behaviour and major bugs in your program.

In the example below, I'm declaring the `age` object again. But this time,
I do not give it an initial value. The variable is only initialized at
the second line of code, where I store the number 25 in this object.

```{zig}
#| auto_main: true
#| build_type: "run"
var age: u8 = undefined;
age = 25;
```

Having these points in mind, just remember that you should avoid as much as possible to use `undefined` in your code.
Always declare and initialize your objects. Because this gives you much more safety in your program.
But in case you really need to declare an object without initializing it... the
`undefined` keyword is the way to do it in Zig.


### There is no such thing as unused objects

Every object (being constant or variable) that you declare in Zig **must be used in some way**. You can give this object
to a function call, as a function argument, or, you can use it in another expression
to calculate the value of another object, or, you can call a method that belongs to this
particular object.

It doesn't matter in which way you use it. As long as you use it.
If you try to break this rule, i.e., if your try to declare a object, but not use it,
the `zig` compiler will not compile your Zig source code, and it will issue a error
message warning that you have unused objects in your code.

Let's demonstrate this with an example. In the source code below, we declare a constant object
called `age`. If you try to compile a simple Zig program with this line of code below,
the compiler will return an error as demonstrated below:

```{zig}
#| build_type: "ast"
#| auto_main: false
const age = 15;
```

```
t.zig:4:11: error: unused local constant
    const age = 15;
          ^~~
```

Everytime you declare a new object in Zig, you have two choices:

1. you either use the value of this object;
1. or you explicitly discard the value of the object;

To explicitly discard the value of any object (constant or variable), all you need to do is to assign
this object to a special character in Zig, which is the underscore (`_`).
When you assign an object to a underscore, like in the example below, the `zig` compiler will automatically
discard the value of this particular object.

You can see in the example below that, this time, the compiler did not
complain about any "unused constant", and successfully compiled our source code.

```{zig}
#| auto_main: true
#| build_type: "run"
// It compiles!
const age = 15;
_ = age;
```

Now, remember, everytime you assign a particular object to the underscore, this object
is essentially destroyed. It's discarded by the compiler. This means that you can no longer
use this object further in your code. It doesn't exist anymore.

So if you try to use the constant `age` in the example below, after we discarded it, you
will get a loud error message from the compiler (talking about a "pointless discard")
warning you about this mistake.

```{zig}
#| eval: false
// It does not compile.
const age = 15;
_ = age;
// Using a discarded value!
std.debug.print("{d}\n", .{age + 2});
```

```
t.zig:7:5: error: pointless discard
    of local constant
```


This same rule applies to variable objects. Every variable object must also be used in
some way. And if you assign a variable object to the underscore,
this object also gets discarded, and you can no longer use this object.



### You must mutate every variable objects

Every variable object that you create in your source code must be mutated at some point.
In other words, if you declare an object as a variable
object, with the keyword `var`, and you do not change the value of this object
at some point in the future, the `zig` compiler will detect this,
and it will raise an error warning you about this mistake.

The concept behind this is that every object you create in Zig should be preferably a
constant object, unless you really need an object whose value will
change during the execution of your program.

So, if I try to declare a variable object such as `where_i_live` below,
and I do not change the value of this object in some way,
the `zig` compiler raises an error message with the phrase "variable is never mutated".

```{zig}
#| eval: false
var where_i_live = "Belo Horizonte";
_ = where_i_live;
```

```
t.zig:7:5: error: local variable is never mutated
t.zig:7:5: note: consider using 'const'
```

## Primitive Data Types {#sec-primitive-data-types}

Zig has many different primitive data types available for you to use.
You can see the full list of available data types at the official
[Language Reference page](https://ziglang.org/documentation/master/#Primitive-Types)[^lang-data-types].

[^lang-data-types]: <https://ziglang.org/documentation/master/#Primitive-Types>.

But here is a quick list:

- Unsigned integers: `u8`, 8-bit integer; `u16`, 16-bit integer; `u32`, 32-bit integer; `u64`, 64-bit integer; `u128`, 128-bit integer.
- Signed integers: `i8`, 8-bit integer; `i16`, 16-bit integer; `i32`, 32-bit integer; `i64`, 64-bit integer; `i128`, 128-bit integer.
- Float number: `f16`, 16-bit floating point; `f32`, 32-bit floating point; `f64`, 64-bit floating point; `f128`, 128-bit floating point;
- Boolean: `bool`, represents true or false values.
- C ABI compatible types: `c_long`, `c_char`, `c_short`, `c_ushort`, `c_int`, `c_uint`, and many others.
- Pointer sized integers: `isize` and `usize`.







## Arrays {#sec-arrays}

You create arrays in Zig by using a syntax that resembles the C syntax.
First, you specify the size of the array (i.e., the number of elements that will be stored in the array)
you want to create inside a pair of brackets.

Then, you specify the data type of the elements that will be stored inside this array.
All elements present in an array in Zig must have the same data type. For example, you cannot mix elements
of type `f32` with elements of type `i32` in the same array.

After that, you simply list the values that you want to store in this array inside
a pair of curly braces.
In the example below, I am creating two constant objects that contain different arrays.
The first object contains an array of 4 integer values, while the second object,
an array of 3 floating point values.

Now, you should notice that in the object `ls`, I am
not explicitly specifying the size of the array inside of the brackets. Instead
of using a literal value (like the value 4 that I used in the `ns` object), I am
using the special character underscore (`_`). This syntax tells the `zig` compiler
to fill this field with the number of elements listed inside of the curly braces.
So, this syntax `[_]` is for lazy (or smart) programmers who leave the job of
counting how many elements there are in the curly braces for the compiler.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [4]u8{48, 24, 12, 6};
const ls = [_]f64{432.1, 87.2, 900.05};
_ = ns; _ = ls;
```

It's worth noting that these are static arrays, meaning that
they cannot grow in size.
Once you declare your array, you cannot change the size of it.
This is very common in low level languages.
Because low level languages normally wants to give you (the programmer) full control over memory,
and the way in which arrays are expanded is tightly related to
memory management.


### Selecting elements of the array {#sec-select-array-elem}

One very common activity is to select specific portions of an array
you have in your source code.
In Zig, you can select a specific element from your
array, by simply providing the index of this particular
element inside brackets after the object name.
In the example below, I am selecting the third element from the
`ns` array. Notice that Zig is a "zero-index" based language,
like C, C++, Rust, Python, and many other languages.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [4]u8{48, 24, 12, 6};
try stdout.print("{d}\n", .{ ns[2] });
try stdout.flush();
```

In contrast, you can also select specific slices (or sections) of your array, by using a
range selector. Some programmers also call these selectors of "slice selectors",
and they also exist in Rust, and have the exact same syntax as in Zig.
Anyway, a range selector is a special expression in Zig that defines
a range of indexes, and it has the syntax `start..end`.

In the example below, at the second line of code,
the `sl` object stores a slice (or a portion) of the
`ns` array. More precisely, the elements at index 1 and 2
in the `ns` array.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [4]u8{48, 24, 12, 6};
const sl = ns[1..3];
_ = sl;
```

When you use the `start..end` syntax,
the "end tail" of the range selector is non-inclusive,
meaning that, the index at the end is not included in the range that is
selected from the array.
Therefore, the syntax `start..end` actually means `start..end - 1` in practice.

You can for example, create a slice that goes from the first to the
last elements of the array, by using `ar[0..ar.len]` syntax
In other words, it's a slice that
accesses all elements in the array.

```{zig}
#| auto_main: true
#| build_type: "run"
const ar = [4]u8{48, 24, 12, 6};
const sl = ar[0..ar.len];
_ = sl;
```

You can also use the syntax `start..` in your range selector.
Which tells the `zig` compiler to select the portion of the array
that begins at the `start` index until the last element of the array.
In the example below, we are selecting the range from index 1
until the end of the array.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [4]u8{48, 24, 12, 6};
const sl = ns[1..];
_ = sl;
```


### More on slices

As we discussed before, in Zig, you can select specific portions of an existing
array. This is called *slicing* in Zig [@zigguide], because when you select a portion
of an array, you are creating a slice object from that array.

A slice object is essentially a pointer object accompanied by a length number.
The pointer object points to the first element in the slice, and the
length number tells the `zig` compiler how many elements there are in this slice.

> Slices can be thought of as a pair of `[*]T` (the pointer to the data) and a `usize` (the element count) [@zigguide].

Through the pointer contained inside the slice you can access the elements (or values)
that are inside this range (or portion) that you selected from the original array.
But the length number (which you can access through the `len` property of your slice object)
is the really big improvement (over C arrays for example) that Zig brings to the table here.

Because with this length number
the `zig` compiler can easily check if you are trying to access an index that is out of the bounds of this particular slice,
or, if you are causing any buffer overflow problems. In the example below,
we access the `len` property of the slice `sl`, which tells us that this slice
has 2 elements in it.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [4]u8{48, 24, 12, 6};
const sl = ns[1..3];
try stdout.print("{d}\n", .{sl.len});
try stdout.flush();
```


### Array operators

There are two array operators available in Zig that are very useful.
The array concatenation operator (`++`), and the array multiplication operator (`**`). As the name suggests,
these are array operators.

One important detail about these two operators is that they work
only when both operands have a size (or "length") that is compile-time known.
We are going to talk more about
the differences between "compile-time known" and "runtime known" in @sec-compile-time.
But for now, keep this information in mind, that you cannot use these operators in every situation.

In summary, the `++` operator creates a new array that is the concatenation,
of both arrays provided as operands. So, the expression `a ++ b` produces
a new array which contains all the elements from arrays `a` and `b`.

```{zig}
#| auto_main: true
#| build_type: "run"
const a = [_]u8{1,2,3};
const b = [_]u8{4,5};
const c = a ++ b;
try stdout.print("{any}\n", .{c});
try stdout.flush();
```

This `++` operator is particularly useful to concatenate strings together.
Strings in Zig are described in depth in @sec-zig-strings. In summary, a string object in Zig
is essentially an array of bytes. So, you can use this array concatenation operator
to effectively concatenate strings together.

In contrast, the `**` operator is used to replicate an array multiple
times. In other words, the expression `a ** 3` creates a new array
which contains the elements of the array `a` repeated 3 times.

```{zig}
#| auto_main: true
#| build_type: "run"
const a = [_]u8{1,2,3};
const c = a ** 2;
try stdout.print("{any}\n", .{c});
try stdout.flush();
```


### Runtime versus compile-time known length in slices

We are going to talk a lot about the differences between compile-time known
and runtime known across this book, especially in @sec-compile-time.
But the basic idea is that a thing is compile-time known, when we know
everything (the value, the attributes and the characteristics) about this thing at compile-time.
In contrast, a runtime known thing is when the exact value of a thing is calculated only at runtime.
Therefore, we don't know the value of this thing at compile-time, only at runtime.

We have learned in @sec-select-array-elem that slices are created by using a *range selector*,
which represents a range of indexes. When this "range of indexes" (i.e., both the start and the end of this range)
is known at compile-time, the slice object that gets created is actually, under the hood, just
a single-item pointer to an array.

You don't need to precisely understand what that means now. We are going to talk a lot about pointers
in @sec-pointer. For now, just understand that, when the range of indexes is known at compile-time,
the slice that gets created is just a pointer to an array, accompanied by a length value that
tells the size of the slice.

If you have a slice object like this, i.e., a slice that has a compile-time known range,
you can use common pointer operations over this slice object. For example, you can
dereference the pointer of this slice, by using the `.*` method, like you would
do on a normal pointer object.

```{zig}
#| auto_main: true
#| build_type: "run"
const arr1 = [10]u64 {
    1, 2, 3, 4, 5,
    6, 7, 8, 9, 10
};
// This slice has a compile-time known range.
// Because we know both the start and end of the range.
const slice = arr1[1..4];
_ = slice;
```


On the other hand, if the range of indexes is not known at compile time, then, the slice object
that gets created is not a pointer anymore, and, thus, it does not support pointer operations.
For example, maybe the start index is known at compile time, but the end index is not. In such
case, the range of the slice becomes runtime known only.

Reading a file is a type of operation that usually leads to lengths that are known only at
runtime. Because you usually don't know the size of the file upfront. Maybe today the file
is 4.5KB in size. But, maybe tomorrow, you add some more lines to the file and it's
size grows to 4.8KB. Since the file is something external (it is independent) to your source code
, you can easily change it without affecting your code.
As consequence, knowing the size of the file at compile time can be trick, or impossible.

Since we have `comptime` in Zig, there probably are some techniques that can be used
to calculate the size of a file at compile-time. But I think you got my point anyway, right?
Regardless of these techniques, programmers don't usually write their program just to calculate
the size of a file at compile-time.

If a programmer wants to read a file, he/she/they usually write a program that either:

1. reads a fixed amount of bytes from the file (which is the code example exposed below).
2. first, calculates the size of the file (usually this is done with position indicators), then, tries to allocate a buffer that can hold the amount of data in the file, then, reads the entire file into this allocated buffer.
3. reads the file as a continuous stream of bytes.

In either of these three cases, your program still cannot predict the exact size of the file
during compile-time. Even on the first case, in which we specify a fixed amount of bytes
that we want to read from the file.

The code snippet exposed below is an example of the first case. In this snippet, we always try
to read the first 1024 bytes of the file. Because we have specified this fixed amount of bytes (1024 bytes) in the source code, we do know the
length of the `file_buffer` object (it's 1024) at compile time. But, we don't know the length of the data that we
actually got from the file.

In other words, we don't know the value stored in the `nbytes` object, which represents
how many bytes of data we actually read from the file. The value of this object is known only at runtime, and,
therefore, we don't know (at compile-time) the size of the slice that get's printed to the screen in the `std.debug.print()` call.


```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");

fn read_file(path: []const u8, buffer: []u8, io: std.Io) !usize {
    const file = try std.Io.Dir.cwd().openFile(
        io, path, .{}
    );
    defer file.close(io);

    const nbytes = try file.readPositionalAll(
        io, buffer[0..], 0
    );
    return nbytes;
}

pub fn main(init: std.process.Init) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var file_buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(file_buffer);
    @memset(file_buffer[0..], 0);

    const path = "../ZigExamples/file-io/shop-list.txt";
    const nbytes = try read_file(
        path, file_buffer[0..], init.io
    );

    std.debug.print("{s}", .{file_buffer[0..nbytes]});
}
```


## Blocks and scopes {#sec-blocks}

Blocks are created in Zig by a pair of curly braces. A block is just a group of
expressions (or statements) contained inside of a pair of curly braces. All of these expressions that
are contained inside of this pair of curly braces belongs to the same scope.

In other words, a block just delimits a scope in your code.
The objects that you define inside the same block belongs to the same
scope, and, therefore, are accessible from within this scope.
At the same time, these objects are not accessible outside of this scope.
So, you could also say that blocks are used to limit the scope of the objects that you create in
your source code. In less technical terms, blocks are used to specify where in your source code
you can access whatever object you have in your source code.

So, a block is just a group of expressions contained inside a pair of curly braces.
And every block have its own scope separated from the others.
The body of a function is a classic example of a block. If statements, for and while loops
(and any other structure in the language that uses the pair of curly braces)
are also examples of blocks.

This means that, every if statement, or for loop,
etc., that you create in your source code has its own separate scope.
That is why you can't access the objects that you defined inside
of your for loop (or if statement) in an outer scope, i.e., a scope outside of the for loop.
Because you are trying to access an object that belongs to a scope that is different
than your current scope.


You can create blocks within blocks, with multiple levels of nesting.
You can also (if you want to) give a label to a particular block, with the colon character (`:`).
Just write `label:` before you open the pair of curly braces that delimits your block. When you label a block
in Zig, you can use the `break` keyword to return a value from this block, like as if it
was a function's body. You just write the `break` keyword, followed by the block label in the format `:label`,
and the expression that defines the value that you want to return.

Like in the example below, where we are returning the value from the `y` object
from the block `add_one`, and saving the result inside the `x` object.

```{zig}
#| auto_main: true
#| build_type: "run"
var y: i32 = 123;
const x = add_one: {
    y += 1;
    break :add_one y;
};
if (x == 124 and y == 124) {
    try stdout.print("Hey!", .{});
    try stdout.flush();
}
```





## How strings work in Zig? {#sec-zig-strings}

The first project that we are going to build and discuss in this book is a base64 encoder/decoder (@sec-base64).
But in order for us to build such a thing, we need to get a better understanding on how strings work in Zig.
So let's discuss this specific aspect of Zig.

Strings in Zig work very similarly to strings in C, but they come with some extra caveats which adds more safety
and efficiency to them. You could also say that Zig simply uses a more modern and safe approach to manage
and use strings.

A string in Zig is essentially an array of arbitrary bytes, or, more specifically, an array of `u8` values.
This very similar to a string in C, which is also interpreted as an array of arbitrary bytes, or, in the case
of C, an array of `char` (which usually represents an unsigned 8-bit integer value in most systems) values.

Now, because a string in Zig is an array, you automatically
get the length of the string (i.e. the length of the array) embedded in the value itself. This makes
all the difference! Because now, the Zig compiler can use the length value that is embedded in the string to
check for "buffer overflow" or "wrong memory access" problems in your code.


To achieve this same kind of safety in C, you have to do a lot of work that kind of seems pointless.
So getting this kind of safety is not automatic and much harder to do in C. For example, if you want
to track the length of your string throughout your program in C, then, you first need to loop through
the array of bytes that represents this string, and find the null element (`'\0'`) position to discover
where exactly the array ends, or, in other words, to find how much elements the array of bytes contain.

To do that, you would need to do something like this in C. In this example, the C string stored in
the object `array` is 25 bytes long:

```c
#include <stdio.h>
int main() {
    char* array = "An example of string in C";
    int index = 0;
    while (1) {
        if (array[index] == '\0') {
            break;
        }
        index++;
    }
    printf("Number of elements in the array: %d\n", index);
}
```

```
Number of elements in the array: 25
```


You don't have this kind of work in Zig. Because the length of the string is always
present and accessible in the string value itself. You can easily access the length of the string
through the `len` attribute. As an example, the `string_object` object below is 43 bytes long:


```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const string_object = "This is an example of string literal in Zig";
    try stdout.print("{d}\n", .{string_object.len});
    try stdout.flush();
}
```


Another point is that Zig always assumes that the sequence of bytes in your string is UTF-8 encoded. This might not be true for every
sequence of bytes you're working with, but it's not really Zig's job to fix the encoding of your strings
(you can use [`iconv`](https://www.gnu.org/software/libiconv/)[^libiconv] for that).
Today, most of the text in our modern world, especially on the web, should be UTF-8 encoded.
So if your string literal is not UTF-8 encoded, then, you will likely have problems in Zig.

[^libiconv]: <https://www.gnu.org/software/libiconv/>

Let's take for example the word "Hello". In UTF-8, this sequence of characters (H, e, l, l, o)
is represented by the sequence of decimal numbers 72, 101, 108, 108, 111. In hexadecimal, this
sequence is `0x48`, `0x65`, `0x6C`, `0x6C`, `0x6F`. So if I take this sequence of hexadecimal values,
and ask Zig to print this sequence of bytes as a sequence of characters (i.e., a string), then,
the text "Hello" will be printed into the terminal:

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const bytes = [_]u8{0x48, 0x65, 0x6C, 0x6C, 0x6F};
    try stdout.print("{s}\n", .{bytes});
    try stdout.flush();
}
```



### Using a slice versus a sentinel-terminated array {#sec-string-slice-versus-array}

In memory, all string values in Zig are always stored in the same way.
They are simply stored as sequences/arrays of arbitrary bytes in memory. However, there are two different ways
that this sequence/array of bytes is normally used and accessed inside Zig code, which are:

- a sentinel-terminated array of `u8` values.
- or as a slice of `u8` values.

Most of the times, you will normally access and use strings as slices of `u8` values.
Specially because most of the functions from the Zig Standard Library receive
strings as input as slices of `u8` values.


#### Sentinel-terminated arrays

Sentinel-terminated arrays in Zig are described in the Language Reference of Zig[^sentinel].
In summary a sentinel-terminated array is just a normal array, but, the key difference here is that they
contain a "sentinel value" at the last index/element of the array. With a sentinel-terminated array
you embed both the length of the array, and also, the sentinel value in the type itself of your object.

[^sentinel]: <https://ziglang.org/documentation/master/#Sentinel-Terminated-Arrays>.

For example, if you write a string literal value in your code, and ask Zig to print the data type of this value,
you usually get a data type in the format `*const [n:0]u8`. The `n` in the data type indicates the size of
the string (that is the length of the array). The zero after the `n:` part of the data type is the sentinel
value itself.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "run"
// This is a string literal value:
_ = "A literal value";
try stdout.print("{any}\n", .{@TypeOf("A literal value")});
try stdout.flush();
```


So, with this data type `*const [n:0]u8` you are essentially saying that you have an array of `u8` values
of length `n`, where, the element at the index corresponding to the length `n` in the array is the
number zero. If you really think about this description, you will notice that this is just a fancy way to
describe a string in C, which is a null-terminated array of bytes. The `NULL` value in C is the number
zero. So, an array that ends in a null/zero value in C is essentially a sentinel-terminated array in Zig,
where the sentinel value of the array is the number zero.

Therefore, a sentinel-terminated array in Zig is just a type that embeds both the length and also the sentinel-value
of the array inside the object type itself. So, in the case of a string literal value in Zig, it is just a pointer to a null-terminated array of bytes (i.e., similar to a C string).
But in Zig, a string literal value also embeds the length of the string, and also, the fact that they are "NULL terminated",
into the data type of the value itself.



#### Slice

You can also access and use the arbitrary sequence of bytes that represent your string as a slice of `u8` values.
The majority of functions from the Zig standard library usually receive strings as inputs as slices of
`u8` values (slices were presented in @sec-arrays).

Thus, you will see a lot of string values with a data type of `[]u8` or `[]const u8`, depending if the object
where this string is stored is marked as constant with `const`, or as variable with `var`. Now, because
the string in this case is being interpreted as a slice, this slice is not necessarilly null-terminated,
because now, the sentinel value is not mandatory. You can include the null/zero value in the slice if you
want to, but there is no need to do it.

```{zig}
#| eval: true
#| build_type: "run"
#| auto_main: true
// This is a string value being
// interpreted as a slice.
const str: []const u8 = "A string value";
try stdout.print("{any}\n", .{@TypeOf(str)});
try stdout.flush();
```



### Iterating through the string

If you want to see the actual bytes that represents a string in Zig, you can use
a `for` loop to iterate through each byte in the string, and ask Zig to print each byte as a hexadecimal
value to the terminal. You do that by using a `print()` statement with the `X` formatting specifier,
like you would normally do with the [`printf()` function](https://cplusplus.com/reference/cstdio/printf/)[^printfs] in C.

[^printfs]: <https://cplusplus.com/reference/cstdio/printf/>

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const string_object = "This is an example";
    try stdout.print("Bytes that represents the string object: ", .{});
    for (string_object) |byte| {
        try stdout.print("{X} ", .{byte});
    }
    try stdout.print("\n", .{});
    try stdout.flush();
}
```



### A better look at the object type

Now, we can inspect better the type of objects that Zig create. To check the type of any object in Zig, you can use the
`@TypeOf()` function. If we look at the type of the `simple_array` object below, you will find that this object
is an array of 4 elements. Each element is a signed integer of 32 bits which corresponds to the data type `i32` in Zig.
That is what an object of type `[4]i32` is.

But if we look closely at the type of the string literal value exposed below, you will find that this object is a
constant pointer (hence the `*const` annotation) to an array of 16 elements (or 16 bytes). Each element is a
single byte (more precisely, an unsigned 8 bit integer - `u8`), that is why we have the `[16:0]u8` portion of the type below,
and also, you can see that this is a null-terminated array, because of the zero value after the `:` character in the data type.
In other words, the string literal value exposed below is 16 bytes long.

Now, if we create a pointer to the `simple_array` object, then, we get a constant pointer to an array of 4 elements (`*const [4]i32`),
which is very similar to the type of the string literal value. This demonstrates that a string literal value
in Zig is already a pointer to a null-terminated array of bytes.

Furthermore, if we take a look at the type of the `string_obj` object, you will see that it's a
slice object (hence the `[]` portion of the type) to a sequence of constant `u8` values (hence
the `const u8` portion of the type).


```{zig}
#| build_type: "run"
#| auto_main: false
#| eval: true
#| results: "hide"
const std = @import("std");
pub fn main() !void {
    const simple_array = [_]i32{1, 2, 3, 4};
    const string_obj: []const u8 = "A string object";
    std.debug.print(
        "Type 1: {}\n", .{@TypeOf(simple_array)}
    );
    std.debug.print(
        "Type 2: {}\n", .{@TypeOf("A string literal")}
    );
    std.debug.print(
        "Type 3: {}\n", .{@TypeOf(&simple_array)}
    );
    std.debug.print(
        "Type 4: {}\n", .{@TypeOf(string_obj)}
    );
}
```

```
Type 1: [4]i32
Type 2: *const [16:0]u8
Type 3: *const [4]i32
Type 4: []const u8
```



### Byte vs unicode points

It's important to point out that each byte in the array is not necessarily a single character.
This fact arises from the difference between a single byte and a single unicode point.

The encoding UTF-8 works by assigning a number (which is called a unicode point) to each character in
the string. For example, the character "H" is stored in UTF-8 as the decimal number 72. This means that
the number 72 is the unicode point for the character "H". Each possible character that can appear in a
UTF-8 encoded string have its own unicode point.

For example, the Latin Capital Letter A With Stroke (Ⱥ) is represented by the number (or the unicode point)
570. However, this decimal number (570) is higher than the maximum number stored inside a single byte, which
is 255. In other words, the maximum decimal number that can be represented with a single byte is 255. That is why,
the unicode point 570 is actually stored inside the computer’s memory as the bytes `C8 BA`.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const string_object = "Ⱥ";
    _ = try stdout.write(
        "Bytes that represents the string object: "
    );
    for (string_object) |char| {
        try stdout.print("{X} ", .{char});
    }
    try stdout.flush();
}
```


This means that to store the character Ⱥ in a UTF-8 encoded string, we need to use two bytes together
to represent the number 570. That is why the relationship between bytes and unicode points is not always
1 to 1. Each unicode point is a single character in the string, but not always a single byte corresponds
to a single unicode point.

All of this means that if you loop through the elements of a string in Zig, you will be looping through the
bytes that represents that string, and not through the characters of that string. In the Ⱥ example above,
the for loop needed two iterations (instead of a single iteration) to print the two bytes that represents this Ⱥ letter.

Now, all english letters (or ASCII letters if you prefer) can be represented by a single byte in UTF-8. As a
consequence, if your UTF-8 string contains only english letters (or ASCII letters), then, you are lucky. Because
the number of bytes will be equal to the number of characters in that string. In other words, in this specific
situation, the relationship between bytes and unicode points is 1 to 1.

But on the other side, if your string contains other types of letters… for example, you might be working with
text data that contains, chinese, japanese or latin letters, then, the number of bytes necessary to represent
your UTF-8 string will likely be much higher than the number of characters in that string.

If you need to iterate through the characters of a string, instead of its bytes, then, you can use the
`std.unicode.Utf8View` struct to create an iterator that iterates through the unicode points of your string.

In the example below, we loop through the japanese characters “アメリカ”. Each of the four characters in
this string is represented by three bytes. But the for loop iterates four times, one iteration for each
character/unicode point in this string:

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var utf8 = try std.unicode.Utf8View.init("アメリカ");
    var iterator = utf8.iterator();
    while (iterator.nextCodepointSlice()) |codepoint| {
        try stdout.print(
            "got codepoint {x}\n",
            .{codepoint},
        );
    }

    try stdout.flush();
}

```

```
got codepoint e382a2
got codepoint e383a1
got codepoint e383aa
got codepoint e382ab
```


### Some useful functions for strings {#sec-strings-useful-funs}

In this section, I just want to quickly describe some functions from the Zig Standard Library
that are very useful to use when working with strings. Most notably:

- `std.mem.eql()`: to compare if two strings are equal.
- `std.mem.splitScalar()`: to split a string into an array of substrings given a delimiter value.
- `std.mem.splitSequence()`: to split a string into an array of substrings given a substring delimiter.
- `std.mem.startsWith()`: to check if string starts with substring.
- `std.mem.endsWith()`: to check if string ends with substring.
- `std.mem.trim()`: to remove specific values from both start and end of the string.
- `std.mem.concat()`: to concatenate strings together.
- `std.mem.count()`: to count the occurrences of substring in the string.
- `std.mem.replace()`: to replace the occurrences of substring in the string.

Notice that all of these functions come from the `mem` module of
the Zig Standard Library. This module contains multiple functions and methods
that are useful to work with memory and sequences of bytes in general.

The `eql()` function is used to check if two slices of data are equal or not.
Since strings are just arbitrary arrays of bytes, we can use this function to compare two strings together.
This function returns a boolean value indicating if the two strings are equal
or not. The first argument of this function is the data type of the elements of the slices
that are being compared.

```{zig}
#| auto_main: true
#| build_type: "run"
const name: []const u8 = "Pedro";
try stdout.print(
    "{any}\n", .{std.mem.eql(u8, name, "Pedro")}
);
try stdout.flush();
```

The `splitScalar()` and `splitSequence()` functions are useful to split
a string into multiple fragments, like the `split()` method from Python strings. The difference between these two
methods is that the `splitScalar()` uses a single character as the separator to
split the string, while `splitSequence()` uses a sequence of characters (a.k.a. a substring)
as the separator. There is a practical example of these functions later in the book.

The `startsWith()` and `endsWith()` functions are pretty straightforward. They
return a boolean value indicating if the string (or, more precisely, if the slice of data)
begins (`startsWith`) or ends (`endsWith`) with the sequence provided.

```{zig}
#| auto_main: true
#| build_type: "run"
const name: []const u8 = "Pedro";
try stdout.print(
    "{any}\n", .{std.mem.startsWith(u8, name, "Pe")}
);
try stdout.flush();
```

The `concat()` function, as the name suggests, concatenate two or more strings together.
Because the process of concatenating the strings involves allocating enough space to
accomodate all the strings together, this `concat()` function receives an allocator
object as input.

```{zig}
#| eval: false
#| auto_main: true
#| build_type: "ast"
const str1 = "Hello";
const str2 = " you!";
const str3 = try std.mem.concat(
    allocator, u8, &[_][]const u8{ str1, str2 }
);
try stdout.print("{s}\n", .{str3});
try stdout.flush();
```


As you can imagine, the `replace()` function is used to replace substrings in a string by another substring.
This function works very similarly to the `replace()` method from Python strings. Therefore, you
provide a substring to search, and every time that the `replace()` function finds
this substring within the input string, it replaces this substring with the "replacement substring"
that you provided as input.

In the example below, we are taking the input string "Hello", and replacing all occurrences
of the substring "el" inside this input string with "34", and saving the results inside the
`buffer` object. As result, the `replace()` function returns an `usize` value that
indicates how many replacements were performed.


```{zig}
#| auto_main: true
#| build_type: "lib"
const str1 = "Hello";
var buffer: [5]u8 = undefined;
const nrep = std.mem.replace(
    u8, str1, "el", "34", buffer[0..]
);
try stdout.print("New string: {s}\n", .{buffer});
try stdout.print("N of replacements: {d}\n", .{nrep});
try stdout.flush();
```

```
New string: H34lo
N of replacements: 1
```






## Safety in Zig

A general trend in modern low-level programming languages is safety. As our modern world
becomes more interconnected with technology and computers,
the data produced by all of this technology becomes one of the most important
(and also, one of the most dangerous) assets that we have.

This is probably the main reason why modern low-level programming languages
have been giving great attention to safety, especially memory safety, because
memory corruption is still the main target for hackers to exploit.
The reality is that we don't have an easy solution for this problem.
For now, we only have techniques and strategies that mitigates these
problems.

As Richard Feldman explains on his [most recent GOTO conference talk](https://www.youtube.com/watch?v=jIZpKpLCOiU&ab_channel=GOTOConferences)[^gotop]
, we haven't figured it out yet a way to achieve **true safety in technology**.
In other words, we haven't found a way to build software that won't be exploited
with 100% certainty. We can greatly reduce the risks of our software being
exploited, by ensuring memory safety for example. But this is not enough
to achieve "true safety" territory.

Because even if you write your program in a "safe language", hackers can still
exploit failures in the operating system where your program is running (e.g. maybe the
system where your code is running has a "backdoor exploit" that can still
affect your code in unexpected ways), or also, they can exploit the features
from the architecture of your computer. A recently found exploit
that involves memory invalidation through a feature of "memory tags"
present in ARM chips is an example of that [@exploit1].

[^gotop]: <https://www.youtube.com/watch?v=jIZpKpLCOiU&ab_channel=GOTOConferences>

The question is: what have Zig and other languages been doing to mitigate this problem?
If we take Rust as an example, Rust is, for the most part[^rust-safe], a memory safe
language by enforcing specific rules to the developer. In other words, the key feature
of Rust, the *borrow checker*, forces you to follow a specific logic when you are writing
your Rust code, and the Rust compiler will always complain everytime you try to go out of this
pattern.

[^rust-safe]: Actually, a lot of existing Rust code is still memory unsafe, because they communicate with external libraries through FFI (*foreign function interface*), which disables the borrow-checker features through the `unsafe` keyword.


In contrast, the Zig language is not a memory safe language by default.
There are some memory safety features that you get for free in Zig,
especially in arrays, slices and pointer objects. But there are other tools
offered by the language, that are not used by default.
In other words, the `zig` compiler does not obligate you to use such tools.

The tools listed below are related to memory safety. That is, they help you to achieve
memory safety in your Zig code:

- `defer` allows you to keep free operations physically close to allocations. This helps you to avoid memory leaks, "use after free", and also "double-free" problems. Furthermore, it also keeps free operations logically tied to the end of the current scope, which greatly reduces the mental overhead about object lifetime.
- `errdefer` helps you to guarantee that your program frees the allocated memory, even if a runtime error occurs.
- pointers and objects are non-nullable by default. This helps you to avoid memory problems that might arise from de-referencing null pointers.
- Zig offers some native types of allocators (called "testing allocators") that can detect memory leaks and double-frees. These types of allocators are widely used on unit tests, so they transform your unit tests into a weapon that you can use to detect memory problems in your code.
- arrays and slices in Zig have their lengths embedded in the object itself, which makes the `zig` compiler very effective on detecting "index out-of-range" type of errors, and avoiding buffer overflows.


Despite these features that Zig offers that are related to memory safety issues, the language
also has some rules that help you to achieve another type of safety, which is more related to
program logic safety. These rules are:

- pointers and objects are non-nullable by default. Which eliminates an edge case that might break the logic of your program.
- switch statements must exaust all possible options.
- the `zig` compiler forces you to handle every possible error in your program.


## Other parts of Zig

We already learned a lot about Zig's syntax, and also, some pretty technical
details about it. Just as a quick recap:

- We talked about how functions are written in Zig in @sec-root-file and @sec-main-file.
- How to create new objects/identifiers in @sec-root-file and especially in @sec-assignments.
- How strings work in Zig in @sec-zig-strings.
- How to use arrays and slices in @sec-arrays.
- How to import functionality from other Zig modules in @sec-root-file.


But, for now, this amount of knowledge is enough for us to continue with this book.
Later, over the next chapters we will still talk more about other parts of
Zig's syntax that are also equally important. Such as:


- How Object-Oriented programming can be done in Zig through *struct declarations* in @sec-structs-and-oop.
- Basic control flow syntax in @sec-zig-control-flow.
- Enums in @sec-enum;
- Pointers and Optionals in @sec-pointer;
- Error handling with `try` and `catch` in @sec-error-handling;
- Unit tests in @sec-unittests;
- Vectors in @sec-vectors-simd;
- Build System in @sec-build-system;
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Control flow, structs, modules and types

We have discussed a lot of Zig's syntax in the last chapter,
especially in @sec-root-file and @sec-main-file.
But we still need to discuss some other very important
elements of the language. Elements that you will use constantly on your day-to-day
routine.

We begin this chapter by discussing the different keywords and structures
in Zig related to control flow (e.g. loops and if statements).
Then, we talk about structs and how they can be used to do some
basic Object-Oriented (OOP) patterns in Zig. We also talk about
type inference and type casting.
Finally, we end this chapter by discussing modules, and how they relate
to structs.



## Control flow {#sec-zig-control-flow}

Sometimes, you need to make decisions in your program. Maybe you need to decide
whether or not to execute a specific piece of code. Or maybe,
you need to apply the same operation over a sequence of values. These kinds of tasks,
involve using structures that are capable of changing the "control flow" of our program.

In computer science, the term "control flow" usually refers to the order in which expressions (or commands)
are evaluated in a given language or program. But this term is also used to refer
to structures that are capable of changing this "evaluation order" of the commands
executed by a given language/program.

These structures are better known
by a set of terms, such as: loops, if/else statements, switch statements, among others. So,
loops and if/else statements are examples of structures that can change the "control
flow" of our program. The keywords `continue` and `break` are also examples of symbols
that can change the order of evaluation, since they can move our program to the next iteration
of a loop, or make the loop stop completely.


### If/else statements

An if/else statement performs a "conditional flow operation".
A conditional flow control (or choice control) allows you to execute
or ignore a certain block of commands based on a logical condition.
Many programmers and computer science professionals also use
the term "branching" in this case.
In essence, an if/else statement allow us to use the result of a logical test
to decide whether or not to execute a given block of commands.

In Zig, we write if/else statements by using the keywords `if` and `else`.
We start with the `if` keyword followed by a logical test inside a pair
of parentheses, followed by a pair of curly braces which contains the lines
of code to be executed in case the logical test returns the value `true`.

After that, you can optionally add an `else` statement. To do that, just add the `else`
keyword followed by a pair of curly braces, with the lines of code
to executed in case the logical test defined at `if` returns `false`.

In the example below, we are testing if the object `x` contains a number
that is greater than 10. Judging by the output printed to the console,
we know that this logical test returned `false`. Because the output
in the console is compatible with the line of code present in the
`else` branch of the if/else statement.


```{zig}
#| auto_main: true
#| build_type: "run"
const x = 5;
if (x > 10) {
    try stdout.print("x > 10!\n", .{});
} else {
    try stdout.print("x <= 10!\n", .{});
}
try stdout.flush();
```



### Switch statements {#sec-switch}

Switch statements are also available in Zig, and they have a very similar syntax to a switch statement in Rust.
As you would expect, to write a switch statement in Zig we use the `switch` keyword.
We provide the value that we want to "switch over" inside a
pair of parentheses. Then, we list the possible combinations (or "branches")
inside a pair of curly braces.

Let's take a look at the code example below. You can see that
I'm creating an enum type called `Role`. We talk more about enums in @sec-enum.
But in summary, this `Role` type is listing different types of roles in a fictitious
company, like `SE` for Software Engineer, `DE` for Data Engineer, `PM` for Product Manager,
etc.

Notice that we are using the value from the `role` object in the
switch statement, to discover which exact area we need to store in the `area` variable object.
Also notice that we are using type inference inside the switch statement, with the dot character,
as we are going to describe in @sec-type-inference.
This makes the `zig` compiler infer the correct data type of the values (`PM`, `SE`, etc.) for us.

Also notice that, we are grouping multiple values in the same branch of the switch statement.
We just separate each possible value with a comma. For example, if `role` contains either `DE` or `DA`,
the `area` variable would contain the value `"Data & Analytics"`, instead of `"Platform"` or `"Sales"`.

```{zig}
#| build_type: "run"
#| auto_main: false
const std = @import("std");
const Role = enum {
    SE, DPE, DE, DA, PM, PO, KS
};

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var area: []const u8 = undefined;
    const role = Role.SE;
    switch (role) {
        .PM, .SE, .DPE, .PO => {
            area = "Platform";
        },
        .DE, .DA => {
            area = "Data & Analytics";
        },
        .KS => {
            area = "Sales";
        },
    }
    try stdout.print("{s}\n", .{area});
    try stdout.flush();
}
```


#### Switch statements must exhaust all possibilities

One very important aspect about switch statements in Zig
is that they must exhaust all existing possibilities.
In other words, all possible values that could be found inside the `role`
object must be explicitly handled in this switch statement.

Since the `role` object has type `Role`, the only possible values to
be found inside this object are `PM`, `SE`, `DPE`, `PO`, `DE`, `DA` and `KS`.
There are no other possible values to be stored in this `role` object.
Thus, the switch statements must have a combination (branch) for each one of these values.
This is what "exhaust all existing possibilities" means. The switch statement covers
every possible case.

Therefore, you cannot write a switch statement in Zig, and leave an edge case
with no explicit action to be taken.
This is a similar behaviour to switch statements in Rust, which also have to
handle all possible cases.



#### The else branch

Take a look at the `dump_hex_fallible()` function below as an example. This function
comes from the Zig Standard Library. More precisely, from the
[`debug.zig` module](https://codeberg.org/ziglang/zig/src/branch/master/lib/std/debug.zig)[^debug-mod].
There are multiple lines in this function, but I omitted them to focus solely on the
switch statement found in this function. Notice that this switch statement has four
possible cases (i.e., four explicit branches). Also, notice that we used an `else` branch
in this case.

An `else` branch in a switch statement works as the "default branch".
Whenever you have multiple cases in your switch statement where
you want to apply the exact same action, you can use an `else` branch to do that.

[^debug-mod]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std/debug.zig>

```{zig}
#| eval: false
pub fn dump_hex_fallible(bytes: []const u8) !void {
    // Many lines ...
    switch (byte) {
        '\n' => try writer.writeAll("␊"),
        '\r' => try writer.writeAll("␍"),
        '\t' => try writer.writeAll("␉"),
        else => try writer.writeByte('.'),
    }
}
```

Many programmers would also use an `else` branch to handle a "not supported" case.
That is, a case that cannot be properly handled by your code, or, just a case that
should not be "fixed". Therefore, you can use an `else` branch to panic (or raise an error)
in your program to stop the current execution.

Take the code example below. We can see that, we are handling the cases
for the `level` object being either 1, 2, or 3. All other possible cases are not supported by default,
and, as consequence, we raise a runtime error in such cases through the `@panic()` built-in function.

Also notice that, we are assigning the result of the switch statement to a new object called `category`.
This is another thing that you can do with switch statements in Zig. If a branch
outputs a value as result, you can store the result value of the switch statement into
a new object.

```{zig}
#| auto_main: true
#| build_type: "lib"
const level: u8 = 4;
const category = switch (level) {
    1, 2 => "beginner",
    3 => "professional",
    else => {
        @panic("Not supported level!");
    },
};
try stdout.print("{s}\n", .{category});
try stdout.flush();
```

```
thread 13103 panic: Not supported level!
t.zig:9:13: 0x1033c58 in main (switch2)
            @panic("Not supported level!");
            ^
```



#### Using ranges in switch

Furthermore, you can also use ranges of values in switch statements.
That is, you can create a branch in your switch statement that is used
whenever the input value is within the specified range. These "range expressions"
are created with the operator `...`. It's important
to emphasize that the ranges created by this operator are
inclusive on both ends.

For example, I could easily change the previous code example to support all
levels between 0 and 100. Like this:

```{zig}
#| build_type: "run"
#| auto_main: true
const level: u8 = 4;
const category = switch (level) {
    0...25 => "beginner",
    26...75 => "intermediary",
    76...100 => "professional",
    else => {
        @panic("Not supported level!");
    },
};
try stdout.print("{s}\n", .{category});
try stdout.flush();
```

This is neat, and it works with character ranges too. That is, I could
simply write `'a'...'z'`, to match any character value that is a
lowercase letter, and it would work fine.


#### Labeled switch statements

In @sec-blocks we have talked about labeling blocks, and also, about using these labels
to return a value from the block. Well, from version 0.14.0 and onwards of the `zig` compiler,
you can also apply labels over switch statements, which makes it possible to almost implement a
"C `goto`" like pattern.

For example, if you give the label `xsw` to a switch statement, you can use this
label in conjunction with the `continue` keyword to go back to the beginning of the switch
statement. In the example below, the execution goes back to the beginning of the
switch statement two times, before ending at the `3` branch.

```{zig}
#| auto_main: true
#| build_type: "lib"
xsw: switch (@as(u8, 1)) {
    1 => {
        try stdout.print("First branch\n", .{});
        continue :xsw 2;
    },
    2 => continue :xsw 3,
    3 => return,
    4 => {},
    else => {
        try stdout.print(
            "Unmatched case, value: {d}\n", .{@as(u8, 1)}
        );
        try stdout.flush();
    },
}
```


### The `defer` keyword {#sec-defer}

Zig has a `defer` keyword, which plays a very important role in control flow, and also, in releasing resources.
In summary, the `defer` keyword allows you to register an expression to be executed when you exit the current scope.

At this point, you might attempt to compare the Zig `defer` keyword to it's sibling in the Go language
(i.e. [Go also has a `defer` keyword](https://go.dev/tour/flowcontrol/12)).
However, the Go `defer` keyword behaves slightly different
than it's sibling in Zig. More specifically, the `defer` keyword in Go always move an expression to be
executed at the **exit of the current function**.

If you think deeply about this statement, you will notice that the "exit of the current function" is something
slightly different than the "exit of the current scope". So, just be careful when comparing the two
keywords together. A single function in Zig might contain many different scopes inside of it, and, therefore,
the `defer` input expression might be executed at different places of the function, depending on which scope you
are currently in.

As a first example, consider the code exposed below. When the `main()` function get's executed, the expression
that prints the message "Exiting function ..." is getting executed only when the function exits
its scope.


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main() !void {
    defer std.debug.print(
        "Exiting function ...\n", .{}
    );
    std.debug.print("Adding some numbers ...\n", .{});
    const x = 2 + 2; _ = x;
    std.debug.print("Multiplying ...\n", .{});
    const y = 2 * 8; _ = y;
}
```

```
Adding some numbers ...
Multiplying ...
Exiting function ...
```

Therefore, we can use `defer` to declare an expression that is going to be executed
when your code exits the current scope. Some programmers like to interpret the phrase "exit of the current scope"
as "the end of the current scope". But this interpretation might not be entirely correct, depending
on what you consider as "the end of the current scope".

I mean, what do you consider as **the end** of the current scope? Is it the closing curly bracket (`}`) of the scope?
Is it when the last expression in the function gets executed? Is it when the function returns to the previous scope?
Etc. For example, it would not be correct to interpret the "exit of the current scope" as the closing
curly bracket of the scope. Because the function might exit from an earlier position than this
closing curly bracket (e.g. an error value was generated at a previous line inside the function;
the function reached an earlier return statement; etc.). Anyway, just be careful with this interpretation.

Now, if you remember of what we have discussed in @sec-blocks, there are multiple structures in the language
that create their own separate scopes. For/while loops, if/else statements,
functions, normal blocks, etc. This also affects the interpretation of `defer`.
For example, if you use `defer` inside a for loop, then, the given expression
will be executed everytime this specific for loop exits its own scope.

Before we continue, it's worth emphasizing that the `defer` keyword is an "unconditional defer".
Which means that the given expression will be executed no matter how the code exits
the current scope. For example, your code might exit the current scope because of an error value
being generated, or, because of a return statement, or, a break statement, etc.



### The `errdefer` keyword {#sec-errdefer1}

On the previous section, we have discussed the `defer` keyword, which you can use to
register an expression to be executed at the exit of the current scope.
But this keyword has a brother, which is the `errdefer` keyword. While `defer`
is an "unconditional defer", the `errdefer` keyword is a "conditional defer".
Which means that the given expression is executed only when you exit the current
scope on a very specific circumstance.

In more details, the expression given to `errdefer` is executed only when an error occurs in the current scope.
Therefore, if the function (or for/while loop, if/else statement, etc.) exits the current scope
in a normal situation, without errors, the expression given to `errdefer` is not executed.

This makes the `errdefer` keyword one of the many tools available in Zig for error handling.
In this section, we are more concerned with the control flow aspects around `errdefer`.
But we are going to discuss `errdefer` later as a error handling tool in @sec-errdefer2.

The code example below demonstrates three things:

- that `defer` is an "unconditional defer", because the given expression gets executed regardless of how the function `foo()` exits its own scope.
- that `errdefer` is executed because the function `foo()` returned an error value.
- that `defer` and `errdefer` expressions are executed in a LIFO (*last in, first out*) order.

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn foo() !void { return error.FooError; }
pub fn main() !void {
    var i: usize = 1;
    errdefer std.debug.print("Value of i: {d}\n", .{i});
    defer i = 2;
    try foo();
}
```

```
Value of i: 2
error: FooError
/t.zig:6:5: 0x1037e48 in foo (defer)
    return error.FooError;
    ^
```


When I say that "defer expressions" are executed in a LIFO (last in, first out) order, what that means is that
the last `defer` or `errdefer` expression in the code is first one to be executed.
You could also interpret this as: "defer expressions" are executed from bottom to top, or,
from last to first.

Therefore, if I change the order of the `defer` and `errdefer` expressions, you will notice that
the value of `i` that gets printed to the console changes to 1. This doesn't mean that the
`defer` expression was not executed in this case. This actually means that the `defer` expression
was executed only after the `errdefer` expression. The code example below demonstrates this:

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn foo() !void { return error.FooError; }
pub fn main() !void {
    var i: usize = 1;
    defer i = 2;
    errdefer std.debug.print("Value of i: {d}\n", .{i});
    try foo();
}
```

```
Value of i: 1
error: FooError
/t.zig:6:5: 0x1037e48 in foo (defer)
    return error.FooError;
    ^
```




### For loops

A loop allows you to execute the same lines of code multiple times,
thus, creating a "repetition space" in the execution flow of your program.
Loops are particularly useful when we want to replicate the same function
(or the same set of commands) over different inputs.

There are different types of loops available in Zig. But the most
essential of them all is probably the *for loop*. A for loop is
used to apply the same piece of code over the elements of a slice, or, an array.

For loops in Zig use a syntax that may be unfamiliar to programmers coming from
other languages. You start with the `for` keyword, then, you
list the items that you want to iterate
over inside a pair of parentheses. Then, inside of a pair of pipes (`|`)
you should declare an identifier that will serve as your iterator, or,
the "repetition index of the loop".

```{zig}
#| eval: false
for (items) |value| {
    // code to execute
}
```

Therefore, instead of using a `(value in items)` syntax,
in Zig, for loops use the syntax `(items) |value|`. In the example
below, you can see that we are looping through the items
of the array stored at the object `name`, and printing to the
console the decimal representation of each character in this array.

If we wanted, we could also iterate through a slice (or a portion) of
the array, instead of iterating through the entire array stored in the `name` object.
Just use a range selector to select the section you want. For example,
I could provide the expression `name[0..3]` to the for loop, to iterate
just through the first 3 elements in the array.

```{zig}
#| auto_main: true
#| build_type: "run"
const name = [_]u8{'P','e','d','r','o'};
for (name) |char| {
    try stdout.print("{d} | ", .{char});
}
try stdout.flush();
```

In the above example we are using the value itself of each
element in the array as our iterator. But there are many situations where
we need to use an index instead of the actual values of the items.

You can do that by providing a second set of items to iterate over.
More precisely, you provide the range selector `0..` to the for loop. So,
yes, you can use two different iterators at the same time in a for
loop in Zig.

But remember from @sec-assignments that, every object
you create in Zig must be used in some way. So if you declare two iterators
in your for loop, you must use both iterators inside the for loop body.
But if you want to use just the index iterator, and not use the "value iterator",
then, you can discard the value iterator by maching the
value items to the underscore character, like in the example below:


```{zig}
#| auto_main: true
#| build_type: "ast"
const name = "Pedro";
for (name, 0..) |_, i| {
    try stdout.print("{d} | ", .{i});
}
try stdout.flush();
```

```
0 | 1 | 2 | 3 | 4 |
```


### While loops

A while loop is created from the `while` keyword. A `for` loop
iterates through the items of an array, but a `while` loop
will loop continuously, and infinitely, until a logical test
(specified by you) becomes false.

You start with the `while` keyword, then, you define a logical
expression inside a pair of parentheses, and the body of the
loop is provided inside a pair of curly braces, like in the example below:

```{zig}
#| auto_main: true
#| build_type: "run"
var i: u8 = 1;
while (i < 5) {
    try stdout.print("{d} | ", .{i});
    i += 1;
}
try stdout.flush();
```

You can also specify the increment expression to be used at the beginning of a while loop.
To do that, we write the increment expression inside a pair of parentheses after a colon character (`:`).
The code example below demonstrates this other pattern.

```{zig}
#| auto_main: true
#| build_type: "run"
var i: u8 = 1;
while (i < 5) : (i += 1) {
    try stdout.print("{d} | ", .{i});
}
try stdout.flush();
```

### Using `break` and `continue`

In Zig, you can explicitly stop the execution of a loop, or, jump to the next iteration of the loop, by using
the keywords `break` and `continue`, respectively. The `while` loop presented in the next code example is,
at first sight, an infinite loop. Because the logical value inside the parenthese will always be equal to `true`.
But what makes this `while` loop stop when the `i` object reaches the count
10? It's the `break` keyword!

Inside the while loop, we have an if statement that is constantly checking if the `i` variable
is equal to 10. Since we are incrementing the value of `i` at each iteration of the
while loop, this `i` object will eventually be equal to 10, and when it is, the if statement
will execute the `break` expression, and, as a result, the execution of the while loop is stopped.

Notice the use of the `expect()` function from the Zig Standard Library after the while loop.
This `expect()` function is an "assert" type of function.
This function checks if the logical test provided is equal to true. If so, the function do nothing.
Otherwise (i.e., the logical test is equal to false), the function raises an assertion error.

```{zig}
#| auto_main: true
#| build_type: "run"
var i: usize = 0;
while (true) {
    if (i == 10) {
        break;
    }
    i += 1;
}
try std.testing.expect(i == 10);
try stdout.print("Everything worked!", .{});
try stdout.flush();
```

Since this code example was executed successfully by the `zig` compiler,
without raising any errors, we known that, after the execution of the while loop,
the `i` object is equal to 10. Because if it wasn't equal to 10, an error would have
been raised by `expect()`.

Now, in the next example, we have a use case for
the `continue` keyword. The if statement is constantly
checking if the current index is a multiple of 2. If
it is, we jump to the next iteration of the loop.
Otherwise, the loop just prints the current index to the console.

```{zig}
#| auto_main: true
#| build_type: "run"
const ns = [_]u8{1,2,3,4,5,6};
for (ns) |i| {
    if ((i % 2) == 0) {
        continue;
    }
    try stdout.print("{d} | ", .{i});
}
try stdout.flush();
```



## Function parameters are immutable {#sec-fun-pars}

We have already discussed a lot of the syntax behind function declarations in @sec-root-file and @sec-main-file.
But I want to emphasize a curious fact about function parameters (a.k.a. function arguments) in Zig.
In summary, function parameters are immutable in Zig.

Take the code example below, where we declare a simple function that just tries to add
some amount to the input integer, and returns the result back. If you look closely
at the body of this `add2()` function, you will notice that we try
to save the result back into the `x` function argument.

In other words, this function not only uses the value that it received through the function argument
`x`, but it also tries to change the value of this function argument, by assigning the addition result
into `x`. However, function arguments in Zig are immutable. You cannot change their values, or, you
cannot assign values to them inside the body's function.

This is the reason why, the code example below does not compile successfully. If you try to compile
this code example, you will get a compile error message about "trying to change the value of a
immutable (i.e., constant) object".

```{zig}
#| eval: false
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn add2(x: u32) u32 {
    x = x + 2;
    return x;
}

pub fn main() !void {
    const y = add2(4);
    std.debug.print("{d}\n", .{y});
}
```

```
t.zig:3:5: error: cannot assign to constant
    x = x + 2;
    ^
```


### A free optimization

If a function argument receives as input an object whose data type is
any of the primitive types that we have listed in @sec-primitive-data-types,
this object is always passed by value to the function. In other words, this object
is copied into the function stack frame.

However, if the input object have a more complex data type, for example, it might
be a struct instance, or an array, or an union value, etc., in cases like that, the `zig` compiler
will take the liberty of deciding for you which strategy is best. Thus, the `zig` compiler will
pass your object to the function either by value, or by reference. The compiler will always
choose the strategy that is faster for you.
This optimization that you get for free is possible only because function arguments are
immutable in Zig.


### How to overcome this barrier

There are some situations where you might need to change the value of your function argument
directly inside the function's body. This happens more often when we are passing
C structs as inputs to Zig functions.

In a situation like this, you can overcome this barrier by using a pointer. In other words,
instead of passing a value as input to the argument, you can pass a "pointer to value" instead.
You can change the value that the pointer points to, by dereferencing it.

Therefore, if we take our previous `add2()` example, we can change the value of the
function argument `x` inside the function's body by marking the `x` argument as a
"pointer to a `u32` value" (i.e., `*u32` data type), instead of a `u32` value.
By making it a pointer, we can finally alter the value of this function argument directly inside
the body of the `add2()` function. You can see that the code example below compiles successfully.

```{zig}
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
fn add2(x: *u32) void {
    const d: u32 = 2;
    x.* = x.* + d;
}

pub fn main() !void {
    var x: u32 = 4;
    add2(&x);
    std.debug.print("Result: {d}\n", .{x});
}
```

```
Result: 6
```


Even in this code example above, the `x` argument is still immutable. Which means that the pointer itself is immutable.
Therefore, you cannot change the memory address that it points to. However, you can dereference the pointer
to access the value that it points to, and also, to change this value, if you need to.





## Structs and OOP {#sec-structs-and-oop}

Zig is a language more closely related to C (which is a procedural language),
than it is to C++ or Java (which are object-oriented languages). Because of that, you do not
have advanced OOP (Object-Oriented Programming) patterns available in Zig, such as classes, interfaces or
class inheritance. Nonetheless, OOP in Zig is still possible by using struct definitions.

With struct definitions, you can create (or define) a new data type in Zig. These struct definitions work the same way as they work in C.
You give a name to this new struct (or, to this new data type you are creating), then, you list the data members of this new struct. You can
also register functions inside this struct, and they become the methods of this particular struct (or data type), so that, every object
that you create with this new type, will always have these methods available and associated with them.

In C++, when we create a new class, we normally have a constructor method (or, a constructor function) which
is used to construct (or, to instantiate) every object of this particular class, and we also have
a destructor method (or a destructor function), which is the function responsible for destroying
every object of this class.

In Zig, we normally declare the constructor and the destructor methods
of our structs, by declaring an `init()` and a `deinit()` methods inside the struct.
This is just a naming convention that you will find across the entire Zig Standard Library.
So, in Zig, the `init()` method of a struct is normally the constructor method of the class represented by this struct.
While the `deinit()` method is the method used for destroying an existing instance of that struct.

The `init()` and `deinit()` methods are both used extensively in Zig code, and you will see both of
them being used when we talk about allocators in @sec-allocators.
But, as another example, let's build a simple `User` struct to represent a user of some sort of system.

If you look at the `User` struct below, you can see the `struct` keyword.
Notice the data members of this struct: `id`, `name` and `email`. Every data member has its
type explicitly annotated, with the colon character (`:`) syntax that we described earlier in @sec-root-file.
But also notice that every line in the struct body that describes a data member, ends with a comma character (`,`).
So every time you declare a data member in your Zig code, always end the line with a comma character, instead
of ending it with the traditional semicolon character (`;`).

Next, we have registered an `init()` function as a method
of this `User` struct. This `init()` method is the constructor method that we will use to instantiate
every new `User` object. That is why this `init()` function returns a new `User` object as result.


```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    fn init(id: u64,
            name: []const u8,
            email: []const u8) User {

        return User {
            .id = id,
            .name = name,
            .email = email
        };
    }

    fn print_name(self: User, stdout: *std.Io.Writer) !void {
        try stdout.print("{s}\n", .{self.name});
        try stdout.flush();
    }
};

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const u = User.init(1, "pedro", "email@gmail.com");
    try u.print_name(stdout);
}
```



### The `pub` keyword {#sec-pub-keyword}

The `pub` keyword plays an important role in struct declarations, and OOP in Zig.
In essence, this keyword is short for "public", and it makes an item/component available outside of the
module where this item/component is declared. In other words, if I don't apply the `pub` keyword on
something, it means that this "something" is available to be called/used only from within the module
where this "something" is declared.

To demonstrate the effect of this keyword let's focus again on the `User` struct that we have
declared on the previous section. For our example here, let's suppose that this `User` struct is declared inside
a Zig module named `user.zig`. If I don't use the `pub` keyword on the `User` struct, it means that I can create
an `User` object, and call it's methods (`print_name()` and `init()`) only from within the module where the `User`
struct is declared, which in this case is the `user.zig` module.

This is why the previous code example works fine. Because we declare and also use the `User` struct
inside the same module. But problems start to arise when we try to import and call/use this struct
from another module. For example, if I create a new module called `register.zig`, and import the `user.zig`
module into it, and try to annotate any variable with the `User` type, I get an error from the compiler.

```zig
// register.zig
const user = @import("user.zig");
pub fn main() !void {
    const u: user.User = undefined;
    _ = u;
}
```

```
register.zig:3:18: error: 'User' is not marked 'pub'
    const u: user.User = undefined;
             ~~~~^~~~~
user.zig:3:1: note: declared here
const User = struct {
^~~~~
```

Therefore, if you want to use something outside of the module where this "something" is declared,
you have to mark it with the `pub` keyword. This "something" can be a module,
a struct, a function, an object, etc.

For our example here, if we go back to the `user.zig` module, and add the `pub` keyword
to the `User` struct declaration, then, I can successfully compile the `register.zig` module.

```zig
// user.zig
// Added the `pub` keyword to `User`
pub const User = struct {
// ...
```

```zig
// register.zig
// This works fine now!
const user = @import("user.zig");
pub fn main() !void {
    const u: user.User = undefined;
    _ = u;
}
```


Now, what do you think it will happen if I try to actually call from `register.zig` any of the methods
of the `User` struct? For example, if I try to call the `init()` method? The answer is: I get a similar error message,
warning me that the `init()` method is not marked as `pub`, as you can see below:

```zig
const user = @import("user.zig");
pub fn main() !void {
    const u: user.User = user.User.init(
        1, "pedro", "email@gmail.com"
    );
    _ = u;
}
```

```
register.zig:3:35: error: 'init' is not marked 'pub'
    const u: user.User = user.User.init(
                         ~~~~~~~~~^~~~~
user.zig:8:5: note: declared here
    fn init(id: u64,
    ^~~~~~~
```

Thus, just because we have applied the `pub` keyword on the struct declaration,
this does not make the methods of that struct public as well. If we want to use
any method from a struct (such as the `init()` method) outside of the module
where this struct is declared, we have to mark this method with the `pub` keyword
as well.

Going back to the `user.zig` module, and marking both the `init()` and `print_name()`
methods with the `pub` keyword, makes them both available to the outside world, and,
as consequence, makes the previous code example work.


```zig
// user.zig
// Added the `pub` keyword to `User.init`
    pub fn init(
// ...
// Added the `pub` keyword to `User.print_name`
    pub fn print_name(self: User) !void {
// ...
```

```zig
// register.zig
// This works fine now!
const user = @import("user.zig");
pub fn main() !void {
    const u: user.User = user.User.init(
        1, "pedro", "email@gmail.com"
    );
    _ = u;
}
```


### Anonymous struct literals {#sec-anonymous-struct-literals}

You can declare a struct object as a literal value. When we do that, we normally specify the
data type of this struct literal by writing its data type just before the opening curly brace.
For example, I could write a struct literal value of the type `User` that we have defined
in the previous section like this:

```{zig}
#| eval: false
const eu = User {
    .id = 1,
    .name = "Pedro",
    .email = "someemail@gmail.com"
};
_ = eu;
```

However, in Zig, we can also write an anonymous struct literal. That is, you can write a
struct literal, but not specify explicitly the type of this particular struct.
An anonymous struct is written by using the syntax `.{}`. So, we essentially
replaced the explicit type of the struct literal with a dot character (`.`).

As we described in @sec-type-inference, when you put a dot before a struct literal,
the type of this struct literal is automatically inferred by the `zig` compiler.
In essence, the `zig` compiler will look for some hint of what is the type of that struct.
This hint can be the type annotation of a function argument,
or the return type annotation of the function that you are using, or the type annotation
of an existing object.
If the compiler does find such type annotation, it will use this
type in your literal struct.

Anonymous structs are very commonly used as inputs to function arguments in Zig.
One example that you have seen already constantly, is the `print()`
function from the `stdout` object.
This function takes two arguments.
The first argument, is a template string, which should
contain string format specifiers in it, which tells how the values provided
in the second argument should be printed into the message.

While the second argument is a struct literal that lists the values
to be printed into the template message specified in the first argument.
You normally want to use an anonymous struct literal here, so that the
`zig` compiler do the job of specifying the type of this particular
anonymous struct for you.

```{zig}
#| build_type: "run"
#| auto_main: false
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.print("Hello, {s}!\n", .{"world"});
    try stdout.flush();
}
```



### Struct declarations must be constant

Types in Zig must be `const` or `comptime` (we are going to talk more about comptime in @sec-comptime).
What this means is that you cannot create a new data type, and mark it as variable with the `var` keyword.
So struct declarations are always constant. You cannot declare a new struct type using the `var` keyword.
It must be `const`.

In the `Vec3` example below, this declaration is allowed because I'm using the `const` keyword
to declare this new data type.

```{zig}
#| build_type: "lib"
#| auto_main: false
const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,
};
```


### The `self` method argument {#sec-self-arg}

In every language that have OOP, when we declare a method of some class or struct, we
usually declare this method as a function that has a `self` argument.
This `self` argument is the reference to the object itself from which the method
is being called from.

It's not mandatory to use this `self` argument. But why would you not use this `self` argument?
There is no reason to not use it. Because the only way to get access to the data stored in the
data members of your struct is to access them through this `self` argument.
If you don't need to use the data in the data members of your struct inside your method, you very likely don't need
a method. You can just declare this logic as a simple function, outside of your
struct declaration.


Take the `Vec3` struct below. Inside this `Vec3` struct we declared a method named `distance()`.
This method calculates the distance between two `Vec3` objects, by following the distance
formula in euclidean space. Notice that this `distance()` method takes two `Vec3` objects
as input, `self` and `other`.


```{zig}
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
const m = std.math;
const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = m.pow(f64, self.x - other.x, 2.0);
        const yd = m.pow(f64, self.y - other.y, 2.0);
        const zd = m.pow(f64, self.z - other.z, 2.0);
        return m.sqrt(xd + yd + zd);
    }
};
```


The `self` argument corresponds to the `Vec3` object from which this `distance()` method
is being called from. While the `other` is a separate `Vec3` object that is given as input
to this method. In the example below, the `self` argument corresponds to the object
`v1`, because the `distance()` method is being called from the `v1` object,
while the `other` argument corresponds to the object `v2`.


```{zig}
#| eval: false
#| auto_main: true
#| build_type: "ast"
const v1 = Vec3 {
    .x = 4.2, .y = 2.4, .z = 0.9
};
const v2 = Vec3 {
    .x = 5.1, .y = 5.6, .z = 1.6
};

std.debug.print(
    "Distance: {d}\n",
    .{v1.distance(v2)}
);
```

```
Distance: 3.3970575502926055
```



### About the struct state

Sometimes you don't need to care about the state of your struct object. Sometimes, you just need
to instantiate and use the objects, without altering their state. You can notice that when you have methods
inside your struct declaration that might use the values that are present in the data members, but they
do not alter the values in these data members of the struct in anyway.

The `Vec3` struct that was presented in @sec-self-arg is an example of that.
This struct have a single method named `distance()`, and this method does use the values
present in all three data members of the struct (`x`, `y` and `z`). But at the same time,
this method does not change the values of these data members at any point.

As a result of that, when we create `Vec3` objects we usually create them as
constant objects, like the `v1` and `v2` objects presented in @sec-self-arg.
We can create them as variable objects with the `var` keyword,
if we want to. But because the methods of this `Vec3` struct do not change
the state of the objects in any point, it's unnecessary to mark them
as variable objects.

But why? Why am I talking about this here? It's because the `self` argument
in the methods are affected depending on whether the
methods present in a struct change or don't change the state of the object itself.
More specifically, when you have a method in a struct that changes the state
of the object (i.e., changes the value of a data member), the `self` argument
in this method must be annotated in a different manner.

As I described in @sec-self-arg, the `self` argument in methods of
a struct is the argument that receives as input the object from which the method
was called from. We usually annotate this argument in the methods by writing `self`,
followed by the colon character (`:`), and the data type of the struct to which
the method belongs to (e.g. `User`, `Vec3`, etc.).

If we take the `Vec3` struct that we defined in the previous section as an example,
we can see in the `distance()` method that this `self` argument is annotated as
`self: Vec3`. Because the state of the `Vec3` object is never altered by this
method.

But what if we do have a method that alters the state of the object, by altering the
values of its data members, how should we annotate `self` in this instance? The answer is:
"we should annotate `self` as a pointer of `x`, instead of just `x`".
In other words, you should annotate `self` as `self: *x`, instead of annotating it
as `self: x`.

If we create a new method inside the `Vec3` object that, for example, expands the
vector by multiplying its coordinates by a factor of two, then, we need to follow
this rule specified in the previous paragraph. The code example below demonstrates
this idea:

```{zig}
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
const m = std.math;
const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = m.pow(f64, self.x - other.x, 2.0);
        const yd = m.pow(f64, self.y - other.y, 2.0);
        const zd = m.pow(f64, self.z - other.z, 2.0);
        return m.sqrt(xd + yd + zd);
    }

    pub fn twice(self: *Vec3) void {
        self.x = self.x * 2.0;
        self.y = self.y * 2.0;
        self.z = self.z * 2.0;
    }
};
```

Notice in the code example above that we have added a new method
to our `Vec3` struct named `twice()`. This method doubles the
coordinate values of our vector object. In the
case of the `twice()` method, we annotated the `self` argument as `*Vec3`,
indicating that this argument receives a pointer (or a reference, if you prefer to call it this way)
to a `Vec3` object as input.

```{zig}
#| eval: false
var v3 = Vec3 {
    .x = 4.2, .y = 2.4, .z = 0.9
};
v3.twice();
std.debug.print("Doubled: {d}\n", .{v3.x});
```

```
Doubled: 8.4
```



Now, if you change the `self` argument in this `twice()` method to `self: Vec3`, like in the
`distance()` method, you will get the compiler error exposed below as result. Notice that this
error message is showing a line from the `twice()` method body,
indicating that you cannot alter the value of the `x` data member.

```{zig}
#| eval: false
// If we change the function signature of double to:
    pub fn twice(self: Vec3) void {
```

```
t.zig:16:13: error: cannot assign to constant
        self.x = self.x * 2.0;
        ~~~~^~
```

This error message indicates that the `x` data member belongs to a constant object,
and, because of that, it cannot be changed. Ultimately, this error message
is telling us that the `self` argument is constant.

If you take some time, and think hard about this error message, you will understand it.
You already have the tools to understand why we are getting this error message.
We have talked about it already in @sec-fun-pars.
So remember, every function argument is immutable in Zig, and `self`
is no exception to this rule.

In this example, we marked the `v3` object as a variable object.
But this does not matter. Because it's not about the input object, it's about
the function argument.

The problem begins when we try to alter the value of `self` directly, which is a function argument,
and, every function argument is immutable by default. You may ask yourself how can we overcome
this barrier, and once again, the solution was also discussed in @sec-fun-pars.
We overcome this barrier, by explicitly marking the `self` argument as a pointer.


::: {.callout-note}
If a method of your `x` struct alters the state of the object, by
changing the value of any data member, then, remember to use `self: *x`,
instead of `self: x` in the function signature of this method.
:::


You could also interpret the content discussed in this section as:
"if you need to alter the state of your `x` struct object in one of its methods,
you must explicitly pass the `x` struct object by reference to the `self` argument of this method".



## Type inference {#sec-type-inference}

Zig is a strongly typed language. But, there are some situations
where you don't have to explicitly write the type of every single object in your source code,
as you would expect from a traditional strongly typed language, such as C and C++.

In some situations, the `zig` compiler can use type inference to solve the data types for you, easing some of
the burden that you carry as a developer.
The most common way this happens is through function arguments that receive struct objects
as input.

In general, type inference in Zig is done by using the dot character (`.`).
Everytime you see a dot character written before a struct literal, or before an enum value, or something like that,
you know that this dot character is playing a special part in this place. More specifically, it's
telling the `zig` compiler something along the lines of: "Hey! Can you infer the type of this
value for me? Please!". In other words, this dot character is playing a similar role as the `auto` keyword in C++.

I gave you some examples of this in @sec-anonymous-struct-literals, where we used anonymous struct literals.
Anonymous struct literals are, struct literals that use type inference to
infer the exact type of this particular struct literal.
This type inference is done by looking for some minimal hint of the correct data type to be used.
You could say that the `zig` compiler looks for any neighbouring type annotation that might tell it
what the correct type would be.

Another common place where we use type inference in Zig is at switch statements (which we talked about in @sec-switch).
I also gave some other examples of type inference in @sec-switch, where we were inferring the data types of enum values listed inside
of switch statements (e.g. `.DE`).
But as another example, take a look at this `fence()` function reproduced below,
which comes from the [`atomic.zig` module](https://codeberg.org/ziglang/zig/src/branch/master/lib/std/atomic.zig)[^fence-fn]
of the Zig Standard Library.

[^fence-fn]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std/atomic.zig>.

There are a lot of things in this function that we haven't talked about yet, such as:
what `comptime` means? `inline`? `extern`?
Let's just ignore all of these things, and focus solely on the switch statement
that is inside this function.

We can see that this switch statement uses the `order` object as input. This `order`
object is one of the inputs of this `fence()` function, and we can see in the type annotation,
that this object is of type `AtomicOrder`. We can also see a bunch of values inside the
switch statements that begin with a dot character, such as `.release` and `.acquire`.

Because these weird values contain a dot character before them, we are asking the `zig`
compiler to infer the types of these values inside the switch statement. Then, the `zig`
compiler is looking into the current context where these values are being used, and trying
to infer the types of these values.

Since they are being used inside a switch statement, the `zig` compiler looks into the type
of the input object given to the switch statement, which is the `order` object in this case.
Because this object have type `AtomicOrder`, the `zig` compiler infers that these values
are data members from this type `AtomicOrder`.

```{zig}
#| eval: false
pub inline fn fence(self: *Self, comptime order: AtomicOrder) void {
    // many lines of code ...
    if (builtin.sanitize_thread) {
        const tsan = struct {
            extern "c" fn __tsan_acquire(addr: *anyopaque) void;
            extern "c" fn __tsan_release(addr: *anyopaque) void;
        };

        const addr: *anyopaque = self;
        return switch (order) {
            .unordered, .monotonic => @compileError(
                @tagName(order)
                ++ " only applies to atomic loads and stores"
            ),
            .acquire => tsan.__tsan_acquire(addr),
            .release => tsan.__tsan_release(addr),
            .acq_rel, .seq_cst => {
                tsan.__tsan_acquire(addr);
                tsan.__tsan_release(addr);
            },
        };
    }

    return @fence(order);
}
```

This is how basic type inference is done in Zig. If we didn't use the dot character before
the values inside this switch statement, then, we would be forced to explicitly write
the data types of these values. For example, instead of writing `.release` we would have to
write `AtomicOrder.release`. We would have to do this for every single value
in this switch statement, and this is a lot of work. That is why type inference
is commonly used on switch statements in Zig.



## Type casting {#sec-type-cast}

In this section, I want to discuss type casting (or, type conversion) with you.
We use type casting when we have an object of type "x", and we want to convert
it into an object of type "y", i.e., we want to change the data type of the object.

Most languages have a formal way to perform type casting. In Rust for example, we normally
use the keyword `as`, and in C, we normally use the type casting syntax, e.g. `(int) x`.
In Zig, we use the `@as()` built-in function to cast an object of type "x", into
an object of type "y".

This `@as()` function is the preferred way to perform type conversion (or type casting)
in Zig. Because it's explicit, and, it also performs the casting only if it
is unambiguous and safe. To use this function, you just provide the target data type
in the first argument, and, the object that you want cast as the second argument.

```{zig}
#| auto_main: false
#| build_type: "test"
const std = @import("std");
const expect = std.testing.expect;
test {
    const x: usize = 500;
    const y = @as(u32, x);
    try expect(@TypeOf(y) == u32);
}
```

This is the general way to perform type casting in Zig. But remember, `@as()` works only when casting
is unambiguous and safe. There are many situations where these assumptions do not hold. For example,

when casting an integer value into a float value, or vice-versa, it's not clear to the compiler
how to perform this conversion safely.

Therefore, we need to use specialized "casting functions" in such situations.
For example, if you want to cast an integer value into a float value, then, you
should use the `@floatFromInt()` function. In the inverse scenario, you should use
the `@intFromFloat()` function.

In these functions, you just provide the object that you want to
cast as input. Then, the target data type of the "type casting operation" is determined by
the type annotation of the object where you are saving the results.
In the example below, we are casting the object `x` into a value of type `f32`,
because the object `y`, which is where we are saving the results, is annotated
as an object of type `f32`.

```{zig}
#| auto_main: false
#| build_type: "test"
const std = @import("std");
const expect = std.testing.expect;
test {
    const x: usize = 565;
    const y: f32 = @floatFromInt(x);
    try expect(@TypeOf(y) == f32);
}
```

Another built-in function that is very useful when performing type casting operations is `@ptrCast()`.
In essence, we use the `@as()` built-in function when we want to explicit convert (or cast) a Zig value/object
from a type "x" to a type "y", etc. However, pointers (we are going to discuss pointers
in more depth in @sec-pointer) are a special type of object in Zig,
i.e., they are treated differently from "normal objects".

Everytime a pointer is involved in some "type casting operation" in Zig, the `@ptrCast()` function is used.
This function works similarly to `@floatFromInt()`.
You just provide the pointer object that you want to cast as input to this function, and the
target data type is, once again, determined by the type annotation of the object where the results are being
stored.

```{zig}
#| auto_main: false
#| build_type: "test"
const std = @import("std");
const expect = std.testing.expect;
test {
    const bytes align(@alignOf(u32)) = [_]u8{
        0x12, 0x12, 0x12, 0x12
    };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    try expect(@TypeOf(u32_ptr) == *const u32);
}
```





## Modules

We already talked about what modules are, and also, how to import other modules into
your current module via *import statements*. Every Zig module (i.e., a `.zig` file) that you write in your project
is internally stored as a struct object. Take the line exposed below as an example. In this line we are importing the
Zig Standard Library into our current module.

```{zig}
#| eval: false
const std = @import("std");
```

When we want to access the functions and objects from the standard library, we
are basically accessing the data members of the struct stored in the `std`
object. That is why we use the same syntax that we use in normal structs, with the dot operator (`.`)
to access the data members and methods of the struct.

When this "import statement" gets executed, the result of this expression is a struct
object that contains the Zig Standard Library modules, global variables, functions, etc.
And this struct object gets saved (or stored) inside the constant object named `std`.


Take the [`thread_pool.zig` module from the project `zap`](https://github.com/kprotty/zap/blob/blog/src/thread_pool.zig)[^thread]
as an example. This module is written as if it was
a big struct. That is why we have a top-level and public `init()` method
written in this module. The idea is that all top-level functions written in this
module are methods from the struct, and all top-level objects and struct declarations
are data members of this struct. The module is the struct itself.

[^thread]: <https://github.com/kprotty/zap/blob/blog/src/thread_pool.zig>


So you would import and use this module by doing something like this:

```{zig}
#| eval: false
const std = @import("std");
const ThreadPool = @import("thread_pool.zig");
const num_cpus = std.Thread.getCpuCount()
    catch @panic("failed to get cpu core count");
const num_threads = std.math.cast(u16, num_cpus)
    catch std.math.maxInt(u16);
const pool = ThreadPool.init(
    .{ .max_threads = num_threads }
);
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---


```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Memory and Allocators {#sec-memory-chap}


In this chapter, we will talk about memory. How does Zig control memory? What
common tools are used? Are there any important aspects that make memory
different/special in Zig? You will find the answers here.

Computers fundamentally rely on memory to function. This memory acts as a temporary storage
space for the data and values generated during computations. Without memory, the core
concepts of "variables" and "objects" in programming languages would be impossible.




## Memory spaces

Every object that you create in your Zig source code needs to be stored somewhere,
in your computer's memory. Depending on where and how you define your object, Zig
will use a different "memory space", or a different
type of memory to store this object.

Each type of memory normally serves for different purposes.
In Zig, there are 3 types of memory (or 3 different memory spaces) that we care about. They are:

- Global data register (or the "global data section");
- Stack;
- Heap;


### Compile-time known versus runtime known {#sec-compile-time}

One strategy that Zig uses to decide where it will store each object that you declare, is by looking
at the value of this particular object. More specifically, by investigating if this value is
known at "compile-time" or at "runtime".

When you write a program in Zig, the values of some of the objects that you write in your program are *known
at compile time*. Meaning that, when you compile your Zig source code, during the compilation process,
the `zig` compiler can figure out the exact value of a particular object
that exists in your source code.
Knowing the length (or the size) of each object is also important. So the length (or the size) of each object that you write in your program is,
in some cases, *known at compile time*.

The `zig` compiler cares more about knowing the length (or the size) of a particular object
, than to know its actual value. But, if the `zig` compiler knows the value of the object, then, it
automatically knows the size of this object. Because it can simply calculate the
size of the object by looking at the size of the value.

Therefore, the priority for the `zig` compiler is to discover the size of each object in your source code.
If the value of the object in question is known at compile-time, then, the `zig` compiler
automatically knows the size/length of this object. But if the value of this object is not
known at compile-time, then, the size of this object is only known at compile-time if,
and only if, the type of this object has a known fixed size.

In order for a type to have a known fixed size, this type must have data members whose size is fixed.
If this type includes, for example, a slice that does not have a clear size in it, then, this type does not have a known
fixed size. Because at runtime this slice can assume different sizes
(i.e., it might contain 2, 50, or 1 thousand elements, etc.).

For example, as described at @sec-zig-strings, a string object in Zig is internally an array of arbitrary bytes. But, as we've discussed
at @sec-string-slice-versus-array, this array of bytes is normally accessed as a slice of this array of bytes (`[]const u8`).
Now, if a particular function receives a string as input (maybe is the name of the user to be created inside the database,
or, the name of a particular product to search, etc.), there is no easy way to predict the size of the string that you
are going to receive as input.

Think about this for a minute, depending on the context, your function might receive different strings as input, which
might have different sizes. It might be a string with 100 characters, or maybe 10 characters, etc. If there is
no change for us to predict the exact size of the string that we are going to receive while we are developing our new
function, then, the size of this input string is, most likely, not known at compile-time.

So, any type, or any struct declaration that includes a data member that does not have an explicit fixed size,
makes this type, or this new struct that you are declaring, a type that does not have a known fixed size at compile-time.

In contrast, if the type of this struct that you are declaring, includes a data member that is an array,
but this array has a known fixed size, like `[60]u8` (which declares an array of 60 `u8` values), then,
this type, or, this struct that you are declaring, becomes a type with a known fixed size at compile-time.
And because of that, in this case, the `zig` compiler does not need to know at compile-time the exact value of
any object of this type. Since the compiler can find the necessary size to store this object by
looking at the size of its type.


Let's look at an example. In the source code below, we have two constant objects (`name` and `array`) declared.
Because the values of these particular objects are written down, in the source code itself (`"Pedro"`
and the number sequence from 1 to 4), the `zig` compiler can easily discover the values of these constant
objects (`name` and `array`) during the compilation process.
This is what "known at compile time" means. It refers to any object that you have in your Zig source code
whose value can be identified at compile time.


```{zig}
#| auto_main: false
#| build_type: "run"
fn input_length(input: []const u8) usize {
    const n = input.len;
    return n;
}

pub fn main() !void {
    const name = "Pedro";
    const array = [_]u8{1, 2, 3, 4};
    _ = name; _ = array;
}
```

The other side of the spectrum are objects whose values are not known at compile time.
Function arguments are a classic example of this. Because the value of each function
argument depends on the value that you assign to this particular argument,
when you call the function.

For example, the function `input_length()` contains an argument named `input`, which is a slice of constant `u8` integers (`[]const u8`).
It's impossible to know the value of this particular argument at compile time. And it also is impossible to know the size/length
of this particular argument. Because it's a slice that does not have a fixed size specified explicitly in the argument type annotation.

So, we know that this `input` argument will be a slice of `u8` integers. But we do not know at compile-time, it's value, and neither it's size.
This information is known only at runtime, which is the period of time when your program is being executed.
As a consequence, the value of the expression `input.len` is also known only at runtime.
This is an intrinsic characteristic of any function. Just remember that the value of function arguments is usually not "compile-time known".

However, as I mentioned earlier, what really matters to the compiler is to know the size of the object
at compile-time, and not necessarily its value. So, although we don't know the value of the object `n`, which is the result of the expression
`input.len`, at compile-time, we do know its size. Because the expression `input.len` always returns a value of type `usize`,
and the type `usize` has a known fixed size.



### Global data register

The global data register is a specific section of the executable of your Zig program, that is responsible
for storing any value that is known at compile time.

Every constant object whose value is known at compile time that you declare in your source code,
is stored in the global data register. Also, every literal value that you write in your source code,
such as the string `"this is a string"`, or the integer `10`, or a boolean value such as `true`,
is also stored in the global data register.

Honestly, you don't need to care much about this memory space. Because you can't control it,
you can't deliberately access it or use it for your own purposes.
Also, this memory space does not affect the logic of your program.
It simply exists in your program.


### Stack vs Heap

If you are familiar with systems programming, or just low-level programming in general, you
probably have heard of the "duel" between Stack vs Heap. These are two different types of memory,
or different memory spaces, which are both available in Zig.

These two types of memory don't actually duel with
each other. This is a common mistake that beginners have, when seeing "x vs y" styles of
tabloid headlines. These two types of memory are actually complementary to each other.
So, in almost every Zig program that you ever write, you will likely use a combination of both.
I will describe each memory space in detail over the next sections. But for now, I just want to
stablish the main difference between these two types of memory.

In essence, the stack memory is normally used to store values whose length is fixed and known
at compile time. In contrast, the heap memory is a *dynamic* type of memory space, meaning that, it's
used to store values whose length might grow during the execution (runtime) of your program [@jenny2022].

Lengths that grow during runtime are intrinsically associated with "runtime known" type of values.
In other words, if you have an object whose length might grow during runtime, then, the length
of this object becomes not known at compile time. If the length is not known at compile-time,
the value of this object also becomes not known at compile-time.
These types of objects should be stored in the heap memory space, which is
a dynamic memory space, which can grow or shrink to fit the size of your objects.



### Stack {#sec-stack}

The stack is a type of memory that uses the power of the *stack data structure*, hence the name.
A "stack" is a type of *data structure* that uses a "last in, first out" (LIFO) mechanism to store the values
you give to it. I imagine you are familiar with this data structure.
But, if you are not, the [Wikipedia page](https://en.wikipedia.org/wiki/Stack_(abstract_data_type))[^wiki-stack]
, or, the [Geeks For Geeks page](https://www.geeksforgeeks.org/stack-data-structure/)[^geek-stack] are both
excellent and easy resources to fully understand how this data structure works.

[^wiki-stack]: <https://en.wikipedia.org/wiki/Stack_(abstract_data_type)>
[^geek-stack]: <https://www.geeksforgeeks.org/stack-data-structure/>

So, the stack memory space is a type of memory that stores values using a stack data structure.
It adds and removes values from the memory by following a "last in, first out" (LIFO) principle.

Every time you make a function call in Zig, an amount of space in the stack is
reserved for this particular function call [@jenny2022; @zigdocs].
The value of each function argument given to the function in this function call is stored in this
stack space. Also, every local object that you declare inside the function scope is
usually stored in this same stack space.


Looking at the example below, the object `result` is a local object declared inside the scope of the `add()`
function. Because of that, this object is stored inside the stack space reserved for the `add()` function.
The `r` object (which is declared outside of the `add()` function scope) is also stored in the stack.
But since it's declared in the "outer" scope, this object is stored in the
stack space that belongs to this outer scope.

```{zig}
#| auto_main: false
#| build_type: "run"
fn add(x: u8, y: u8) u8 {
    const result = x + y;
    return result;
}

pub fn main() !void {
    const r = add(5, 27);
    _ = r;
}
```


So, any object that you declare inside the scope of a function is always stored inside
the space that was reserved for that particular function in the stack memory. This
also counts for any object declared inside the scope of your `main()` function for example.
As you would expect, in this case, they
are stored inside the stack space reserved for the `main()` function.

One very important detail about the stack memory is that **it frees itself automatically**.
This is very important, remember that. When objects are stored in the stack memory,
you don't have the work (or the responsibility) of freeing/destroying these objects.
Because they will be automatically destroyed once the stack space is freed at the end of the function scope.

So, once the function call returns (or ends, if you prefer to call it this way)
the space that was reserved in the stack is destroyed, and all of the objects that were in that space goes away with it.
This mechanism exists because this space, and the objects within it, are not necessary anymore,
since the function "finished its business".
Using the `add()` function that we exposed above as an example, it means that the object `result` is automatically
destroyed once the function returns.

::: {.callout-important}
Local objects that are stored in the stack space of a function are automatically
freed/destroyed at the end of the function scope.
:::


This same logic applies to any other special structure in Zig that has its own scope by surrounding
it with curly braces (`{}`).
For loops, while loops, if else statements, etc. For example, if you declare any local
object in the scope of a for loop, this local object is accessible only within the scope
of this particular for loop. Because once the scope of this for loop ends, the space in the stack
reserved for this for loop is freed.
The example below demonstrates this idea.

```{zig}
#| auto_main: true
#| build_type: "run"
#| eval: false
// This does not compile successfully!
const a = [_]u8{0, 1, 2, 3, 4};
for (0..a.len) |i| {
    const index = i;
    _ = index;
}
// Trying to use an object that was
// declared in the for loop scope,
// and that does not exist anymore.
std.debug.print("{d}\n", .{index});
```



One important consequence of this mechanism is that, once the function returns, you can no longer access any memory
address that was inside the space in the stack reserved for this particular function. Because this space was
destroyed. This means that, if this local object is stored in the stack,
you cannot make a function that **returns a pointer to this object**.

Think about that for a second. If all local objects in the stack are destroyed at the end of the function scope, why
would you even consider returning a pointer to one of these objects? This pointer is at best,
invalid, or, more likely, "undefined".

In conclusion, it's totally fine to write a function that returns the local object
itself as result, because then, you return the value of that object as the result.
But, if this local object is stored in the stack, you should never write a function
that returns a pointer to this local object. Because the memory address pointed by the pointer
no longer exists.


So, using again the `add()` function as an example, if you rewrite this function so that it
returns a pointer to the local object `result`, the `zig` compiler will actually compile
your program, with no warnings or errors. At first glance, it looks like this is good code
that works as expected. But this is a lie!

If you try to take a look at the value inside of the `r` object,
or, if you try to use this `r` object in another expression
or function call, then, you would have undefined behaviour, and major
bugs in your program [@zigdocs, see "Lifetime and Ownership"[^life] and "Undefined Behaviour"[^undef] sections].

[^life]: <https://ziglang.org/documentation/master/#Lifetime-and-Ownership>
[^undef]: <https://ziglang.org/documentation/master/#Undefined-Behavior>


```{zig}
#| auto_main: false
#| build_type: "run"
fn add(x: u8, y: u8) *const u8 {
    const result = x + y;
    return &result;
}

pub fn main() !void {
    // This code compiles successfully. But it has
    // undefined behaviour. Never do this!!!
    // The `r` object is undefined!
    const r = add(5, 27); _ = r;
}
```

This "invalid pointer to stack variable" problem is well known across many programming language communities.
If you try to do the same thing, for example, in a C or C++ program (i.e., returning an address to
a local object stored in the stack), you would also get undefined behaviour
in the program.

::: {.callout-important}
If a local object in your function is stored in the stack, you should never
return a pointer to this local object from the function. Because
this pointer will always become undefined after the function returns, since the stack space of the function
is destroyed at the end of its scope.
:::

But what if you really need to use this local object in some way after your function returns?
How can you do this? The answer is: "in the same way you would do if this were a C or C++ program. By returning
an address to an object stored in the heap". The heap memory has a much more flexible lifecycle,
and allows you to get a valid pointer to a local object of a function that already returned
from its scope.


### Heap {#sec-heap}

One important limitation of the stack, is that, only objects whose length/size is known at compile-time can be
stored in it. In contrast, the heap is a much more dynamic
(and flexible) type of memory. It's the perfect type of memory to use
for objects whose size/length might grow during the execution of your program.

Virtually any application that behaves as a server is a classic use case of the heap.
A HTTP server, a SSH server, a DNS server, a LSP server, ... any type of server.
In summary, a server is a type of application that runs for long periods of time,
and that serves (or "deals with") any incoming request that reaches this particular server.

The heap is a good choice for this type of system, mainly because the server does not know upfront
how many requests it will receive from users, while it is active. It could be a single request,
5 thousand requests, or even zero requests.
The server needs to have the ability to allocate and manage its memory according to how many requests it receives.

Another key difference between the stack and the heap, is that the heap is a type
of memory that you, the programmer, have complete control over. This makes the heap a
more flexible type of memory, but it also makes it harder to work with. Because you,
the programmer, is responsible for managing everything related to it. Including where the memory is allocated,
how much memory is allocated, and where this memory is freed.

> Unlike stack memory, heap memory is allocated explicitly by programmers and it won’t be deallocated until it is explicitly freed [@jenny2022].

To store an object in the heap, you, the programmer, needs to explicitly tells Zig to do so,
by using an allocator to allocate some space in the heap. In @sec-allocators, I will present how you can use allocators to allocate memory
in Zig.

::: {.callout-important}
Every memory you allocate in the heap needs to be explicitly freed by you, the programmer.
:::

The majority of allocators in Zig do allocate memory on the heap. But some exceptions to this rule are
`ArenaAllocator()` and `FixedBufferAllocator()`. The `ArenaAllocator()` is a special
type of allocator that works in conjunction with a second type of allocator.
On the other side, the `FixedBufferAllocator()` is an allocator that works based on
buffer objects created on the stack. This means that the `FixedBufferAllocator()` makes
allocations only on the stack.




### Summary

After discussing all of these boring details, we can quickly recap what we learned.
In summary, the Zig compiler will use the following rules to decide where each
object you declare is stored:

1. every literal value (such as `"this is string"`, `10`, or `true`) is stored in the global data section.
1. every constant object (`const`) whose value **is known at compile-time** is also stored in the global data section.
1. every object (constant or not) whose length/size **is known at compile time** is stored in the stack space for the current scope.
1. if an object is created with the method `alloc()` or `create()` of an allocator object, this object is stored in the memory space used by this particular allocator object. Most of allocators available in Zig use the heap memory, so, this object is likely stored in the heap (`FixedBufferAllocator()` is an exception to that).
1. the heap can only be accessed through allocators. If your object was not created through the `alloc()` or `create()` methods of an allocator object, then, it is most certainly not an object stored in the heap.


## Stack overflows {#sec-stack-overflow}

Allocating memory on the stack is generally faster than allocating it on the heap.
But this better performance comes with many restrictions. We have already discussed
many of these restrictions of the stack in @sec-stack. But there is one more important
limitation that I want to talk about, which is the size of the stack itself.

The stack is limited in size. This size varies from computer to computer, and it depends on
a lot of things (the computer architecture, the operating system, etc.). Nevertheless, this size is usually
not that big. This is why we normally use the stack to store only temporary and small objects in memory.

In essence, if you try to make an allocation on the stack, that is so big that exceeds the stack size limit,
a *stack overflow* happens, and your program just crashes as a result of that. In other words, a stack overflow happens when
you attempt to use more space than is available on the stack.

This type of problem is very similar to a *buffer overflow*, i.e., you are trying to use more space
than is available in the "buffer object". However, a stack overflow always causes your program to crash,
while a buffer overflow does not always cause your program to crash (although it often does).

You can see an example of a stack overflow in the example below. We are trying to allocate a very big array of `u64` values
on the stack. You can see below that this program does not run successfully, because it crashed
with a "segmentation fault" error message.

```{zig}
#| build_type: "ast"
#| auto_main: true
var very_big_alloc: [1000 * 1000 * 24]u64 = undefined;
@memset(very_big_alloc[0..], 0);
```

```
Segmentation fault (core dumped)
```

This segmentation fault error is a result of the stack overflow that was caused by the big
memory allocation made on the stack, to store the `very_big_alloc` object.
This is why very big objects are usually stored on the heap, instead of the stack.



## Allocators {#sec-allocators}

One key aspect about Zig, is that there are "no hidden-memory allocations" in Zig.
What that really means, is that "no allocations happen behind your back in the standard library" [@zigguide].

This is a known problem, especially in C++. Because in C++, there are some operators that do allocate
memory behind the scene, and there is no way for you to know that, until you actually read the
source code of these operators, and find the memory allocation calls.
Many programmers find this behaviour annoying and hard to keep track of.

But, in Zig, if a function, an operator, or anything from the standard library
needs to allocate some memory during its execution, then, this function/operator needs to receive (as input) an allocator
provided by the user, to actually be able to allocate the memory it needs.

This creates a clear distinction between functions that "do not" from those that "actually do"
allocate memory. Just look at the arguments of this function.
If a function, or operator, has an allocator object as one of its inputs/arguments, then, you know for
sure that this function/operator will allocate some memory during its execution.

An example is the `allocPrint()` function from the Zig Standard Library. With this function, you can
write a new string using format specifiers. So, this function is, for example, very similar to the function `sprintf()` in C.
In order to write such a new string, the `allocPrint()` function needs to allocate some memory to store the
output string.

That is why, the first argument of this function is an allocator object that you, the user/programmer, gives
as input to the function. In the example below, I am using the `GeneralPurposeAllocator()` as my allocator
object. But I could easily use any other type of allocator object from the Zig Standard Library.

```{zig}
#| auto_main: true
#| build_type: "run"
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
const name = "Pedro";
const output = try std.fmt.allocPrint(
    allocator,
    "Hello {s}!!!",
    .{name}
);
try stdout.print("{s}\n", .{output});
try stdout.flush();
```


You get a lot of control over where and how much memory this function can allocate.
Because it is you, the user/programmer, that provides the allocator for the function to use.
This makes "total control" over memory management easier to achieve in Zig.

### What are allocators?

Allocators in Zig are objects that you can use to allocate memory for your program.
They are similar to the memory allocating functions in C, like `malloc()` and `calloc()`.
So, if you need to use more memory than you initially have, during the execution of your program, you can simply ask
for more memory by using an allocator object.

Zig offers different types of allocators, and they are usually available through the `std.heap` module of
the standard library. Thus, just import the Zig Standard Library into your Zig module (with `@import("std")`), and you can start
using these allocators in your code.

Furthermore, every allocator object is built on top of the `Allocator` interface in Zig.
This means that, every allocator object you find in Zig must have the methods `alloc()`,
`create()`, `free()` and `destroy()`. So, you can change the type of allocator you are using,
but you don't need to change the function calls to the methods that do the memory allocation
(and the free memory operations) for your program.

### Why you need an allocator?

As we described in @sec-stack, everytime you make a function call in Zig,
a space in the stack is reserved for this function call. But the stack
has a key limitation which is: every object stored in the stack has a
known fixed length.

But in reality, there are two very common instances where this "fixed length limitation" of the stack is a deal braker:

1. the objects that you create inside your function might grow in size during the execution of the function.
1. sometimes, it's impossible to know upfront how many inputs you will receive, or how big this input will be.

Also, there is another instance where you might want to use an allocator, which is when you want to write a function that returns a pointer
to a local object. As I described in @sec-stack, you cannot do that if this local object is stored in the
stack. However, if this object is stored in the heap, then, you can return a pointer to this object at the
end of the function. Because you (the programmer) control the lifetime of any heap memory that you allocate. You decide
when this memory gets destroyed/freed.

These are common situations for which the stack is not good.
That is why you need a different memory management strategy to
store these objects inside your function. You need to use
a memory type that can grow together with your objects, or that you
can control the lifetime of this memory.
The heap fits this description.

Allocating memory on the heap is commonly known as dynamic memory management. As the objects you create grow in size
during the execution of your program, you grow the amount of memory
you have by allocating more memory in the heap to store these objects.
And you do that in Zig, by using an allocator object.


### The different types of allocators


At the moment of the writing of this book, in Zig, we have 6 different
allocators available in the standard library:

- `GeneralPurposeAllocator()`.
- `page_allocator()`.
- `FixedBufferAllocator()` and `ThreadSafeFixedBufferAllocator()`.
- `ArenaAllocator()`.
- `c_allocator()` (requires you to link to libc).


Each allocator has its own perks and limitations. All allocators, except `FixedBufferAllocator()` and `ArenaAllocator()`,
are allocators that use the heap memory. So any memory that you allocate with
these allocators, will be placed in the heap.

### General-purpose allocators

The `GeneralPurposeAllocator()`, as the name suggests, is a "general purpose" allocator. You can use it for every type
of task. In the example below, I'm allocating enough space to store a single integer in the object `some_number`.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = @as(u32, 45);
}
```


While useful, you might want to use the `c_allocator()`, which is a alias to the C standard allocator `malloc()`. So, yes, you can use
`malloc()` in Zig if you want to. Just use the `c_allocator()` from the Zig standard library. However,
if you do use `c_allocator()`, you must link to Libc when compiling your source code with the
`zig` compiler, by including the flag `-lc` in your compilation process.
If you do not link your source code to Libc, Zig will not be able to find the
`malloc()` implementation in your system.

### Page allocator

The `page_allocator()` is an allocator that allocates full pages of memory in the heap. In other words,
every time you allocate memory with `page_allocator()`, a full page of memory in the heap is allocated,
instead of just a small piece of it.

The size of this page depends on the system you are using.
Most systems use a page size of 4KB in the heap, so, that is the amount of memory that is normally
allocated in each call by `page_allocator()`. That is why, `page_allocator()` is considered a
fast, but also "wasteful" allocator in Zig. Because it allocates a big amount of memory
in each call, and you most likely will not need that much memory in your program.

### Buffer allocators

The `FixedBufferAllocator()` and `ThreadSafeFixedBufferAllocator()` are allocator objects that
work with a fixed sized buffer object at the back. In other words, they use a fixed sized buffer
object as the basis for the memory. When you ask these allocator objects to allocate some memory for you,
they are essentially reserving some amount of space inside this fixed sized buffer object for you to use.

This means that, in order to use these allocators, you must first create a buffer object in your code,
and then, give this buffer object as an input to these allocators.

This also means that, these allocator objects can allocate memory both in the stack or in the heap.
Everything depends on where the buffer object that you provide lives. If this buffer object lives
in the stack, then, the memory allocated is "stack-based". But if it lives on the heap, then,
the memory allocated is "heap-based".


In the example below, I'm creating a `buffer` object on the stack that is 10 elements long.
Notice that I give this `buffer` object to the `FixedBufferAllocator()` constructor.
Now, because this `buffer` object is 10 elements long, this means that I am limited to this space.
I cannot allocate more than 10 elements with this allocator object. If I try to
allocate more than that, the `alloc()` method will return an `OutOfMemory` error value.

```{zig}
#| auto_main: true
#| build_type: "run"
var buffer: [10]u8 = undefined;
for (0..buffer.len) |i| {
    buffer[i] = 0; // Initialize to zero
}

var fba = std.heap.FixedBufferAllocator.init(&buffer);
const allocator = fba.allocator();
const input = try allocator.alloc(u8, 5);
defer allocator.free(input);
```

Remember, the memory allocated by these allocator objects can be either from
the stack, or, from the heap. It all depends on where the buffer object that you provide lives.
In the above example, the `buffer` object lives in the stack, and, therefore, the memory allocated
is based in the stack. But what if it was based on the heap?

As we described in @sec-stack-overflow, one of the main reasons why you would use the heap,
instead of the stack, is to allocate huge amounts of space to store very big objects.
Thus, let's suppose you wanted to use a very big buffer object as the basis for your
allocator objects. You would have to allocate this very big buffer object on the heap.
The example below demonstrates this case.

```{zig}
#| build_type: "ast"
#| auto_main: true
const heap = std.heap.page_allocator;
const memory_buffer = try heap.alloc(
    u8, 100 * 1024 * 1024 // 100 MB memory
);
defer heap.free(memory_buffer);
var fba = std.heap.FixedBufferAllocator.init(
    memory_buffer
);
const allocator = fba.allocator();

const input = try allocator.alloc(u8, 1000);
defer allocator.free(input);
```



### Arena allocator {#sec-arena-allocator}

The `ArenaAllocator()` is an allocator object that takes a child allocator as input. The idea behind the `ArenaAllocator()` in Zig
is similar to the concept of "arenas" in the programming language Go[^go-arena]. It's an allocator object that allows you
to allocate memory as many times you want, but free all memory only once.
In other words, if you have, for example, called 5 times the method `alloc()` of an `ArenaAllocator()` object, you can
free all the memory you allocated over these 5 calls at once, by simply calling the `deinit()` method of the same `ArenaAllocator()` object.

[^go-arena]: <https://go.dev/src/arena/arena.go>

If you give, for example, a `GeneralPurposeAllocator()` object as input to the `ArenaAllocator()` constructor, like in the example below, then, the allocations
you perform with `alloc()` will actually be made with the underlying object `GeneralPurposeAllocator()` that was passed.
So, with an arena allocator, any new memory you ask for is allocated by the child allocator. The only thing that an arena allocator
really does is help you to free all the memory you allocated multiple times with just a single command. In the example
below, I called `alloc()` 3 times. So, if I did not use an arena allocator, then, I would need to call
`free()` 3 times to free all the allocated memory.

```{zig}
#| auto_main: true
#| build_type: "lib"
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var aa = std.heap.ArenaAllocator.init(gpa.allocator());
defer aa.deinit();
const allocator = aa.allocator();

const in1 = try allocator.alloc(u8, 5);
const in2 = try allocator.alloc(u8, 10);
const in3 = try allocator.alloc(u8, 15);
_ = in1; _ = in2; _ = in3;
```



### The `alloc()` and `free()` methods

In the code example below, we are accessing the `stdin`, which is
the standard input channel, to receive an input from the
user. We read the next line of input given by the user with the `takeDelimiterExclusive()`
method.

Now, after reading the input of the user, we need to store this input somewhere in
our program. That is why I use an allocator in this example. I use it to allocate some
amount of memory to store this input given by the user. More specifically, the method `alloc()`
of the allocator object is used to allocate an array capable of storing 50 `u8` values.

Notice that this `alloc()` method receives two inputs. The first one, is a type.
This defines what type of values the allocated array will store. In the example
below, we are allocating an array of unsigned 8-bit integers (`u8`). But
you can create an array to store any type of value you want. Next, in the second argument, we
define the size of the allocated array, by specifying how many elements
this array will contain. In the case below, we are allocating an array of 50 elements.

In @sec-zig-strings we described that strings in Zig are simply arrays of characters.
Each character is represented by a `u8` value[^charn]. So, this means that the array that
was allocated in the object `input` is capable of storing a string that is
50-characters long.

[^charn]: Just remember that this is an oversimplification. If we are talking only about ASCII strings, then yes, every `u8` value represents a separate character in the string. But if we enter the realm of UTF-8 encoded string, then, this scenario is not always true.

So, in essence, the expression `var input: [50]u8 = undefined` would create
an array for 50 `u8` values in the stack of the current scope. But, you
can allocate the same array in the heap by using the expression `var input = try allocator.alloc(u8, 50)`.

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var input = try allocator.alloc(u8, 50);
    defer allocator.free(input);
    @memset(input[0..], 0);

    // Read user input until a line break is found.
    const stream = try stdin.takeDelimiterExclusive('\n');
    // Store the input into our heap memory.
    @memcpy(input[0..stream.len], stream[0..]);
    // Print our heap memory, so that we can see what
    // was stored in it.
    std.debug.print("{s}\n", .{input});
}
```

Also, notice that in this example, we use the `defer` keyword (which I described in @sec-defer) to run a small
piece of code at the end of the current scope, which is the expression `allocator.free(input)`.
When you execute this expression, the allocator will free the memory that it allocated
for the `input` object.

We have talked about this in @sec-heap. You **should always** explicitly free any memory that you allocate
using an allocator! You do that by using the `free()` method of the same allocator object you
used to allocate this memory. The `defer` keyword is used in this example only to help us execute
this free operation at the end of the current scope.


### The `create()` and `destroy()` methods

With the `alloc()` and `free()` methods, you can allocate memory to store multiple elements
at once. In other words, with these methods, we always allocate an array to store multiple elements at once.
But what if you need enough space to store just a single item? Should you
allocate an array of a single element through `alloc()`?

The answer is no! In this case,
you should use the `create()` method of the allocator object.
Every allocator object offers the `create()` and `destroy()` methods,
which are used to allocate and free memory for a single item, respectively.

So, in essence, if you want to allocate memory to store an array of elements, you
should use `alloc()` and `free()`. But if you need to store just a single item,
then, the `create()` and `destroy()` methods are ideal for you.

In the example below, I'm defining a struct to represent an user of some sort.
It could be a user for a game, or software to manage resources, it doesn't matter.
Notice that I use the `create()` method this time, to store a single `User` object
in the program. Also notice that I use the `destroy()` method to free the memory
used by this object at the end of the scope.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
const User = struct {
    id: usize,
    name: []const u8,

    pub fn init(id: usize, name: []const u8) User {
        return .{ .id = id, .name = name };
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const user = try allocator.create(User);
    defer allocator.destroy(user);

    user.* = User.init(0, "Pedro");
}
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Project 1 - Building a base64 encoder/decoder {#sec-base64}

As our first small project, I want to implement a base64 encoder/decoder with you.
Base64 is an encoding system which translates binary data to text.
A big chunk of the web uses base64 to deliver binary data to systems
that can only read text data.

The most common example of a modern use case for base64 is essentially any email system,
like GMail, Outlook, etc. Because email systems normally use
the Simple Mail Transfer Protocol (SMTP), which is a web protocol
that supports only text data. So, if you need, for any reason, to
send a binary file (like for example, a PDF, or an Excel file) as
an attachment in your email, these binary files are normally
converted to base64, before they are included in the SMTP message.
So, the base64 encoding is largely used in these email systems to include
binary data into the SMTP message.






## How the base64 algorithm work?

But how exactly does the algorithm behind the base64 encoding work? Let's discuss that. First, I will
explain the base64 scale, which is the 64-character scale that is the basis for
the base64 encoding system.

After that, I explain the algorithm behind a base64 encoder, which is the part of the algorithm that is responsible for encoding messages
into the base64 encoding system. Then, after that, I explain the algorithm behind a base64 decoder, which is
the part of the algorithm that is responsible for translating base64 messages back into their original meaning.

If you are unsure about the differences between an "encoder" and a "decoder",
take a look at @sec-encode-vs-decode.


### The base64 scale {#sec-base64-scale}

The base64 encoding system is based on a scale that goes from 0 to 63 (hence the name).
Each index in this scale is represented by a character (it's a scale of 64 characters).
So, in order to convert some binary data, to the base64 encoding, we need to convert each binary number to the corresponding
character in this "scale of 64 characters".

The base64 scale starts with all ASCII uppercase letters (A to Z) which represents
the first 25 indexes in this scale (0 to 25). After that, we have all ASCII lowercase letters
(a to z), which represents the range 26 to 51 in the scale. After that, we
have the one digit numbers (0 to 9), which represents the indexes from 52 to 61 in the scale.
Finally, the last two indexes in the scale (62 and 63) are represented by the characters `+` and `/`,
respectively.

These are the 64 characters that compose the base64 scale. The equal sign character (`=`) is not part of the scale itself,
but it is a special character in the base64 encoding system. This character is used solely as a suffix, to mark the end of the character sequence,
or, to mark the end of meaningful characters in the sequence.

The bullet points below summarises the base64 scale:

- range 0 to 25 is represented by: ASCII uppercase letters `-> [A-Z]`;
- range 26 to 51 is represented by: ASCII lowercase letters `-> [a-z]`;
- range 52 to 61 is represented by: one digit numbers `-> [0-9]`;
- index 62 and 63 are represented by the characters `+` and `/`, respectively;
- the character `=` represents the end of meaningful characters in the sequence;




### Creating the scale as a lookup table {#sec-base64-table}

The best way to represent this scale in code, is to represent it as a *lookup table*.
Lookup tables are a classic strategy in computer science to speed up calculations. The basic idea
is to replace a runtime calculation (which can take a long time to be done) with a basic array indexing
operation.

Instead of calculating the results everytime you need them, you calculate all possible results at once, and then, you store them in an array
(which behaves like a "table"). Then, every time you need to use one of the characters in the base64 scale, instead of
using many resources to calculate the exact character to be used, you simply retrieve this character
from the array where you stored all the possible characters in the base64 scale.
We retrieve the character that we need directly from memory.

We can start building a Zig struct to store our base64 decoder/encoder logic.
We start with the `Base64` struct below. For now, we only have one single data member in this
struct, i.e., the member `_table`, which represents our lookup table. We also have an `init()` method,
to create a new instance of a `Base64` object, and, a `_char_at()` method, which is a
"get character at index $x$" type of function.


```{zig}
#| build_type: "lib"
#| auto_main: false
const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";
        return Base64{
            ._table = upper ++ lower ++ numbers_symb,
        };
    }

    pub fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }
};
```


In other words, the `_char_at()` method is responsible for getting the character in the lookup
table (i.e., the `_table` struct data member) that corresponds to a particular index in the
"base64 scale". So, in the example below, we know that the character that corresponds to the
index 28 in the "base64 scale" is the character "c".


```{zig}
#| eval: false
const base64 = Base64.init();
try stdout.print(
    "Character at index 28: {c}\n",
    .{base64._char_at(28)}
);
try stdout.flush();
```

```
Character at index 28: c
```



### A base64 encoder {#sec-base64-encoder-algo}

The algorithm behind a base64 encoder usually works on a window of 3 bytes. Because each byte has
8 bits, so, 3 bytes forms a set of $8 \times 3 = 24$ bits. This is desirable for the base64 algorithm, because
24 bits is divisible by 6, which forms $24 / 6 = 4$ groups of 6 bits each.

Therefore, the base64 algorithm works by converting 3 bytes at a time
into 4 characters from the base64 scale. It keeps iterating through the input string,
3 bytes at a time, and converting them into the base64 scale, producing 4 characters
per iteration. It keeps iterating, and producing these "new characters"
until it hits the end of the input string.

Now you may think, what if you have a particular string that has a number of bytes
that is not divisible by 3 - what happens? For example, if you have a string
that contains only two characters/bytes, such as "Hi". How would the algorithm
behave in such situation? You find the answer in @fig-base64-algo1.
You can see in @fig-base64-algo1 that the string "Hi", when converted to base64,
becomes the string "SGk=":

![The logic behind a base64 encoder](./../Figures/base64-encoder-flow.png){#fig-base64-algo1}

Taking the string "Hi" as an example, we have 2 bytes, or, 16 bits in total. So, we lack a full byte (8 bits)
to complete the window of 24 bits that the base64 algorithm likes to work on. The first thing that
the algorithm does, is to check how to divide the input bytes into groups of 6 bits.

If the algorithm notices that there is a group of 6 bits that it's not complete, meaning that, this group contains $nbits$, where $0 < nbits < 6$,
the algorithm simply adds extra zeros in this group to fill the space that it needs.
That is why in @fig-base64-algo1, in the third group after the 6-bit transformation,
2 extra zeros were added to fill the gap.

When we have a 6-bit group that is not completely full, like the third group, extra zeros
are added to fill the gap. But what about when an entire 6-bit group is empty, or, it
simply doesn't exist? This is the case of the fourth 6-bit group exposed at
@fig-base64-algo1.

This fourth group is necessary, because the algorithm works on 4 groups of 6 bits.
But the input string does not have enough bytes to create a fourth 6-bit group.
Every time this happens, where an entire group of 6 bits is empty,
this group becomes a "padding group". Every "padding group" is mapped to
the character `=` (equal sign), which represents "null", or, the end
of meaningful characters in the sequence. Hence, everytime that the algorithm produces a
"padding group", this group is automatically mapped to `=`.

As another example, if you give the string "0" as input to a base64 encoder, this string is
translated into the base64 sequence "MA==".
The character "0" is, in binary, the sequence `00110000`[^zero-note]. So, with the 6-bit transformation
exposed in @fig-base64-algo1, this single character would produce these two 6-bit groups: `001100`, `000000`.
The remaining two 6-bit groups become "padding groups". That is why the last
two characters in the output sequence (MA==) are `==`.


[^zero-note]: Notice that, the character "0" is different than the actual number 0, which is simply zero in binary.

### A base64 decoder {#sec-base64-decoder-algo}

The algorithm behind a base64 decoder is essentially the inverse process of a base64 encoder.
A base64 decoder needs to translate base64 messages back into their original meaning,
i.e., into the original sequence of binary data.

A base64 decoder usually works on a window of 4 bytes. Because it wants to convert these 4 bytes
back into the original sequence of 3 bytes, that was converted into 4 groups of 6 bits by the
base64 encoder. Remember, in a base64 decoder we are essentially reverting the process made
by the base64 encoder.

Each byte in the input string (the base64 encoded string) normally contributes to re-create
two different bytes in the output (the original binary data).
In other words, each byte that comes out of a base64 decoder is created by transforming merging two different
bytes in the input together. You can visualize this relationship in @fig-base64-algo2:

![The logic behind a base64 decoder](./../Figures/base64-decoder-flow.png){#fig-base64-algo2}

The exact transformations, or, the exact steps applied to each byte from the input to transform them
into the bytes of the output, are a bit tricky to visualize in a figure like this. Because of that, I have
summarized these transformations as "Some bit shifting and additions ..." in the figure. These transformations
will be described in depth later.

Besides that, if you look again in @fig-base64-algo2, you will notice that the character `=` was completely
ignored by the algorithm. Remember, this is just a special character that marks the end of meaningful characters
in the base64 sequence. So, every `=` character in a base64 encoded sequence should be ignored by a base64 decoder.


## Difference between encode and decode {#sec-encode-vs-decode}

If you don't have any previous experience with base64, you might not understand the differences
between "encode" and "decode". Essentially, the terms "encode" and "decode" here
have the exact same meaning as they have in the field of encryption (i.e., they mean the same thing as "encode" and "decode" in hashing
algorithms, like the MD5 algorithm).

Thus, "encode" means that we want to encode, or, in other words, we want to translate some message into
the base64 encoding system. We want to produce the sequence of base64 characters that represent this
original message in the base64 encoding system.

In contrast, "decode" represents the inverse process.
We want to decode, or, in other words, translate a base64 message back to its original content.
So, in this process we get a sequence of base64 characters as input, and produce as output,
the binary data that is represented by this sequence of base64 characters.

Any base64 library is normally composed of these two parts: 1) the encoder, which is a function that encodes
(i.e., it converts) any sequence of binary data into a sequence of base64 characters; 2) the decoder, which is a function
that converts a sequence of base64 characters back into the original sequence of binary data.



## Calculating the size of the output {#sec-base64-length-out}

One task that we need to do is to calculate how much space we need to reserve for the
output, both of the encoder and decoder. This is simple math, and can be done easily in Zig
because every array has its length (its number of elements) easily accesible by consulting
the `.len` property of the array.

For the encoder, the logic is the following: for each 3 bytes that we find in the input,
4 new bytes are created in the output. So, we take the number of bytes in the input, divide it
by 3, use a ceiling function, then, we multiply the result by 4. That way, we get the total
number of bytes that will be produced by the encoder in its output.

The `_calc_encode_length()` function below encapsulates this logic.
Inside this function, we take the length of the input array,
we divide it by 3, and apply a ceil operation over the result by using the
`divCeil()` function from the Zig Standard Library. Lastly, we multiply
the end result by 4 to get the answer we need.

Also, you might have notice that, if the input length is less than 3 bytes, then, the output length of the encoder is
always 4 bytes. This is the case for every input with less than 3 bytes, because, as I described in @sec-base64-encoder-algo,
the algorithm always produces enough "padding-groups" in the end result, to complete the 4 bytes window.

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn _calc_encode_length(input: []const u8) !usize {
    if (input.len < 3) {
        return 4;
    }
    const n_groups: usize = try std.math.divCeil(
        usize, input.len, 3
    );
    return n_groups * 4;
}
```


Now, the logic to calculate the length of the output from the decoder is a little bit more complicated. But, it is basically
just the inverse logic that we've used for the encoder: for each 4 bytes in the input, 3 bytes
will be produced in the output of the decoder. However, this time we need to
take the `=` character into account, which is always ignored by the decoder, as we described in @sec-base64-decoder-algo, and,
in @fig-base64-algo2.

In essence, we take the length of the input and divide it by 4, then we apply a floor function on the result, then
we multiply the result by 3, and then, we subtract from the result how much times the character `=` is found
in the input.

The function `_calc_decode_length()` exposed below summarizes this logic that we described. It's similar
to the function `_calc_encode_length()`. Notice that the division part is twisted. Also notice that this time, we apply
a floor operation over the output of the division, by using the `divFloor()`
function (instead of a ceiling operation with `divCeil()`).


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn _calc_decode_length(input: []const u8) !usize {
    if (input.len < 4) {
        return 3;
    }

    const n_groups: usize = try std.math.divFloor(
        usize, input.len, 4
    );
    var multiple_groups: usize = n_groups * 3;
    var i: usize = input.len - 1;
    while (i > 0) : (i -= 1) {
        if (input[i] == '=') {
            multiple_groups -= 1;
        } else {
            break;
        }
    }

    return multiple_groups;
}
```


## Building the encoder logic {#sec-encoder-logic}

In this section, we can start building the logic behind the `encode()` function, which
will be responsible for encoding messages into the base64 encoding system.
If you are an anxious person, and you want to see now the full source code of the implementation
for this base64 encoder/decoder, you can find it at the `ZigExamples` folder in the official repository of
this book[^zig-base64-algo].

[^zig-base64-algo]: <https://github.com/pedropark99/zig-book/blob/main/ZigExamples/base64/base64_basic.zig>.



### The 6-bit transformation {#sec-6bit-transf}

The 6-bit transformation presented in @fig-base64-algo1 is the core part of the base64 encoder algorithm.
By understanding how this transformation is made in code, the rest of the algorithm becomes much simpler
to comprehend.

In essence, this 6-bit transformation is made with the help of bitwise operators.
Bitwise operators are essential to any type of low-level operation that is done at the bit-level. For the specific case of the base64 algorithm,
the operators *bit shift to the left* (`<<`), *bit shift to the right* (`>>`), and the *bitwise and* (`&`) are used. They
are the core solution for the 6-bit transformation.

There are 3 different scenarios that we need to take into account in this transformation. First, is the perfect scenario,
where we have the perfect window of 3 bytes to work on. Second, we have the scenario where we have a window of only
two bytes to work with. And last, we have the scenario where we have a window of one single byte.

In each of these 3 scenarios, the 6-bit transformation works a bit differently. To make the explanation
easier, I will use the variable `output` to refer to the bytes in the output of the base64 encoder,
and the variable `input` to refer to the bytes in the input of the encoder.


So, if you have the perfect window of 3 bytes, these are steps for the 6-bit transformation:

1. `output[0]` is produced by moving the bits from `input[0]` two positions to the right.
1. `output[1]` is produced by summing two components. First, take the last two bits from `input[0]`, then, move them four positions to the left. Second, move the bits from `input[1]` four positions to the right. Sum these two components.
1. `output[2]` is produced by summing two components. First, take the last four bits from `input[1]`, then, move them two positions to the left. Second, move the bits from `input[2]` six positions to the right. Sum these two components.
1. `output[3]` is produced by taking the last six bits from `input[2]`.


This is the perfect scenario, where we have a full window of 3 bytes to work on.
Just to make things as clear as possible, the @fig-encoder-bitshift demonstrates visually how
the step 2 mentioned above works. So the 2nd byte in the `output` of the encoder, is made by taking the 1st byte (dark purple)
and the 2nd byte (orange) from the input. You can see that, at the end of the process, we get a new
byte that contains the last 2 bits from the 1st byte in the `input`, and the first 4 bits
from the 2nd byte in the `input`.

![How the 2nd byte in the output of the encoder is produced from the 1st byte (dark purple) and the 2nd byte (orange) of the input.](../Figures/base64-encoder-bit-shift.png){#fig-encoder-bitshift}

On the other hand, we must be prepared for the instances where we do not have the perfect window of 3 bytes.
If you have a window of 2 bytes, then, the steps 3 and 4, which produces the bytes `output[2]` and `output[3]`, change a little bit,
and they become:

- `output[2]` is produced by taking the last 4 bits from `input[1]`, then, move them two positions to the left.
- `output[3]` is the character `'='`.


Finally, if you have a window of a single byte, then, the steps 2 to 4, which produces the bytes `output[1]`, `output[2]` and `output[3]` change,
becoming:

- `output[1]` is produced by taking the last two bits from `input[0]`, then, move them four positions to the left.
- `output[2]` and `output[3]` are the character `=`.


If these bullet points were a bit confusing for you, you may find the @tbl-transf-6bit more intuitive.
This table unifies all this logic into a simple table. Notice that
this table also provides the exact expression in Zig that creates the corresponding
byte in the output.


::: {#tbl-transf-6bit}

| Number of bytes in the window | Byte index in the output | In code                                    |
|-------------------------------|--------------------------|--------------------------------------------|
| 3                             | 0                        | input[0] >> 2                              |
| 3                             | 1                        | ((input[0] & 0x03) << 4) + (input[1] >> 4) |
| 3                             | 2                        | ((input[1] & 0x0f) << 2) + (input[2] >> 6) |
| 3                             | 3                        | input[2] & 0x3f                            |
| 2                             | 0                        | input[0] >> 2                              |
| 2                             | 1                        | ((input[0] & 0x03) << 4) + (input[1] >> 4) |
| 2                             | 2                        | ((input[1] & 0x0f) << 2)                   |
| 2                             | 3                        | '='                                        |
| 1                             | 0                        | input[0] >> 2                              |
| 1                             | 1                        | ((input[0] & 0x03) << 4)                   |
| 1                             | 2                        | '='                                        |
| 1                             | 3                        | '='                                        |

: How the 6-bit transformation translates into code in different window settings.

:::






### Bit-shifting in Zig

Bit-shifting in Zig works similarly to bit-shifting in C.
All bitwise operators that exist in C are available in Zig.
Here, in the base64 encoder algorithm, they are essential
to produce the result we want.

For those who are not familiar with these operators, they are
operators that operates at the bit-level of your values.
This means that these operators takes the bits that form the value
you have, and change them in some way. This ultimately also changes
the value itself, because the binary representation of this value
changes.

We have already seen in @fig-encoder-bitshift the effect produced by a bit-shift.
But let's use the first byte in the output of the base64 encoder as another example of what
bit-shifting means. This is the easiest byte of the 4 bytes in the output
to build. Because we only need to move the bits from the first byte in the input two positions to the right,
with the *bit shift to the right* (`>>`) operator.

If we take the string "Hi" that we used in @fig-base64-algo1 as an example, the first byte in
this string is "H", which is the sequence `01001000` in binary.
If we move the bits of this byte, two places to the right, we get the sequence `00010010` as result.
This binary sequence is the value `18` in decimal, and also, the value `0x12` in hexadecimal.
Notice that the first 6 bits of "H" were moved to the end of the byte.
With this operation, we get the first byte of the output.


```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const input = "Hi";
    try stdout.print("{d}\n", .{input[0] >> 2});
    try stdout.flush();
}
```

If you recall @fig-base64-algo1, the first byte present in the output should
be equivalent to the 6-bit group `010010`. Although being visually different, the
sequences `010010` and `00010010` are semantically equal. They mean the same thing.
They both represent the number 18 in decimal, and the value `0x12` in hexadecimal.

So, don't take the "6-bit group" factor so seriously. We do not need necessarily to
get a 6-bit sequence as result. As long as the meaning of the 8-bit sequence we get is the same
of the 6-bit sequence, we are in the clear.



### Selecting specific bits with the `&` operator

If you comeback to @sec-6bit-transf, you will see that, in order to produce
the second and third bytes in the output, we need to select specific
bits from the first and second bytes in the input string. But how
can we do that? The answer relies on the *bitwise and* (`&`) operator.

The @fig-encoder-bitshift already showed you what effect this `&` operator
produces in the bits of its operands. But let's make a clear description of it.

In summary, the `&` operator performs a logical conjunction operation
between the bits of its operands. In more details, the operator `&`
compares each bit of the first operand to the corresponding bit of the second operand.
If both bits are 1, the corresponding result bit is set to 1.
Otherwise, the corresponding result bit is set to 0 [@microsoftbitwiseand].

So, if we apply this operator to the binary sequences `1000100` and `00001101`
the result of this operation is the binary sequence `00000100`. Because only
at the sixth position in both binary sequences we had a 1 value. So any
position where we do not have both binary sequences setted to 1, we get
a 0 bit in the resulting binary sequence.

We lose information about the original bit values
from both sequences in this case. Because we no longer know
if this 0 bit in the resulting binary sequence was produced by
combining 0 with 0, or 1 with 0, or 0 with 1.

As an example, suppose you have the binary sequence `10010111`, which is the number 151 in decimal. How
can we get a new binary sequence which contains only the third and
fourth bits of this sequence?

We just need to combine this sequence with `00110000` (is `0x30` in hexadecimal) using the `&` operator.
Notice that only the third and fourth positions in this binary sequence is setted to 1. As a consequence, only the
third and fourth values of both binary sequences are potentially preserved in the output. All the remaining positions
are setted to zero in the output sequence, which is `00010000` (is the number 16 in decimal).

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const bits = 0b10010111;
    try stdout.print("{d}\n", .{bits & 0b00110000});
    try stdout.flush();
}
```



### Allocating space for the output

As I described in @sec-stack, to store an object in the stack,
this object needs to have a known and fixed length at compile-time. This is an important
limitation for our base64 encoder/decoder case. Because the size of
the output (from both the encoder and decoder) depends
directly on the size of the input.

Having this in mind, we cannot know at compile time which is
the size of the output for both the encoder and decoder.
So, if we can't know the size of the output at compile time,
this means that we cannot store the output for both the encoder
and decoder in the stack.

Consequently, we need to store this output on the heap,
and, as I commented in @sec-heap, we can only
store objects in the heap by using allocator objects.
So, one of the arguments to both the `encode()` and `decode()`
functions, needs to be an allocator object, because
we know for sure that, at some point inside the body of these
functions, we need to allocate space on the heap to
store the output of these functions.

That is why, both the `encode()` and `decode()` functions that I
present in this book, have an argument called `allocator`,
which receives a allocator object as input, identified by
the type `std.mem.Allocator` from the Zig Standard Library.



### Writing the `encode()` function

Now that we have a basic understanding on how the bitwise operators work, and how
exactly they help us to achieve the result we want to achieve. We can now encapsulate
all the logic that we have described in @fig-base64-algo1 and @tbl-transf-6bit into a nice
function that we can add to our `Base64` struct definition, that we started in @sec-base64-table.

You can find the `encode()` function below. Notice that the first argument of this function,
is the `Base64` struct itself. Therefore, this argument clearly signals
that this function is a method from the `Base64` struct.

Because the `encode()` function itself is fairly long,
I intentionally omitted the `Base64` struct definition in this source code,
just for brevity reasons. So, just remember that this function is a public function (or a public method) from the
`Base64` struct.

Furthermore, this `encode()` function has two other arguments:

1. `input` is the input sequence of characters that you want to encode in base64;
1. `allocator` is an allocator object to use in the necessary memory allocations.

I described everything you need to know about allocator objects in @sec-allocators.
So, if you are not familiar with them, I highly recommend you to comeback to
that section, and read it.
By looking at the `encode()` function, you will see that we use this
allocator object to allocate enough memory to store the output of
the encoding process.

The main for loop in the function is responsible for iterating through the entire input string.
In every iteration, we use a `count` variable to count how many iterations we had at the
moment. When `count` reaches 3, then, we try to encode the 3 characters (or bytes) that we have accumulated
in the temporary buffer object (`buf`).

After encoding these 3 characters and storing the result in the `output` variable, we reset
the `count` variable to zero, and start to count again on the next iteration of the loop.
If the loop hits the end of the string, and, the `count` variable is less than 3, then, it means that
the temporary buffer contains the last 1 or 2 bytes from the input.
That is why we have two `if` statements after the for loop. To deal which each possible case.


```{zig}
#| eval: false
pub fn encode(self: Base64,
              allocator: std.mem.Allocator,
              input: []const u8) ![]u8 {

    if (input.len == 0) {
        return "";
    }

    const n_out = try _calc_encode_length(input);
    var out = try allocator.alloc(u8, n_out);
    var buf = [3]u8{ 0, 0, 0 };
    var count: u8 = 0;
    var iout: u64 = 0;

    for (input, 0..) |_, i| {
        buf[count] = input[i];
        count += 1;
        if (count == 3) {
            out[iout] = self._char_at(buf[0] >> 2);
            out[iout + 1] = self._char_at(
                ((buf[0] & 0x03) << 4) + (buf[1] >> 4)
            );
            out[iout + 2] = self._char_at(
                ((buf[1] & 0x0f) << 2) + (buf[2] >> 6)
            );
            out[iout + 3] = self._char_at(buf[2] & 0x3f);
            iout += 4;
            count = 0;
        }
    }

    if (count == 1) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at(
            (buf[0] & 0x03) << 4
        );
        out[iout + 2] = '=';
        out[iout + 3] = '=';
    }

    if (count == 2) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at(
            ((buf[0] & 0x03) << 4) + (buf[1] >> 4)
        );
        out[iout + 2] = self._char_at(
            (buf[1] & 0x0f) << 2
        );
        out[iout + 3] = '=';
        iout += 4;
    }

    return out;
}
```



## Building the decoder logic {#sec-decoder-logic}

Now, we can focus on writing the base64 decoder logic. Remember from @fig-base64-algo2 that,
a base64 decoder does the inverse process of an encoder. So, all we need to do, is to
write a `decode()` function that performs the inverse process that I exposed in @sec-encoder-logic.


### Mapping base64 characters to their indexes {#sec-map-base64-index}

One thing that we need to do, in order to decode a base64-encoded message, is to calculate
the index in the base64 scale of every base64 character that we encounter in the decoder input.

In other words, the decoder receives as input, a sequence of base64 characters. We need
to translate this sequence of characters into a sequence of indexes. These indexes
are the index of each character in the base64 scale. This way, we get the value/byte
that was calculated in the 6-bit transformation step of the encoder process.

There are probably better/faster ways to calculate this, especially using a "divide and conquer"
type of strategy. But for now, I am satisfied with a simple and "brute force" type of strategy.
The `_char_index()` function below contains this strategy.

We are essentially looping through the *lookup table* with the base64 scale,
and comparing the character we got with each character in the base64 scale.
If these characters match, then, we return the index of this character in the
base64 scale as the result.

Notice that, if the input character is `'='`, the function returns the index 64, which is
"out of range" in the scale. But, as I described in @sec-base64-scale,
the character `'='` does not belong to the base64 scale itself.
It's a special and meaningless character in base64.

Also notice that this `_char_index()` function is a method from our `Base64` struct,
because of the `self` argument. Again, I have omitted the `Base64` struct definition in this example
for brevity reasons.

```{zig}
#| eval: false
fn _char_index(self: Base64, char: u8) u8 {
    if (char == '=')
        return 64;

    var i: u8 = 0;
    var output_index: u8 = 0;

    while (i < 64) : (i += 1) {
        if (self._char_at(i) == char)
            break;
        output_index += 1;
    }

    return output_index;
}
```



### The 6-bit transformation

Once again, the core part of the algorithm is the 6-bit transformation.
If we understand the necessary steps to perform this transformation, the rest
of the algorithm becomes much easier.

First of all, before we actually go to the 6-bit transformation,
we need to make sure that we use `_char_index()` to convert the sequence of base64 characters
into a sequence of indexes. So the snippet below is important for the job that will be done.
The result of `_char_index()` is stored in a temporary buffer, and this temporary buffer
is what we are going to use in the 6-bit transformation, instead of the actual `input` object.

```{zig}
#| eval: false
for (0..input.len) |i| {
    buf[i] = self._char_index(input[i]);
}
```

Now, instead of producing 4 bytes (or 4 characters) as output per each window of 3 characters in the input,
a base64 decoder produces 3 bytes (or 3 characters) as output per each window of 4 characters in the input.
Once again, is the inverse process.

So, the steps to produce the 3 bytes in the output are:

1. `output[0]` is produced by summing two components. First, move the bits from `buf[0]` two positions to the left. Second, move the bits from `buf[1]` 4 positions to the right. Then, sum these two components.
1. `output[1]` is produced by summing two components. First, move the bits from `buf[1]` four positions to the left. Second, move the bits from `buf[2]` 2 positions to the right. Then, sum these two components.
1. `output[2]` is produced by summing two components. First, move the bits from `buf[2]` six positions to the left. Then, you sum the result with `buf[3]`.


Before we continue, let's try to visualize how these transformations make the original bytes that we had
before the encoding process. First, think back to the 6-bit transformation performed by the encoder exposed in @sec-encoder-logic.
The first byte in the output of the encoder is produced by moving the bits in the first byte of the input two positions to the right.

If for example the first byte in the input of the encoder was the sequence `ABCDEFGH`, then, the first byte in the output of the encoder would be
`00ABCDEF` (this sequence would be the first byte in the input of the decoder). Now, if the second byte in the input of the encoder was the sequence
`IJKLMNOP`, then, the second byte in the encoder output would be `00GHIJKL` (as we demonstrated in @fig-encoder-bitshift).

Hence, if the sequences `00ABCDEF` and `00GHIJKL` are the first and second bytes, respectively, in the input of the decoder, the
@fig-decoder-bitshift demonstrates visually how these two bytes are transformed into the first byte of the output of the decoder.
Notice that the output byte is the sequence `ABCDEFGH`, which is the original byte from the input of the encoder.

![How the 1st byte in the decoder output is produced from the 1st byte (dark purple) and the 2nd byte (orange) of the input](../Figures/base64-decoder-bit-shift.png){#fig-decoder-bitshift}

The @tbl-6bit-decode presents how the three steps described earlier translate into Zig code:



::: {#tbl-6bit-decode}

| Byte index in the output | In code                       |
|--------------------------|-------------------------------|
| 0                        | (buf[0] << 2) + (buf[1] >> 4) |
| 1                        | (buf[1] << 4) + (buf[2] >> 2) |
| 2                        | (buf[2] << 6) + buf[3]        |

: The necessary steps for the 6-transformation in the decode process.


:::







### Writing the `decode()` function

The `decode()` function below contains the entire decoding process.
We first calculate the size of the output, with
`_calc_decode_length()`, then, we allocate enough memory for this output with
the allocator object.

Three temporary variables are created: 1) `count`, to hold the window count
in each iteration of the for loop; 2) `iout`, to hold the current index in the output;
3) `buf`, which is the temporary buffer that holds the base64 indexes to be
converted through the 6-bit transformation.

Then, in each iteration of the for loop we fill the temporary buffer with the current
window of bytes. When `count` hits the number 4, then, we have a full window of
indexes in `buf` to be converted, and then, we apply the 6-bit transformation
over the temporary buffer.

Notice that we check if the indexes 2 and 3 in the temporary buffer are the number 64, which, if you recall
from @sec-map-base64-index, is when the `_calc_index()` function receives a `'='` character
as input. So, if these indexes are equal to the number 64, the `decode()` function knows
that it can simply ignore these indexes. They are not converted because, as I described before,
the character `'='` has no meaning, despite being the end of meaningful characters in the sequence.
So we can safely ignore them when they appear in the sequence.

```{zig}
#| eval: false
fn decode(self: Base64,
          allocator: std.mem.Allocator,
          input: []const u8) ![]u8 {

    if (input.len == 0) {
        return "";
    }
    const n_output = try _calc_decode_length(input);
    var output = try allocator.alloc(u8, n_output);
    var count: u8 = 0;
    var iout: u64 = 0;
    var buf = [4]u8{ 0, 0, 0, 0 };

    for (0..input.len) |i| {
        buf[count] = self._char_index(input[i]);
        count += 1;
        if (count == 4) {
            output[iout] = (buf[0] << 2) + (buf[1] >> 4);
            if (buf[2] != 64) {
                output[iout + 1] = (buf[1] << 4) + (buf[2] >> 2);
            }
            if (buf[3] != 64) {
                output[iout + 2] = (buf[2] << 6) + buf[3];
            }
            iout += 3;
            count = 0;
        }
    }

    return output;
}
```


## The end result

Now that we have both `decode()` and `encode()` implemented. We have a fully functioning
base64 encoder/decoder implemented in Zig. Here is an usage example of our
`Base64` struct with the `encode()` and `decode()` methods that we have implemented.

```{zig}
#| eval: false
var memory_buffer: [1000]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(
    &memory_buffer
);
const allocator = fba.allocator();

const text = "Testing some more stuff";
const etext = "VGVzdGluZyBzb21lIG1vcmUgc3R1ZmY=";
const base64 = Base64.init();
const encoded_text = try base64.encode(
    allocator, text
);
const decoded_text = try base64.decode(
    allocator, etext
);
try stdout.print(
    "Encoded text: {s}\n", .{encoded_text}
);
try stdout.print(
    "Decoded text: {s}\n", .{decoded_text}
);
try stdout.flush();
```

```
Encoded text: VGVzdGluZyBzb21lIG1vcmUgc3R1ZmY=
Decoded text: Testing some more stuff
```

You can also see the full source code at once, by visiting the official repository of this book[^repo].
More precisely inside the `ZigExamples` folder[^zig-base64-algo].

[^repo]: <https://github.com/pedropark99/zig-book>
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Debugging Zig applications

Being able to debug your applications is essential for any programmer who wants to
do serious programming in any language. That is why, in this chapter, we are going to talk about the
available strategies and tools to debug applications written in Zig.


## Print debugging

We begin with the classic and battle-tested *print debugging* strategy.
The key advantage that debugging offers you is *visibility*.
With *print statements* you can easily see what results and objects
are being produced by your application.

This is the essence of *print debugging* - using
print expressions to see the values that are being generated by your program,
and, as a result, get a much better understanding of how your program
is behaving.

Many programmers often resort to the print functions in Zig, such as the `stdout.print()`,
or, the `std.debug.print()`, to get a better understanding of their programs.
This is a known and old strategy that is very simple and effective, and it's better known within
the programming community as *print debugging*.
In Zig, you can print information to the `stdout` or `stderr` streams of your system.

Let's begin with `stdout`. In order to print something to the `stdout`, you need to get access to a "writer object"
that writes to the `stdout`. First, you need to get a *file descriptor* object that describes the `stdout`.
To do that, call the `stdout()` method of the `std.Io.File` module from
the Zig Standard Library.
After that, you can get the "writer object" by calling the `writer()` method from the *file descriptor* object.

The `print()` method from this *writer* object is a "print formatter" type of a function.
In other words, this method works exactly like the `printf()` function from C,
or, like `println!()` from Rust.
In the first argument of the function, you specify a template string, and,
in the second argument, you provide a list of values (or objects) that you want to insert
into your template message.

Ideally, the template string in the first argument should contain some format specifier.
Each format specifier is matched to a value (or object) that you have listed in the second argument.
So, if you provided 5 different objects in the second argument, then, the template string
should contain 5 format specifiers, one for each object provided.

Each format specifier is represented by a single letter, and
you provide this format specifier inside a pair of curly braces. So, if you want to format
your object using the string specifier (`s`), then, you can insert the text `{s}` in your template string.
Here is a quick list of the most used format specifiers:

- `d`: for printing integers and floating-point numbers.
- `c`: for printing characters.
- `s`: for printing strings.
- `p`: for printing memory addresses.
- `x`: for printing hexadecimal values.
- `any`: use any compatible format specifier (i.e., it automatically selects a format specifier for you).

The code example below gives you an example of use of this `print()` method
with the `d` format specifier.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
fn add(x: u8, y: u8) u8 {
    return x + y;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const result = add(34, 16);
    try stdout.print("Result: {d}", .{result});
    try stdout.flush();
}
```

It's important to emphasize that, the `stdout.print()` method, as you would expect,
prints your template string into the `stdout` stream of your system.
However, you can also print your template string into the `stderr` stream
if your prefer. All you need to do, is to replace the `stdout.print()`
call with the function `std.debug.print()`. Like this:

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
fn add(x: u8, y: u8) u8 {
    return x + y;
}

pub fn main() !void {
    const result = add(34, 16);
    std.debug.print("Result: {d}\n", .{result});
}
```


You could also achieve the exact same result by getting a file descriptor object to `stderr`,
then, creating a *writer* object to `stderr`, then, using the `print()` method of this
*writer* object, like in the example below:

```{zig}
#| eval: false
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stderr_buffer: [1024]u8 = undefined;
    var stderr_writer = std.Io.File.stderr().writer(init.io, &stderr_buffer);
    const stderr = &stderr_writer.interface;
    // some more lines ...
    try stderr.print("Result: {d}", .{result});
}
```



## Debugging through debuggers

Although *print debugging* is a valid and very useful strategy,
most programmers prefer to use a debugger to debug their programs.
Since Zig is a low-level language, you can use either GDB (GNU Debugger),
or LLDB (LLVM Project Debugger) as your debugger.

Both debuggers can work with Zig code, and it's a matter of taste here.
You choose the debugger of your preference, and you work with it.
In this book, I will use LLDB as my debugger in the examples.


### Compile your source code in debug mode {#sec-compile-debug-mode}

In order to debug your program through a debugger, you must compile
your source code in `Debug` mode. Because when you compile your
source code in other modes (such as `Release`), the compiler usually
strips out some essential information that is used by the debugger
to read and track your program, like PDB (*Program Database*) files.

By compiling your source code in `Debug` mode, you ensure that the debugger
will find the necessary information in your program to debug it.
By default, the compiler uses the `Debug` mode when compiling your code.
Having this in mind, when you compile your program with the `build-exe`
command (which was described in @sec-compile-code), if you don't specify
an explicit mode through the `-O` command-line [^oargument]
argument, then, the compiler will compile your code in `Debug` mode.

[^oargument]: See <https://ziglang.org/documentation/master/#Debug>.


### Let's debug a program

As an example, let's use LLDB to navigate and investigate the following
piece of Zig code:

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
fn add_and_increment(a: u8, b: u8) u8 {
    const sum = a + b;
    const incremented = sum + 1;
    return incremented;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var n = add_and_increment(2, 3);
    n = add_and_increment(n, n);
    try stdout.print("Result: {d}!\n", .{n});
    try stdout.flush();
}
```

There is nothing wrong with this program. But it's
a good start for us. First, we need to compile
this program with the `zig build-exe` command.
For this example, suppose that I have compiled the above
Zig code into a binary executable called `add_program`.

```bash
zig build-exe add_program.zig
```

Now, we can start LLDB with `add_program`, like this:

```bash
lldb add_program
```

From now on, LLDB is started, and you can know that I'm
executing LLDB commands by looking at the prefix `(lldb)`.
If something is prefixed with `(lldb)`, then you know
that it's a LLDB command.

The first thing I will do, is to set a breakpoint at
the `main()` function, by executing `b main`.
After that, I just start the execution of the program
with `run`.
You can see in the output below, that the execution
stopped at the first line in the function `main()`, as we expected.

```bash
(lldb) b main
Breakpoint 1: where = debugging`debug1.main + 22
    at debug1.zig:11:30, address = 0x00000000010341a6
(lldb) run
Process 8654 launched: 'add_program' (x86_64)
Process 8654 stopped
* thread #1, name = 'add_program',
    stop reason = breakpoint 1.1 frame #0: 0x10341a6
    add_program`debug1.main at add_program.zig:11:30
   8   	}
   9
   10  	pub fn main() !void {
-> 11  	    var n = add_and_increment(2, 3);
   12  	    n = add_and_increment(n, n);
   13  	    try stdout.print("Result: {d}!\n", .{n});
   14  	}
```

I can start navigating through the code, and checking the objects
that are being generated. If you are not familiar with the commands
available in LLDB, I recommend you to read the official documentation
of the project[^lldb].
You can also look for cheat sheets, which quickly describes all commands
available for you[^lldb-quick-list].

[^lldb]: <https://lldb.llvm.org/>
[^lldb-quick-list]: <https://gist.github.com/ryanchang/a2f738f0c3cc6fbd71fa>.

Currently, we are in the first line at the `main()` function. In this line, we create
the `n` object, by executing the `add_and_increment()` function.
To execute the current line of code, and go to the next line, we can
run the `n` LLDB command. Let's execute this command.

After we executed this line, we can also look at the value stored inside this `n` object
by using the `p` LLDB command. The syntax for this command is `p <name-of-object>`.

If we take a look at the value stored in the `n` object (`p n`),
notice that it stores the hexadecimal value `0x06`, which
is the number 6 in decimal. We can also see that this value has a type of `unsigned char`,
which is an unsigned 8-bit integer.
We have talked already about this in @sec-zig-strings, that `u8` integers in Zig are equivalent
to the C data type `unsigned char`.



```bash
(lldb) n
Process 4798 stopped
* thread #1, name = 'debugging',
    stop reason = step over frame #0: 0x10341ae
    debugging`debug1.main at debug1.zig:12:26
   9
   10  	pub fn main() !void {
   11  	    var n = add_and_increment(2, 3);
-> 12  	    n = add_and_increment(n, n);
   13  	    try stdout.print("Result: {d}!\n", .{n});
   14  	}
(lldb) p n
(unsigned char) $1 = '\x06'
```

Now, on the next line of code, we are executing the `add_and_increment()` function once again.
Why not step inside this function? Shall we? We can do that, by executing the `s` LLDB command.
Notice in the example below that, after executing this command, we have entered into the context of the
`add_and_increment()` function.

Also notice in the example below that, I have walked two more lines in the function's body, then,
I execute the `frame variable` LLDB command, to see at once, the value stored in each of the variables
that were created inside the current scope.

You can see in the output below that, the object `sum` stores the value `\f`,
which represents the *form feed* character. This character in the ASCII table,
corresponds to the hexadecimal value `0x0C`, or, in decimal, the number 12.
So, this means that the result of the expression `a + b` executed at line
5, resulted in the number 12.

```bash
(lldb) s
Process 4798 stopped
* thread #1, name = 'debugging',
    stop reason = step in frame #0: 0x10342de
    debugging`debug1.add_and_increment(a='\x02', b='\x03')
    at debug1.zig:4:39
-> 4   	fn add_and_increment(a: u8, b: u8) u8 {
   5   	    const sum = a + b;
   6   	    const incremented = sum + 1;
   7   	    return incremented;
(lldb) n
(lldb) n
(lldb) frame variable
(unsigned char) a = '\x06'
(unsigned char) b = '\x06'
(unsigned char) sum = '\f'
(unsigned char) incremented = '\x06'
```



## How to investigate the data type of your objects

Since Zig is a strongly-typed language, the data types associated with your objects
are very important for your program. So, debugging the data types associated
with your objects might be important to understand bugs and errors in your program.

When you walk through your program with a debugger, you can inspect the types of
your objects by simply printing them to the console, with the LLDB `p` command.
But you also have alternatives embedded in the language itself to access the data
types of your objects.

In Zig, you can retrieve the data type of an object, by using the built-in function
`@TypeOf()`. Just apply this function over the object, and you get access to
the data type of the object.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
const expect = std.testing.expect;
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const number: i32 = 5;
    try expect(@TypeOf(number) == i32);
    try stdout.print("{any}\n", .{@TypeOf(number)});
    try stdout.flush();
}
```

This function is similar to the `type()` built-in function from Python,
or, the `typeof` operator in Javascript.
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Pointers and Optionals {#sec-pointer}

On our next project we are going to build a HTTP server from scratch.
But in order to do that, we need to learn more about pointers and how they work in Zig.
Pointers in Zig are similar to pointers in C. But they come with some extra advantages in Zig.

A pointer is an object that contains a memory address. This memory address is the address where
a particular value is stored in memory. It can be any value. Most of the times,
it's a value that comes from another object (or variable) present in our code.

In the example below, I'm creating two objects (`number` and `pointer`).
The `pointer` object contains the memory address where the value of the `number` object
(the number 5) is stored. So, that is a pointer in a nutshell. It's a memory
address that points to a particular existing value in the memory. You could
also say, that, the `pointer` object points to the memory address where the `number` object is
stored.


```{zig}
#| build_type: "run"
#| auto_main: true
const number: u8 = 5;
const pointer = &number;
_ = pointer;
```

We create a pointer object in Zig by using the `&` operator. When you put this operator
before the name of an existing object, you get the memory address of this object as result.
When you store this memory address inside a new object, this new object becomes a pointer object.
Because it stores a memory address.

People mostly use pointers as an alternative way to access a particular value.
For example, I can use the `pointer` object to access the value stored by
the `number` object. This operation of accessing the value that the
pointer "points to" is normally called of *dereferencing the pointer*.
We can dereference a pointer in Zig by using the `*` method of the pointer object. Like in the example
below, where we take the number 5 pointed by the `pointer` object,
and double it.

```{zig}
#| build_type: "run"
#| auto_main: true
const number: u8 = 5;
const pointer = &number;
const doubled = 2 * pointer.*;
std.debug.print("{d}\n", .{doubled});
```


This syntax to dereference the pointer is nice. Because we can easily chain it with
methods of the value pointed by the pointer. We can use the `User` struct that we have
created in @sec-structs-and-oop as an example. If you comeback to that section,
you will see that this struct have a method named `print_name()`.

So, for example, if we have an user object, and a pointer that points to this user object,
we can use the pointer to access this user object, and, at the same time, call the method `print_name()`
on it, by chaining the dereference method (`*`) with the `print_name()` method. Like in the
example below:


```{zig}
#| eval: false
const u = User.init(1, "pedro", "email@gmail.com");
const pointer = &u;
try pointer.*.print_name();
```

```
pedro
```

We can also use pointers to effectively alter the value of an object.
For example, I could use the `pointer` object to set
the value of the object `number` to 6, like in the example below.


```{zig}
#| auto_main: true
#| build_type: "run"
var number: u8 = 5;
const pointer = &number;
pointer.* = 6;
try stdout.print("{d}\n", .{number});
try stdout.flush();
```


Therefore, as I mentioned earlier, people use pointers as an alternative way to access a particular value.
And they use it especially when they do not want to "move" these values around. There are situations where,
you want to access a particular value in a different scope (i.e., a different location) of your code,
but you do not want to "move" this value to this new scope (or location) that you are in.

This matters especially if this value is big in size. Because if it is, then,
moving this value becomes an expensive operation to do.
The computer will have to spend a considerable amount of time
copying this value to this new location.

Therefore, many programmers prefer to avoid this heavy operation of copying the value
to the new location, by accessing this value through pointers.
We are going to talk more about this "moving operation" over the next sections.
For now, just keep in mind that avoiding this "move operation" is
one of main reasons why pointers are used in programming languages.





## Constant objects vs variable objects {#sec-pointer-var}

You can have a pointer that points to a constant object, or, a pointer that points to a variable object.
But regardless of who this pointer is, a pointer **must always respect the characteristics of the object that it points to**.
As a consequence, if the pointer points to a constant object, then, you cannot use this pointer
to change the value that it points to. Because it points to a value that is constant. As we discussed in @sec-assignments, you cannot
change a value that is constant.

For example, if I have a `number` object, which is constant, I cannot execute
the expression below where I'm trying to change the value of `number` to 6 through
the `pointer` object. As demonstrated below, when you try to do something
like that, you get a compile time error:

```{zig}
#| eval: false
const number = 5;
const pointer = &number;
pointer.* = 6;
```

```
p.zig:6:12: error: cannot assign to constant
    pointer.* = 6;
```

If I change the `number` object to be a variable object, by introducing the `var` keyword,
then, I can successfully change the value of this object through a pointer, as demonstrated below:

```{zig}
#| auto_main: true
#| build_type: "run"
var number: u8 = 5;
const pointer = &number;
pointer.* = 6;
try stdout.print("{d}\n", .{number});
try stdout.flush();
```

You can see this relationship between "constant versus variable" on the data type of
your pointer object. In other words, the data type of a pointer object already gives you
some clues about whether the value that it points to is constant or not.

When a pointer object points to a constant value, then, this pointer have a data type `*const T`,
which means "a pointer to a constant value of type `T`".
In contrast, if the pointer points to a variable value, then, the type of the pointer is usually `*T`, which is
simply "a pointer to a value of type `T`".
Hence, whenever you see a pointer object whose data type is in the format `*const T`, then,
you know that you cannot use this pointer to change the value that it points to.
Because this pointer points to a constant value of type `T`.


We have talked about the value pointed by the pointer being constant or not,
and the consequences that arises from it. But, what about the pointer object itself? I mean, what happens
if the pointer object itself is constant or not? Think about it.
We can have a constant pointer that points to a constant value.
But we can also have a variable pointer that points to a constant value. And vice-versa.

Until this point, the `pointer` object was always constant,
but what does this mean for us? What is the consequence of the
`pointer` object being constant? The consequence is that
we cannot change the pointer object, because it is constant. We can use the
pointer object in multiple ways, but we cannot change the
memory address that is inside this pointer object.

However, if we mark the `pointer` object as a variable object,
then, we can change the memory address pointed by this `pointer` object.
The example below demonstrates that. Notice that the object pointed
by the `pointer` object changes from `c1` to `c2`.

```{zig}
#| eval: false
const c1: u8 = 5;
const c2: u8 = 6;
var pointer = &c1;
try stdout.print("{d}\n", .{pointer.*});
pointer = &c2;
try stdout.print("{d}\n", .{pointer.*});
try stdout.flush();
```

```
5
6
```

Thus, by setting the `pointer` object to a `var` or `const` object,
you specify if the memory address contained in this pointer object can change or not
in your program. On the other side, you can change the value pointed by the pointer,
if, and only if this value is stored in a variable object. If this value
is in a constant object, then, you cannot change this value through a pointer.


## Types of pointer

In Zig, there are two types of pointers [@zigdocs], which are:

- single-item pointer (`*`);
- many-item pointer (`[*]`);


Single-item pointer objects are objects whose data types are in the format `*T`.
So, for example, if an object have a data type `*u32`, it means that, this
object contains a single-item pointer that points to an unsigned 32-bit integer value.
As another example, if an object have type `*User`, then, it contains
a single-item pointer to an `User` value.

In contrast, many-item pointers are objects whose data types are in the format `[*]T`.
Notice that the star symbol (`*`) is now inside a pair of brackets (`[]`). If the star
symbol is inside a pair of brackets, you know that this object is a many-item pointer.

When you apply the `&` operator over an object, you will always get a single-item pointer.
Many-item pointers are more of a "internal type" of the language, more closely
related to slices. So, when you deliberately create a pointer with the `&` operator,
you always get a single-item pointer as result.



## Pointer arithmetic

Pointer arithmetic is available in Zig, and they work the same way they work in C.
When you have a pointer that points to an array, the pointer usually points to
the first element in the array, and you can use pointer arithmetic to
advance this pointer and access the other elements in the array.


Notice in the example below, that initially, the `ptr` object was pointing
to the first element in the array `ar`. But then, I started to walk through the array, by advancing
the pointer with simple pointer arithmetic.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "run"
#| results: "hide"
const ar = [_]i32{ 1, 2, 3, 4 };
var ptr: [*]const i32 = &ar;
try stdout.print("{d}\n", .{ptr[0]});
ptr += 1;
try stdout.print("{d}\n", .{ptr[0]});
ptr += 1;
try stdout.print("{d}\n", .{ptr[0]});
try stdout.flush();
```

```
1
2
3
```

Although you can create a pointer to an array like that, and
start to walk through this array by using pointer arithmetic,
in Zig, we prefer to use slices, which were presented in @sec-arrays.

Behind the hood, slices already are pointers,
and they also come with the `len` property, which indicates
how many elements are in the slice. This is good because the `zig` compiler
can use it to check for potential buffer overflows, and other problems like that.

Also, you don't need to use pointer arithmetic to walk through the elements
of a slice. You can simply use the `slice[index]` syntax to directly access
any element you want in the slice.
As I mentioned in @sec-arrays, you can get a slice from an array by using
a range selector inside brackets. In the example below, I'm creating
a slice (`sl`) that covers the entire `ar` array. I can access any
element of `ar` from this slice, and, the slice itself already is a pointer
behind the hood.

```{zig}
#| auto_main: true
#| build_type: "run"
const ar = [_]i32{1,2,3,4};
const sl = ar[0..ar.len];
_ = sl;
```


## Optionals and Optional Pointers

Let's talk about optionals and how they relate to pointers in Zig.
By default, objects in Zig are **non-nullable**. This means that, in Zig,
you can safely assume that any object in your source code is not null.

This is a powerful feature of Zig when you compare it to the developer experience in C.
Because in C, any object can be null at any point, and, as consequence, a pointer in C
might point to a null value. This is a common source of undefined behaviour in C.
When programmers work with pointers in C, they have to constantly check if
their pointers are pointing to null values or not.

In contrast, when working in Zig, if for some reason, your Zig code produces a null value somewhere, and, this null
value ends up in an object that is non-nullable, a runtime error is always
raised by your Zig program. Take the program below as an example.
The `zig` compiler can see the `null` value at compile time, and, as result,
it raises a compile time error. But, if a `null` value is raised during
runtime, a runtime error is also raised by the Zig program, with a
"attempt to use null value" message.

```{zig}
#| eval: false
var number: u8 = 5;
number = null;
```
```
p5.zig:5:14: error: expected type 'u8',
        found '@TypeOf(null)'
    number = null;
             ^~~~
```


You don't get this type of safety in C.
In C, you don't get warnings or errors about null values being produced in your program.
If for some reason, your code produces a null value in C, most of the times, you end up getting a segmentation fault error
as result, which can mean many things.
That is why programmers have to constantly check for null values in C.

Pointers in Zig are also, by default, **non-nullable**. This is another amazing
feature in Zig. So, you can safely assume that any pointer that you create in
your Zig code is pointing to a non-null value.
Therefore, you don't have this heavy work of checking if the pointers you create
in Zig are pointing to a null value.


### What are optionals?

Ok, we know now that all objects are non-nullable by default in Zig.
But what if we actually need to use an object that might receive a null value?
Here is where optionals come in.

An optional object in Zig is rather similar to a [`std::optional` object in C++](https://en.cppreference.com/w/cpp/utility/optional.html).
It is an object that can either contain a value, or nothing at all (a.k.a. the object can be null).
To mark an object in our Zig code as "optional", we use the `?` operator. When you put
this `?` operator right before the data type of an object, you transform
this data type into an optional data type, and the object becomes an optional object.

Take the snippet below as an example. We are creating a new variable object
called `num`. This object have the data type `?i32`, which means that,
this object contains either a signed 32-bit integer (`i32`), or, a null value.
Both alternatives are valid values to the `num` object.
That is why, I can actually change the value of this object to null, and,
no errors are raised by the `zig` compiler, as demonstrated below:

```{zig}
#| auto_main: true
#| build_type: "run"
var num: ?i32 = 5;
num = null;
```

### Optional pointers

You can also mark a pointer object as an optional pointer, meaning that,
this object contains either a null value, or, a pointer that points to a value.
When you mark a pointer as optional, the data type of this pointer object
becomes `?*const T` or `?*T`, depending if the value pointed by the pointer
is a constant value or not. The `?` identifies the object as optional, while
the `*` identifies it as a pointer object.

In the example below, we are creating a variable object named `num`, and an
optional pointer object named `ptr`. Notice that the data type of the object
`ptr` indicates that it's either a null value, or a pointer to an `i32` value.
Also, notice that the pointer object (`ptr`) can be marked as optional, even if
the object `num` is not optional.

What this code tells us is that, the `num` variable will never contain a null value.
This variable will always contain a valid `i32` value. But in contrast, the `ptr` object might contain either a null
value, or, a pointer to an `i32` value.

```{zig}
#| auto_main: true
#| build_type: "run"
var num: i32 = 5;
var ptr: ?*i32 = &num;
ptr = null;
num = 6;
```

But what happens if we turn the table, and mark the `num` object as optional,
instead of the pointer object. If we do that, then, the pointer object is
not optional anymore. It would be a similar (although different) result. Because then, we would have
a pointer to an optional value. In other words, a pointer to a value that is either a
null value, or, a not-null value.

In the example below, we are recreating this idea. Now, the `ptr` object
have a data type of `*?i32`, instead of `?*i32`. Notice that the `*` symbol comes before of `?`
this time. So now, we have a pointer that points to a value that is either null
, or, a signed 32-bit integer.

```{zig}
#| auto_main: true
#| build_type: "run"
var num: ?i32 = 5;
// ptr have type `*?i32`, instead of `?*i32`.
const ptr = &num;
_ = ptr;
```


### Null handling in optionals {#sec-null-handling}

When you have an optional object in your Zig code, you have to explicitly handle
the possibility of this object being null. It's like error-handling with `try` and `catch`.
In Zig you also have to handle null values like if they were a type of error.

We can do that, by using either:

- an if statement, like you would do in C.
- the `orelse` keyword.
- unwrap the optional value with the `?` method.

When you use an if statement, you use a pair of pipes
to unwrap the optional value, and use this "unwrapped object"
inside the if block.
Using the example below as a reference, if the object `num` is null,
then, the code inside the if statement is not executed. Otherwise,
the if statement will unwrap the object `num` into the `not_null_num`
object. This `not_null_num` object is guaranteed to be not null inside
the scope of the if statement.

```{zig}
#| auto_main: true
#| build_type: "run"
const num: ?i32 = 5;
if (num) |not_null_num| {
    try stdout.print("{d}\n", .{not_null_num});
    try stdout.flush();
}
```

Now, the `orelse` keyword behaves like a binary operator. You connect two expressions with this keyword.
On the left side of `orelse`, you provide the expression that might result
in a null value, and on the right side of `orelse`, you provide another expression
that will not result in a null value.

The idea behind the `orelse` keyword is: if the expression on the left side
result in a not-null value, then, this not-null value is used. However,
if this expression on the left side result in a null value, then, the value
of the expression on the right side is used instead.

Looking at the example below, since the `x` object is currently null, the
`orelse` decided to use the alternative value, which is the number 15.

```{zig}
#| auto_main: true
#| build_type: "run"
const x: ?i32 = null;
const dbl = (x orelse 15) * 2;
try stdout.print("{d}\n", .{dbl});
try stdout.flush();
```

You can use the if statement or the `orelse` keyword, when you want to
solve (or deal with) this null value. However, if there is no clear solution
to this null value, and the most logic and sane path is to simply panic
and raise a loud error in your program when this null value is encountered,
you can use the `?` method of your optional object.

In essence, when you use this `?` method, the optional object is unwrapped.
If a not-null value is found in the optional object, then, this not-null value is used.
Otherwise, the `unreachable` keyword is used. You can read more about this
[`unreacheable` keyword at the official documentation](https://ziglang.org/documentation/master/#unreachable)[^un-docs].
But in essence, when you build your Zig source code using the build modes `ReleaseSafe` or `Debug`, this
`unreacheable` keyword causes the program to panic and raise an error during runtime,
like in the example below:

```{zig}
#| eval: false
const std = @import("std");
fn return_null(n: i32) ?i32 {
    if (n == 5) return null;
    return n;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const y: ?i32 = return_null(5);
    try stdout.print("{d}\n", .{y.?});
    try stdout.flush();
}
```

```
thread 12767 panic: attempt to use null value
p7.zig:12:34: 0x103419d in main (p7):
    try stdout.print("{d}\n", .{y.?});
                                 ^
```


[^un-docs]: <https://ziglang.org/documentation/master/#unreachable>.
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Project 2 - Building a HTTP Server from scratch

In this chapter, I want to implement a new
small project with you. This time, we are going
to implement a basic HTTP Server from scratch.

The Zig Standard Library already have a HTTP Server
implemented, which is available at `std.http.Server`.
But again, our objective here in this chapter, is to implement
it **from scratch**. So we can't use this server object available
from the Zig Standard Library.

## What is a HTTP Server?

First of all, what is a HTTP Server?
A HTTP server, as any other type of server, is essentially
a program that runs indefinitely, on an infinite loop, waiting for incoming connections
from clients. Once the server receives an incoming connection, it will
accept this connection, and it will send messages back-and-forth to the client
through this connection.

But the messages that are transmitted inside this connection are in a
specific format. They are HTTP messages
(i.e., messages that use the HTTP Protocol specification).
The HTTP Protocol is the backbone of the modern web.
The world wide web as we know it today, would not exist without the
HTTP Protocol.

So, Web servers (which is just a fancy name to
HTTP Servers) are servers that exchange HTTP messages with clients.
And these HTTP servers and the HTTP Protocol specification
are essential to the operation of the world wide web today.

That is the whole picture of the process.
Again, we have two subjects involved here, a server (which is
a program that is running indefinitely, waiting to receive incoming connections),
and a client (which is someone that wants to connect to the server,
and exchange HTTP messages with it).

You may find the material about the [HTTP Protocol available at the Mozilla MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)[^mdn-http]
, a great resource for you to also look at. It gives you a great overview on how
HTTP works, and what role the server plays in this matter.

[^mdn-http]: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview>.


## How a HTTP Server works? {#sec-how-http-works}

Imagine a HTTP Server as if it were the receptionist of a large hotel. In a hotel,
you have a reception, and inside that reception there is a receptionist
waiting for customers to arrive. A HTTP Server is essentially a receptionist
that is indefinitely waiting for new customers (or, in the context of HTTP, new clients)
to arrive in the hotel.

When a customer arrives at the hotel, that customer starts a conversation with the
receptionist. He tells the receptionist how many days he wants to stay at the hotel.
Then, the receptionist search for an available apartment. If there is an available apartment
at the moment, the customer pays the hotel fees, then, he gets the keys to the apartment,
and then, he goes to the apartment to rest.

After this entire process of dealing with the customer (searching for available apartments,
receiving payment, handing over the keys), the receptionist goes back to what he was
doing earlier, which is to wait. Wait for new customers to arrive.

That is, in a nutshell, what a HTTP Server do. It waits for clients to connect to the
server. When a client attempts to connect to the server, the server accepts this connection,
and it starts to exchange messages with the client through this connection.
The first message that happens inside this connection is always a message from the client
to the server. This message is called the *HTTP Request*.

This HTTP Request is a HTTP message that contains what
the client wants from the server. It is literally a request. The client
that connected to the server is asking this server to do something for him.

There are different "types of request" that a client can send to a HTTP Server.
But the most basic type of request, is when a client ask to the
HTTP Server to serve (i.e., to send) some specific web page (which is a HTML file) to him.
When you type `google.com` in your web browser, you are essentially sending a HTTP Request to Google's
HTTP servers. This request is asking these servers to send the Google webpage to you.

Nonetheless, when the server receives this first message, the *HTTP Request*, it
analyzes this request, to understand: who the client is? What he wants the server to do?
This client has provided all the necessary information to perform the action that he
asked? Etc.

Once the server understands what the client wants, he simply perform the action
that was requested, and, to finish the whole process, the server sends back
a HTTP message to the client, informing if the action performed was successful or not,
and, at last, the server ends (or closes) the connection with the client.

This last HTTP message sent from the server to the client, is called the *HTTP Response*.
Because the server is responding to the action that was requested by the client.
The main objective of this response message is let the client know if the
action requested was successful or not, before the server closes the connection.


## How a HTTP server is normally implemented? {#sec-http-how-impl}

Let's use the C language as an example. There are many materials
teaching how to write a simple HTTP server in C code, like @jeffrey_http,
or @nipun_http, or @eric_http.
Having this in mind, I will not show C code examples here, because you
can find them on the internet.
But I will describe the theory behind the necessary steps to create
such HTTP server in C.


In essence, we normally implement a HTTP server in C by using a TCP socket,
which involves the following steps:

1. Create a TCP socket object.
1. Bind a name (or more specifically, an address) to this socket object.
1. Make this socket object to start listening and waiting for incoming connections.
1. When a connection arrive, we accept this connection, and we exchange the HTTP messages (HTTP Request and HTTP Response).
1. Then, we simply close this connection.


A socket object is essentially a channel of communication.
You are creating a channel where people can send messages through.
When you create a socket object, this object is not binded to any particular
address. This means that with this object you have a representation of a channel of communication
in your hands. But this channel is not currently available, or, it is not currently accessible,
because it does not have a known address where you can find it.

That is what the "bind" operation do. It binds a name (or more specifically, an address) to
this socket object, or, this channel of communication, so that it becomes available,
or, accessible through this address. While the "listen" operation makes the socket object to
listen for incoming connections in this address. In other words, the "listen" operation
makes the socket wait for incoming connections.

Now, when a client actually attempts to connect to the server through the socket address
that we have specified, in order to establish this connection with the client,
the socket object needs to accept this incoming connection. Thus, when we
accept an incoming connection, the client and the server become
connected to each other, and they can start reading or writing messages into this
established connection.

After we receive the HTTP Request from the client, analyze it, and send the HTTP Response
to the client, we can then close the connection, and end this communication.


## Implementing the server - Part 1

### Creating the server object {#sec-create-socket}

Let's begin by writing the code responsible for listening and accepting incoming connections
to our server. Just to make things shorter, I will write this code inside a separate Zig module,
named `server.zig`.

Now, we essentially need to create a TCP socket object in our code. On previous versions of this book, we've decided
to create such TCP socket through the the `std.posix.socket()` function, from the Zig Standard Library.
But, with the introduction of the new IO interface in Zig 0.16, this function fit's weird on
the new `std.Io.net.Stream` API.

Because of that, I will take a different route this time. In summary, we are going to create
a TCP socket through the [`listen()` method from `std.Io.net.IpAddress`](https://ziglang.org/documentation/master/std/#std.Io.net.IpAddress.listen)[^listen-ipaddress].
Then, with this TCP socket represented by the `std.Io.net.Server` type, we use the `accept()` method to establish the connection
between our server and the client. Through this "connection object" that we get from `accept()` we get access to a
stream, from which we can exchange messages between the server and the client.

[^listen-ipaddress]: <https://ziglang.org/documentation/master/std/#std.Io.net.IpAddress.listen>

As I mentioned earlier in @sec-http-how-impl, every socket object that we create
represents a communication channel, and we need to bind this channel to a specific address.
An "address" is defined as an IP address, or, more specifically, an IPv4 address^[It can be also an IPv6 address. But normally, we use a IPv4 address for that.].
Every IPv4 address is composed by two components. The first component is the host,
which is a sequence of 4 numbers separated by dot characters (`.`) that identifies the machine used.
While the second component is a port number, which identifies the specific
door, or, the specific port to use in the host machine.

The sequence of 4 numbers (i.e., the host) identifies the machine (i.e., the computer itself) where
this socket will live in. Every computer normally have multiple "doors" available inside of him, because
this allows the computer to receive and work with multiple connections at the same time.
He simply use a single door for each connection. So the port number, is
essentially a number that identifies the "door" in the computer that the socket will use
to receive incoming connections.

To make things simpler, I will use an IP address that identifies our current machine in this example.
This means that, our socket object will reside on the same computer that we are currently using
(this is also known as the "localhost") to write this Zig source code.
By convention, the IP address that identifies the "localhost", which is the current machine we
are using, is the IP `127.0.0.1`. So, that is the IP
address we are going to use in our server.

Now, we need to decide which port number to use. By convention, there are some
port numbers that are reserved, meaning that, we cannot use them for our own
purposes, like the port 22 (which is normally used for SSH connections).
For TCP connections, which is our case here,
a port number is a 16-bit unsigned integer (type `u16` in Zig),
thus ranging from 0 to 65535 [@wikipedia_port].
So, we can choose
a number from 0 to 65535 for our port number. In the
example of this book, I will use the port number 3490
(just a random number).


All of this process and steps that we've described are concentrated inside our own custom struct
called `Server`, which is exposed below. Notice that we create a new `std.Io.net.IpAddress`
object inside this struct. We also create our `std.Io.net.Server` object through the `listen()`
method from our IP address object.


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
const Socket = std.Io.net.Socket;
const Protocol = std.Io.net.Protocol;

pub const Server = struct {
    host: []const u8,
    port: u16,
    addr: std.Io.net.IpAddress,
    io: std.Io,

    pub fn init(io: std.Io) !Server {
        const host: []const u8 = "127.0.0.1";
        const port: u16 = 3490;
        const addr = try std.Io.net.IpAddress.parseIp4(
            host, port
        );

        return .{.host=host, .port=port, .addr=addr, .io=io};
    }

    pub fn listen(self: Server) !std.Io.net.Server {
        std.debug.print("Server Addr: {s}:{any}\n", .{self.host, self.port});
        return try self.addr.listen(
            self.io,
            .{.mode=Socket.Mode.stream, .protocol=Protocol.tcp}
        );
    }
};
```


### Listening and receiving connections


Remember that our `Server` struct declaration that we've built in @sec-create-socket is inside a Zig module named `server.zig`.
This is why I have imported this module into our main module (`main.zig`) in the example below, to access our `Server` struct.

Now, the socket stored inside our `Server` object needs to start listening and accepting new connections.
We can do that by calling the method `listen()` from it, and then, calling the `accept()` method from the result.
If you run the main module exposed below, you will notice that the program never ends. It just keeps stuck.

This happens, because the program is waiting for something to happen.
It's waiting for someone to try to connect to the address (`127.0.0.1:3490`) where
the server is running and listening for incoming connections. This is what
the `listen()` method do, it makes the socket to be active waiting for someone
to connect.

On the other side, the `accept()` method is the function that establishes the connection
when someone tries to connect to the socket. This means that, the `accept()` method
returns a new connection object as a result. And you can use this connection object
to read or write messages from or to the client.
For now, we are not doing anything with this connection object.
But we are going to use it in the next section.


```{zig}
#| eval: false
const std = @import("std");
const Server = @import("server.zig").Server;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);
}
```

This code example allows one single connection. In other words, the
server will wait for one incoming connection, and as soon as the
server is done with this first connection that it establishes, the
program ends, and the server stops.

This is not the norm in the real world. Most people that write
a HTTP server like this, usually put the `accept()` method
inside a `while` (infinite) loop, where if a connection
is created with `accept()`, a new thread of execution is created to deal with
this new connection and the client. That is, real-world examples of HTTP Servers
normally rely on parallel computing to work.

With this design, the server simply accepts the connection,
and the whole process of dealing with the client, and receiving
the HTTP Request, and sending the HTTP Response, all of this
is done in the background, on a separate execution thread.

So, as soon as the server accepts the connection, and creates
the separate thread, the server goes back to what he was doing earlier,
which is to wait indefinitely for a new connection to accept.
Having this in mind, the code example exposed above, is a
server that serves only a single client. Because the program
terminates as soon as the connection is accepted.



### Reading the message from the client {#sec-read-http-message}

Now that we have a connection established, i.e., the connection
object that we created through the `accept()` function, we can now
use this connection object to read any messages that the client
send to our server. But we can also use it to send messages back
to the client.

The basic idea is, if we **write** any data into this connection object,
then, we are sending data to the client, and if we **read** the data present in
this connection object, then, we are reading any data that the
client sent to us, through this connection object. So, just
have this logic in mind. "Read" is for reading messages from the client,
and "write" is to send a message to the client.

Remember from @sec-how-http-works that, the first thing that we need to do is to read the HTTP Request
sent by the client to our server. Because it is the first message that happens
inside the established connection, and, as a consequence, it is the first
thing that we need to deal with.

That is why, I'm going to create a new Zig module in this small project, named `request.zig`
to keep all functions related to the HTTP Request
together. Then, I will create a new function named `read_request()` that will
use our connection object to read the message sent by the client,
which is the HTTP Request.

You can see below that our `read_request()` function receives three inputs.
The `io` argument should receive the IO backend that we want to use in our IO operations.
The `conn` argument receives the connection object that we generated through the `accept()`
method. While the `buffer` argument receives the buffer object in which we are going
to store the request that the client have sent to our server.

```{zig}
#| eval: false
const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn read_request(io: std.Io, conn: Stream, buffer: []u8) !void {
    var recv_buffer: [1024]u8 = undefined;
    var reader = conn.reader(io, &recv_buffer);
    const reader_interface = &reader.interface;
    var start_index: usize = 0;
    for (0..5) |_| {
        const len = try read_next_line(reader_interface, buffer, start_index);
        start_index += len;
    }
}

fn read_next_line(reader: *std.Io.Reader, buffer: []u8, start_index: usize) !usize {
    const next_line = try reader.takeDelimiterInclusive('\n');
    @memcpy(
        buffer[start_index..(start_index + next_line.len)],
        next_line[0..],
    );
    return next_line.len;
}
```


So, the `read_request()` function essentially receives a connection object as input, which is represented by
an IO stream object, then, it reads the HTTP request sent by the client by "reading data from the IO stream",
and saves this message into this buffer object that we have provided as input.

In order to do that, I first create a `reader` object from the IO stream object.
Then, I call the `takeDelimiterInclusive()` method of this `reader` object, together with `@memcpy()`,
to effectively read the next line of data from the stream. The for loop present in `read_request()` repeats
this process 6 times, so, we are effectively reading the 6 first lines of the HTTP Request, and saving this data
into the buffer object that we've created earlier.



## Looking at the current state of the program


I think now is a good time to see how our program is currently working. Shall we?
So, the first thing I will do is to update the `main.zig` module in our small Zig project,
so that the `main()` function call this new `read_request()` function that we have just created.
I will also add a print statement at the end of the `main()` function,
just so that you can see what the HTTP Request that we have just loaded into the buffer object
looks like.

Also, I'm creating the buffer object (`request_buffer`) in the `main()` function, which will be
responsible for storing the message sent by the client, and, I'm also
using `@memset()` to initialize the entire buffer object to zero.
This is important to make sure that we don't have uninitialized memory in
this object. Because uninitialized memory may cause undefined behaviour in our program.


```{zig}
#| eval: false
const std = @import("std");
const Request = @import("request.zig");
const Server = @import("server.zig").Server;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(
        io,
        connection,
        request_buffer[0..]
    );

    std.debug.print("{s}\n", .{request_buffer});
}
```

Now, I'm going to execute this program, with the `run` command from the
`zig` compiler. But remember, as we sad earlier, as soon as I execute this program, it will
hang indefinitely, because the program is waiting for a client trying to
connect to the server.

More specifically, the program will pause at the line
with the `accept()` call. As soon as a client try to connect to the
server, then, the execution will "unpause", and the `accept()` function
will finally be executed to create the
connection object that we need, and the remaining of the program
will run.

You can see that in @fig-print-zigrun1. The message `Server Addr: 127.0.0.1:3490`
is printed to the console, and the program is now waiting for an incoming connection.

![A screenshot of running the program](./../Figures/print-zigrun1.png){#fig-print-zigrun1}


We can finally try to connect to this server, and there are several ways we can do this.
For example, we could use the following Python script:

```python
import requests
requests.get("http://127.0.0.1:3490")
```

Or, we could also open any web browser of our preference, and type
the URL `localhost:3490`. OBS: `localhost` is the same thing as the
IP `127.0.0.1`. When you press enter, and your web browser go
to this address, first, the browser will probably print a message
saying that "this page isn't working", and, then, it will
probably change to a new message saying that "the site can't be
reached".

You get these "error messages" in the web browser, because
it got no response back from the server. In other words, when the web
browser connected to our server, it did send the HTTP request through the established connection.
Then, the web browser was expecting to receive a HTTP response back, but
it got no response from the server (we didn't implemented the HTTP Response logic yet).

But that is okay. We have achieved the result that we wanted for now,
which is to connect to the server, and see the HTTP request
that was sent by the web browser (or by the Python script)
to the server.

If you comeback to the console that you left open
when you have executed the program, you will see that the
program finished its execution, and, a new message is
printed in the console, which is the actual HTTP request
message that was sent by the web browser to the server.

Since we are only reading the first 6 lines of the HTTP request in our code,
this program might not print the entire HTTP request message to you. That will
depend on how big the HTTP request message was.
You can see the HTTP request printed in @fig-print-zigrun2.

![A screenshot of the HTTP Request sent by the web browser](./../Figures/print-zigrun2.png){#fig-print-zigrun2}




## Learning about Enums in Zig {#sec-enum}

Enums structures are available in Zig through the `enum` keyword.
An enum (short for "enumeration") is a special structure that represents a group of constant values.
So, if you have a variable which can assume a short and known
set of values, you might want to associate this variable to an enum structure,
to make sure that this variable only assumes a value from this set.

A classic example for enums are primary colors. If for some reason, your program
needs to represent one of the primary colors, you can create an enum
that represents one of these colors.
In the example below, we are creating the enum `PrimaryColorRGB`, which
represents a primary color from the RGB color system. By using this enum,
I am guaranteed that the `acolor` object for example, will contain
one of these three values: `RED`, `GREEN` or `BLUE`.

```{zig}
#| auto_main: true
#| build_type: "run"
const PrimaryColorRGB = enum {
    RED, GREEN, BLUE
};
const acolor = PrimaryColorRGB.RED;
_ = acolor;
```

If for some reason, my code tries to save in `acolor`,
a value that is not in this set, I will get an error message
warning me that a value such as "MAGENTA" do not exist
inside the `PrimaryColorRGB` enum.
Then I can easily fix my mistake.


```{zig}
#| eval: false
const acolor = PrimaryColorRGB.MAGENTA;
```

```
e1.zig:5:36: error: enum 'PrimaryColorRGB' has
        no member named 'MAGENTA':
    const acolor = PrimaryColorRGB.MAGENTA;
                                   ^~~~~~~
```

Behind the hood, enums in Zig work the same way that enums
work in C. Each enum value is essentially represented as an integer.
The first value in the set is represented as zero,
then, the second value is one, ... etc.

One thing that we are going to learn in the next section is that
enums can have methods in them. Wait... What? This is amazing!
Yes, enums in Zig are similar to structs, and they can have
private and public methods inside them.







## Implementing the server - Part 2

Now, on this section, I want to focus on parsing
the HTTP Request that we received from the client.
However, to effectively parse a HTTP Request message, we first need to understand its
structure.
In summary, a HTTP Request is a text message that is divided into 3 different
sections (or parts):

- The top-level header indicating the method of the HTTP Request, the URI, and the HTTP version used in the message.
- A list of HTTP Headers.
- The body of the HTTP Request.

### The top-level header

The first line of text in a HTTP Request always come with the three most essential
information about the request. These three key attributes of the HTTP Request
are separated by a simple space in this first line of the request.
The first information is the HTTP method that is being
used in the request, second, we have the URI to which this HTTP Request is being sent to,
and third, we have the version of the HTTP protocol that is being used in this HTTP Request.

In the snippet below, you can find an example of this first line in a HTTP Request.
First, we have the HTTP method of this request (`GET`). Many programmers
refer to the URI component (`/users/list`) as the "API endpoint" to which the HTTP Request
is being sent to. In the context of this specific request, since it's a GET request,
you could also say that the URI component is the path to the resource we want to access,
or, the path to the document (or the file) that we want to retrieve from the server.

```
GET /users/list HTTP/1.1
```

Also, notice that this HTTP Request is using the version 1.1 of the HTTP protocol,
which is the most popular version of the protocol used in the web.



### The list of HTTP headers

Most HTTP Requests also include a section of HTTP Headers,
which is just a list of attributes or key-value pairs associated with this
particular request. This section always comes right after the "top-level header" of the request.

For our purpose in this chapter, which is to build a simple HTTP Server,
we are going to ignore this section of the HTTP Request, for simplicity.
But most HTTP servers that exist in the wild parses and use these
HTTP headers to change the way that the server responds to the request
sent by the client.

For example, many requests we encounter in the real-world comes with
a HTTP header called `Accept`. In this header, we find a list of [MIME types](https://en.wikipedia.org/wiki/Media_type)[^mime].
This list indicates the file formats that the client can read, or parse, or interpret.
In other words, you also interpret this header as the client saying the following phrase
to the server: "Hey! Look, I can read only HTML documents, so please, send me back
a document that is in a HTML format.".

[^mime]: <https://en.wikipedia.org/wiki/Media_type>.

If the HTTP server can read and use this `Accept` header, then, the server can identify
which is the best file format for the document to be sent to the client. Maybe the HTTP server have
the same document in multiple formats, for example, in JSON, in XML, in HTML and in PDF,
but the client can only understand documents in the HTML format. That is the purpose
of this `Accept` header.


### The body

The body comes after the list of HTTP headers, and it's an optional section of the HTTP Request, meaning that, not
all HTTP Requests will come with a body in them. For example, every HTTP Request that uses the
GET method usually does not come with a body.

Because a GET request is used to request data, instead of sending it to the server.
So, the body section is more related to the POST method, which is a method that involves
sending data to the server, to be processed and stored.

Since we are going to support only the GET method in this project, it means that
we also do not need to care about the body of the request.



### Creating the HTTP Method enum

Every HTTP Request comes with a explicit method. The method used in a HTTP Request
is identified by one these words:

- GET;
- POST;
- OPTIONS;
- PATCH;
- DELETE;
- and some other methods.

Each HTTP method is used for a specific type of task. The POST method for example is normally
used to post some data into the destination. In other words, it's used
to send some data to the HTTP server, so that it can be processed and stored by the server.

As another example, the GET method is normally used to get content from the server.
In other words, we use this method whenever we want the server to send some
content back to us. It can be any type of content. It can be a web page,
a document file, or some data in a JSON format.

When a client sends a POST HTTP Request, the HTTP Response sent by the server normally have the sole purpose of
letting the client know if the server processed and stored the data successfully.
In contrast, when the server receives a GET HTTP Request, then, the server sends the content
that the client asked for in the HTTP Response itself. This demonstrates that the method associated
with the HTTP Request changes a lot on the dynamics and the roles that each party
plays in the whole process.

Since the HTTP method of the HTTP Request is identified by this very small and specific
set of words, it would be interesting to create an enum structure to represent a HTTP method.
This way, we can easily check if the HTTP Request we receive from the client is a
HTTP method that we currently support in our small HTTP server project.

The `Method` structure below represents this enumeration.
Notice that, for now, only the GET HTTP method is included in this
enumeration. Because, for the purpose of this chapter, I want to
implement only the GET HTTP method. That is why I am not
including the other HTTP methods in this enumeration.

```{zig}
#| build_type: "lib"
pub const Method = enum {
    GET
};
```


Now, I think we should add two methods to this enum structure. One method is `is_supported()`,
which will be a function that returns a boolean value, indicating if the input HTTP method is supported
or not by our HTTP Server. The other is `init()`, which is a constructor function that takes a string as input,
and tries to convert it into a `Method` value.


But in order to build these functions, I will use a functionality from the Zig Standard Library, called
`StaticStringMap()`. This function allows us to create a simple map from strings to enum values.
In other words, we can use this map structure to map a string to the respective enum value.
To some extent, this specific structure from the standard library works almost like a "hashtable" structure,
and it's optimized for small sets of words, or, small sets of keys, which is our case here.
We are going to talk more about hashtables in Zig in @sec-maps-hashtables.

To use this "static string map" structure, you have to import it from the `std.static_string_map` module
of the Zig Standard Library. Just to make things shorter and easier to type, I am going to import this
function through a different and shorter name (`Map`).

With `Map()` imported, we can just apply this function over the enum structure
that we are going to use in the resulting map. In our case here, it's the `Method` enum structure
that we declared at the last code example. Then, I call the `initComptime()` method with the
map, i.e., the list of key-value pairs that we are going to use.

You can see in the example below that I wrote this map using multiple anonymous struct literals.
Inside the first (or "top-level") struct literal, we have a list (or a sequence) of struct literals.
Each struct literal in this list represents a separate key-value pair. The first element (or the key)
in each key-value pair should always be a string value. While the second element should
be a value from the enum structure that you have used inside the `Map()` function.


```{zig}
#| eval: false
const Map = std.static_string_map.StaticStringMap;
const MethodMap = Map(Method).initComptime(.{
    .{ "GET", Method.GET },
});
```

Therefore, the `MethodMap` object is basically a `std::map` object from C++, or,
a `dict` object from Python. You can retrieve (or get) the enum value that
corresponds to a particular key, by using the `get()` method from the map
object. This method returns an optional value, so, the `get()` method might
result in a null value.

We can use this in our advantage to detect if a particular HTTP method is
supported or not in our HTTP server. Because, if the `get()` method returns null,
it means that it did not found the method that we provided inside the `MethodMap` object, and,
as a consequence, this method is not supported by our HTTP server.

The `init()` method below, takes a string value as input, and then, it simply passes this string value
to the `get()` method of our `MethodMap` object. As consequence, we should get the enum value that corresponds
to this input string.

Notice in the example below that, the `init()` method returns either an error
(which might happen if the `?` method returns `unreacheable`, checkout @sec-null-handling for more details)
or a `Method` object as result. Since `GET` is currently the only value in our `Method` enum
structure, it means that, the `init()` method will most likely return the value `Method.GET` as result.

Also notice that, in the `is_supported()` method, we are using the optional value returned
by the `get()` method from our `MethodMap` object. The if statement unwraps the optional value
returned by this method, and returns `true` in case this optional value is a not-null value.
Otherwise, it simply returns `false`.

```{zig}
#| eval: false
pub const Method = enum {
    GET,
    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text).?;
    }
    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};
```







### Writing the parse request function

Now that we created the enum that represents our HTTP method,
we should start to write the function responsible for
actually parsing the HTTP Request.

The first thing we can do, is to write a struct to represent the HTTP Request.
Take the `Request` struct below as an example. It contains the three
essential information from the "top-level" header (i.e., the first line)
in the HTTP Request.

```{zig}
#| eval: false
const Request = struct {
    method: Method,
    version: []const u8,
    uri: []const u8,
    pub fn init(method: Method,
                uri: []const u8,
                version: []const u8) Request {
        return Request{
            .method = method,
            .uri = uri,
            .version = version,
        };
    }
};
```


The `parse_request()` function should receive a string as input. This input string
contains the HTTP Request message, and the parsing function should
read and understand the individual parts of this message.

Now, remember that for the purpose of this chapter, we care only about the first
line in this message, which contains the "top-level header", or, the three essential attributes about the HTTP Request,
which are the HTTP method used, the URI and the HTTP version.

Notice that I use the function `indexOfScalar()` in `parse_request()`. This function from the
Zig Standard Library returns the first index where the scalar value that we provide
happens in a string. In this case, I'm looking at the first occurrence of the new line character (`\n`).
Because once again, we care only about the first line in the HTTP Request message.
This is the line where we have the three information that we want to parse
(version of HTTP, the HTTP method and the URI).

Therefore, we are using this `indexOfScalar()` function
to limit our parsing process to the first line in the message.
It's also worth mentioning that, the `indexOfScalar()` function returns an optional value.
That is why I use the `orelse` keyword to provide an alternative value, in case
the value returned by the function is a null value.

Since each of these three attributes are separated by a simple space, we
could use the function `splitScalar()` from the Zig Standard Library to split
the input string into sections by looking for every position that appears
a simple space. In other words, this `splitScalar()` function is equivalent
to the `split()` method in Python, or, the `std::getline()` function from C++,
or the `strtok()` function in C.

When you use this `splitScalar()` function, you get an iterator as the result.
This iterator have a `next()` method that you can use to advance the iterator
to the next position, or, to the next section of the splitted string.
Note that, when you use `next()`, the method not only advances the iterator,
but it also returns a slice to the current section of the splitted
string as result.

Now, if you want to get a slice to the current section of the splitted
string, but not advance the iterator to the next position, you can use
the `peek()` method. Both `next()` and `peek()` methods return an optional value, that is
why I use the `?` method to unwrap these optional values.


```{zig}
#| eval: false
pub fn parse_request(text: []u8) Request {
    const line_index = std.mem.indexOfScalar(
        u8, text, '\n'
    ) orelse text.len;
    var iterator = std.mem.splitScalar(
        u8, text[0..line_index], ' '
    );
    const method = try Method.init(iterator.next().?);
    const uri = iterator.next().?;
    const version = iterator.next().?;
    const request = Request.init(method, uri, version);
    return request;
}
```


As I described in @sec-zig-strings, strings in Zig are simply arrays of bytes in the language.
So, you will find lots of excellent utility functions to work directly with strings
inside this `mem` module from the Zig Standard Library.
We have described some of these useful utility functions already
in @sec-strings-useful-funs.



### Using the parse request function

Now that we wrote the function responsible for parsing the HTTP Request,
we can add the function call to `parse_request()` in
the `main()` function of our program.

After that, is a good idea to test once again the state of our program.
I execute this program again with the `run` command from the `zig` compiler,
then, I use my web browser to connect once again to the server through the URL `localhost:3490`, and finally,
the end result of our `Request` object is printed to the console.

A quick observation, since I have used the `any` format specifier in the
print statement, the data members `version` and `uri` of the `Request`
struct were printed as raw integer values. String data being printed
as integer values is common in Zig, and remember, these integer values are just the decimal representation of
the bytes that form the string in question.

In the result below, the sequence of decimal values 72, 84, 84, 80, 47, 49, 46, 49, and 13,
are the bytes that form the text "HTTP/1.1". And the integer 47, is the decimal value of
the character `/`, which represents our URI in this request.

```{zig}
#| eval: false
const std = @import("std");
const Request = @import("request.zig");
const Server = @import("server.zig").Server;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(
        io,
        connection,
        request_buffer[0..]
    );
    const request = Request.parse_request(request_buffer[0..]);
    std.debug.print("{any}\n", .{request});
}
```

```
request.Request{
    .method = request.Method.GET,
    .version = {72, 84, 84, 80, 47, 49, 46, 49, 13},
    .uri = {47}
}
```



### Sending the HTTP Response to the client

In this last part, we are going to write the logic responsible for
sending the HTTP Response from the server to the client. To make things
simple, the server in this project will send just a simple web page
containing the text "Hello world".

First, I create a new Zig module in the project, named `response.zig`.
In this module, I will declare just two functions. Each function
corresponds to a specific status code in the HTTP Response.
The `send_200()` function will send a HTTP Response with status code 200
(which means "Success") to the client. While the `send_404()` function sends a response
with status code 404 (which means "Not found").

This is definitely not the most ergonomic and adequate way of handling the
HTTP Response, but it works for our case here. We are just building toy projects
in this book after all, therefore, the source code that we write do not need to be perfect.
It just needs to work!


```{zig}
#| eval: false
const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn send_200(conn: Stream, io: std.Io) !void {
    const message = (
        "HTTP/1.1 200 OK\nContent-Length: 48"
        ++ "\nContent-Type: text/html\n"
        ++ "Connection: Closed\n\n<html><body>"
        ++ "<h1>Hello, World!</h1></body></html>"
    );
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}

pub fn send_404(conn: Stream, io: std.Io) !void {
    const message = (
        "HTTP/1.1 404 Not Found\nContent-Length: 50"
        ++ "\nContent-Type: text/html\n"
        ++ "Connection: Closed\n\n<html><body>"
        ++ "<h1>File not found!</h1></body></html>"
    );
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}
```

Notice that both functions receives the connection object as input, creates
a writer object from this connection object, then, uses
the `write()` method to write the HTTP Response message directly
into this communication channel. As result, the party in the other
side of the connection (i.e., the client), will receive such message.

Most real-world HTTP Servers will have a single function (or a single struct) to effectively handle
the response. It gets the HTTP Request already parsed as input, and then, it tries to build
the HTTP Response bit by bit, before the function sends it over the connection.

We would also have a specialized struct to represent a HTTP Response, and
a lot of methods that would be used to build each part or component of the response object.
Take the `Response` struct created by the Javascript runtime Bun as an example.
You can find this struct in the [`response.zig` module](https://github.com/oven-sh/bun/blob/main/src/bun.js/webcore/response.zig)[^bun-resp]
in their GitHub project.

[^bun-resp]: <https://github.com/oven-sh/bun/blob/main/src/bun.js/webcore/response.zig>.


## The end result

We can now, update once again our `main()` function to incorporate our new
functions from the `response.zig` module. First, I need to import this module
into our `main.zig` module, then, I add the function calls to `send_200()`
and `send_404()`.

Notice that I'm using if statements to decide which "response function" to call,
based especially on the URI present in the HTTP Request. If the user asked for
a content (or a document) that is not present in our server, we should respond
with a 404 status code. But since we have just a simple HTTP server, with no
real documents to send, we can just check if the URI is the root path (`/`)
or not to decide which function to call.

Also, notice that I'm using the function `std.mem.eql()` from the Zig Standard Library
to check if the string from `uri` is equal or not the string `"/"`. We have
described this function already in @sec-strings-useful-funs, so, comeback to
that section if you are not familiar yet with this function.


```{zig}
#| eval: false
const std = @import("std");
const Request = @import("request.zig");
const Response = @import("response.zig");
const Server = @import("server.zig").Server;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(
        io,
        connection,
        request_buffer[0..]
    );
    const request = Request.parse_request(request_buffer[0..]);
    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection, io);
        } else {
            try Response.send_404(connection, io);
        }
    }
}
```


Now that we adjusted our `main()` function, I can now execute our program, and
see the effects of these last changes. First, I execute the program once again, with the
`run` command of the `zig` compiler. The program will hang, waiting for a client to connect.

Then, I open my web browser, and try to connect to the server again, using the URL `localhost:3490`.
This time, instead of getting some sort of an error message from the browser, you will get the message
"Hello World" printed into your web browser. Because this time, the server sended the HTTP Response
successfully to the web browser, as demonstrated by @fig-print-zigrun3.


![The Hello World message sent in the HTTP Response](./../Figures/print-zigrun3.png){#fig-print-zigrun3}
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Unit tests {#sec-unittests}

In this chapter, I want to dive in on how unit tests are done in
Zig. We are going to talk about what is the testing workflow in Zig, and
also, about the `test` command from the `zig` compiler.


## Introducing the `test` block

In Zig, unit tests are written inside a `test` declaration, or, how I prefer to call it, inside a `test` block.
Every `test` block is written by using the keyword `test`.
You can optionally use a string literal to write a label, which is responsible for identifying
the specific group of unit tests that you are writing inside this specific `test` block.

In the example below, we are testing if the sum of two objects (`a` and `b`)
is equal to 4. The `expect()` function from the Zig Standard Library
is a function that receives a logical test as input. If this logical test
results in `true`, then, the test passes. But if it results
in `false`, then, the test fails.

You can write any Zig code you want inside a `test` block.
Part of this code might be some necessary commands to setup your testing
environment, or just initializing some objects that you need to use
in your unit tests.

```{zig}
#| build_type: "test"
const std = @import("std");
const expect = std.testing.expect;
test "testing simple sum" {
    const a: u8 = 2;
    const b: u8 = 2;
    try expect((a + b) == 4);
}
```

You can have multiple `test` blocks written on the same Zig module.
Also, you can mix `test` blocks with your source code, with no problems
or consequences. If you mix `test` blocks with your normal source code,
when you execute the `build`, `build-exe`, `build-obj` or `build-lib` commands from the
`zig` compiler that we exposed in @sec-compile-code, these `test` blocks are automatically
ignored by the compiler.

In other words, the `zig` compiler builds and execute your unit tests only
when you ask it to. By default, the compiler always ignore `test`
blocks written in your Zig modules. The compiler normally checks only if
there are any syntax errors in these `test` blocks.

If you take a look at the source code for most of the files present in the
Zig Standard Library[^zig-std-lib], you can see that the `test` blocks
are written together with the normal source code of the library.
You can see this for example, at the [`array_list` module](https://codeberg.org/ziglang/zig/src/branch/master/lib/std/array_list.zig)[^zig-array].
So, the standard that the Zig developers decided to adopt
is to keep their unit tests together with the source code
of the functionality that they are testing.

Each programmer might have a different opinion on this.
Some of them might prefer to keep unit tests separate from the actual
source code of their application. If that is your case, you can
simply create a separate `tests` folder in your project, and
start writing Zig modules that contains only unit tests (as you would normally do
on a Python project with `pytest`, for example), and everything will work fine.
It boils down to which is your preference here.

[^zig-std-lib]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std>
[^zig-array]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std/array_list.zig>


## How to run your tests

If the `zig` compiler ignores any `test` block by default, how can
you compile and run your unit tests? The answer is the `test` command from
the `zig` compiler. By running the `zig test` command, the compiler will
find every instance of a `test` block in your Zig modules, and, it will
compile and run the unit tests that you wrote.


```bash
zig test simple_sum.zig
```

```
1/1 simple_sum.test.testing simple sum... OK
All 1 tests passed.
```


## Testing memory allocations

One of the advantages of Zig is that it offers great tools
that help us, programmers, to avoid (but also detect) memory problems, such as
memory leaks and double-frees. The `defer` keyword
is especially helpful in this regard.

When developing your source code, you, the programmer, are responsible for making
sure that your code does not produce such problems. However,
you can also use a special type of an allocator object in Zig
that is capable of automatically detecting such problems for you.
This is the `std.testing.allocator` object.
This allocator object offers some basic memory safety detection
features, which are capable of detecting memory leaks.

As we described in @sec-heap, to allocate memory on the heap, you need
to use an allocator object, and your functions that use these objects to allocate memory
on the heap, should receive an allocator object as one of its inputs.
Every memory on the heap that you allocate using these allocator objects,
must also be freed using this same allocator object.

So, if you want to test the memory allocations performed by your functions,
and make sure that you don't have problems in these allocations, you can simply
write unit tests for these functions, where you provide the
`std.testing.allocator` object as input to these functions.

Look at the example below, where I'm defining a function that clearly causes
a memory leak. Because we allocate memory, but, at the same time,
we do not free this allocated memory at any point. So, when the function
returns, we lose the reference to the `buffer` object, which contains
the allocated memory, and, as a result, we can no longer free this memory.

Notice that, inside a `test` block I execute this function with
the `std.testing.allocator`. The allocator object was capable
of looking deeper in our program, and detecting the memory leak. As a result,
this allocator object returns an error message of "memory leaked", and also,
a stack trace showing the exact point where the memory was leaked.

```{zig}
#| eval: false
const std = @import("std");
const Allocator = std.mem.Allocator;
fn some_memory_leak(allocator: Allocator) !void {
    const buffer = try allocator.alloc(u32, 10);
    _ = buffer;
    // Return without freeing the
    // allocated memory
}

test "memory leak" {
    const allocator = std.testing.allocator;
    try some_memory_leak(allocator);
}
```

```
Test [1/1] leak_memory.test.memory leak...
    [gpa] (err): memory address 0x7c1fddf39000 leaked:
./ZigExamples/debugging/leak_memory.zig:4:39: 0x10395f2
    const buffer = try allocator.alloc(u32, 10);
                                      ^
./ZigExamples/debugging/leak_memory.zig:12:25: 0x10398ea
    try some_memory_leak(allocator);

... more stack trace
```


## Testing errors

One common style of unit tests are those that look for
specific errors in your functions. In other words, you write
a unit test that tries to assert if a specific function call
returns any error, or a specific type of error.

In C++ you would normally write this style of unit tests using, for example,
the functions `REQUIRE_THROWS()` or `CHECK_THROWS()` from the [`Catch2` test framework](https://github.com/catchorg/Catch2/tree/devel)[^catch2].
In the case of a Python project, you would probably use the
[`raises()` function from `pytest`](https://docs.pytest.org/en/7.1.x/reference/reference.html#pytest-raises)[^pytest].
While in Rust, you would probably use `assert_eq!()` in conjunction with `Err()`.

[^pytest]: <https://docs.pytest.org/en/7.1.x/reference/reference.html#pytest-raises>
[^catch2]: <https://github.com/catchorg/Catch2/tree/devel>


But in Zig, we use the `expectError()` function, from the `std.testing` module.
With this function, you can test if a specific function call returns the exact
type of error that you expect it to return. To use this function, you first write
`try expectError()`. Then, on the first argument, you provide the type of error that you
are expecting from the function call. Then, on the second argument, you write
the function call that you expect to fail.

The code example below demonstrates such type of unit test in Zig.
Notice that, inside the function `alloc_error()` we are allocating
100 bytes of memory, or, an array of 100 elements, for the object `ibuffer`. However,
in the `test` block, we are using the `FixedBufferAllocator()`
allocator object, which is limited to 10 bytes of space, because
the object `buffer`, which we provided to the allocator object,
have only 10 bytes of space.

That is why, the `alloc_error()` function raises an `OutOfMemory` error
on this case.
Because this function is trying to allocate more space than the allocator
object allows.
So, in essence, we are testing for a specific type of error,
which is `OutOfMemory`. If the `alloc_error()` function returns any other type of error,
then, the `expectError()` function would make the entire test fail.


```{zig}
#| build_type: "test"
const std = @import("std");
const Allocator = std.mem.Allocator;
const expectError = std.testing.expectError;
fn alloc_error(allocator: Allocator) !void {
    var ibuffer = try allocator.alloc(u8, 100);
    defer allocator.free(ibuffer);
    ibuffer[0] = 2;
}

test "testing error" {
    var buffer: [10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    try expectError(error.OutOfMemory, alloc_error(allocator));
}
```




## Testing simple equalities

In Zig, there are some different ways you can test for an equality.
You already saw that we can use `expect()` with the logical operator `==`
to essentially reproduce an equality test. But we also have
some other helper functions that you should know about, especially
`expectEqual()`, `expectEqualSlices()` and `expectEqualStrings()`.


The `expectEqual()` function, as the name suggests, is a classic
test equality function. It receives two objects as input. The first
object is the value that you expect to be in the second object.
While second object is the object you have, or, the object that your application
produced as result. So, with `expectEqual()` you are essentially
testing if the values stored inside these two objects
are equal or not.

You can see in the example below that, the test performed by
`expectEqual()` failed. Because the objects `v1` and `v2` contain
different values in them.

```{zig}
#| eval: false
const std = @import("std");
test "values are equal?" {
    const v1 = 15;
    const v2 = 18;
    try std.testing.expectEqual(v1, v2);
}
```

```
1/1 ve.test.values are equal?...
    expected 15, found 18
    FAIL (TestExpectedEqual)
ve.zig:5:5: test.values are equal? (test)
    try std.testing.expectEqual(v1, v2);
    ^
0 passed; 0 skipped; 1 failed.
```


Although useful, the `expectEqual()` function does not work with arrays.
For testing if two arrays are equal, you should use the `expectEqualSlices()`
function instead. This function have three arguments. First, you provide
the data type contained in both arrays that you are trying to compare.
While the second and third arguments corresponds to the array objects that you want to compare.

In the example below, we are using this function to test if two array
objects (`array1` and `array2`) are equal or not. Since they
are in fact equal, the unit test passed with no errors.

```{zig}
#| build_type: "test"
const std = @import("std");
test "arrays are equal?" {
    const array1 = [3]u32{1, 2, 3};
    const array2 = [3]u32{1, 2, 3};
    try std.testing.expectEqualSlices(
        u32, &array1, &array2
    );
}
```


At last, you might also want to use the `expectEqualStrings()` function.
As the name suggests, you can use this function to test if two strings
are equal or not. Just provide the two string objects that you want to compare,
as inputs to the function.

If the function finds any existing differences between the two strings,
then, the function will raise an error, and also, print an error message
that shows the exact difference between the two string objects provided,
as the example below demonstrates:


```{zig}
#| eval: false
const std = @import("std");
test "strings are equal?" {
    const str1 = "hello, world!";
    const str2 = "Hello, world!";
    try std.testing.expectEqualStrings(
        str1, str2
    );
}
```

```
1/1 t.test.strings are equal?...
====== expected this output: =========
hello, world!␃
======== instead found this: =========
Hello, world!␃
======================================
First difference occurs on line 1:
expected:
hello, world!
^ ('\x68')
found:
Hello, world!
^ ('\x48')
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Build System {#sec-build-system}


In this chapter, we are going to talk about the build system, and how an entire project
is built in Zig.
One key advantage of Zig is that it includes a build system embedded in the language itself.
This is great, because then you do not have to depend on an external system, separated
from the compiler, to build your code.


You can find a good description of Zig's build system
in the [article entitled "Build System"](https://ziglang.org/learn/build-system/#user-provided-options)[^zig-art1]
from the official Zig's website.
We also have the excellent [series of posts written by Felix](https://zig.news/xq/zig-build-explained-part-1-59lf)[^felix].
Hence, this chapter represents an extra resource for you to consult and rely on.

[^felix]: <https://zig.news/xq/zig-build-explained-part-1-59lf>
[^zig-art1]: <https://ziglang.org/learn/build-system/#user-provided-options>

Building code is one of the things that Zig is best at. One thing that is particularly
difficult in C/C++ and even in Rust, is to cross-compile source code to multiple targets
(e.g. multiple computer architectures and operating systems),
and the `zig` compiler is known for being one of the best existing pieces of software
for this particular task.




## How source code is built?

We already have talked about the challenges of building source code in low-level languages
in @sec-project-files. As we described at that section, programmers invented Build Systems
to surpass these challenges on the process of building source code in low-level languages.

Low-level languages uses a compiler to compile (or to build) your source code into binary instructions.
In C and C++, we normally use compilers like `gcc`, `g++` or `clang` to compile
our C and C++ source code into these instructions.
Every language have its own compiler, and this is no different in Zig.

In Zig, we have the `zig` compiler to compile our Zig source code into
binary instructions that can be executed by our computer.
In Zig, the compilation (or the build) process involves
the following components:

- The Zig modules that contains your source code;
- Library files (either a dynamic library or a static library);
- Compiler flags that tailors the build process to your needs.

These are the things that you need to connect together in order to build your
source code in Zig. In C and C++, you would have an extra component, which are the header files of
the libraries that you are using. But header files do not exist in Zig, so, you only need
to care about them if you are linking your Zig source code with a C library.
If that is not your case, you can forget about it.

Your build process is usually organized in a build script. In Zig, we normally
write this build script into a Zig module in the root directory of our project,
named as `build.zig`. You write this build script, then, when you run it, your project
gets built into binary files that you can use and distribute to your users.

This build script is normally organized around *target objects*. A target is simply
something to be built, or, in other words, it's something that you want the `zig` compiler
to build for you. This concept of "targets" is present in most Build Systems,
especially in CMake[^cmake].

[^cmake]: <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html>

There are four types of target objects that you can build in Zig, which are:

- An executable (e.g. a `.exe` file on Windows).
- A shared library (e.g. a `.so` file in Linux or a `.dll` file on Windows).
- A static library (e.g. a `.a` file in Linux or a `.lib` file on Windows).
- An executable file that executes only unit tests (or, a "unit tests executable").

We are going to talk more about these target objects in @sec-targets.



## The `build()` function {#sec-build-fun}

A build script in Zig always contains a public (and top-level) `build()` function declared.
It's like the `main()` function in the main Zig module of your project, that we discussed in @sec-main-file.
But instead of creating the entrypoint to your code, this `build()` function is the entrypoint to the build process.

This `build()` function should accept a pointer to a `Build` object as input, and it should use this "build object" to perform
the necessary steps to build your project. The return type of this function is always `void`,
and this `Build` struct comes directly from the Zig Standard Library (`std.Build`). So, you can
access this struct by just importing the Zig Standard Library into your `build.zig` module.

Just as a very simple example, here you can see the source code necessary to build
an executable file from the `hello.zig` Zig module.

```{zig}
#| eval: false
const std = @import("std");
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = b.createModule(.{
            .root_source_file = b.path("hello.zig"),
            .target = b.graph.host
        })
    });
    b.installArtifact(exe);
}
```

You can define and use other functions and objects in this build script. You can also import
other Zig modules as you would normally do in any other module of your project.
The only real requirement for this build script, is to have a public and top-level
`build()` function defined, that accepts a pointer to a `Build` struct as input.


## Target objects {#sec-targets}

As we described over the previous sections, a build script is composed around target objects.
Each target object is normally a binary file (or an output) that you want to get from the build process. You can list
multiple target objects in your build script, so that the build process generates multiple
binary files for you at once.

For example, maybe you are a developer working in a cross-platform application,
and, because this application is cross-platform, you probably need to release
binary files of your software for each OS supported by your application to your end users.
Thus, you can define a different target object in your build script
for each OS (Windows, Linux, etc.) where you want to publish your software.
This will make the `zig` compiler to build your project to multiple target OS's at once.
The Zig Build System official documentation have a [great code example that demonstrates this strategy](https://ziglang.org/learn/build-system/#handy-examples)[^zig-ex].

[^zig-ex]: <https://ziglang.org/learn/build-system/#handy-examples>


A target object is created by the following methods of the `Build` struct that we introduced
in @sec-build-fun:

- `addExecutable()` creates an executable file;
- `addSharedLibrary()` creates a shared library file;
- `addStaticLibrary()` creates a static library file;
- `addTest()` creates an executable file that executes unit tests.


These functions are methods from the `Build` struct that you receive
as input of the `build()` function. All of them, create as output
a `Compile` object, which represents a target object to be compiled
by the `zig` compiler. All of these functions accept a similar struct literal as input.
This struct literal defines two essential specs about this target object that you are building:
`name`, `root_module`.

We have already seen these two options being used on the previous example,
where we used the `addExecutable()` method to create an executable target object.
This example is reproduced below. Notice the use of the `path()` method
from the `Build` struct, to define the path to our Zig module in the `root_module` option.

```{zig}
#| eval: false
const exe = b.addExecutable(.{
    .name = "hello",
    .root_module = b.createModule(.{
        .root_source_file = b.path("hello.zig"),
        .target = b.graph.host
    })
});
```

The `name` option specify the name that you want to give to the binary file defined
by this target object. So, in this example, we are building an executable file named `hello`.
It's common to set this `name` option to the name of your project.


Furthermore, the `target` option inside `root_module` specify the target computer architecture (or the target operating system) of this
binary file. For example, if you want this target object to run on a Windows machine
that uses a `x86_64` architecture, you can set this `target` option to `x86_64-windows-gnu` for example.
This will make the `zig` compiler to compile the project to run on a `x86_64` Windows machine.
You can see the full list of architectures and OS's that the `zig` compiler supports by running
the `zig targets` command in the terminal.

Now, if you are building the project to run on the current machine
that you are using to run this build script, you can set this `target`
option to the `host` method of the `Build.graph` object, like we did in the example above.
This `host` method identifies the current machine where you are
currently running the `zig` compiler.


At last, the `.root_source_file` option inside `root_module` specifies the path to the root Zig module of your project.
That is the Zig module that contains the entrypoint to your application (i.e., the `main()` function), or, the main API of your library.
This also means that, all the Zig modules that compose your project are automatically discovered
from the import statements you have inside this "root source file".
The `zig` compiler can detect when a Zig module depends on the other through the import statements,
and, as a result, it can discover the entire map of Zig modules used in your project.

This is handy, and it's different from what happens in other build systems.
In CMake for example, you have to explicitly list the paths to all source files that you want to
include in your build process. This is probably a symptom of the "lack of conditional
compilation" in the C and C++ compilers. Since they lack this feature, you have
to explicitly choose which source files should be sent to the C/C++ compiler, because not
every C/C++ code is portable or supported in every operating system, and, therefore,
would cause a compilation error in the C/C++ compiler.


Now, one important detail about the build process is that, you have to **explicitly
install the target objects that you create in your build script**, by using the
`installArtifact()` method of the `Build` struct.

Everytime you invoke the build process of your project, by calling the `build` command
of the `zig` compiler, a new directory named `zig-out` is created in the root
directory of your project. This new directory contains the outputs of the build process,
that is, the binary files built from your source code.

What the `installArtifact()` method do is to install (or copy) the built target objects
that you defined to this `zig-out` directory.
This means that, if you do not
install the target objects you define in your build script, these target objects are
essentially discarded at the end of the build process.

For example, you might be building a project that uses a third party library that is built
together with the project. So, when you build your project, you would need first, to
build the third party library, and then, you link it with the source code of your project.
So, in this case, we have two binary files that are generated in the build process (the executable file of your project, and the third party library).
But only one is of interest, which is the executable file of our project.
We can discard the binary file of the third party library, by simply not installing it
into this `zig-out` directory.

This `installArtifact()` method is pretty straightforward. Just remember to apply it to every
target object that you want to save into the `zig-out` directory, like in the example below:


```{zig}
#| eval: false
const exe = b.addExecutable(.{
    .name = "hello",
    .root_module = b.createModule(.{
        .root_source_file = b.path("hello.zig"),
        .target = b.graph.host
    })
});

b.installArtifact(exe);
```


## Setting the build mode

We have talked about the three essential options that are set when you create a new target object.
But there is also a fourth option that you can use to set the build mode of this target object,
which is the `optimize` option.
This option is called this way, because the build modes in Zig are treated more of
an "optimization vs safety" problem. So optimization plays an important role here.
Don't worry, I'm going back to this question very soon.

In Zig, we have four build modes (which are listed below). Each one of these build modes offer
different advantages and characteristics. As we described in @sec-compile-debug-mode, the `zig` compiler
uses the `Debug` build mode by default, when you don't explicitly choose a build mode.

- `Debug`, mode that produces and includes debugging information in the output of the build process (i.e., the binary file defined by the target object);
- `ReleaseSmall`, mode that tries to produce a binary file that is small in size;
- `ReleaseFast`, mode that tries to optimize your code, in order to produce a binary file that is as fast as possible;
- `ReleaseSafe`, mode that tries to make your code as safe as possible, by including safeguards when possible.

So, when you build your project, you can set the build mode of your target object to `ReleaseFast` for example, which will tell
the `zig` compiler to apply important optimizations in your code. This creates a binary file
that simply runs faster on most contexts, because it contains a more optimized version of your code.
However, as a result, we often lose some safety features in our code.
Because some safety checks are removed from the final binary file,
which makes your code run faster, but in a less safe manner.

This choice depends on your current priorities. If you are building a cryptography or banking system, you might
prefer to prioritize safety in your code, so, you would choose the `ReleaseSafe` build mode, which is a little
slower to run, but much more secure, because it includes all possible runtime safety checks in the binary file
built in the build process. In the other hand, if you are writing a game for example, you might prefer to prioritize performance
over safety, by using the `ReleaseFast` build mode, so that your users can experience faster frame rates in your game.

In the example below, we are creating the same target object that we have used on previous examples.
But this time, we are specifying the build mode of this target object to the `ReleaseSafe` mode.

```{zig}
#| eval: false
const exe = b.addExecutable(.{
    .name = "hello",
    .root_module = b.createModule(.{
        .root_source_file = b.path("hello.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseSafe
    })
});
b.installArtifact(exe);
```


## Setting the version of your build

Everytime you build a target object in your build script, you can assign a version
number to this specific build, following a semantic versioning framework.
You can find more about semantic versioning by visiting the [Semantic Versioning website](https://semver.org/)[^semver].
Anyway, in Zig, you can specify the version of your build, by providing a `SemanticVersion` struct to
the `version` option, like in the example below:


[^semver]: <https://semver.org/>


```{zig}
#| eval: false
const exe = b.addExecutable(.{
    .name = "hello",
    .root_module = b.createModule(.{
        .root_source_file = b.path("hello.zig"),
        .target = b.graph.host
    }),
    .version = .{
        .major = 2, .minor = 9, .patch = 7
    }
});
b.installArtifact(exe);
```


## Detecting the OS in your build script {#sec-detect-os}

It's very common in Build Systems to use different options, or, to include different modules, or,
to link against different libraries depending on the Operational System (OS)
that you are targeting in the build process.

In Zig, you can detect the target OS of the build process, by looking
at the `os.tag` inside the `builtin` module from the Zig library.
In the example below, we are using an if statement to run some
arbitrary code when the target of the build process is a
Windows system.

```{zig}
#| eval: false
const builtin = @import("builtin");
if (builtin.target.os.tag == .windows) {
    // Code that runs only when the target of
    // the compilation process is Windows.
}
```


## Adding a run step to your build process

One thing that is neat in Rust is that you can compile and run your
source code with one single command (`cargo run`) from the Rust compiler.
We saw in @sec-compile-run-code how can we perform a similar job in Zig, by
building and running our Zig source code through the `run` command from the `zig` compiler.

But how can we, at the same time, build and run the binary file specified by a target object in our
build script?
The answer is by including a "run artifact" in our build script.
A run artifact is created through the `addRunArtifact()` method from the `Build` struct.
We simply provide as input to this function the target object that describes the binary file that we
want to execute. As a result, this function creates a run artifact that is capable of executing
this binary file.

In the example below, we are defining an executable binary file named `hello`,
and we use this `addRunArtifact()` method to create a run artifact that will execute
this `hello` executable file.

```{zig}
#| eval: false
const exe = b.addExecutable(.{
    .name = "hello",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/hello.zig"),
        .target = b.graph.host
    })
});
b.installArtifact(exe);
const run_arti = b.addRunArtifact(exe);
```

Now that we have created this run artifact, we need to include it in
the build process. We do that by declaring a new step in our build
script to call this artifact, through the `step()` method of the `Build`
struct.

We can give any name we want to this step, but, for our
context here, I'm going to name this step as "run".
Also, I give it a brief description to this step ("Run the project").

```{zig}
#| eval: false
const run_step = b.step(
    "run", "Run the project"
);
```


Now that we have declared this "run step" we need to tell Zig that
this "run step" depends on the run artifact.
In other words, a run artifact always depends on a "step" to effectively be executed.
By creating this dependency
we finally stablish the necessary commands to build and run the executable file
from the build script.

We can establish a dependency between the run step and the run artifact
by using the `dependOn()` method from the run step. So, we first
create the run step, and then, we link it with the run artifact, by
using this `dependOn()` method from the run step.

```{zig}
#| eval: false
run_step.dependOn(&run_arti.step);
```

The entire source code of this specific build script that
we wrote, piece by piece, in this section, is
available in the `build_and_run.zig` module. You can
see this module by
[visiting the official repository of this book](https://github.com/pedropark99/zig-book/blob/main/ZigExamples/build_system/build_and_run.zig)
[^module-src].


[^module-src]: <https://github.com/pedropark99/zig-book/blob/main/ZigExamples/build_system/build_and_run.zig>

When you declare a new step in your build script, this step
becomes available through the `build` command in the `zig` compiler.
You can actually see this step by running `zig build --help` in the terminal, like
in the example below, where we can see that this new "run"
step that we declared in the build script appeared in the output.

```bash
zig build --help
```

```
Steps:
  ...
  run   Run the project
  ...
```

Now, everything that we need to is to
call this "run" step that we created in our build script. We
call it by using the name that we gave to this step
after the `build` command from the `zig` compiler.
This will cause the compiler to build our executable file
and execute it at the same time.

```bash
zig build run
```

## Build unit tests in your project

We have talked at length about writing unit tests in Zig in @sec-unittests,
and we also have talked about how to execute these unit tests through
the `test` command of the `zig` compiler. However,
as we did with the `run` command on the previous section, we also might want to
include some commands in our build script to also build and execute the unit tests in our project.

So, once again, we are going to discuss how a specific built-in command from the `zig` compiler,
(in this case, the `test` command) can be used in a build script in Zig.
Here is where a "test target object" comes into play.
As was described in @sec-targets, we can create a test target object by using the `addTest()` method of
the `Build` struct. The first thing that we need to do is to
declare a test target object in our build script.


```{zig}
#| eval: false
const test_exe = b.addTest(.{
    .name = "unit_tests",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = b.graph.host
    })
});

b.installArtifact(test_exe);
```


A test target object essentially selects all `test` blocks in all Zig modules
across your project, and builds only the source code present inside
these `test` blocks in your project. As a result, this target object
creates an executable file that contains only the source code present
in all of these `test` blocks (i.e., the unit tests) in your project.

Perfect! Now that we have declared this test target object, an executable file
named `unit_tests` is built by the `zig` compiler when we trigger the build
script with the `build` command. After the build
process is finished, we can simply execute this `unit_tests` executable
in the terminal.

However, if you remember the previous section, we already learned
how can we create a run step in our build script, to execute an executable file
built by the build script.

So, we could simply add a run step in our build script to run these unit tests
from a single command in the `zig` compiler, to make our lifes easier.
In the example below, we demonstrate the commands to
register a new build step called "tests" in our build script
to run these unit tests.

```{zig}
#| eval: false
const run_arti = b.addRunArtifact(test_exe);
const run_step = b.step("tests", "Run unit tests");
run_step.dependOn(&run_arti.step);
```

Now that we registered this new build step, we can trigger it by calling the command below
in the terminal. You can also checkout the complete source
code for this specific build script at the `build_tests.zig` module at the
[official repository of this book](https://github.com/pedropark99/zig-book/blob/main/ZigExamples/build_system/build_tests.zig)
[^module-src2].


[^module-src2]: <https://github.com/pedropark99/zig-book/blob/main/ZigExamples/build_system/build_tests.zig>


```bash
zig build tests
```


## Tailoring your build process with user-provided options

Sometimes, you want to make a build script that is customizable by the user
of your project. You can do that by creating user-provided options in
your build script. We create an user-provided option by using the
`option()` method from the `Build` struct.

With this method, we create a "build option" which can be passed
to the `build.zig` script at the command line. The user have the power of setting
this option at the `build` command from the
`zig` compiler. In other words, each build option that we create
becomes a new command line argument that is accessible through the `build` command
of the compiler.

These "user-provided options" are set by using the prefix `-D` in the command line.
For example, if we declare an option named `use_zlib`, that receives a boolean value which
indicates if we should link our source code to `zlib` or not, we can set the value
of this option in the command line with `-Duse_zlib`. The code example below
demonstrates this idea:

```{zig}
#| eval: false
const std = @import("std");
pub fn build(b: *std.Build) void {
    const use_zlib = b.option(
        bool,
        "use_zlib",
        "Should link to zlib?"
    ) orelse false;
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = b.createModule(.{
            .root_source_file = b.path("example.zig"),
            .target = b.graph.host
        })
    });
    if (use_zlib) {
        exe.root_module.linkSystemLibrary("zlib", .{});
    }
    b.installArtifact(exe);
}
```

```bash
zig build -Duse_zlib=false
```


## Linking to external libraries


One essential part of every build process is the linking stage.
This stage is responsible for combining the multiple object files
that represent your code, into a single executable file. It also links
this executable file to external libraries, if you use any in your code.

In Zig, we have two notions of a "library", which are: 1) a system's library;
2) a local library. A system's library is just a library that is already installed
in your system. While a local library is a library that belongs to the current
project; a library that is present in your project directory, and
that you are building together with your project source code.

The basic difference between the two, is that a system's library is already
built and installed in your system, supposedly, and all you need to do
is to link your source code to this library to start using it.
We do that by using the `linkSystemLibrary()` method from a
`Compile.root_module` object. This method accepts the name of the library
in a string as input. Remember from @sec-targets that a `Compile` object
is a target object that you declare in your build script.

When you link a particular target object with a system's library,
the `zig` compiler will use `pkg-config` to find where
are the binary files and also the header files of this library
in your system.
When it finds these files, the linker present in the `zig` compiler
will link your object files with the files of this library to
produce a single binary file for you.

In the example below, we are creating an executable file named `image_filter`,
and, we are linking this executable file to the C Standard Library by setting the `link_libc`
option to `true`. But we also link this executable file to the
C library `libpng` that is currently installed in my system.

```{zig}
#| eval: false
const std = @import("std");
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "image_filter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host
            .link_libc = true,
        })
    });
    exe.root_module.linkSystemLibrary("png", .{});
    b.installArtifact(exe);
}
```

If you are linking with a C library in your project, is generally a good idea
to also link your code with the C Standard Library. Because is very likely
that this C library uses some functionality of the C Standard Library at some point.
The same goes to C++ libraries. So, if you are linking with
C++ libraries, is a good idea to link your project with the C++
Standard Library by setting the `link_libcpp` option to `true`.

On the order side, when you want to link with a local library,
you should use the `linkLibrary()` method of a `Compile.root_module` object.
This method expects to receive another `Compile` object as input.
That is, another target object defined in your build script,
using either the `addStaticLibrary()` or `addSharedLibrary()` methods
which defines a library to be built.

As we discussed earlier, a local library is a library
that is local to your project, and that is being built together
with your project. So, you need to create a target object in your build script
to build this local library. Then, you link the target objects of interest in your project,
with this target object that identifies this local library.

Take a look at this example extracted from the build script of the [`libxev` library](https://github.com/mitchellh/libxev/tree/main)[^libxev2].
You can see in this snippet that
we are declaring a shared library file, from the `c_api.zig`
module. Then, later in the build script, we declare an
executable file named `"dynamic-binding-test"`, which
links to this shared library that we defined earlier
in the script.

[^libxev2]: <https://github.com/mitchellh/libxev/tree/main>


```{zig}
#| eval: false
const dynamic_lib = b.addSharedLibrary(.{
    .name = dynamic_lib_name,
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/c_api.zig"),
        .target = b.graph.host
    })
});
b.installArtifact(dynamic_lib);
// ... more lines in the script
const dynamic_binding_test = b.addExecutable(.{
    .name = "dynamic-binding-test",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/test.zig"),
        .target = b.graph.host
    })
});
dynamic_binding_test.root_module.linkLibrary(
    dynamic_lib
);
```



## Building C code {#sec-building-c-code}

The `zig` compiler comes with a C compiler embedded in it. In other words,
you can use the `zig` compiler to build C projects. This C compiler is available
through the `cc` command of the `zig` compiler.

As an example, let's use the famous [FreeType library](https://freetype.org/)[^freetype].
FreeType is one of the most widely used pieces of software in the world.
It's a C library designed to produce high-quality fonts. But it's also
heavily used in the industry to natively render text and fonts
in the screen of your computer.

In this section, we are going to write a build script, piece by piece, that is capable
of building the FreeType project from source.
You can find the source code of this build script on the
[`freetype-zig` repository](https://github.com/pedropark99/freetype-zig/tree/main)[^freetype-zig]
available at GitHub.

[^freetype]: <https://freetype.org/>
[^freetype-zig]: <https://github.com/pedropark99/freetype-zig/tree/main>

After you download the source code of FreeType from the official website[^freetype],
you can start writing the `build.zig` module. We begin by defining the target object
that defines the binary file that we want to compile.

As an example, I will build the project as a static library file using the `addStaticLibrary()` method
to create the target object. Also, since FreeType is a C library, I will also link the library
against `libc` through the `link_libc` option, to guarantee that any use
of the C Standard Library is covered in the compilation process.


```{zig}
#| eval: false
const lib = b.addStaticLibrary(.{
    .name = "freetype",
    .root_module = b.createModule(.{
        .target = b.graph.host,
        .link_libc = true
    })
});
```

### Creating C compiler flags

Compiler flags are also known as "compiler options" by many programmers,
or also, as "command options" in the GCC official documentation.
It's fair to also call them as the "command-line arguments" of the C compiler.
In general, we use compiler flags to turn on (or turn off) some features from the compiler,
or to tweak the compilation process to fit the needs of our project.

In build scripts written in Zig, we normally list the C compiler flags to be used in the compilation process
in a simple array, like in the example below.

```{zig}
#| eval: false
const c_flags = [_][]const u8{
    "-Wall",
    "-Wextra",
    "-Werror",
};
```

In theory, there is nothing stopping you from using this array to add "include paths" (with the `-I` flag)
or "library paths" (with the `-L` flag) to the compilation process. But there are formal ways in Zig to
add these types of paths in the compilation process. Both are discussed in @sec-include-paths
and @sec-library-paths.

Anyway, in Zig, we add C flags to the build process together with the C files that we want to compile, by using the
`addCSourceFile()` and `addCSourceFiles()` methods. In the example above, we have just declared
the C flags that we want to use. But we haven't added them to the build process yet.
To do that, we also need to list the C files to be compiled.

### Listing your C files

The C files that contains "cross-platform" source code are listed in the `c_source_files`
object below. These are the C files that are included by default in every platform
supported by the FreeType library. Now, since the amount of C files in the FreeType library is big,
I have omitted the rest of the files in the code example below, for brevity purposes.

```{zig}
#| eval: false
const c_source_files = [_][]const u8{
    "src/autofit/autofit.c",
    "src/base/ftbase.c",
    // ... and many other C files.
};
```

Now, in addition to "cross-platform" source code, we also have some C files in the FreeType project
that are platform-specific, meaning that, they contain source code that can only be compiled in specific platforms,
and, as a result, they are only included in the build process on these specific target platforms.
The objects that list these C files are exposed in the code example below.

```{zig}
#| eval: false
const windows_c_source_files = [_][]const u8{
    "builds/windows/ftdebug.c",
    "builds/windows/ftsystem.c"
};
const linux_c_source_files = [_][]const u8{
    "src/base/ftsystem.c",
    "src/base/ftdebug.c"
};
```

Now that we declared both the files that we want to include and the C compiler flags to be used,
we can add them to the target object that describes the FreeType library, by using the
`addCSourceFile()` and `addCSourceFiles()` methods.

Both of these functions are methods from a `Compile.root_module` object.
The `addCSourceFile()` method is capable of adding a single C file to the target object,
while the `addCSourceFiles()` method is used to add multiple C files in a single command.
You might prefer to use `addCSourceFile()` when you need to use different compiler flags
on specific C files in your project. But, if you can use the same compiler flags
across all C files, then, you will probably find `addCSourceFiles()` a better choice.

Notice that we are using the `addCSourceFiles()` method in the example below,
to add both the C files and the C compiler flags. Also notice that we
are using the `os.tag` that we learned about in @sec-detect-os, to add the platform-specific
C files.

```{zig}
#| eval: false
const builtin = @import("builtin");
lib.root_module.addCSourceFiles({
    .files=&c_source_files,
    .flags=&c_flags
});

switch (builtin.target.os.tag) {
    .windows => {
        lib.root_module.addCSourceFiles({
            .files=&windows_c_source_files,
            .flags=&c_flags
        });
    },
    .linux => {
        lib.root_module.addCSourceFiles({
            .files=&linux_c_source_files,
            .flags=&c_flags
        });
    },
    else => {},
}
```


### Defining C Macros

C Macros are an essential part of the C programming language,
and they are commonly defined through the `-D` flag from a C compiler.
In Zig, you can define a C Macro to be used in your build process
by using the `addCMacro()` method from the `root_module` attribute of the target object that
defines the binary file that you are building.

In the example below, we are using the `lib` object that we have defined
in the previous sections to define some C Macros used by the FreeType project
in the compilation process. These C Macros specify if FreeType
should (or should not) include functionalities from different
external libraries.

```{zig}
#| eval: false
lib.root_module.addCMacro("FT_DISABLE_ZLIB", "TRUE");
lib.root_module.addCMacro("FT_DISABLE_PNG", "TRUE");
lib.root_module.addCMacro("FT_DISABLE_HARFBUZZ", "TRUE");
lib.root_module.addCMacro("FT_DISABLE_BZIP2", "TRUE");
lib.root_module.addCMacro("FT_DISABLE_BROTLI", "TRUE");
lib.root_module.addCMacro("FT2_BUILD_LIBRARY", "TRUE");
```


### Adding library paths {#sec-library-paths}

Library paths are paths in your computer where the C compiler will look (or search) for
library files to link against your source code. In other words, when you use a library in your
C source code, and you ask the C compiler to link your source code against this library,
the C compiler will search for the binary files of this library across the paths listed
in this "library paths" set.

These paths are platform specific, and, by default, the C compiler starts by looking at a
pre-defined set of places in your computer. But you can add more paths (or more places)
to this list. For example, you may have a library installed in a non-conventional place of your
computer, and you can make the C compiler "see" this "non-conventional place" by adding this path
to this list of pre-defined paths.

In Zig, you can add more paths to this set by using the `addLibraryPath()` method from the
`root_module` attribute of your target object.
First, you defined a `LazyPath` object, containing the path you want to add, then,
you provide this object as input to the `addLibraryPath()` method, like in the example below:

```{zig}
#| eval: false
const lib_path: std.Build.LazyPath = .{
    .cwd_relative = "/usr/local/lib/"
};
lib.root_module.addLibraryPath(lib_path);
```




### Adding include paths {#sec-include-paths}

The preprocessor search path is a popular concept from the
C community, but it's also known by many C programmers as "include paths", because
the paths in this "search path" relate to the `#include` statements found in the C files.

Include paths are similar to library paths. They are a set of pre-defined places in your computer where
the C compiler will look for files during the compilation process. But instead of looking for
library files, the include paths are places where the compiler looks for header files included
in your C source code.
This is why many C programmers prefer to call these paths as the "preprocessor search path".
Because header files are processed during the preprocessor stage of the compilation
process.

So, every header file that you include in your C source code, through a `#include` statements needs to
be found somewhere, and the C compiler will search for this header file across the paths listed in this "include paths" set.
Include paths are added to the compilation process through the `-I` flag.

In Zig, you can add new paths to this pre-defined set of paths, by using the `addIncludePath()` method from the
`root_module` attribute of your target object. This method also accepts a `LazyPath` object as input.

```{zig}
#| eval: false
const inc_path: std.Build.LazyPath = .{
    .path = "./include"
};
lib.root_module.addIncludePath(inc_path);
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Error handling and unions {#sec-error-handling}

In this chapter, I want to discuss how error handling is done in Zig.
We already briefly learned about one of the available strategies to handle errors in Zig,
which is the `try` keyword presented in @sec-main-file. But we still haven't learned about
the other methods, such as the `catch` keyword.
I also want to discuss in this chapter how union types are created in Zig.

## Learning more about errors in Zig

Before we get into how error handling is done, we need to learn more about what errors are in Zig.
An error is actually a value in Zig [@zigoverview]. In other words, when an error occurs inside your Zig program,
it means that somewhere in your Zig codebase, an error value is being generated.
An error value is similar to any integer value that you create in your Zig code.
You can take an error value and pass it as input to a function,
and you can also cast (or coerce) it into a different type of an error value.

This have some similarities with exceptions in C++ and Python.
Because in C++ and Python, when an exception happens inside a `try` block,
you can use a `catch` block (in C++) or an `except` block (in Python)
to capture the exception produced in the `try` block,
and pass it to functions as an input.

However, error values in Zig are treated very differently than exceptions.
First, you cannot ignore error values in your Zig code. Meaning that, if an error
value appears somewhere in your source code, this error value must be explicitly handled in some way.
This also means that you cannot discard error values by assigning them to an underscore,
as you could do with normal values and objects.

Take the source code below as an example. Here we are trying to open a file that does not exist
in my computer, and as a result, an obvious error value of `FileNotFound` is returned from the `openFile()`
function. But because I'm assigning the result of this function to an underscore, I end up
trying to discard an error value.

The `zig` compiler detects this mistake, and raises a compile
error telling me that I'm trying to discard an error value.
It also adds a note message that suggests the use of `try`,
`catch` or an if statement to explicitly handle this error value
This note is reinforcing that every possible error value must be explicitly handled in Zig.


```{zig}
#| eval: false
#| auto_main: true
#| build_type: "run"
const cwd = std.Io.Dir.cwd();
_ = cwd.openFile(
    init.io, "doesnt_exist.txt", .{ .mode = .write_only }
);
```

```
t.zig:8:17: error: error set is discarded
t.zig:8:17: note: consider using 'try', 'catch', or 'if'
```


### Returning errors from functions

As we described in @sec-main-file, when we have a function that might return an error
value, this function normally includes an exclamation mark (`!`) in its return type
annotation. The presence of this exclamation mark indicates that this function might
return an error value as result, and, the `zig` compiler forces you to always handle explicitly
the case of this function returning an error value.

Take a look at the `print_name()` function below. This function might return an error in the `stdout.print()` function call,
and, as a consequence, its return type (`!void`) includes an exclamation mark in it.

```{zig}
#| eval: false
fn print_name(stdout: *std.Io.Writer) !void {
    try stdout.print("My name is Pedro!", .{});
    try stdout.flush();
}
```

In the example above, we are using the exclamation mark to tell the `zig` compiler
that this function might return some error. But which error exactly is returned from
this function? For now, we are not specifying a specific error value. For now,
we only know that some error value (whatever it is) might be returned.

But in fact, you can (if you want to) specify clearly which exact error values
might be returned from this function. There are lot of examples of
this in the Zig Standard Library. Take this `fill()` function from
the `http.Client` module as an example. This function returns
either a error value of type `ReadError`, or `void`.

```{zig}
#| eval: false
pub fn fill(conn: *Connection) ReadError!void {
    // The body of this function ...
}
```

This idea of specifying the exact error values that you expect to be returned
from the function is interesting. Because they automatically become some sort of documentation
of your function, and also, this allows the `zig` compiler to perform some extra checks over
your code. Because the compiler can check if there is any other type of error value
that is being generated inside your function, and, that it's not being accounted
for in this return type annotation.

Anyway, you can list the types of errors that can be returned from the function
by listing them on the left side of the exclamation mark. While the valid values
stay on the right side of the exclamation mark. So the syntax format become:

```
<error-value>!<valid-value>
```


### Error sets

But what about when we have a single function that might return different types of errors?
When you have such a function, you can list
all of these different types of errors that can be returned from this function,
through a structure in Zig that we call of an *error set*.

An error set is a special case of a union type. It's a union that contains error values in it.
Not all programming languages have a notion of a "union object".
But in summary, a union is just a set of data types.
Unions are used to allow an object to have multiple data types.
For example, a union of `x`, `y` and `z`, means that
an object can be either of type `x`, or type `y` or type `z`.

We are going to talk in more depth about unions in @sec-unions.
But you can write an error set by writing the keyword `error` before
a pair of curly braces, then you list the error values that can be
returned from the function inside this pair of curly braces.

Take the `resolvePath()` function below as an example, which comes from the
`introspect.zig` module of the Zig Standard Library. We can see in its return type annotation, that this
function return either: 1) a valid slice of `u8` values (`[]u8`); or, 2) one of the three different
types of error values listed inside the error set (`OutOfMemory`, `Unexpected`, etc.).
This is an usage example of an error set.


```{zig}
#| eval: false
pub fn resolvePath(
    ally: mem.Allocator,
    p: []const u8,
) error{
    OutOfMemory,
    CurrentWorkingDirectoryUnlinked,
    Unexpected,
}![]u8 {
    // The body of the function ...
}
```


This is a valid way of annotating the return value of a Zig function. But, if you navigate through
the modules that composes the Zig Standard Library, you will notice that, for the majority of cases,
the programmers prefer to give a descriptive name to this error set, and then, use this name (or this "label")
of the error set in the return type annotation, instead of using the error set directly.

We can see that in the `ReadError` error set that we showed earlier in the `fill()` function,
which is defined in the `http.Client` module.
So yes, I presented the `ReadError` as if it was just a standard and single error value, but in fact,
it's an error set defined in the `http.Client` module, and therefore, it actually represents
a set of different error values that might happen inside the `fill()` function.


Take a look at the `ReadError` definition reproduced below. Notice that we are grouping all of these
different error values into a single object, and then, we use this object into the return type annotation of the function.
Like the `fill()` function that we showed earlier, or, the `readvDirect()` function from the same module,
which is reproduced below.

```{zig}
#| eval: false
pub const ReadError = error{
    TlsFailure,
    TlsAlert,
    ConnectionTimedOut,
    ConnectionResetByPeer,
    UnexpectedReadFailure,
    EndOfStream,
};
// Some lines of code
pub fn readvDirect(
        conn: *Connection,
        buffers: []std.posix.iovec
    ) ReadError!usize {
    // The body of the function ...
}
```

So, an error set is just a convenient way of grouping a set of
possible error values into a single object, or a single type of an error value.


### Casting error values

Let's suppose you have two different error sets, named `A` and `B`.
If error set `A` is a superset of error set `B`, then, you can cast (or coerce)
error values from `B` into error values of `A`.

Error sets are just a set of error values. So, if the error set `A`
contains all error values from the error set `B`, then `A`
becomes a superset of `B`. You could also say
that the error set `B` is a subset of error set `A`.

The example below demonstrates this idea. Because `A` contains all
values from `B`, `A` is a superset of `B`.
In math notation, we would say that $A \supset B$.
As a consequence, we can give an error value from `B` as input to the `cast()`
function, and, implicitly cast this input into the same error value, but from the `A` set.


```{zig}
#| build_type: "test"
const std = @import("std");
const A = error{
    ConnectionTimeoutError,
    DatabaseNotFound,
    OutOfMemory,
    InvalidToken,
};
const B = error {
    OutOfMemory,
};

fn cast(err: B) A {
    return err;
}

test "coerce error value" {
    const error_value = cast(B.OutOfMemory);
    try std.testing.expect(
        error_value == A.OutOfMemory
    );
}
```


## How to handle errors

Now that we learned more about what errors are in Zig,
let's discuss the available strategies to handle these errors,
which are:

- `try` keyword;
- `catch` keyword;
- an if statement;
- `errdefer` keyword;



### What `try` means?

As I described over the previous sections, when we say that an expression might
return an error, we are basically referring to an expression that have
a return type in the format `!T`.
The `!` indicates that this expression returns either an error value, or a value of type `T`.

In @sec-main-file, I presented the `try` keyword and where to use it.
But I did not talked about what exactly this keyword does to your code,
or, in other words, I have not explained yet what `try` means in your code.

In essence, when you use the `try` keyword in an expression, you are telling
the `zig` compiler the following: "Hey! Execute this expression for me,
and, if this expression return an error, please, return this error for me
and stop the execution of my program. But if this expression return a valid
value, then, return this value, and move on".

In other words, the `try` keyword is essentially, a strategy to enter in panic mode, and stop
the execution of your program in case an error occurs.
With the `try` keyword, you are telling the `zig` compiler, that stopping the execution
of your program is the most reasonable strategy to take if an error occurs
in that particular expression.

### The `catch` keyword

Ok, now that we understand properly what `try` means, let's discuss `catch` now.
One important detail here, is that you can use `try` or `catch` to handle your errors,
but you **cannot use `try` and `catch` together**. In other words, `try` and `catch`
are different and completely separate strategies in the Zig language.

This is uncommon, and different than what happens in other languages. Most
programming languages that adopts the *try catch* pattern (such as C++, R, Python, Javascript, etc.), normally use
these two keywords together to form the complete logic to
properly handle the errors.
Anyway, Zig tries a different approach in the *try catch* pattern.

So, we learned already about what `try` means, and we also known that both
`try` and `catch` should be used alone, separate from each other. But
what exactly `catch` do in Zig? With `catch`, we can construct a block of
logic to handle the error value, in case it happens in the current expression.

Look at the code example below. Once again, we go back to the previous
example where we were trying to open a file that doesn't exist in my computer,
but this time, I use `catch` to actually implement a logic to handle the error, instead of
just stopping the execution right away.

More specifically, in this example, I'm using a logger object to record some logs into
the system, before I return the error, and stop the execution of the program. For example,
this could be some part of the codebase of a complex system that I do not have full control over,
and I want to record these logs before the program crashes, so that I can debug it later
(e.g. maybe I cannot compile the full program, and properly debug it with a debugger. So, these logs might
be a valid strategy to surpass this barrier).

```{zig}
#| eval: false
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = cwd.openFile(
        init.io, "doesnt_exist.txt", .{}
    ) catch |err| {
        logger.record_context();
        logger.log_error(err);
        return err;
    };
}
```


Therefore, we use `catch` to create a block of expressions that will handle the error.
I can return the error value from this block of expressions, like I did in the above example,
which, will make the program enter in panic mode, and, stop the execution.
But I could also, return a valid value from this block of code, which would
be stored in the `file` object.

Notice that, instead of writing the keyword before the expression that might return the error,
like we do with `try`, we write `catch` after the expression. We can open the pair of pipes (`|`),
which captures the error value returned by the expression, and makes
this error value available in the scope of the `catch` block as the object named `err`.
In other words, because I wrote `|err|` in the code, I can access the error value
returned by the expression, by using the `err` object.

Although this being the most common use of `catch`, you can also use this keyword
to handle the error in a "default value" style. That is, if the expression returns
an error, we use the default value instead. Otherwise, we use the valid value returned
by the expression.

The Zig official language reference, provides a great example of this "default value"
strategy with `catch`. This example is reproduced below. Notice that we are trying to parse
some unsigned integer from a string object named `str`. In other words, this function
is trying to transform an object of type `[]const u8` (i.e., an array of characters, a string, etc.)
into an object of type `u64`.

But this parsing process done by the function `parseU64()` may fail, resulting in a runtime error.
The `catch` keyword used in this example provides an alternative value (13) to be used in case
this `parseU64()` function raises an error. So, the expression below essentially means:
"Hey! Please, parse this string into a `u64` for me, and store the results into the
object `number`. But, if an error occurs, then, use the value `13` instead".

```{zig}
#| eval: false
const number = parseU64(str, 10) catch 13;
```

So, at the end of this process, the object `number` will contain either a `u64` integer
that was parsed successfully from the input string `str`, or, if an error occurs in the
parsing process, it will contain the `u64` value `13` that was provided by the `catch`
keyword as the "default", or, the "alternative" value.



### Using if statements

Now, you can also use if statements to handle errors in your Zig code.
In the example below, I'm reproducing the previous example, where
we try to parse an integer value from an input string with a function
named `parseU64()`.

We execute the expression inside the "if". If this expression returns an
error value, the "if branch" (or, the "true branch") of the if statement is not executed.
But if this expression returns a valid value instead, then, this value is unwrapped
into the `number` object.

This means that, if the `parseU64()` expression returns a valid value, this value becomes available
inside the scope of this "if branch" (i.e., the "true branch") through the object that we listed inside the pair
of pipe character (`|`), which is the object `number`.

If an error occurs, we can use an "else branch" (or the "false branch") of the if statement
to handle the error. In the example below, we are using the `else` in the if statement
to unwrap the error value (that was returned by `parseU64()`) into the `err` object,
and handle the error.

```{zig}
#| eval: false
if (parseU64(str, 10)) |number| {
    // do something with `number` here
} else |err| {
    // handle the error value.
}
```

Now, if the expression that you are executing returns different types of error values,
and you want to take a different action in each of these types of error values, the
`try` and `catch` keywords, and the if statement strategy, becomes limited.

For this type of situation, the official documentation of the language suggests
the use of a switch statement together with an if statement [@zigdocs].
The basic idea is, to use the if statement to execute the expression, and
use the "else branch" to pass the error value to a switch statement, where
you define a different action for each type of error value that might be
returned by the expression executed in the if statement.

The example below demonstrates this idea. We first try to add (or register) a set of
tasks to a queue. If this "registration process" occurs well, we then try
to distribute these tasks across the workers of our system. But
if this "registration process" returns an error value, we then use a switch
statement in the "else branch" to handle each possible error value.

```{zig}
#| eval: false
if (add_tasks_to_queue(&queue, tasks)) |_| {
    distribute_tasks(&queue);
} else |err| switch (err) {
    error.InvalidTaskName => {
        // do something
    },
    error.TimeoutTooBig => {
        // do something
    },
    error.QueueNotFound => {
        // do something
    },
    // and all the other error options ...
}
```


### The `errdefer` keyword {#sec-errdefer2}

A common pattern in C programs in general, is to clean resources when an error occurs during
the execution of the program. In other words, one common way to handle errors, is to perform
"cleanup actions" before we exit our program. This guarantees that a runtime error does not make
our program to leak resources of the system.


The `errdefer` keyword is a tool to perform such "cleanup actions" in hostile situations.
This keyword is commonly used to clean (or to free) allocated resources, before the execution of our program
gets stopped because of an error value being generated.

The basic idea is to provide an expression to the `errdefer` keyword. Then,
`errdefer` executes this expression if, and only if, an error occurs
during the execution of the current scope.
In the example below, we are using an allocator object (that we have presented in @sec-allocators)
to create a new `User` object. If we are successful in creating and registering this new user,
this `create_user()` function will return this new `User` object as its return value.

However, if for some reason, an error value is generated by some expression
that is after the `errdefer` line, for example, in the `db.add(user)` expression,
the expression registered by `errdefer` gets executed before the error value is returned
from the function, and before the program enters in panic mode and stops the
current execution.


```{zig}
#| eval: false
fn create_user(db: Database, allocator: Allocator) !User {
    const user = try allocator.create(User);
    errdefer allocator.destroy(user);

    // Register new user in the Database.
    _ = try db.register_user(user);
    return user;
}
```

By using `errdefer` to destroy the `user` object that we have just created,
we guarantee that the memory allocated for this `user` object
gets freed, before the execution of the program stops.
Because if the expression `try db.add(user)` returns an error value,
the execution of our program stops, and we lose all references and control over the memory
that we have allocated for the `user` object.
As a result, if we do not free the memory associated with the `user` object before the program stops,
we cannot free this memory anymore. We simply lose our chance to do the right thing.
That is why `errdefer` is essential in this situation.

Just to state clearly the differences between `defer` and `errdefer`
(which I described in @sec-defer and @sec-errdefer1), it might be worth
to discuss the subject a bit further. You might still have the question
"why use `errdefer` if we can use `defer` instead?" in your mind.

Although being similar, the key difference between `errdefer` and `defer` keyword
is when the provided expression gets executed.
The `defer` keyword always execute the provided expression at the end of the
current scope, no matter how your code exits this scope.
In contrast, `errdefer` executes the provided expression only when an error occurs in the
current scope.

This becomes important if a resource that you allocate in the
current scope gets freed later in your code, in a different scope.
The `create_user()` functions is an example of this. If you think
closely about this function, you will notice that this function returns
the `user` object as the result.

In other words, the allocated memory for the `user` object does not get
freed inside the `create_user()` function, if it returns successfully.
So, if an error does not occur inside this function, the `user` object
is returned from the function, and probably, the code that runs after
this `create_user()` function will be responsible for freeing
the memory of the `user` object.

But what if an error occurs inside the `create_user()` function? What happens then?
This would mean that the execution of your code would stop in this `create_user()`
function, and, as a consequence, the code that runs after this `create_user()`
function would simply not run, and, as a result, the memory of the `user` object
would not be freed before your program stops.

This is the perfect scenario for `errdefer`. We use this keyword to guarantee
that our program will free the allocated memory for the `user` object,
even if an error occurs inside the `create_user()` function.

If you allocate and free some memory for an object inside the same scope, then,
just use `defer` and be happy, i.e., `errdefer` have no use for you in such situation.
But if you allocate some memory in a scope A, but you only free this memory
later, in a scope B for example, then, `errdefer` becomes useful to avoid leaking memory
in sketchy situations.



## Union type in Zig {#sec-unions}

A union type defines a set of types that an object can be. It's like a list of
options. Each option is a type that an object can assume. Therefore, unions in Zig
have the same meaning, or, the same role as unions in C. They are used for the same purpose.
You could also say that unions in Zig produces a similar effect to
[using `typing.Union` in Python](https://docs.python.org/3/library/typing.html#typing.Union)[^pyunion].

[^pyunion]: <https://docs.python.org/3/library/typing.html#typing.Union>

For example, you might be creating an API that sends data to a data lake, hosted
in some private cloud infrastructure. Suppose you have created different structs in your codebase,
to store the necessary information that you need, in order to connect to the services of
each mainstream data lake service (Amazon S3, Azure Blob, etc.).

Now, suppose you also have a function named `send_event()` that receives an event as input,
and, a target data lake, and it sends the input event to the data lake specified in the
target data lake argument. But this target data lake could be any of the three mainstream data lakes
services (Amazon S3, Azure Blob, etc.). Here is where an union can help you.

The union `LakeTarget` defined below allows the `lake_target` argument of `send_event()`
to be either an object of type `AzureBlob`, or type `AmazonS3`, or type `GoogleGCP`.
This union allows the `send_event()` function to receive an object of any of these three types
as input in the `lake_target` argument.

Remember that each of these three types (`AmazonS3`, `GoogleGCP` and `AzureBlob`)
are separate structs that we have defined in our source code. So, at first glance,
they are separate data types in our source code. But is the `union` keyword that
unifies them into a single data type called `LakeTarget`.

```{zig}
#| eval: false
const LakeTarget = union {
    azure: AzureBlob,
    amazon: AmazonS3,
    google: GoogleGCP,
};

fn send_event(
    event: Event,
    lake_target: LakeTarget
) bool {
    // body of the function ...
}
```

An union definition is composed by a list of data members. Each data member is of a specific data type.
In the example above, the `LakeTarget` union have three data members (`azure`, `amazon`, `google`).
When you instantiate an object that uses an union type, you can only use one of its data members
in this instantiation.

You could also interpret this as: only one data member of an union type can be activated at a time, the other data
members remain deactivated and unaccessible. For example, if you create a `LakeTarget` object that uses
the `azure` data member, you can no longer use or access the data members `google` or `amazon`.
It's like if these other data members didn't exist at all in the `LakeTarget` type.

You can see this logic in the example below. Notice that, we first instantiate the union
object using the `azure` data member. As a result, this `target` object contains only
the `azure` data member inside of it. Only this data member is active in this object.
That is why the last line in this code example is invalid. Because we are trying to instantiate the data member
`google`, which is currently inactive for this `target` object, and as a result, the program
enters in panic mode warning us about this mistake through a loud error message.

```{zig}
#| eval: false
var target = LakeTarget {
    .azure = AzureBlob.init()
};
// Only the `azure` data member exist inside
// the `target` object, and, as a result, this
// line below is invalid:
target.google = GoogleGCP.init();
```

```
thread 2177312 panic: access of union field 'google' while
    field 'azure' is active:
    target.google = GoogleGCP.init();
          ^
```

So, when you instantiate an union object, you must choose one of the data types (or, one of the data members)
listed in the union type. In the example above, I choose to use the `azure` data member, and, as a result,
all other data members were automatically deactivated,
and you can no longer use them after you instantiate the object.

You can activate another data member by completely redefining the entire enum object.
In the example below, I initially use the `azure` data member. But then, I redefine the
`target` object to use a new `LakeTarget` object, which uses the `google` data member.

```{zig}
#| eval: false
var target = LakeTarget {
    .azure = AzureBlob.init()
};
target = LakeTarget {
    .google = GoogleGCP.init()
};
```

A curious fact about union types, is that, at first, you cannot use them in switch statements (which were presented in @sec-switch).
In other words, if you have an object of type `LakeTarget` for example, you cannot give this object
as input to a switch statement.

But what if you really need to do so? What if you actually need to
provide an "union object" to a switch statement? The answer to this question relies on another special type in Zig,
which are the *tagged unions*. To create a tagged union, all you have to do is to add
an enum type into your union declaration.

As an example of a tagged union in Zig, take the `Registry` type exposed
below. This type comes from the
[`grammar.zig` module](https://codeberg.org/ziglang/zig/src/branch/master/tools/spirv/grammar.zig)[^grammar]
from the Zig repository. This union type lists different types of registries.
But notice this time, the use of `(enum)` after the `union` keyword. This is what makes
this union type a tagged union. By being a tagged union, an object of this `Registry` type
can be used as input in a switch statement. This is all you have to do. Just add `(enum)`
to your `union` declaration, and you can use it in switch statements.

[^grammar]: <https://codeberg.org/ziglang/zig/src/branch/master/tools/spirv/grammar.zig>.

```{zig}
#| eval: false
pub const Registry = union(enum) {
    core: CoreRegistry,
    extension: ExtensionRegistry,
};
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Data Structures

In this chapter, I want to present the most common Data Structures that are available from
the Zig Standard Library, especially `ArrayList` and also `HashMap`. These are generic Data Structures
that you can use to store and control any type of data that is produced by your application.

## Dynamic Arrays {#sec-dynamic-array}

In high level languages, arrays are usually dynamic. They can easily grow
in size when they have to, and you don't need to worry about it.
In contrast, arrays in low level languages are usually static by default.
This is the reality of C, C++, Rust and also Zig. Static arrays were presented at
@sec-arrays, but in this section, we are going to talk about dynamic arrays in Zig.

Dynamic arrays are simply arrays that can grow in size during the runtime
of your program. Most low level languages have some implementation of
a dynamic array in their standard library. C++ have `std::vector`, Rust have `Vec`,
and Zig have `std.ArrayList`.

The `std.ArrayList` struct provides a contiguous and growable array for you.
It works like any other dynamic array, it allocates a contiguous block of memory, and when this block have no space left,
`ArrayList` allocates another contiguous and bigger block of memory, copies the
elements to this new location, and erases (or frees) the previous block of memory.


### Capacity vs Length

When we talk about dynamic arrays, we usually have two similar concepts that
are very essential to how a dynamic array works behind the hood.
These concepts are *capacity* and *length*. In some contexts, especially
in C++, *length* is also called of *size*.

Although they look similar, these concepts represent different things
in the context of a dynamic array. *Capacity* is the number of items (or elements)
that your dynamic array can currently hold without the need to allocate more memory.

In contrast, the *length* refers to how many elements in the array
are currently being used, or, in other words, how many elements in this array
that you have assigned a value to. Every dynamic array works around
a block of allocated memory, which represents an array with total capacity for $n$ elements.
However, only a portion of these $n$ elements are being used most of the time. This portion
of $n$ is the *length* of the array. So every time you append a new value
to the array, you are incrementing its *length* by one.

This means that a dynamic array usually works with an extra margin, or an extra space
that is currently empty, but waiting and ready to be used. This "extra space"
is essentially the difference between *capacity* and *length*. *Capacity* represents
the total number of elements that the array can hold without the need to re-allocate
or re-expand the array, while the *length* represents how much of this capacity
is currently being used to hold/store values.

@fig-capacity-length presents this idea visually. Notice that, at first,
the capacity of the array is greater than the length of the array.
So, the dynamic array have extra space that is currently empty, but it
is ready to receive a value to be stored.

![Difference between capacity and length in a dynamic array](./../Figures/dynamic-array.png){#fig-capacity-length}

We can also see in @fig-capacity-length that, when *length* and *capacity* are equal, it means that the array have no space left.
We have reached the ceiling of our capacity, and because of that, if we want to store more values
in this array, we need to expand it. We need to get a bigger space that can hold more values
than what we currently have.

A dynamic array works by expanding the underlying array, whenever the *length* becomes equal
to the *capacity* of the array. It basically allocates a new contiguous block of memory that is bigger
than the previous one, then, it copies all values that are currently being stored to this new
location (i.e., this new block of memory), then, it frees the previous block of
memory. At the end of this process, the new underlying array have a bigger *capacity*, and, therefore,
the *length* becomes, once again, smaller than the *capacity* of the array.

This is the cycle of a dynamic array. Notice that, throughout this cycle, the *capacity* is always
either equal to or higher than the *length* of the array. If you have an `ArrayList` object (let's suppose
you named it `buffer`), you can check the current capacity of your array by accessing the `capacity`
attribute of your `ArrayList` object, while the current *length* of it is available at the `items.len`
attribute.


```{zig}
#| eval: false
// Check capacity
buffer.capacity;
// Check length
buffer.items.len;
```


### Creating an `ArrayList` object

In order to use `ArrayList`, you must provide an allocator object to it.
Remember, Zig does not have a default memory allocator. And as I described in @sec-allocators, all memory
allocations must be done by an allocator object that you define, that
you have control over. In our example here, I'm going to use
a general purpose allocator, but you can use any other allocator
of your preference.

When you initialize an `ArrayList` object, you must provide the data type of the elements of
the array. In other words, this defines the type of data that this array (or container) will
store. Therefore, if I provide the `u8` type to it, then, I will create a dynamic
array of `u8` values. However, if I provide a struct that I have defined instead, like the struct `User`
from @sec-structs-and-oop, then, a dynamic array of `User` values
will be created. In the example below, with the expression `ArrayList(u8)` we
are creating a dynamic array of `u8` values.

After you provide the data type of the elements of the array, you can initialize
an `ArrayList` object by either using the `init()` or the `initCapacity()` methods.
The former method receives only the allocator object
as input, while the latter method receives both the allocator object and a capacity number as inputs.
With the latter method, you not only initialize the struct, but you
also set the starting capacity of the allocated array.

Using the `initCapacity()` method is the preferred way to initialize your dynamic array.
Because reallocations, or, in other words, the process of expanding the capacity of the array,
is always a high cost operation. You should take any possible opportunity to avoid reallocations in
your array. If you know how much space your array needs to occupy at the beginning,
you should always use `initCapacity()` to create your dynamic array.


```{zig}
#| auto_main: true
#| build_type: "run"
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
var buffer = try std.ArrayList(u8)
    .initCapacity(allocator, 100);
defer buffer.deinit(allocator);
```


In the example above, the `buffer` object starts as an array of 100 elements. If this
`buffer` object needs to create more space to accomodate more elements during the runtime of your program, the `ArrayList`
internals will perform the necessary actions for you automatically.
Also notice the `deinit()` method being used to destroy the `buffer` object at the
end of the current scope, by freeing all the memory that was allocated for the dynamic
array stored in this `buffer` object.


### Adding new elements to the array

Now that we have created our dynamic array, we can start to use it. You can append (a.k.a "add")
new values to this array by using the `append()` method. This method works the same way
as the `append()` method from a Python list, or, the `emplace_back()` method from `std::vector` of C++.
You provide a single value to this method, and the method appends this value to the array.

You can also use the `appendSlice()` method to append multiple values at once. You provide
a slice (slices were described in @sec-arrays) to this method, and the method adds all values present
in this slice to your dynamic array.

```{zig}
#| eval: false
try buffer.append(allocator, 'H');
try buffer.append(allocator, 'e');
try buffer.append(allocator, 'l');
try buffer.append(allocator, 'l');
try buffer.append(allocator, 'o');
try buffer.appendSlice(allocator, " World!");
```

### Removing elements from the array {#sec-dynamic-array-remove}

You can use the `pop()` method to "pop" or remove
the last element in the array. It's worth noting that this method
do not change the capacity of the array. It just deletes or erases
the last value stored in the array.

Also, this method returns as result the value that got deleted. That is, you can
use this method to both get the last value in the array, and also, remove
it from the array. It's a "get and remove value" type of method.

```{zig}
#| eval: false
const exclamation_mark = buffer.pop();
```

Now, if you want to remove specific elements from specific positions
of your array, you can use the `orderedRemove()` method from your
`ArrayList` object. With this method, you can provide an index as input,
then, the method will delete the value that is at this index in the array.
You are effectively reducing the *length* of the array everytime you execute
an `orderedRemove()` operation.

In the example below, we first create an `ArrayList` object, and we fill it
with numbers. Then, we use `orderedRemove()` to remove the value at
index 3 in the array, two consecutive times.

Also, notice that we are assigning the result of `orderedRemove()` to the
underscore character. So we are discarding the result value of this method.
The `orderedRemove()` method returns the value that got deleted, in a similar
style to the `pop()` method.


```{zig}
#| auto_main: true
#| build_type: "lib"
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
var buffer = try std.ArrayList(u8)
    .initCapacity(allocator, 100);
defer buffer.deinit(allocator);

for (0..10) |i| {
    const index: u8 = @intCast(i);
    try buffer.append(allocator, index);
}

std.debug.print(
    "{any}\n", .{buffer.items}
);
_ = buffer.orderedRemove(3);
_ = buffer.orderedRemove(3);

std.debug.print("{any}\n", .{buffer.items});
std.debug.print("{any}\n", .{buffer.items.len});
```

```
{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
{ 0, 1, 2, 5, 6, 7, 8, 9 }
8
```

One key characteristic about `orderedRemove()` is that it preserves the order
of the values in the array. So, it deletes the value that you asked it to
remove, but it also makes sure that the order of the values that remain in the array
stay the same as before.

Now, if you don't care about the order of the values, for example, maybe you want to treat
your dynamic array as a set of values, like the `std::unordered_set`
structure from C++, you can use the `swapRemove()` method instead. This method
works similarly to the `orderedRemove()` method. You give an index to this
method, then, it deletes the value that is at this index in the array.
But this method does not preserve the original order of the values that remain
in the array. As a result, `swapRemove()` is, in general, faster than `orderedRemove()`.


### Inserting elements at specific indexes

When you need to insert values in the middle of your array,
instead of just appending them to the end of the array, you need to use
the `insert()` and `insertSlice()` methods, instead of
the `append()` and `appendSlice()` methods.

These two methods work very similarly to `insert()` and `insert_range()`
from the C++ `std::vector` class. You provide an index to these methods,
and they insert the values that you provide at that index in the array.

```{zig}
#| auto_main: true
#| build_type: "lib"
#| eval: true
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
var buffer = try std.ArrayList(u8)
    .initCapacity(allocator, 10);
defer buffer.deinit(allocator);

try buffer.appendSlice(allocator, "My Pedro");
try buffer.insert(allocator, 4, '3');
try buffer.insertSlice(allocator, 2, " name");
for (buffer.items) |char| {
    try stdout.print("{c}", .{char});
}
try stdout.flush();
```

```
My name P3edro
```


### Conclusion

If you feel the lack of some other method, I recommend
you to read the [official documentation for the `ArrayListAligned`](https://ziglang.org/documentation/master/std/#std.array_list.ArrayListAligned)[^zig-array2]
struct, which describes most of the methods available
through the `ArrayList` object.

You will notice that there is a lot of other methods in this page that
I did not described here, and I recommend you to explore these methods,
and understand how they work.

[^zig-array2]: <https://ziglang.org/documentation/master/std/#std.array_list.ArrayListAligned>



## Maps or HashTables {#sec-maps-hashtables}

Some professionals know this type of data structure by different terms, like "map",
"hashmap" or "associative arrays". But the most common term used is *hashtable*.
Every programming language normally have some implementation of a hashtable in their
standard libraries. Python have `dict()`, C++ have `std::map` and `std::unordered_map`, Rust
have `HashMap`, Javascript have `Object()` and `Map()`, etc.



### What is a hashtable?

A hashtable is a data structure based on key-value pairs.
You provide a key and a value to this structure, then, the hashtable will store
the input value at a location that can be identified by the input
key that you provided.
It does that by using an underlying array and a hash function.
These two components are essential to how a hashtable works.

Under the hood, the hashtable contains an array. This array is where the values
are stored, and the elements of this array are usually called of *buckets*.
So the values that you provide to the hashtable are stored inside buckets,
and you access each bucket by using an index.

When you provide a key to a hashtable, it passes this key to the
hash function. This hash function uses some sort of hashing algorithm to transform
this key into an index. This index is actually an array index. It's a position
in the underlying array of the hashtable.
This is how a key identifies a specific position (or location) inside the hashtable
structure.

Therefore, you provide a key to the hashtable, and this key identifies a specific location
inside the hashtable, then, the hashtable takes the input value that you provided,
and stores this value in the location identified by this input key.
You could say that the key maps to the value stored in the hashtable. You find
the value, by using the key that identifies the location where the value is stored.
The @fig-hashtable presents this process visually.


![A diagram of a Hashtable. Source: Wikipedia, the free encyclopedia.](./../Figures/hashtable.svg){#fig-hashtable}


The operation described in the previous paragraph is normally called an *insertion* operation.
Because you are inserting new values into the hashtable.
But there are other types of operations in hashtables such as *delete* and *lookup*.
Delete is self describing, it's when you delete (or remove) a value from the hashtable.
While lookup corresponds to when you look at a value that is stored in
the hashtable, by using the key that identifies the location where this value is stored.

Sometimes, instead of storing the values directly, the underlying array of the hashtable might be an array of pointers,
i.e., the buckets of the array stores pointers that points to the value,
or also, may be an array of linked lists.
These cases are common on hashtables that allows duplicate keys, or, in other words,
on hashtables that effectively handle "collisions" that may arise from the hash function.

Duplicate keys, or this "collision" thing that I'm talking about, is when you have two different keys
that points to the same location (i.e., to the same index)
in the underlying array of the hashtable. This might happen depending on the characteristics of the hash function
that is being used in the hashtable. Some implementations of the hashtable will actively deal with collisions,
meaning that, they will handle this case in some way. For example, the hashtable
might transform all buckets into linked lists. Because with a linked list you can store
multiple values into a single bucket.

There are different techniques to handle collisions in hashtables, which I will not describe
in this book, because it's not our main scope here. But you can find a good description of
some of the most common techniques at the Wikipedia page of hashtables [@wikipedia_hashtables].


### Hashtables in Zig {#sec-hashmap}

The Zig Standard Library provides different implementations of a hashtable.
Each implementation have its own cons and pros, which we will
discuss later on, and all of them are available through the `std.hash_map` module.

The `HashMap` struct is a general-purpose hashtable,
which have very fast operations (lookup, insertion, delete), and also,
quite high load factors for low memory usage. You can create and provide a context object
to the `HashMap` constructor. This context object allows you to tailor
the behaviour of the hashtable itself, because you can
provide a hash function implementation to be used by the hashtable
through this context object.

But let's not worry about this context object now, because it's meant to be used
by "experts in the field of hashtables". Since we are most likely not
experts in this field, we are going to take the easy way to create
a hashtable. Which is by using the `AutoHashMap()` function.


This `AutoHashMap()` function is essentially a "create a hashtable object that uses the default settings"
type of function. It automatically chooses a context object, and, therefore, a hash function implementation,
for you. This function receives two data types as input, the first input is the data type of the keys
that will be used in this hashtable, while the second input is the data type of the data that will be
stored inside the hashtable, that is, the data type of the values to be stored.

In the example below, we are providing the data type `u32` in the first argument, and `u16` in the second argument of this
function. This means that we are going to use `u32` values as keys in this hashtable, while `u16` values are the actual values
that are going to be stored into this hashtable.
At the end of this process, the `hash_table` object contains a `HashMap` object
that uses the default settings and context.


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var hash_table = AutoHashMap(u32, u16).init(allocator);
    defer hash_table.deinit();

    try hash_table.put(54321, 89);
    try hash_table.put(50050, 55);
    try hash_table.put(57709, 41);
    std.debug.print(
        "N of values stored: {d}\n",
        .{hash_table.count()}
    );
    std.debug.print(
        "Value at key 50050: {d}\n",
        .{hash_table.get(50050).?}
    );

    if (hash_table.remove(57709)) {
        std.debug.print(
            "Value at key 57709 successfully removed!\n",
            .{}
        );
    }
    std.debug.print(
        "N of values stored: {d}\n",
        .{hash_table.count()}
    );
}
```

```
N of values stored: 3
Value at key 50050: 55
Value at key 57709 successfully removed!
N of values stored: 2
```

You can add/put new values into the hashtable by using the `put()` method. The first argument
is the key to be used, and the second argument is the actual value that you want to store inside
the hashtable. In the example below, we first add the value 89 using the key 54321, next, we add
the value 55 using the key 50050, etc.

Notice that we have used the method `count()` to see how many values are currently stored in the
hashtable. After that, we also use the `get()` method to access (or look) at the value stored in
the position identified by the key 500050. The output of this `get()` method is an optional value.
This is why we use the `?` method at the end to get the actual value.

Also notice that we can remove (or delete) values from the hashtable by using the `remove()` method.
You provide the key that identifies the value that you want to delete, then, the method will
delete this value and return a `true` value as output. This `true` value essentially tells us
that the method successfully deleted the value.

But this delete operation might not be always successful. For example, you might provide the wrong
key to this method. I mean, maybe you provide
(either intentionally or unintentionally) a key that points to an empty bucket,
i.e., a bucket that still doesn't have a value in it.
In this case, the `remove()` method would return a `false` value.



### Iterating through the hashtable

Iterating through the keys and values that are currently being stored in
the hashtable is a very common necessity.
You can do that in Zig by using an iterator object that can iterate
through the elements of your hashtable object.

This iterator object works like any other iterator object that you would
find in languages such as C++ and Rust. It's basically a pointer object
that points to some value in the container, and has a `next()` method
that you can use to navigate (or iterate) through the values in the
container.

You can create such iterator object by using the `iterator()` method of the hashtable object.
This method returns an iterator object, from which you can use the `next()` method in conjunction
with a while loop to iterate through the elements of your hashtable. The `next()` method returns an optional
`Entry` value, and therefore, you must unwrap this optional value to get the actual `Entry` value
from which you can access the key and also the value identified by this key.

With this `Entry` value at hand, you can access the key of this current entry by using the `key_ptr`
attribute and dereferencing the pointer that lives inside of it, while the value identified by this
key is accessed through the `value_ptr` attribute instead, which is also a pointer to be dereferenced.
The code example below demonstrates the use of these elements:


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var hash_table = AutoHashMap(u32, u16).init(allocator);
    defer hash_table.deinit();

    try hash_table.put(54321, 89);
    try hash_table.put(50050, 55);
    try hash_table.put(57709, 41);

    var it = hash_table.iterator();
    while (it.next()) |kv| {
        // Access the current key
        std.debug.print("Key: {d} | ", .{kv.key_ptr.*});
        // Access the current value
        std.debug.print("Value: {d}\n", .{kv.value_ptr.*});
    }
}
```

```
Key: 54321 | Value: 89
Key: 50050 | Value: 55
Key: 57709 | Value: 41
```


If you want to iterate specifically through the values or the keys of your hashtable,
you can create a key iterator or a value iterator object. These are also iterator
objects, which have the same `next()` method that you can use to iterate through the
hashtable.

Key iterators are created from the `keyIterator()` method of your
hashtable object, while value iterators are created from the `valueIterator()` method.
All you have to do is to unwrap the value from the `next()` method and deference it
directly to access the key or the value that you are iterating over.
The code example below demonstrates the use of a key iterator,
but you can replicate the same logic to a value iterator.

```{zig}
#| eval: false
var kit = hash_table.keyIterator();
while (kit.next()) |key| {
    std.debug.print("Key: {d}\n", .{key.*});
}
```

```
Key: 54321
Key: 50050
Key: 57709
```


### The `ArrayHashMap` hashtable {#sec-array-map}

If you need to iterate through the elements of your hashtable constantly,
you might want to use the `ArrayHashMap` struct for your specific case,
instead of going with the usual and general-purpose `HashMap` struct.

The `ArrayHashMap` struct creates a hashtable that is faster to iterate over.
That is why this specific type of hashtable might be valuable to you.
Some other properties of a `ArrayHashMap` hashtable are:

- the order of insertion is preserved, i.e., the order of the values that you find while iterating through this hashtable is actually the order in which these values were inserted in the hashtable.
- the key-value pairs are stored sequentially, one after another.


You can create an `ArrayHashMap` object by using, once again, a helper function that
chooses automatically for you a hash function implementation. This is the
`AutoArrayHashMap()` function, which works very similarly to the `AutoHashMap()`
function that we presented in @sec-hashmap.

You provide two data types to this function. The data type of the keys that will be
used in this hashtable, and the data type of the values that will be stored in
this hashtable.

An `ArrayHashMap` object have essentially the exact same methods from the `HashMap` struct.
So you can insert new values into the hashtable by using the `put()` method, and you can look (or get)
a value from the hashtable by using the `get()` method. But the `remove()` method is not available
in this specific type of hashtable.

In order to delete values from the hashtable, you would use the same methods that you find in
an `ArrayList` object, i.e., a dynamic array. I presented these methods in @sec-dynamic-array-remove,
which are the `swapRemove()` and `orderedRemove()` methods. These methods have the same meaning here, or,
the same effect that they have in an `ArrayList` object.

This means that, with `swapRemove()` you remove the value from the hashtable, but you do not preserve
the order in which the values were inserted into the structure. While `orderedRemove()` is able
to retain the order in which these values were inserted.

But instead of providing an index as input to `swapRemove()` or `orderedRemove()`, like I described
in @sec-dynamic-array-remove, these methods here in an `ArrayHashMap` take a key as input, like
the `remove()` method from a `HashMap` object. If you want to provide an index as input, instead
of a key, you should use the `swapRemoveAt()` and `orderedRemoveAt()` methods.


```{zig}
#| eval: false
var hash_table = AutoArrayHashMap(u32, u16)
    .init(allocator);
defer hash_table.deinit();
```



### The `StringHashMap` hashtable {#sec-string-hash-map}

One thing that you will notice in the other two types of hashtables that I have
presented over the last sections, is that neither of them accepts a slice data type
in their keys.
What this means is that you cannot use a slice value to represent a key in
these types of hashtable.

The most obvious consequence of this, is that you cannot use strings as keys
in these hashtables. But it's extremely common to use strings as keys
in hashtables.

Take this very simple Javascript code snippet as an example. We are creating
a simple hashtable object named `people`. Then, we add a new entry to this
hashtable, which is identified by the string `'Pedro'`. This string is the
key in this case, while the object containing different personal information such as
age, height and city, is the value to be stored in the hashtable.

```js
var people = new Object();
people['Pedro'] = {
    'age': 25,
    'height': 1.67,
    'city': 'Belo Horizonte'
};
```

This pattern of using strings as keys is very common in
all sorts of situations. That is why the Zig Standard Library offers a
specific type of hashtable for this purpose, which is created through the `StringHashMap()` function.
This function creates a hashtable that uses strings as keys. The only input of this
function is the data type of the values that will be stored into this hashtable.

In the example below, I'm creating a hashtable to store the ages of different people.
Each key in this hashtable is represented by the name of each person, while the value stored in the
hashtable is the age of this person identified by the key.

That is why I provide the `u8` data type (which is the data type used by the age values) as input to this `StringHashMap()` function.
As the result, it creates a hashtable that uses string values as keys, and, that stores
`u8` values in it. Notice that an allocator object is provided at the `init()` method of the
resulting object from the `StringHashMap()` function.

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var ages = std.StringHashMap(u8).init(allocator);
    defer ages.deinit();

    try ages.put("Pedro", 25);
    try ages.put("Matheus", 21);
    try ages.put("Abgail", 42);

    var it = ages.iterator();
    while (it.next()) |kv| {
        std.debug.print("Key: {s} | ", .{kv.key_ptr.*});
        std.debug.print("Age: {d}\n", .{kv.value_ptr.*});
    }
}
```

```
Key: Pedro | Age: 25
Key: Abgail | Age: 42
Key: Matheus | Age: 21
```


### The `StringArrayHashMap` hashtable

The Zig Standard Library also provides a type of hashtable that mix the cons and pros of the
`StringHashMap` and `ArrayHashMap` together. That is, a hashtable
that uses strings as keys, but also have the advantages from `ArrayHashMap`.
In other words, you can have a hashtable that is fast to iterate over,
that preserves insertion order, and also, that uses strings as keys.

You can create such type of hashtable by using the `StringArrayHashMap()` function.
This function accepts a data type as input, which is the data type of the values that are
going to be stored inside this hashtable, in the same style as the function presented
in @sec-string-hash-map.

You can insert new values into this hashtable by using the same `put()` method that
we have discussed in @sec-string-hash-map. And you can also get values from the hashtable
by using the same `get()` method.
Like its `ArrayHashMap` brother, to delete values from this specific type of hashtable,
we also use the `orderedRemove()` and `swapRemove()` methods, with the same effects that
I have described in @sec-array-map.

If we take the code example that was exposed in @sec-string-hash-map, we can
achieve the exact same result with `StringArrayHashMap()`:

```{zig}
#| eval: false
var ages = std.StringArrayHashMap(u8).init(allocator);
```




## Linked lists

The Zig Standard Library provides an implementation for both singly and doubly linked lists.
More specifically, through the structs `SinglyLinkedList` and `DoublyLinkedList`.

In case you are not familiar with these data structures, a linked list is a linear data structure that looks
like a chain, or, a rope. The main advantage of this data structure is that you normally have very fast
insertion and deletion operations. But, as a disadvantage, iterating through
this data structure is usually not so fast as iterating through an array.

The idea behind a linked list is to build a structure that consists of a sequence of nodes
connected to each other by pointers. This means that linked lists are usually not contiguous
in memory, because each node might be anywhere in memory. They do not need to be close to
one another.

In @fig-linked-list we can see a diagram of a singly linked list. We begin at the first node
(which is usually called "the head of the linked list"). Then, from this
first node we uncover the remaining nodes in the structure, by following the locations pointed
by the pointers found in each node.

Each node has two things in it. It has the value that is stored in the current node
, and also, a pointer. This pointer points to the next node in the list. If this pointer
is null, then, it means that we have reached the end of our linked list.

![A diagram of a singly linked list.](./../Figures/linked-list.png){#fig-linked-list}


In @fig-linked-list2 we can see a diagram of a doubly linked list. The only thing that really
changes now is that every node in the linked list has both a pointer to the previous node,
and, a pointer to the next node. So every node in a doubly linked list has two pointers in it. These are
usually called the `prev` (for "previous") and the `next` (for "next") pointers of the node.

In the singly linked list example, we had only one single pointer in each node, and this singular
pointer was always pointing to the next node in the sequence. This means that singly linked lists
normally have only the `next` pointer in them.

![A diagram of a doubly linked list.](./../Figures/doubly-linked-list.png){#fig-linked-list2}



### Recent change in the API

On previous versions of Zig, the `SinglyLinkedList` and `DoublyLinkedList` structs were initially implemented as "generics data structures".
Meaning that, you would use a generic function to create a singly (or doubly) linked list that could store
the specific data type that you wanted to use. We will learn more about generics at @sec-generics, and also,
how we can create a "generic data structure" at @sec-generic-struct.

However, on the latest versions of Zig, the structs `SinglyLinkedList` and `DoublyLinkedList` were altered to use a
"less generic API". This specific change was introduced on April 3, 2025. Therefore, check if your Zig version is one released after this
date. Just have in mind that if you don't have a very recent version of the Zig compiler,
you might have problems while trying to compile the next examples exposed here.



### How to use a singly linked list

For example, consider that you are creating a singly linked list that is going to store `u32` values.
Given this scenario, the first thing that we need to do, is to create a "node type" that is capable
of storing a `u32` value. The `NodeU32` type exposed below demonstrates such "node type".

Notice that the data type associated with the member named `data` is the most important part of this
custom "node type". It determines the data type that is going to be stored in each node.

```{zig}
#| eval: false
const std = @import("std");
const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};
```

After we created our custom "node type" that can store the specific data type that we
want, we can just create a new and empty singly linked list, which will store our nodes.
To do that, we just create a new object with the type `SinglyLinkedList`, like this:

```{zig}
#| eval: false
var list: std.SinglyLinkedList = .{};
```

Now, we have our linked list... But how can we insert nodes in it? Well, first of all,
we need to create our nodes. So let's focus on that first. The snippet exposed below demonstrates
how we could use our `NodeU32` struct to create such nodes.

Notice in this snippet that we are just setting the `data` member of the struct for now.
We don't need to connect these nodes together in this first instance. This is why we ignore
the `node` member at first. But we are going to connect these nodes in a future point of the code, which is
why these objects are marked as "variable objects", so that we can alter them in the future.

```{zig}
#| eval: false
var one: NodeU32 = .{ .data = 1 };
var two: NodeU32 = .{ .data = 2 };
var three: NodeU32 = .{ .data = 3 };
var five: NodeU32 = .{ .data = 5 };
```

Now that we have both the linked list and also the nodes created, we can start to connect them together.
You can use the `prepend()` method from the linked list object to insert the first node in the list, which
is the "head" of the linked list. As the name suggests, this specific method prepends the input node to the linked list,
or, in other words, it transforms the input node into the first node of the list.

After we added the "head node" of the list, we can start to add the "next nodes" in the list by using the `insertAfter()` method
from the `SinglyLinkedList.Node` type, which, in our case here, is accessible through the `node` member of our
`NodeU32` type. Thus, we can start to create the connections between the nodes by calling this method from the node objects
that are present in the list. Like in this example below:

```{zig}
#| eval: false
list.prepend(&two.node); // {2}
two.node.insertAfter(&five.node); // {2, 5}
two.node.insertAfter(&three.node); // {2, 3, 5}
```

You can also call the `prepend()` method again to add new nodes to the beginning of the linked list, which
means, effectively, changing the "head node" of the list, like this:

```{zig}
#| eval: false
list.prepend(&one.node); // {1, 2, 3, 5}
```


There are other methods available from the singly linked list object that you might be interested. You can find a
summary of them in the bullet points below:

- `remove()` to remove a specific node from the linked list.
- `len()` to count how many nodes there is in the linked list.
- `popFirst()` to remove the first node (i.e., the "head") from the linked list.

So, that is how singly linked lists work in Zig in a nutshell. To sum up,
this is all the source code that was exposed in this section inside the single cell:

```{zig}
#| build_type: "run"
#| auto_main: true
const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};

var list: std.SinglyLinkedList = .{};
var one: NodeU32 = .{ .data = 1 };
var two: NodeU32 = .{ .data = 2 };
var three: NodeU32 = .{ .data = 3 };
var five: NodeU32 = .{ .data = 5 };

list.prepend(&two.node); // {2}
two.node.insertAfter(&five.node); // {2, 5}
two.node.insertAfter(&three.node); // {2, 3, 5}
list.prepend(&one.node); // {1, 2, 3, 5}

try stdout.print("Number of nodes: {}", .{list.len()});
try stdout.flush();
```


### How to use a doubly linked list

If you want to use a doubly linked list instead, you will face a similar workflow compared to the
singly linked list:

1. You first create a "custom node type" that can store the specific data type that you want.
2. Create an empty doubly linked list object.
3. Create the nodes of linked list.
4. Start to insert the nodes inside the list.

In your "custom node type", you should use the `DoublyLinkedList.Node` type to denote
the `node` member of the struct. The snippet below demonstrates that. Here we are creating,
once again, a node type that can store `u32` values. But this time, this struct is tailored
to be used inside a `DoublyLinkedList` struct.

After this step, the way that you create the new empty linked list, and the nodes that you want insert,
is practically identical to the singly linked list case. But, this time,
we normally use the `append()` method from the linked list object to add new nodes to the list.

This `append()` method from the linked list object will always append the input node to the end of the
linked list. However, in case you want to add the new node into a different position of the list, then,
you should take a look at the `insertAfter()` and `insertBefore()` methods of the linked list object.
These methods allow you to insert the new node either after or before an existing node in the list.


```{zig}
#| build_type: "run"
#| auto_main: true
const NodeU32 = struct {
    data: u32,
    node: std.DoublyLinkedList.Node = .{},
};

var list: std.DoublyLinkedList = .{};
var one: NodeU32 = .{ .data = 1 };
var two: NodeU32 = .{ .data = 2 };
var three: NodeU32 = .{ .data = 3 };
var five: NodeU32 = .{ .data = 5 };

list.append(&one.node); // {1}
list.append(&three.node); // {1, 3}
list.insertAfter(
    &one.node,
    &five.node
); // {1, 5, 3}
list.append(&two.node); // {1, 5, 3, 2}

try stdout.print("Number of nodes: {}", .{list.len()});
try stdout.flush();
```

These are other methods from the `DoublyLinkedList` object that might interest you:

- `remove()`: to remove a specific node from the list.
- `len()`: to count the number of nodes in the list.
- `prepend()`: to add a node to the beginning of the list (i.e. set the head node of the list).
- `pop()`: to remove the last node of the list.
- `popFirst()`: to remove the first node of the list.
- `concatByMoving()`: to concat two doubly linked lists together.


### Iterating through the linked list

If you want to iterate over the elements of the linked list, all you need to do is to follow
the trail created by the "pointer to next node". We usually do that inside a while loop, that simply goes to the
next node over and over, until it finds a null pointer, which means that we hit the end of the list.

This next example demonstrates how such while loop would work. Notice that we are using the `@fieldParentPtr()`
built-in function to get access to a pointer that points to the parent instance of the `node` object. In other words,
we get access to a pointer to the `NodeU32` instance that contains the current node. This way, we can use this pointer
to access the data that is currently stored in this node.

Also notice that in each iteration of the while loop, we are changing the value of the `it` variable to the next node
in the list. The while loop is interrupted in the moment that this `it` variable becomes null, which will happen
when the there is not "next node" in the list, which means that we have reached the end of the list.


```{zig}
#| build_type: "run"
#| auto_main: true
#| results: "hide"
const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};

var list: std.SinglyLinkedList = .{};
var one: NodeU32 = .{ .data = 1 };
var two: NodeU32 = .{ .data = 2 };
var three: NodeU32 = .{ .data = 3 };
var five: NodeU32 = .{ .data = 5 };

list.prepend(&two.node); // {2}
list.prepend(&five.node); // {5, 2}
list.prepend(&three.node); // {3, 5, 2}
list.prepend(&one.node); // {1, 3, 5, 2}

var it = list.first;
while (it) |node| : (it = node.next) {
    const l: *NodeU32 = @fieldParentPtr(
        "node", node
    );
    try stdout.print(
        "Current value: {}", .{l.data}
    );
}
try stdout.flush();
```

```
Current value: 1
Current value: 3
Current value: 5
Current value: 2
```




## Multi array structure

Zig introduces a new data structure called `MultiArrayList()`. It's a different version of the dynamic array
that we have introduced in @sec-dynamic-array. The difference between this structure and the `ArrayList()`
that we know from @sec-dynamic-array, is that `MultiArrayList()` creates a separate dynamic array
for each field of the struct that you provide as input.

Consider the following code example. We create a new custom struct called `Person`. This
struct contains three different data members, or, three different fields. As consequence,
when we provide this `Person` data type as input to `MultiArrayList()`, this
creates a "struct of three different arrays" called `PersonArray`. In other words,
this `PersonArray` is a struct that contains three internal dynamic arrays in it.
One array for each field found in the `Person` struct definition.


```{zig}
#| auto_main: false
const std = @import("std");
const Person = struct {
    name: []const u8,
    age: u8,
    height: f32,
};
const PersonArray = std.MultiArrayList(Person);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var people = PersonArray{};
    defer people.deinit(allocator);

    try people.append(allocator, .{
        .name = "Auguste", .age = 15, .height = 1.54
    });
    try people.append(allocator, .{
        .name = "Elena", .age = 26, .height = 1.65
    });
    try people.append(allocator, .{
        .name = "Michael", .age = 64, .height = 1.87
    });
}
```

In other words, instead of creating an array of "persons", the `MultiArrayList()` function
creates a "struct of arrays". Each data member of this struct is a different array that stores
the values of a specific field from the `Person` values that were added (or, appended) to this "struct of arrays".
One important detail is that each of these separate internal arrays stored inside `PersonArray`
are dynamic arrays. This means that these arrays can grow in capacity automatically as needed, to accomodate
more values.

The @fig-multi-array exposed below presents a diagram that describes the `PersonArray` struct
that we have created in the previous code example. Notice that the values of the data members
present in each of the three `Person` values that we have appended into the `PersonArray` object
, are scattered across three different internal arrays of the `PersonArray` object.

![A diagram of the `PersonArray` struct.](./../Figures/multi-array.png){#fig-multi-array}

You can easily access each of these arrays separately, and iterate over the values of each array.
For that, you will need to call the `items()` method from the `PersonArray` object, and provide as input
to this method, the name of the field that you want to iterate over.
If you want to iterate through the `.age` array for example, then, you need to call `items(.age)` from
the `PersonArray` object, like in the example below:

```{zig}
#| eval: false
for (people.items(.age)) |*age| {
    try stdout.print("Age: {d}\n", .{age.*});
}
try stdout.flush();
```

```
Age: 15
Age: 26
Age: 64
```


In the above example, we are iterating over the values of the `.age` array, or,
the internal array of the `PersonArray` object that contains the values of the `age`
data member from the `Person` values that were added to the multi array struct.

In this example we are calling the `items()` method directly from the `PersonArray`
object. However, in most situations it's recommened to call this `items()` method
from a "slice object", which you can create from the `slice()` method.
The reason for this is that calling `items()` multiple times have better performance
if you use a slice object.

Therefore, if you are planning to access only one of the
internal arrays from your "multi array struct", it's fine to call `items()` directly
from the multi array object. But if you need to access many of the internal arrays
from your "multi array struct", then, you will likely need to call `items()` more
than once, and, in such circumstance, is better to call `items()` through a slice object.
The example below demonstrates the use of such object:

```{zig}
#| eval: false
var slice = people.slice();
for (slice.items(.age)) |*age| {
    age.* += 10;
}
for (slice.items(.name), slice.items(.age)) |*n,*a| {
    try stdout.print(
        "Name: {s}, Age: {d}\n", .{n.*, a.*}
    );
}
try stdout.flush();
```

```
Name: Auguste, Age: 25
Name: Elena, Age: 36
Name: Michael, Age: 74
```


## Conclusion

There are many other data structures that I haven't presented here.
But you can check them out at the official Zig Standard Library documentation page.
Actually, when you get into the [homepage of the documentation](https://ziglang.org/documentation/master/std/#)[^home], the first thing
that appears to you in this page, is a list of types and data structures that
are available in the Zig Standard Library.
There are some very specific data structures in this list, like a
[`BoundedArray` struct](https://ziglang.org/documentation/master/std/#std.bounded_array.BoundedArray)[^bounded]
, but there is also some more general structures, such as a
[`PriorityQueue` struct](https://ziglang.org/documentation/master/std/#std.priority_queue.PriorityQueue)[^priority].


[^home]: <https://ziglang.org/documentation/master/std/#>
[^priority]: <https://ziglang.org/documentation/master/std/#std.priority_queue.PriorityQueue>.
[^bounded]: <https://ziglang.org/documentation/master/std/#std.bounded_array.BoundedArray>
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Project 3 - Building a stack data structure

In this chapter we are going to implement a stack data structure as our next small project
in this book. Implementing basic data structures in any language is kind of a
"kindergarten task" (if this term even exist) in computer science (CS), because
we normally learn and implement them in the first semesters of CS.

But this is actually good! Since this should be a very easy task, we don't need much to explain
what a stack is, then, we can concentrate on what is really important here, which is learning
how the concept of "generics" is implemented in the Zig language, and how one of the key
features of Zig, which is comptime, works, and use the stack data structure to demonstrate
these concepts on the fly.

But before we get into building the stack data structure, we first need to understand
what the `comptime` keyword does to your code, and after that, we also need to learn about
how generics work in Zig.


## Understanding `comptime` in Zig {#sec-comptime}

One of the key features of Zig is `comptime`. This keyword introduces a whole
new concept and paradigm, that is tightly connected with the compilation process.
In @sec-compile-time we have described the importance and the role that "compile-time versus runtime"
plays into Zig. In that section, we learned that the rules applied to a value/object change
a lot depending on whether this value is known at compile-time, or just at runtime.

The `comptime` keyword is strongly related to these two spaces in time (compile-time and runtime).
Let's quickly recap the differences. Compile-time is the period of time when your
Zig source code is being compiled by the `zig` compiler, while the runtime is
the period of time when your Zig program is being executed, i.e., when we execute
the binary files that were generated by the `zig` compiler.

There are three ways in which you can apply the `comptime` keyword, which are:

- apply `comptime` on a function argument.
- apply `comptime` on an object.
- apply `comptime` on a block of expressions.



### Applying over a function argument

When you apply the `comptime` keyword on a function argument, you are saying to the `zig` compiler
that the value assigned to that particular function argument must be known at compile-time.
We explained in detail in @sec-compile-time what exactly "value known at compile-time" means. So
if you have any doubts about this idea, refer back to that section.

Now let's think about the consequences of this idea. First of all, we are imposing a limit, or, a requirement
to that particular function argument. If the programmer accidentally tries to give a value to this
function argument that is not known at compile time, the `zig` compiler will notice this problem, and
as a consequence, it will raise a compilation error saying that it cannot compile your program. Because
you are providing a value that is "runtime known" to a function argument that must be "compile-time known".

Take a look at this very simple example below, where we define a `twice()` function, that simply
doubles the input value named `num`. Notice that we use the `comptime` keyword before the name
of the function argument. This keyword is marking the function argument `num` as a "comptime argument".

That is a function argument whose value must be compile-time known. This is why the expression
`twice(5678)` is valid, and no compilation errors are raised. Because the value `5678`
is compile-time known, so this is the expected behaviour for this function.

```{zig}
#| auto_main: false
#| build_type: "test"
fn twice(comptime num: u32) u32 {
    return num * 2;
}
test "test comptime" {
    _ = twice(5678);
}
```

But what if we provide a number that is not compile-time known to this function?
For example, your program might receive some input from the user through the `stdin`
channel of your system. This input from the user might be many different things,
and cannot be predicted at compile-time. These circumstances make this "input
from the user" a value that is runtime-known only.

In the example below, this "input from the user" is initially received as a string,
which is then parsed and transformed into a integer value, and the result of this operation
is stored inside the `n` object.

Because the "input of the user" is known only at runtime, the value of the object `n` is determined only at runtime.
As consequence, we cannot provide this object as input to the `twice()` function.
The `zig` compiler will not allow it, because we marked
the `num` argument as a "comptime argument". That is why the `zig` compiler raises
the compile-time error exposed below:

```{zig}
#| auto_main: false
#| eval: false
const std = @import("std");
fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    var buffer: [5]u8 = .{ 0, 0, 0, 0, 0 };
    _ = try stdout.write("Please write a 4-digit integer number\n");
    _ = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Input: {s}", .{buffer});
    const n: u32 = try std.fmt.parseInt(
        u32, buffer[0 .. buffer.len - 1], 10
    );
    const twice_result = twice(n);
    try stdout.print("Result: {d}\n", .{twice_result});
    try stdout.flush();
}
```

```
t.zig:12:16: error: unable to resolve comptime value
    const twice_result = twice(n);
                               ^
```

Comptime arguments are frequently used on functions that return some sort
of generic structure. In fact, `comptime` is the essence (or the basis) to make generics in Zig.
We are going to talk more about generics in @sec-generics.

For now, let's take a look at this code example from @karlseguin_generics. You
can see that this `IntArray()` function has one argument named `length`.
This argument is marked as comptime, and receives a value of type `usize` as input. So the value given to this argument
must be compile-time known.
We can also see that this function returns an array of `i64` values as output.

```{zig}
#| eval: false
fn IntArray(comptime length: usize) type {
    return [length]i64;
}
```

Now, the key component of this function is the `length` argument. This argument
is used to determine the size of the array that is produced by the function. Let's
think about the consequences of that. If the size of the array is dependent on
the value assigned to the `length` argument, this means that the data type of the
output of the function depends on the value of this `length` argument.

Let this statement sink for a bit in your mind. As I described in @sec-root-file,
Zig is a strongly-typed language, especially on function declarations.
So every time we write a function in Zig, we have to annotate the data type of
the value returned by the function. But how can we do that, if this data type
depends on the value given to the argument of the function?

Think about this for a second. If `length` is equal to 3 for example, then, the
return type of the function is `[3]i64`. But if `length` is equal to 40, then,
the return type becomes `[40]i64`. At this point the `zig` compiler would be confused,
and raise a compilation error, saying something like this:

> Hey! You have annotated that this function should return a `[3]i64` value, but I got a `[40]i64` value instead! This doesn't look right!

So how can you solve this problem? How do we overcome this barrier? This is when
the `type` keyword comes in. This `type` keyword is basically saying to the
`zig` compiler that this function will return some data type as output, but it doesn't know yet
what exactly data type that is. We will talk more about this in @sec-generics.



### Applying over an expression

When you apply the `comptime` keyword over an expression, then, it is guaranteed that the `zig` compiler will
execute this expression at compile-time. If for some reason, this expression cannot be executed at compile-time
(e.g. for example, maybe this expression depends on a value that is only known at runtime), then, the `zig` compiler
will raise a compilation error.

Take this example from the official documentation of Zig [@zigdocs]. We
are executing the same `fibonacci()` function both at runtime, and, at compile-time.
The function is executed by default at runtime, but because we use the `comptime`
keyword in the second "try expression", this expression is executed at compile-time.

This might be a bit confusing for some people. Yes! When I say that this expression
is executed at compile-time, I mean that this expression is compiled and executed
while the `zig` compiler is compiling your Zig source code.


```{zig}
#| auto_main: false
#| build_type: "test"
const expect = @import("std").testing.expect;
fn fibonacci(index: u32) u32 {
    if (index < 2) return index;
    return fibonacci(index - 1) + fibonacci(index - 2);
}

test "fibonacci" {
    // test fibonacci at run-time
    try expect(fibonacci(7) == 13);
    // test fibonacci at compile-time
    try comptime expect(fibonacci(7) == 13);
}
```

A lot of your Zig source code might be potentially executed at compile-time,
because the `zig` compiler can figure out the output of some expressions.
Especially if these expressions depend only on compile-time known values.
We have talked about this in @sec-compile-time.

But when you use the `comptime` keyword on an expression, there is no "it might be executed
at compile-time" anymore. With the `comptime` keyword you are ordering the `zig` compiler
to execute this expression at compile-time. You are imposing this rule, it is guaranteed
that the compiler will always execute it at compile-time. Or, at least, the compiler
will try to execute it. If the compiler cannot execute the expression for whatever reason,
the compiler will raise a compilation error.


### Applying over a block

Blocks were described in @sec-blocks. When you apply the `comptime` keyword to a
block of expressions, you get essentially the same effect as when you apply this keyword to
a single expression. That is, the entire block of expressions is executed at
compile-time by the `zig` compiler.

In the example below, we mark the block labeled of `blk` as a comptime block,
and, therefore, the expressions inside this block are executed at compile-time.

```{zig}
#| auto_main: false
#| build_type: "test"
const expect = @import("std").testing.expect;
fn fibonacci(index: u32) u32 {
    if (index < 2) return index;
    return fibonacci(index - 1) + fibonacci(index - 2);
}

test "fibonacci in a block" {
    const x = comptime blk: {
        const n1 = 5;
        const n2 = 2;
        const n3 = n1 + n2;
        try expect(fibonacci(n3) == 13);
        break :blk n3;
    };
    _ = x;
}
```





## Introducing Generics {#sec-generics}

First of all, what is a generic? Generic is the idea to allow a type
(`f64`, `u8`, `u32`, `bool`, and also, user-defined types, like the `User` struct
that we defined in @sec-structs-and-oop) to be a parameter to methods, classes and
interfaces [@geeks_generics]. In other words, a "generic" is a class (or a method) that can work
with multiple data types.

For example, in Java, generics are created through the operator `<>`. With this operator,
a Java class is capable of receiving a data type as input, and therefore, the class can fit
its features according to this input data type.
As another example, generics in C++ are supported through the concept of templates.
Class templates in C++ are generics.

In Zig, generics are implemented through `comptime`. The `comptime` keyword
allows us to collect a data type at compile time, and pass this data type as
input to a piece of code.


### A generic function {#sec-generic-fun}

Take the `max()` function exposed below as a first example.
This function is essentially a "generic function".
In this function, we have a comptime function argument named `T`.
Notice that this `T` argument has a data type of `type`. Weird right? This `type` keyword is the
"father of all types", or, "the type of types" in Zig.

Because we have used this `type` keyword in the `T` argument, we are telling
the `zig` compiler that this `T` argument will receive some data type as input.
Also notice the use of the `comptime` keyword in this argument.
As I described in @sec-comptime, every time you use this keyword in a function argument,
this means that the value of this argument must be known at compile-time.
This makes sense, right? Because there is no data type that is not known at compile-time.

Think about this. Every data type that you will ever write is always
known at compile-time. Especially because data types are an essential
information for the compiler to actually compile your source code.
Having this in mind, makes sense to mark this argument as a comptime argument.


```{zig}
#| auto_main: false
#| build_type: "lib"
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}
```

Also notice that the value of the `T` argument is actually used
to define the data type of the other arguments in the function, `a` and `b`, and also at the
return type annotation of the function.
That is, the data type of these arguments (`a` and `b`), and, the return data type of the function itself,
are determined by the input value given to the `T` argument.

As a result, we have a generic function that works with different data types.
For example, I can provide `u8` values to this `max()` function, and it will work as expected.
But if I provide `f64` values instead, it will also work as expected.
Without a generic function, I would have to write a different `max()` function
for each data type I wanted to use.
This generic function provides a very useful shortcut for us.

```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}
test "test max" {
    const n1 = max(u8, 4, 10);
    std.debug.print("Max n1: {d}\n", .{n1});
    const n2 = max(f64, 89.24, 64.001);
    std.debug.print("Max n2: {d}\n", .{n2});
}
```

```
Max n1: 10
Max n2: 89.24
```


### A generic data structure {#sec-generic-struct}

Every data structure that you find in the Zig Standard Library (e.g. `ArrayList`, `HashMap`, etc.)
is essentially a generic data structure.
These data structures are generic in the sense that they work with any data type you want.
You just say which is the data type of the values that are going to be stored in this data
structure, and they just work as expected.

A generic data structure in Zig is how you replicate a generic class from Java,
or, a class template from C++. But you may ask yourself: how do we build a
generic data structure in Zig?

The basic idea is to write a generic function that creates the data structure definition
for the specific type we want. In other words, this generic function behaves as a "factory of data structures".
The generic function outputs the `struct` definition that defines this data structure for a
specific data type.

To create such function, we need to add a comptime argument to this function that receives a data type
as input. We already learned how to do this in the previous section (@sec-generic-fun).
I think the best way to demonstrate how to create a generic data structure is to actually write one.
This where we go into our next small project in this book. This one is a very small project,
which is to write a generic stack data structure.




## What is a stack? {#sec-what-stack}

A stack data structure is a structure that follows a LIFO (*last in, first out*) principle.
Only two operations are normally supported in a stack data structure, which are `push` and `pop`.
The `push` operation is used to add new values to the stack, while `pop` is used to remove
values from the stack.

When people try to explain how the stack data structure works, the most common analogy
that they use is a stack of plates. Imagine that you have a stack of plates,
for example, a stack of 10 plates in your table. Each plate represents a value that
is currently stored in this stack.

We begin with a stack of 10 different values, or 10 different plates. Now, imagine that you want to
add a new plate (or a new value) to this stack, which translates to the `push` operation.
You would add this plate (or this value) by just putting the new plate
on the top of the stack. Then, you would increase the stack to 11 plates.

But how would you remove plates (or remove values) from this stack (a.k.a. the `pop` operation) ?
To do that, we would have to remove the plate on the top of the stack, and, as a result, we would
have, once again, 10 plates in the stack.

This demonstrates the LIFO concept, because the first plate in the stack, which is the plate
in the bottom of the stack, is always the last plate to get out of the stack. Think about it. In order
to remove this specific plate from the stack, we have to remove all plates in the
stack. So every operation in the stack, either insertion or deletion, is always made at the top of the stack.
The @fig-stack below exposes this logic visually:

![A diagram of a stack structure. Source: Wikipedia, the free encyclopedia.](./../Figures/lifo-stack.svg){#fig-stack}



## Writing the stack data structure

We are going to write the stack data structure in two steps. First, we are going
to implement a stack that can only store `u32` values. Then, after that, we are going
to extend our implementation to make it generic, so that it works with any data type
we want.

First, we need to decide how the values will be stored inside the stack. There are multiple
ways to implement the storage behind a stack structure. Some people prefer to use a doubly linked list,
others prefer to use a dynamic array, etc. In this example we are going to use an array behind the hood,
to store the values in the stack, which is the `items` data member of our `Stack` struct definition.

Also notice in our `Stack` struct that we have three other data members: `capacity`, `length` and `allocator`.
The `capacity` member contains the capacity of the underlying array that stores the values in the stack.
The `length` contains the number of values that are currently being stored in the stack.
And the `allocator` contains the allocator object that will be used by the stack structure whenever it
needs to allocate more space for the values that are being stored.

We begin by defining an `init()` method of this struct, which is going to be
responsible for instantiating a `Stack` object. Notice that, inside this
`init()` method, we start by allocating an array with the capacity specified
in the `capacity` argument.


```{zig}
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
const Allocator = std.mem.Allocator;
const Stack = struct {
    items: []u32,
    capacity: usize,
    length: usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator, capacity: usize) !Stack {
        var buf = try allocator.alloc(u32, capacity);
        return .{
            .items = buf[0..],
            .capacity = capacity,
            .length = 0,
            .allocator = allocator,
        };
    }
};
```


### Implementing the `push` operation

Now that we have written the basic logic to create a new `Stack` object,
we can start writing the logic responsible for performing a push operation.
Remember, a push operation in a stack data structure is the operation
responsible for adding a new value to the stack.

So how can we add a new value to the `Stack` object that we have?
The `push()` function exposed below is a possible answer to this question.
Remember from what we discussed in @sec-what-stack that values are always added to the top of the stack.
This means that this `push()` function must always find the element in the underlying array
that currently represents the top position of the stack, and then, add the input value there.

First, we have an if statement in this function. This if statement is
checking whether we need to expand the underlying array to store
this new value that we are adding to the stack. In other words, maybe
the underlying array does not have enough capacity to store this new
value, and, in this case, we need to expand our array to get the capacity that we need.

So, if the logical test in this if statement returns true, it means that the array
does not have enough capacity, and we need to expand it before we store this new value.
So inside this if statement we are executing the necessary expressions to expand the underlying array.
Notice that we use the allocator object to allocate a new array that is twice as bigger
than the current array (`self.capacity * 2`).

After that, we use a different built-in function named `@memcpy()`. This built-in function
is equivalent to the `memcpy()` function from the C Standard Library[^cmemcpy]. It's used to
copy the values from one block of memory to another block of memory. In other words,
you can use this function to copy the values from one array into another array.

[^cmemcpy]: <https://www.tutorialspoint.com/c_standard_library/c_function_memcpy.htm>

We are using this `@memcpy()` built-in function to copy the values that are currently stored
in the underlying array of the stack object (`self.items`) into our new and bigger array that
we have allocated (`new_buf`). After we execute this function, the `new_buf` contains a copy
of the values that are present at `self.items`.

Now that we have secured a copy of our current values in the `new_buf` object, we
can now free the memory currently allocated at `self.items`. After that, we just need
to assign our new and bigger array to `self.items`. This is the sequence
of steps necessary to expand our array.


```{zig}
#| eval: false
pub fn push(self: *Stack, val: u32) !void {
    if ((self.length + 1) > self.capacity) {
        var new_buf = try self.allocator.alloc(
            u32, self.capacity * 2
        );
        @memcpy(
            new_buf[0..self.capacity], self.items
        );
        self.allocator.free(self.items);
        self.items = new_buf;
        self.capacity = self.capacity * 2;
    }

    self.items[self.length] = val;
    self.length += 1;
}
```

After we make sure that we have enough room to store this new value
that we are adding to the stack, all we have to do is to assign
this value to the top element in this stack, and, increase the
value of the `length` attribute by one. We find the top element
in the stack by using the `length` attribute.



### Implementing the `pop` operation

Now we can implement the pop operation of our stack object.
This is a much easier operation to implement, and the `pop()` method below summarises
all the logic that is needed.

We just have to find the element in the underlying array that currently represents the top
of the stack, and set this element to "undefined", to indicate that
this element is "empty". After that, we also need to decrease
the `length` attribute of the stack by one.

If the current length of the stack is zero, it means that there is
no values being stored in the stack currently. So, in this case,
we could just return from the function and do nothing really.
This is what the if statement inside this function is checking for.

```{zig}
#| eval: false
pub fn pop(self: *Stack) void {
    if (self.length == 0) return;

    self.items[self.length - 1] = undefined;
    self.length -= 1;
}
```



### Implementing the `deinit` method

We have implemented the methods responsible for the two main operations
associated with the stack data structure, which is `pop()` and `push()`,
and we also have implemented the method responsible for instantiating
a new `Stack` object, which is the `init()` method.

But now, we need to implement also the method responsible for destroying
a `Stack` object. In Zig, this task is commonly associated with the method
named `deinit()`. Most struct objects in Zig have such method, and it
is commonly nicknamed "the destructor method".

In theory, all we have to do to destroy the `Stack` object is to make
sure that we free the allocated memory for the underlying array, using
the allocator object that is stored inside the `Stack` object.
This is what the `deinit()` method below is doing.

```{zig}
#| eval: false
pub fn deinit(self: *Stack) void {
    self.allocator.free(self.items);
}
```




## Making it generic

Now that we have implemented the basic skeleton of our stack data structure,
we can now focus on discussing how we can make it generic. How can we make
this basic skeleton to work not only with `u32` values, but also with any other
data type we want?
For example, we might need to create a stack object to store `User` values
in it. How can we make this possible? The answer lies in the use of generics
and `comptime`.

As I described in @sec-generic-struct, the basic idea is to write a generic
function that returns a struct definition as output.
In theory, we do not need much to transform our `Stack` struct into a generic
data structure. All that we need to do is to transform the underlying array
of the stack into a generic array.

In other words, this underlying array needs to be a "chameleon". It needs to adapt,
and transform it into an array of any data type that we want. For example, if we need to create
a stack that will store `u8` values, then this underlying array needs to be
a `u8` array (i.e., `[]u8`). But if we need to store `User` values instead, then,
this array needs to be a `User` array (i.e., `[]User`). Etc.

We do that by using a generic function. Because a generic function can receive a data type
as input, and we can pass this data type to the struct definition of our `Stack` object.
Therefore, we can use the generic function to create a `Stack` object that can store
the data type we want. If we want to create a stack structure that stores `User` values,
we pass the `User` data type to this generic function, and it will create for us
the struct definition that describes a `Stack` object that can store `User` values in it.

Look at the code example below. I have omitted some parts of the `Stack` struct definition
for brevity. However, if a specific part of our `Stack` struct is not exposed here
in this example, then it's because this part did not change from the previous example.
It remains the same.




```{zig}
#| eval: false
fn Stack(comptime T: type) type {
    return struct {
        items: []T,
        capacity: usize,
        length: usize,
        allocator: Allocator,
        const Self = @This();

        pub fn init(allocator: Allocator,
                    capacity: usize) !Stack(T) {
            var buf = try allocator.alloc(T, capacity);
            return .{
                .items = buf[0..],
                .capacity = capacity,
                .length = 0,
                .allocator = allocator,
            };
        }

        pub fn push(self: *Self, val: T) !void {
        // Truncate the rest of the struct
    };
}
```

Notice that we have created a function in this example named `Stack()`. This function
takes a type as input, and passes this type to the struct definition of our
`Stack` object. The data member `items` is now, an array of type `T`, which is the
data type that we have provided as input to the function. The function argument
`val` in the `push()` function is now a value of type `T` too.

We can just provide a data type to this function, and it will create a definition of a
`Stack` object that can store values of the data type that we have provided. In the example below, we are creating
the definition of a
`Stack` object that can store `u8` values in it. This definition is stored at the `Stacku8` object.
This `Stacku8` object becomes our new struct, that we are going to use
to create our `Stack` object.


```{zig}
#| eval: false
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
const Stacku8 = Stack(u8);
var stack = try Stacku8.init(allocator, 10);
defer stack.deinit();
try stack.push(1);
try stack.push(2);
try stack.push(3);
try stack.push(4);
try stack.push(5);
try stack.push(6);

std.debug.print("Stack len: {d}\n", .{stack.length});
std.debug.print("Stack capacity: {d}\n", .{stack.capacity});

stack.pop();
std.debug.print("Stack len: {d}\n", .{stack.length});
stack.pop();
std.debug.print("Stack len: {d}\n", .{stack.length});
std.debug.print(
    "Stack state: {any}\n",
    .{stack.items[0..stack.length]}
);
```

```
Stack len: 6
Stack capacity: 10
Stack len: 5
Stack len: 4
Stack state: { 1, 2, 3, 4, 0, 0, 0, 0, 0, 0 }
```

Every generic data structure in the Zig Standard Library (`ArrayList`, `HashMap`, `SinlyLinkedList`, etc.)
is implemented through this logic. They use a generic function to create the struct definition that can work
with the data type that you provided as input.




## Conclusion

The full source code of the stack structure discussed in this chapter is freely available in the official
repository of this book. Just checkout the [`stack.zig`](https://github.com/pedropark99/zig-book/tree/main/ZigExamples/data-structures/stack.zig)[^zig-stack]
for the `u32` version of our stack,
and the [`generic_stack.zig`](https://github.com/pedropark99/zig-book/tree/main/ZigExamples/data-structures/generic_stack.zig)[^zig-stack2]
for the generic version, available inside the `ZigExamples` folder of the repository.


[^zig-stack]: <https://github.com/pedropark99/zig-book/tree/main/ZigExamples/data-structures/stack.zig>
[^zig-stack2]: <https://github.com/pedropark99/zig-book/tree/main/ZigExamples/data-structures/generic_stack.zig>
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```





# Filesystem and Input/Output (IO) {#sec-filesystem}

In this chapter we are going to discuss how you can can execute filesystem operations
and also handle input/output (IO) using the cross-platform structs and functions
from the Zig Standard Library. Most of these functions and structs
comes from the `std.Io` module.

## Input/Output basics {#sec-io-basics}

If you have some experience in any high-level programming language, you have certainly used
some input or output functionality before. In other words, you certainly have
been in a situation where you needed to sent some output to the user, or, to receive an input
from the user of your program.

For example, in Python we can receive some input from the user by using the `input()` built-in
function. But we can also print (or "show") some output to the user by using the `print()`
built-in function. So yes, if you have programmed before in Python, you certainly have
used these functions once before.

But do you know how these functions relate back to your operating system (OS)? How exactly
they are interacting with the resources of your OS to receive or sent some input/output.
In essence, these input/output functions from high-level languages are just abstractions
over the *standard output* and *standard input* channels of your operating system.

This means that we receive an input, or send some output, through the operating system.
It's the OS that makes the bridge between the user and your program. Your program
does not have a direct access to the user. It's the OS that intermediates every
message exchanged between your program and the user.

The *standard output* and *standard input* channels of your OS are commonly known as the
`stdout` and `stdin` channels of your OS, respectively. In some contexts, they are also
called the *standard output device* and the *standard input device*. As the name suggests,
the *standard output* is the channel through which output flows, while the *standard input*
is the channel in which input flows.

Furthermore, OS's also normally create a dedicated channel for exchanging error messages, which is known as the
*standard error* channel, or, the `stderr` channel. This is the channel to which error and warning messages
are usually sent to. These are the messages that are normally displayed in red-like or orange-like colors
into your terminal.

Normally, every OS (e.g. Windows, macOS, Linux, etc.) creates a dedicated and separate set of
*standard output*, *standard error* and *standard input* channels for every single program (or process) that runs in your computer.
This means that every program you write have a dedicated `stdin`, `stderr` and `stdout` that are separate
from the `stdin`, `stderr` and `stdout` of other programs and processes that are currently running.

This is a behaviour from your OS. This does not come from the programming language that you are using.
Because as I said earlier, input and output in programming languages, especially
in high-level ones, are just a simple abstraction over the `stdin`, `stderr` and `stdout` from your current OS.
That is, your OS is the intermediary between every input/output operation made in your program,
regardless of the programming language that you are using.




## The writer and reader pattern {#sec-writer-reader}

In Zig, there is a pattern around input/output (IO). I (the author of this book) don't know if there
is an official name for this pattern. But here, in this book, I will call it the "writer and reader pattern".
In essence, every IO operation in Zig is made through either a `Reader` or a `Writer` object[^gen-zig].

These two data types are actually interfaces, and they come from the `std.Io` module of the Zig Standard Library. As their names suggests, a
`Reader` is an object that offers tools to read data from "something" (or "somewhere"), while a `Writer`
offers tools to write data into this "something". This "something" might be different things: like a
file that exists in your filesystem; or, it might be a network socket in your system[^sock]; or,
a continuous stream of data, like a standard input device from your system, that might be constantly
receiving new data from users, or, as another example, a live chat in a game that is constantly
receiving and displaying new messages from the players of the game.

[^gen-zig]: Previously, these objects were known as the `GenericReader` and `GenericWriter` objects. But both of these types were deprecated in 0.15.
[^sock]: The socket objects that we have created in @sec-create-socket, are examples of network sockets.

So, if you want to **read** data from something, or somewhere, it means that you need to use a `Reader` object.
But if you need instead, to **write** data into this "something", then, you need to use a `Writer` object instead.
Both of these objects are normally created from a file descriptor object. More specifically, through the `writer()` and `reader()`
methods of this file descriptor object. If you are not familiar with file descriptors, go to the next section.

Every `Writer` object has methods like `print()`, which allows you to write/send a formatted string
(i.e., this formatted string is like a `f` string in Python, or, similar to the `printf()` C function)
into the "something" (file, socket, stream, etc.) that you are using. It also has a `writeAll()` method, which allows you to
write a string, or, an array of bytes into the "something".

Likewise, every `Reader` object have methods like `readSliceAll()`, which allows you to read
data from the "something" (file, socket, stream, etc.) until it fills a particular array (i.e., a "buffer") object.
In other words, if you provide an array object of 300 `u8` values to `readSliceAll()`, then, this method attempts to read 300 bytes
of data from the "something", and it stores them into the array object that you have provided.

Another useful method is `takeDelimiterExclusive()`. In this method, you specify a "delimiter character".
The idea is that this function will attempt to read as many bytes of data as possible from the "something"
until it finds the "delimiter character" that you have specified, and, it returns a slice with the data to you.


This is just a quick description of the methods present in these types of objects. But I recommend you
to read the official docs, both for
[`Writer`](https://ziglang.org/documentation/master/std/#std.Io.Writer)[^gen-write] and
[`Reader`](https://ziglang.org/documentation/master/std/#std.Io.Reader)[^gen-read].
I also think it's a good idea to read the source code of the modules in the Zig Standard Library
that defines the methods present in these objects, which are the
[`Reader.zig`](https://codeberg.org/ziglang/zig/src/branch/master/lib/std/Io/Reader.zig)[^mod-read]
and [`Writer.zig`](https://codeberg.org/ziglang/zig/src/branch/master/lib/std/Io/Writer.zig)[^mod-write].

[^gen-read]: <https://ziglang.org/documentation/master/std/#std.Io.Reader>.
[^gen-write]: <https://ziglang.org/documentation/master/std/#std.Io.Writer>.
[^mod-read]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std/Io/Reader.zig>.
[^mod-write]: <https://codeberg.org/ziglang/zig/src/branch/master/lib/std/Io/Writer.zig>.



## The new `io` argument {#sec-new-io-backend}

Since Zig 0.15, the Zig development team initiated a movement to change completely how IO operations are made in Zig.
With this big movement, a completely new IO interface was introduced into the language, which was the introduction of the `Reader` and `Writer`
interfaces that we described on @sec-writer-reader. Not only that has happened, but also, since Zig 0.16 a new big step into this new IO interface
was made, with the introduction of the new `io` argument, from which you can choose the "IO backend implementation" that
you want to use, with `std.Io.Evented`, `std.Io.Threaded`, and others.

Let's make a quick comparison here. You've probably noticed from @sec-memory-chap that, allocators are an essential type of object in Zig.
They appear everywhere, and they are essential to any kind of task that needs to allocate some memory to
complete. Well, with the introduction of this new IO interface, choosing an "IO backend implementation" also became an essential
task in Zig code, like choosing an allocator.

So now, you usually start your Zig code by choosing both an allocator, and also, an "IO backend implementation" to use.
In the example below, I'm choosing an IO implementation that is based on thread pools. But I could also (if I wanted to) use
`std.Io.Evented`, which is based on queue rings.

The key objects in this code snippet exposed below are `allocator` and `io`.

```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: true
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var threaded: std.Io.Threaded = .init(allocator, .{});
const io = threaded.io();
defer threaded.deinit();
_ = io;
```


Therefore, since Zig 0.16, you will find different functions that perform some IO operation across the Zig Standard Library
that takes an argument named `io` of type `std.Io`. A big example of that is the `reader()` method that you find in `std.Io.File`. This method is responsible
for creating the `Reader` object through which you can read data from the file represented by the `std.Io.File` object.
And this method have now, an `io` argument, in which you should provide the "IO backend implementation" that you
want to use while reading the file.

In the example below, I'm demonstrating the use of this `io` argument by opening a file in my computer and reading it. Notice that I provide an
"IO backend implementation" (i.e. the `io` object) to the `reader()` method. This is just one
example. You will find this pattern of "providing an IO backend implementation" in many other kinds of tasks.
Functions related to networking are another instance where you will commonly find this `io` argument.

```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(
        init.io, "foo.txt", .{ .mode = .read_only }
    );
    defer file.close(init.io);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);
    _ = reader.readSliceAll(buffer[0..]) catch 0;

    std.debug.print("{s}\n", .{buffer});
}
```

```
This is a line from foo.txt
```


## Using a default IO implementation

Sometimes, is just a hassle to write all the necessary code to properly instantiate a IO
implementation. And sometimes, you just don't really care much about how the IO operations are being done under the hood,
and you just wish to use an IO backend with default settings. If that is your case,
there are currently three easy ways to quickly get an IO backend with default settings, which are:

- use the the default IO implementation for the target configuration.
- use a single threaded IO implementation with default configuration.
- use the IO implementation from the `std.testing` module.


### Using the IO implementation from `std.testing`

As the name suggests, the IO implementation from the `std.testing` module should be
used only inside "unit tests context". If you try to use them inside any other type of context,
you normally end up with a compilation error.

```{zig}
#| eval: false
#| build_type: "lib"
#| auto_main: true
const io = std.testing.io;
_ = io;
```


### Using the single threaded IO implementation

There is an easy an quick way to get a single threaded IO implementation.
All you have to do is to instantiate a `std.Io.Threaded` object with the value
`.init_single_threaded`, and then, call the `io()` method from the resulting
object, as the code example below demonstrates:

```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: true
var threaded: std.Io.Threaded = .init_single_threaded;
const io = threaded.io();
_ = io;
```

### Using the default IO implementation for your target

In more recent versions of Zig, a new "default argument" for the main function was introduced,
which is the `init` argument. In summary, you can write a main function that receives
an object of type `std.process.Init` as input.

This `std.process.Init` object is essentially an object that comes with a set of pre-initialized
APIs for your program to take advantage of. You can use this argument to easily get a pre-defined
and pre-initialized IO implementation for your IO operations. This implementation is accessible at the
`io` attribute of this `init` argument.

```{zig}
#| eval: true
#| build_type: "run"
#| auto_main: false
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    _ = stdout;
}
```

    try stdout.flush();

## Introducing file descriptors {#sec-file-descriptor}

A "file descriptor" object is a core component behind every IO operation that is made in any operating system (OS).
Such object is an identifier for a particular input/output (IO) resource from your OS [@wiki_file_descriptor].
It describes and identifies this particular resource. An IO resource might be:

- an existing file in your filesystem.
- an existing network socket.
- other types of stream channels.
- a pipeline (or just "pipe") in your terminal[^pipes].

[^pipes]: A pipeline is a mechanism for inter-process communication, or, inter-process IO. You could also interpret a pipeline as a "set of processes that are chained together, through the standard input/output devices of the system". At Linux for example, a pipeline is created inside a terminal, by connecting two or more terminal commands with the "pipe" character (`|`).

From the bullet points listed above, we know that although the term "file" is present,
a "file descriptor" might describe something more than just a file.
This concept of a "file descriptor" comes from the Portable Operating System Interface (POSIX) API,
which is a set of standards that guide how operating systems across the world should be implemented,
to maintain compatibility between them.

A file descriptor not only identifies the input/output resource that you are using to receive or send some data,
but it also describes where this resource is, and also, which IO mode this resource is currently using.
For example, this IO resource might be using only the "read" IO mode, which means that this resource
is open to "read operations", while "write operations" are not authorized.
These IO modes are essentially the modes that you provide to the argument `mode`
from the `fopen()` C function, and also, from the `open()` Python built-in function.

In C, a "file descriptor" is a `FILE` pointer, but, in Zig, a file descriptor is a `File` object.
This data type (`File`) is described in the `std.fs` module of the Zig Standard Library.
We normally don't create a `File` object directly in our Zig code. Instead, we normally get such object as result when we
open an IO resource. In other words, we normally ask our OS to open a particular IO resource for us,
and, if the OS do open successfully this IO resource, the OS normally handles back to us
a file descriptor to this particular IO resource.

So you usually get a `File` object by using functions and methods from the Zig Standard Library
that asks the OS to open some IO resource, like the `openFile()` method that opens a file in the
filesystem. The `std.Io.net.Stream` object that we have created in @sec-create-socket is also a type of
file descriptor object.


### The *standard output* {#sec-standard-output}

You already saw across this book, how can we access and use specifically the `stdout` in Zig
to send some output to the user.
For that, we use the `File.stdout()` function from the `std.Io` module. This function returns
a file descriptor that describes the `stdout` channel of your current OS. Through this file
descriptor object, we can read from or write stuff to the `stdout` of our program.

Although we can read stuff recorded into the `stdout` channel, we normally only
write to (or "print") stuff into this channel. The reason is very similar to what we discussed at
@sec-read-http-message, when we were discussing what "reading from" versus "writing to" the connection
object from our small HTTP Server project would mean.

When we write stuff into a channel, we are essentially sending data to the other end of this channel.
In contrast, when we read stuff from this channel, we are essentially reading the data that was sent
through this channel. Since the `stdout` is a channel to send output to the user, the key verb here
is **send**. We want to send something to someone, and, as consequence, we want to **write** something
into some channel.

That is why, when we access `File.stdout()`, most of the times, we also use the `writer()` method from the `stdout` file descriptor,
to get access to a writer object that we can use to write stuff into this `stdout` channel.
As we described in @sec-writer-reader, this `writer()` method returns a `Writer` object, and one of the
main methods of this `Writer` object is the `print()` method that we have used extensively across this book
to write (or "print") a formatted string into the `stdout` channel.

You should also notice in the example below, that in order to instantiate this `Writer` object,
we must provide a reference to a buffer object as input to the `writer()` method. In the example below,
this buffer object is `stdout_buffer`. By providing such buffer, we transform the IO operations performed by
the `Writer` object into "buffered IO operations". We are going to talk more about "buffered IO" in @sec-buffered-io,
so, don't worry too much about that for now.

```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.writeAll(
        "This message was written into stdout.\n"
    );
    try stdout.flush();
}
```



This `Writer` object is like any other writer object that you would normally get from a file descriptor object.
So, the same methods from a writer object that you would use while writing files to the filesystem for example, you could also
use them here, from the file descriptor object of `stdout`, and vice-versa.


### The *standard input*

You can access the *standard input* (i.e., `stdin`) in Zig by using the `File.stdin()` function from the `std.Io` module.
Like its brother (`File.stdout()`), this function also returns a file descriptor object that describes the `stdin` channel
of your OS.

Because we want to receive some input from the user, the key verb here becomes **receive**, and, as consequence,
we usually want to **read** data from the `stdin` channel, instead of writing data into it. So, we normally use
the `reader()` method of the file descriptor object returned by `File.stdin()`, to get access to a `Reader`
object that we can use to read data from `stdin`.

In the example below, we try to read the data from the `stdin` with the `takeDelimiterExclusive()` method
(which will read all the data from the `stdin` until it hits a new line character - `'\n'`, in the stream),
and save this data into the `name` object.

You should also notice that, like we did with the `writer()` method, we also need to provide a reference to a buffer
object as input to the `reader()` method, when instantiating our `Reader` object. The reasons are exactly the same.
This input buffer transforms the IO operations performed by the `Reader` object into "buffered IO operations".

If you execute this program, you will notice that it stops the execution, ands start to wait indefinitely
for some input from the user. In other words, you need to type your name into the terminal, and then, you press Enter to
send your name to `stdin`. After you send your name to `stdin`, the program reads this input, and continues with the execution,
by printing the given name to `stdout`. In the example below, I typed my name (Pedro) into the terminal, and then, pressed Enter.


```{zig}
#| eval: true
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    var stdin_buffer: [1024]u8 = undefined;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;
    const stdout = &stdout_writer.interface;
    try stdout.writeAll("Type your name\n");
    try stdout.flush();

    const name = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Your name is: {s}\n", .{name});
    try stdout.flush();
}
```

```
Type your name
Your name is: Pedro
```


### The *standard error*

The *standard error* (a.k.a. the `stderr`) works exactly the same as `stdout` and `stdin`.
You just call the `File.stderr()` function from the `std.Io` module, and you get the file descriptor to `stderr`.
Ideally, you should write only error or warning messages to `stderr`, because this is
the purpose of this channel.





## Buffered IO {#sec-buffered-io}

As we described in @sec-io-basics, input/output (IO) operations are made directly by the operating system.
It's the OS that manages the IO resource that you want to use for your IO operations.
The consequence of this fact is that IO operations are heavily based on system calls (i.e., calling the operating system directly).

Just to be clear, there is nothing particularly wrong with system calls. We use them all the time on
any serious codebase written in any low-level programming language. However, system calls are
always orders of magnitude slower than many different types of operations.

So is perfectly fine to use a system call once in a while. But when these system calls are used often,
you can clearly notice most of the time the loss of performance in your application. So, the good rule of thumb
is to use a system call only when it's needed, and also, only in infrequent situations, to reduce
the number of system calls performed to a minimum.


### Understanding how buffered IO works

Buffered IO is a strategy to achieve better performance. It's used to reduce the number of system calls made by IO operations, and, as
consequence, achieve a much higher performance. In @fig-unbuffered-io and @fig-buffered-io you can find two different diagrams
which presents the difference between read operations performed in an unbuffered IO environment versus a buffered IO environment.

To give a better context to these diagrams, let's suppose that we have a text file that contains the famous Lorem ipsum text[^lorem]
in our filesystem. Let's also suppose that these diagrams in @fig-unbuffered-io and @fig-buffered-io
are showing the read operations that we are performing to read the Lorem ipsum text from this text file.
The first thing you will notice when looking at these diagrams, is that in an unbuffered environment
the read operations leads to many system calls.
More precisely, in the diagram exposed in @fig-unbuffered-io we get one system call per each byte that we read from the text file.
On the other hand, in @fig-buffered-io we have only one system call at the very beginning.

When we use a buffered IO system, at the first read operation we perform, instead of sending one single byte directly
to our program, the OS first sends a chunk of bytes from the file to a buffer object (i.e., an array).
This chunk of bytes are cached/stored inside this buffer object.

Therefore, from now on, for every new read operation that you perform, instead of making a new system call to ask
for the next byte in the file to the OS, this read operation is redirected to the buffer object, that have
this next byte already cached and ready to go.


[^lorem]: <https://www.lipsum.com/>.


![Unbuffered IO](./../Figures/unbuffered-io.png){#fig-unbuffered-io width=60%}

![Buffered IO](./../Figures/buffered-io.png){#fig-buffered-io}



This is the basic logic behind buffered IO systems. The size of the buffer object depends on multiple factors. But it's usually
equal to the size of a full page of memory (4096 bytes). If we follow this logic, then, the OS reads the first 4096 bytes
of the file and caches it into the buffer object. As long as your program does not consume all of these 4096 bytes from the buffer,
you will not create new system calls.

However, as soon as you consume all of these 4096 bytes from the buffer, it means that there is no bytes left in the buffer.
In this situation, a new system call is made to ask the OS to send the next 4096 bytes in the file, and once again,
these bytes are cached into the buffer object, and the cycle starts once again.


::: {.callout-tip}
In general, you should always use a buffered IO reader or a buffered IO writer object in your code.
Because they deliver better performance to your IO operations.
:::




### Using buffered IO in Zig

Previously, IO operations in Zig were not buffered by default. However, since the new IO interface introduced in Zig 0.15,
the `Reader` and `Writer` interfaces take a buffer object as input when they are instantiated, like we demonstrated in @sec-standard-output.
In other words, a buffer object must be provided to instantiate a `Reader` or `Writer` object in your code. And because of that,
we have buffered IO operations by default on recent versions of Zig.

If you compare it with other languages, you will notice that Zig takes a slightly different approach in it's "buffered IO strategy". If we take C as an example, the IO operations made
through a `FILE` pointer in C are buffered by default. However, in C, you don't need to explicitly pass a buffer object when instantiating such `FILE` pointer,
because this buffer object is created behind the scenes for you, and therefore, it becomes invisible to the programmer. While in Zig, you must
manually create this buffer object yourself.

So, Zig not only choose to use buffered IO, but it also choose to give the programmer full control over the buffer used in such operations.
You (as the programmer) can directly control the size of this buffer, and you can also directly control how this specific buffer object
is allocated in your code (i.e. you can either allocate it in the stack, or, use an `Allocator` object to allocate it in the heap),
which fits very well with the "no hidden allocations" mantra of Zig.

Thus, if you want to use buffered IO in Zig, just make sure to pass a reference to a buffer object as input to either the `writer()` or `reader()`
methods to create a `Writer` or `Reader` object that performs buffered IO operations by default.


### Don't forget to flush!

When you use buffered IO operations in your code, is important to not forget to flush your buffers, specially on write operations.
Basically, when we are in a buffered IO scenario, and we try to write data into "something", this data is first written into the IO buffer that we've provided
to the `Writer` object as input, and this data in the IO buffer will only be effectively written into the "something" when we "commit" it.
We "commit" the bytes written into the IO buffer to our target output by "flushing our IO buffer".

So, when we flush our IO buffer, we are effectively commiting the chunk of data that is present in the IO buffer to
be written into the IO resource that is described by our file descriptor object. If we don't flush our IO buffer, then,
this data never leaves the IO buffer (i.e. it never reaches the IO resource). Therefore, when you forget to flush your IO
resource, what happens, most of the times, is that you don't get any kind of output in your IO resource.

For example, if you are writing data into the `stdout`, and you forget to flush it, what usually happens is that you
don't get any kind of output written into the terminal. The program seems to run successfully, but you don't get any type of
visual output in the terminal to confirm it, and you get really frustrated and confused.

Thus, if you are writing data in Zig, don't forget to flush your IO buffers by calling the `flush()` method of your `Writer` object.
This will make sure that the bytes/data that you are writing are effectivelly written into the IO resource described by your file descriptor
object.

::: {.callout-important}
If you are writing data, do not forget to flush your IO buffer, by calling the `flush()` method of your `Writer` object.
:::



## Filesystem basics

Now that we have discussed the basics around Input/Output operations in Zig, we need to
talk about the basics around filesystems, which is another core part of any operating system.
Also, filesystems are related to input/output, because the files that we store and create in our
computer are considered an IO resource, as we described in @sec-file-descriptor.


### The concept of current working directory (CWD)

The current working directory is the folder on your computer where you are currently rooted at.
In other words, it's the folder that your program is currently looking at.
Therefore, whenever you are executing a program, this program is always working with
a specific folder on your computer. It's always in this folder that the program will initially
look for the files you require, and it's also in this folder that the program
will initially save all the files you ask it to save.

The working directory is determined by the folder from which you invoke your program
in the terminal. In other words, if you are in the terminal of your OS, and you
execute a binary file (i.e., a program) from this terminal, the folder to which your terminal
is pointing at is the current working directory of your program that is being executed.

In @fig-cwd we have an example of me executing a program from the terminal. We are executing
the program outputted by the `zig` compiler by compiling the Zig module named `hello.zig`.
The CWD in this case is the `zig-book` folder. In other words, while the `hello.zig` program
is executing, it will be looking at the `zig-book` folder, and any file operation that we perform
inside this program, will be using this `zig-book` folder as the "starting point", or, as the "central focus".

![Executing a program from the terminal](./../Figures/cwd.png){#fig-cwd}

Just because we are rooted inside a particular folder (in the case of @fig-cwd, the `zig-book` folder) of our computer,
it doesn't mean that we cannot access or write resources in other locations of our computer.
The current working directory (CWD) mechanism just defines where your program will look first
for the files you ask for. This does not prevent you from accessing files that are located
elsewhere on your computer. However, to access any file that is in a folder other than your
current working directory, you must provide a path to that file or folder.


### The concept of paths

A path is essentially a location. It points to a location in your filesystem. We use
paths to describe the location of files and folders in our computer.
One important aspect about paths is that they are always written inside strings,
i.e., they are always provided as text values.

There are two types of paths that you can provide to any program in any OS: a relative path, or an absolute path.
Absolute paths are paths that start at the root of your filesystem, and go all the way to the file name or the specific folder
that you are referring to. This type of path is called absolute, because it points to an unique and absolute location on your computer.
That is, there is no other existing location on your computer that corresponds to this path. It's an unique identifier.

In Windows, an absolute path is a path that starts with a hard disk identifier (e.g. `C:/Users/pedro`).
On the other hand, absolute paths in Linux and macOS, are paths that start with a forward slash character (e.g. `/usr/local/bin`).
Notice that a path is composed by "segments". Each segment is connected to each other by a slash character (`\` or `/`).
On Windows, the backward slash (`\`) is normally used to connect the path segments. While on Linux and macOS, the forward
slash (`/`) is the character used to connect path segments.

A relative path is a path that start at the CWD. In other words, a relative path is
"relative to the CWD". The path used to access the `hello.zig` file in @fig-cwd is an example of a relative path. This path
is reproduced below. This path begins at the CWD, which in the context of @fig-cwd, is the `zig-book` folder,
then, it goes to the `ZigExamples` folder, then, into `zig-basics`, then, to the `hello.zig` file.

```
ZigExamples/zig-basics/hello_world.zig
```


### Path wildcards

When providing paths, especially relative paths, you have the option of using a *wildcard*.
There are two commonly used *wildcards* in paths, which are "one period" (.) and "two periods" (..).
In other words, these two specific characters have special meanings when used in paths,
and can be used on any operating system (Mac, Windows, Linux, etc.). That is, they
are "cross platform".

The "one period" represents an alias for the current directory.
This means that the relative paths `"./Course/Data/covid.csv"` and `"Course/Data/covid.csv"` are equivalent.
On the other hand, the "two periods" refers to the previous directory.
For example, the path `"Course/.."` is equivalent to the path `"."`, that is, the current working directory.

Therefore, the path `"Course/.."` refers to the folder before the `Course` folder.
As another example, the path `"src/writexml/../xml.cpp"` refers to the file `xml.cpp`
that is inside the folder before the `writexml` folder, which in this example is the `src` folder.
Therefore, this path is equivalent to `"src/xml.cpp"`.




## The CWD handler

In Zig, filesystem operations are usually made through a directory handler object.
A directory handler in Zig is an object of type `std.Io.Dir`, which is an object that describes
a particular folder in the filesystem of our computer.
You normally create a `Dir` object, by calling the `std.Io.Dir.cwd()` function.
This function returns a `Dir` object that points to (or, that describes) the
current working directory (CWD).

Through this `Dir` object, you can create new files, or modify, or read existing ones that are
inside your CWD. In other words, a `Dir` object is the main entrypoint in Zig to perform
multiple types of filesystem operations.
In the example below, we are creating this `Dir` object, and storing it
inside the `cwd` object. Although we are not using this object at this code example,
we are going to use it a lot over the next examples.

```{zig}
#| auto_main: true
const cwd = std.Io.Dir.cwd();
_ = cwd;
```








## File operations

### Creating files {#sec-creating-files}

We create new files by using the `createFile()` method from the `Dir` object.
Just provide the name of the file that you want to create, and this function will
do the necessary steps to create such file. You can also provide a relative path to this function,
and it will create the file by following this path, which is relative to the CWD.

This function might return an error, so, you should use `try`, `catch`, or any of the other methods presented
in @sec-error-handling to handle the possible error. But if everything goes well,
this `createFile()` method returns a file descriptor object (i.e., a `File` object) as result,
through which you can add content to the file with the IO operations that I presented before.

Take this code example below. In this example, we are creating a new text file
named `foo.txt`. If the function `createFile()` succeeds, the object named `file` will contain a file descriptor
object, which we can use to write (or add) new content to the file, like we do in this example, by using
a buffered writer object to write a new line of text to the file.

Now, a quick note, when we create a file descriptor object in C, by using a C function like `fopen()`, we must always close the file
at the end of our program, or, as soon as we complete all operations that we wanted to perform
on the file. In Zig, this is no different. So everytime we create a new file, this file remains
"open", waiting for some operation to be performed. As soon as we are done with it, we always have
to close this file, to free the resources associated with it.
In Zig, we do this by calling the method `close()` from the file descriptor object.


```{zig}
#| eval: true
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(
        init.io, "foo.txt", .{}
    );
    // Don't forget to close the file at the end.
    defer file.close(init.io);
    // Do things with the file ...
    _ = try file.writePositionalAll(
        init.io, "Writing this line to the file\n", 0
    );
}
```


So, in this example we not only have created a file into the filesystem,
but we also wrote some data into this file, using the file descriptor object
returned by `createFile()`. If the file that you are trying to create
already exists in your filesystem, this `createFile()` call will
overwrite the contents of the file, or, in other words, it will
in erase all the contents of the existing file.

If you don't want this to happen, meaning, that you don't want to overwrite
the contents of the existing file, but you want to write data to this file anyway
(i.e., you want to append data to the file), you should use the `openFile()`
method from the `Dir` object.

Another important aspect about `createFile()` is that this method creates a file
that is not open to read operations by default. It means that you cannot read this file.
You are not allowed to.
So for example, you might want to write some stuff into this file at the beginning of the execution
of your program. Then, at a future point in your program you might need to read what you
wrote in this file. If you try to read data from this file, you will likely
get a `NotOpenForReading` error as result.


But how can you overcome this barrier? How can you create a file that is open
to read operations? All you have to do, is to set the `read` flag to true
in the third argument of `createFile()`. When you set this flag to true,
then the file gets create with "read permissions", and, as consequence,
a program like this one below becomes valid:


```{zig}
#| eval: true
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo.txt", .{ .read = true });
    defer file.close(init.io);
    _ = try file.writePositionalAll(
        init.io, "We are going to read this line", 0
    );

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    _ = reader.readSliceAll(buffer[0..]) catch 0;

    std.debug.print("What we read from the file: {s}\n", .{buffer});
}
```


```
What we read from the file: We are going to read this line
```


### Opening files and appending data to it

Opening files is easy. Just use the `openFile()` method instead of `createFile()`.
In the first argument of `openFile()` you provide the IO implementation, then, on the second argument you
provide the path to the file that you want to open, then, on the third argument you provide the flags (or, the options)
that dictates how the file is opened.

You can see the full list of options for `openFile()` by visiting the documentation for
[`OpenFlags`](https://ziglang.org/documentation/master/std/#std.Io.File.OpenFlags)[^oflags].
But the main flag that you will most certainly use is the `mode` flag.
This flag specifies the IO mode that the file will be using when it gets opened.
There are three IO modes, or, three values that you can provide to this flag, which are:

- `read_only`, allows only read operations on the file. All write operations are blocked.
- `write_only`, allows only write operations on the file. All read operations are blocked.
- `read_write`, allows both write and read operations on the file.

[^oflags]: <https://ziglang.org/documentation/master/std/#std.Io.File.OpenFlags>

These modes are similar to the modes that you provide to the `mode` argument of the
`open()` Python built-in function[^py-open], or, the `mode` argument of the
`fopen()` C function[^c-open].

In the code example below, we are opening the `foo.txt` text file with a `write_only` mode,
and appending a new line of text to the end of the file. To do that, we use the `writePositionalAll()`
method from the file descriptor object. This method allows you to write a slice of bytes/data into
a specific position in the file.

Since we want to append data to the end of the file, I use the `length()` method of the file descriptor
object to calculate the length of the file (i.e. how many bytes the file contains), and then, I pass the result
on the third argument of this `writePositionalAll()` method, which tells this method to write the input data
at the end of the file.

[^py-open]: <https://docs.python.org/3/tutorial/inputoutput.html#reading-and-writing-files>
[^c-open]: <https://www.tutorialspoint.com/c_standard_library/c_function_fopen.htm>



```{zig}
#| eval: true
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(init.io, "foo.txt", .{ .mode = .write_only });
    defer file.close(init.io);

    const length = try file.length(init.io);
    _ = try file.writePositionalAll(
        init.io, "Some random text to write\n", length
    );
}
```


### Deleting files

Sometimes, we just need to delete/remove the files that we have.
To do that, we use the `deleteFile()` method. You just provide an IO implementation
in the first argument, and the path of the
file that you want to delete in the second argument, and this method will try to delete the file located
at this path.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "lib"
const cwd = std.Io.Dir.cwd();
try cwd.deleteFile(init.io, "foo.txt");
```

### Copying files

To copy existing files, we use the `copyFile()` method. The first argument in this method
is the path to the file that you want to copy. The second argument is a `Dir` object, i.e., a directory handler,
more specifically, a `Dir` object that points to the folder in your computer where you want to
copy the file to. The third argument is the new path of the file, or, in other words, the new location
of the file. The fourth argument is the IO implementation that you want to use. And the fifth argument are the
options (or flags) to be used in the copy operation.

The `Dir` object that you provide as input to this method will be used to copy the file to
the new location. You may create this `Dir` object before calling the `copyFile()` method.
Maybe you are planning to copy the file to a completely different location in your computer,
so it might be worth to create a directory handler to that location. But if you are copying the
file to a subfolder of your CWD, then, you can just simply pass the CWD handler to this argument.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "lib"
const cwd = std.Io.Dir.cwd();
try cwd.copyFile(
    "foo.txt",
    cwd,
    "ZigExamples/file-io/foo.txt",
    init.io,
    .{}
);
```


### Read the docs!

There are some other useful methods for file operations available at `Dir` objects,
such as the `writeFile()` method, but I recommend you to read the docs for the
[`Dir` type](https://ziglang.org/documentation/master/std/#std.fs.Dir)[^zig-dir]
to explore the other available methods, since I already talked too much about them.


[^zig-dir]: <https://ziglang.org/documentation/master/std/#std.fs.Dir>





## Directory operations

### Iterating through the files in a directory

One of the most classic tasks related to filesystem is to be able
to iterate through the existing files in a directory. To iterate over the
files in a directory, we need to create an iterator object.

You can produce such iterator object by using either the `iterate()` or `walk()` methods
of a `Dir` object. Both methods return an iterator object as output, which you can advance by using the
`next()` method. The difference between these methods, is that `iterate()` returns a non-recursive iterator,
while `walk()` does. It means that the iterator returned by `walk()` will not only iterate through
the files available in the current directory, but also, through the files from any subdirectory found
inside the current directory.

In the example below, we are displaying the names of the files stored inside the
directory `ZigExamples/file-io`. Notice that we had to open this directory through
the `openDir()` function. Also notice that we provided the flag `iterate` in the
second argument of `openDir()`. This flag is important, because without this flag,
we would not be allowed to iterate through the files in this directory.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "lib"
const cwd = std.Io.Dir.cwd();
const dir = try cwd.openDir(
    init.io,
    "ZigExamples/file-io/",
    .{ .iterate = true }
);
var it = dir.iterate();
while (try it.next(init.io)) |entry| {
    try stdout.print(
        "File name: {s}\n",
        .{entry.name}
    );
}
try stdout.flush();
```

```
File name: create_file_and_write_toit.zig
File name: create_file.zig
File name: lorem.txt
File name: iterate.zig
File name: delete_file.zig
File name: append_to_file.zig
File name: user_input.zig
File name: foo.txt
File name: create_file_and_read.zig
File name: buff_io.zig
File name: copy_file.zig
```


### Creating new directories

There are two methods that are important when it comes to
creating directories, which are `createDir()` and `createDirPath()`.
The difference between these two methods is that `createDir()` can
only create one single directory in the current directory in each call,
while `createDirPath()` is capable of recursively create subdirectories in the same call.


This is why the name of this method is "make path". It will create as many
subdirectories as necessary to create the path that you provided as input.
So, if you provide the path `"sub1/sub2/sub3"` as input to this method,
it will create three different subdirectories, `sub1`, `sub2` and `sub3`,
within the same function call. In contrast, if you provided such path
as input to `createDir()`, you would likely get an error as result, since
this method can only create a single subdirectory.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "lib"
const cwd = std.Io.Dir.cwd();
try cwd.createDir(init.io, "src", .default_dir);
try cwd.createDirPath(init.io, "src/decoders/jpg/");
```

### Deleting directories

To delete a directory, just provide the path to the directory that you want to delete
as input to the `deleteDir()` method from a `Dir` object. In the example below,
we are deleting the `src` directory that we have just created in the previous example.

```{zig}
#| eval: true
#| auto_main: true
#| build_type: "lib"
const cwd = std.Io.Dir.cwd();
try cwd.deleteDir(init.io, "src");
```


## Conclusion

In this chapter, I have described how to perform in Zig the most common filesystem and IO operations.
But you might feel the lack of some other, less common, operation in this chapter, such as: how to rename files,
or how to open a directory, or how to create symbolic links, or how to use `access()` to test if a particular
path exists in your computer. But for all of these less common tasks, I recommend you to read
the documentation of the [`Dir` type](https://ziglang.org/documentation/master/std/#std.fs.Dir)[^zig-dir]
, since you can find a good description of these cases there.
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Zig interoperability with C

In this chapter, we are going to discuss the interoperability of Zig with C.
We have discussed in @sec-building-c-code how you can use the `zig` compiler to build C code.
But we haven't discussed yet how to actually use C code in Zig. In other words,
we haven't discussed yet how to call and use C code from Zig.

This is the main subject of this chapter.
Also, in our next small project in this book, we are going to use a C library in it.
As consequence, we will put in practice a lot of the knowledge discussed here on
this next project.


## How to call C code from Zig

Interoperability with C is not something new. Most high-level programming languages have FFI (foreign function interfaces),
which can be used to call C code. For example, Python have Cython, R have `.Call()`, Javascript have `ccall()`, etc.
But Zig integrates with C in a deeper level, which affects not only the way that C code gets called, but also,
how this C code is compiled and incorporated into your Zig project.

In summary, Zig have great interoperability with C. If you want to call any C code from Zig,
you have to perform the following steps:

- import a C header file into your Zig code.
- link your Zig code with the C library.


### Strategies to import C header files {#sec-strategy-c}

Using C code in Zig always involves performing the two steps cited above. However, when
we talk specifically about the first step listed above, there are currently two
different ways to perform this first step, which are:

- translating the C header file into Zig code, through the `zig translate-c` command, and then, import and use the translated Zig code.
- importing the C header file directly into your Zig module through the `@cImport()` built-in function.

If you are not familiar with `translate-c`, this is a subcommand inside the `zig` compiler that takes C files
as input, and outputs the Zig representation of the C code present in these C files.
In other words, this subcommand works like a transpiler. It takes C code, and translates it into
the equivalent Zig code.

I think it would be ok to interpret `translate-c` as a tool to generate Zig bindings
to C code, similarly to the `rust-bindgen`[^bindgen] tool, which generates Rust FFI bindings to C code.
But that would not be a precise interpretation of `translate-c`. The idea behind this tool is
to really translate the C code into Zig code.

[^bindgen]: <https://github.com/rust-lang/rust-bindgen>

Now, on a surface level, `@cImport()` versus `translate-c` might seem like
two completely different strategies. But in fact, they are effectively the exact same strategy.
Because, under the hood, the `@cImport()` built-in function is just a shortcut to `translate-c`.
Both tools use the same "C to Zig" translation functionality. So when you use `@cImport()`,
you are essentially asking the `zig` compiler to translate the C header file into Zig code, then,
to import this Zig code into your current Zig module.

At the present moment, there is an accepted proposal at the Zig project, to move `@cImport()`
to the Zig build system[^cimport-issue]. If this proposal is completed, then, the "use `@cImport()`"
strategy would be transformed into "call a translate C function in your Zig build script".
So, the step of translating the C code into Zig code would be moved to
the build script of your Zig project, and you would only need to import the translated Zig code into
your Zig module to start calling C code from Zig.

[^cimport-issue]: <https://github.com/ziglang/zig/issues/20630>

If you think about this proposal for a minute, you will understand that this is actually
a small change. I mean, the logic is the same, and the steps are still essentially the same.
The only difference is that one of the steps will be moved to the build script of your Zig project.



### Linking Zig code with a C library {#sec-linking-c}

Regardless of which of the two strategies from the previous section you choose,
if you want to call C code from Zig, you must link your Zig code
with the C library that contains the C code that you want to call.

In other words, everytime you use some C code in your Zig code, **you introduce a dependency in your build process**.
This should come as no surprise to anyone that have any experience with C and C++.
Because this is no different in C. Everytime you use a C library in your C code, you also
have to build and link your C code with this C library that you are using.

When we use a C library in our Zig code, the `zig` compiler needs to access the definition of the C functions that
are being called in your Zig code. The C header file of this library provides the
declarations of these C functions, but not their definitions. So, in order to access these definitions,
the `zig` compiler needs to build your Zig code and link it with the C library during the build process.

As we discussed across the @sec-build-system, there are different strategies to link something with a library.
This might involve building the C library first, and then, linking it with the Zig code. Or,
it could also involve just the linking step, if this C library is already built and
installed in your system. Anyway, if you have doubts about this, comeback to @sec-build-system.



## Importing C header files {#sec-import-c-header}

In @sec-strategy-c, we have described that, currently, there are two different paths that
you can take to import a C header file into your Zig modules, `translate-c` or `@cImport()`.
This section describes each strategy separately in more details.

### Strategy 1: using `translate-c`

When we choose this strategy, we first need to use the `translate-c` tool to translate
the C header files that we want to use into Zig code. For example, suppose we wanted to
use the `fopen()` C function from the `stdio.h` C header file. We can translate the
`stdio.h` C header file through the bash command below:

```bash
zig translate-c /usr/include/stdio.h \
    -lc -I/usr/include \
    -D_NO_CRT_STDIO_INLINE=1 > c.zig \
```

Notice that, in this bash command, we are passing the necessary compiler flags (`-D` to define macros,
`-l` to link libraries, `-I` to add an "include path") to compile and use the `stdio.h` header file.
Also notice that we are saving the results of the translation process inside a Zig module called `c.zig`.

Therefore, after running this command, all we have to do is to import this `c.zig` module, and start
calling the C functions that you want to call from it. The example below demonstrates that.
It's important to remember what we've discussed in @sec-linking-c. In order to compile this
example you have to link this code with `libc`, by passing the flag `-lc` to the `zig` compiler.

```{zig}
#| eval: false
const c = @import("c.zig");
pub fn main() !void {
    const x: f32 = 1772.94122;
    _ = c.printf("%.3f\n", x);
}
```

```
1772.941
```


### Strategy 2: using `@cImport()`

To import a C header file into our Zig code, we can use the built-in functions `@cInclude()` and `@cImport()`.
Inside the `@cImport()` function, we open a block (with a pair of curly braces). Inside this block
we can (if we need to) include multiple `@cDefine()` calls to define C macros when including this specific C header file.
But for the most part, you will probably need to use just a single call inside this block,
which is a call to `@cInclude()`.

This `@cInclude()` function is equivalent to the `#include` statement in C.
You provide the name of the C header that you want to include as input to this `@cInclude()` function,
then, in conjunction with `@cImport()`, it will perform the necessary steps
to include this C header file into your Zig code.

You should bind the result of `@cImport()` to a constant object, pretty much like you would do with
`@import()`. You just assign the result to a constant object in your
Zig code, and, as consequence, all C functions, C structs, C macros, etc. that are defined inside the
C header files will be available through this constant object.

Look at the code example below, where we are importing the Standard I/O C Library (`stdio.h`),
and calling the `printf()`[^printf] C function. Notice that we have also used in this example the C function `powf()`[^powf],
which comes from the C Math Library (`math.h`).
In order to compile this example, you have to link this Zig code with both
the C Standard Library and the C Math Library, by passing the flags `-lc` and `-lm`
to the `zig` compiler.

[^printf]: <https://cplusplus.com/reference/cstdio/printf/>
[^powf]: <https://en.cppreference.com/w/c/numeric/math/pow>


```{zig}
#| eval: false
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
    @cInclude("math.h");
});

pub fn main() !void {
    const x: f32 = 15.2;
    const y = c.powf(x, @as(f32, 2.6));
    _ = c.printf("%.3f\n", y);
}
```

```
1182.478
```


## About passing Zig values to C functions {#sec-zig-obj-to-c}

Zig objects have some intrinsic differences between their C equivalents.
Probably the most noticeable one is the difference between C strings and Zig strings,
which I described in @sec-zig-strings.
Zig strings are objects that contains both an array of arbitrary bytes and a length value.
On the other hand, a C string is usually just a pointer to a null-terminated array of arbitrary bytes.

Because of these intrinsic differences, in some specific cases, you cannot pass Zig objects directly
as inputs to C functions before you convert them into C compatible values. However, in some other cases,
you are allowed to pass Zig objects and Zig literal values directly as inputs to C functions,
and everything will work just fine, because the `zig` compiler will handle everything for you.

So we have two different scenarios being described here. Let's call them "auto-conversion" and "need-conversion".
The "auto-conversion" scenario is when the `zig` compiler handles everything for you, and automatically convert your
Zig objects/values into C compatible values. In contrast,
the "need-conversion" scenario is when you, the programmer, have the responsibility of converting
that Zig object into a C compatible value, before passing it to C code.

There is also a third scenario that is not being described here, which is when you create a C object, or, a C struct, or
a C compatible value in your Zig code, and you pass this C object/value as input to a C function in your Zig code.
This scenario will be described later in @sec-c-inputs. In this section, we are focused on the scenarios where
we are passing Zig objects/values to C code, instead of C objects/values being passed to C code.


### The "auto-conversion" scenario

An "auto-conversion" scenario is when the `zig` compiler automatically converts our Zig objects into
C compatible values for us. This specific scenario happens mostly in two instances:

- with string literal values;
- with any of the primitive data types that were introduced in @sec-primitive-data-types.

When we think about the second instance described above, the `zig` compiler does automatically
convert any of the primitive data types into their C equivalents, because the compiler knows how
to properly convert a `i16` into a `signed short`, or, a `u8` into a `unsigned char`, etc.
Now, when we think about string literal values, they can be automatically
converted into C strings as well, especially because the `zig` compiler does not forces
a specific Zig data type into a string literal at first glance, unless you store this
string literal into a Zig object, and explicitly annotate the data type of this object.

Thus, with string literal values, the `zig` compiler has more freedom to infer which is the appropriate data type
to be used in each situation. You could say that the string literal value "inherits its data type" depending on the context that
it's used in. Most of the times, this data type is going to be the type that we commonly associate with Zig strings (`[]const u8`).
But it might be a different type depending on the situation. When the `zig` compiler detects that you are providing
a string literal value as input to some C function, the compiler automatically interprets this string
literal as a C string value.

As an example, look at the code exposed below. Here we are using
the `fopen()` C function to simply open and close a file. If you do not know how this `fopen()`
function works in C, it takes two C strings as input. But in this code example below, we are passing some
string literals written in our Zig code directly as inputs to this `fopen()` C function.

In other words, we are not doing any conversion from a Zig string to a C string.
We are just passing the Zig string literals directly as inputs to the C function. And it works just fine!
Because the compiler interprets the string `"foo.txt"` as a C string given the current context.


```{zig}
#| eval: false
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main() !void {
    const file = c.fopen("foo.txt", "rb");
    if (file == null) {
        @panic("Could not open file!");
    }
    if (c.fclose(file) != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}
```

Let's make some experiments, by writing the same code in different manners, and we
see how this affects the program. As a starting point, let's store the `"foo.txt"` string inside
a Zig object, like the `path` object below, and then, we pass this Zig object as input to the `fopen()` C function.

If we do this, the program still compiles and runs successfully. Notice that I have omitted most of the code in this example below.
This is just for brevity reasons, because the remainder of the program is still the same.
The only difference between this example and the previous one is just these two lines exposed below.

```{zig}
#| eval: false
    const path = "foo.txt";
    const file = c.fopen(path, "rb");
    // Remainder of the program
```

Now, what happens if you give an explicit data type to the `path` object? Well, if I force
the `zig` compiler to interpret this `path` object as a Zig string object,
by annotating the `path` object with the data type `[]const u8`, then, I actually get a compile error
as demonstrated below. We get this compile error because now I'm forcing the `zig` compiler
to interpret `path` as a Zig string object.

According to the error message, the `fopen()` C function was expecting to receive an
input value of type `[*c]const u8` (C string) instead of a value of type `[]const u8` (Zig string).
In more details, the type `[*c]const u8` is actually the Zig type representation of a C string.
The `[*c]` portion of this type identifies a C pointer. So, this Zig type essentially means: a C pointer to an array (`[*c]`) of
constant bytes (`const u8`).


```{zig}
#| eval: false
    const path: []const u8 = "foo.txt";
    const file = c.fopen(path, "rb");
    // Remainder of the program
```

```
t.zig:2:7 error: expected type '[*c]const u8', found '[]const u8':
    const file = c.fopen(path, "rb");
                         ^~~~
```

Therefore, when we talk exclusively about string literal values, as long as you don't give an
explicit data type to these string literal values, the `zig` compiler should be capable of automatically
converting them into C strings as needed.

But what about using one of the primitive data types that were introduced in @sec-primitive-data-types?
Let's take code exposed below as an example of that. Here, we are giving some float literal values as input
to the C function `powf()`. Notice that this code example compiles and runs successfully.

```{zig}
#| eval: false
const std = @import("std");
const cmath = @cImport({
    @cInclude("math.h");
});

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const y = cmath.powf(15.68, 2.32);
    try stdout.print("{d}\n", .{y});
    try stdout.flush();
}
```

```
593.2023
```

Once again, because the `zig` compiler does not associate a specific data type with the literal values
`15.68` and `2.32` at first glance, the compiler can automatically convert these values
into their C `float` (or `double`) equivalents, before it passes to the `powf()` C function.
Now, even if I give an explicit Zig data type to these literal values, by storing them into a Zig object,
and explicit annotating the type of these objects, the code still compiles and runs successfully.

```{zig}
#| eval: false
    const x: f32 = 15.68;
    const y = cmath.powf(x, 2.32);
    // The remainder of the program
```

```
593.2023
```



### The "need-conversion" scenario

A "need-conversion" scenario is when we need to manually convert our Zig objects into C compatible values
before passing them as input to C functions. You will fall in this scenario, when passing Zig string objects
to C functions.

We have already seen this specific circumstance in the last `fopen()` example,
which is reproduced below. You can see in this example, that we have given an explicit Zig data type
(`[]const u8`) to our `path` object, and, as a consequence of that, we have forced the `zig` compiler
to see this `path` object, as a Zig string object. Therefore, we need now to manually convert
this `path` object into a C string before we pass it to `fopen()`.


```{zig}
#| eval: false
    const path: []const u8 = "foo.txt";
    const file = c.fopen(path, "rb");
    // Remainder of the program
```

```
t.zig:10:26: error: expected type '[*c]const u8', found '[]const u8'
    const file = c.fopen(path, "rb");
                         ^~~~
```


There are different ways to convert a Zig string object into a C string.
One way to solve this problem is to provide the pointer to the underlying array
of bytes, instead of providing the Zig object directly as input.
You can access this pointer by using the `ptr` property of the Zig string object.

The code example below demonstrates this strategy. Notice that, by giving the
pointer to the underlying array in `path` through the `ptr` property, we get no compile errors as result
while using the `fopen()` C function.

```{zig}
#| eval: false
    const path: []const u8 = "foo.txt";
    const file = c.fopen(path.ptr, "rb");
    // Remainder of the program
```

This strategy works because this pointer to the underlying array found in the `ptr` property,
is semantically identical to a C pointer to an array of bytes, i.e., a C object of type `*unsigned char`.
This is why this option also solves the problem of converting the Zig string into a C string.

Another option is to explicitly convert the Zig string object into a C pointer by using the
built-in function `@ptrCast()`. With this function we can convert
an object of type `[]const u8` into an object of type `[*c]const u8`.
As I described at the previous section, the `[*c]` portion of the type
means that it's a C pointer. This strategy is not-recommended. But it's
useful to demonstrate the use of `@ptrCast()`.

You may recall of `@as()` and `@ptrCast()` from @sec-type-cast. Just as a recap,
the `@as()` built-in function is used to explicitly convert (or cast) a Zig value
from a type "x" into a value of type "y". But in our case here, we are converting
a pointer object. Everytime a pointer is involved in some "type casting operation" in Zig,
the `@ptrCast()` function is involved.

In the example below, we are using this function to cast our `path` object
into a C pointer to an array of bytes. Then, we pass this C pointer as input
to the `fopen()` function. Notice that this code example compiles successfully
with no errors.

```{zig}
#| eval: false
    const path: []const u8 = "foo.txt";
    const c_path: [*c]const u8 = @ptrCast(path);
    const file = c.fopen(c_path, "rb");
    // Remainder of the program
```



## Creating C objects in Zig {#sec-c-inputs}

Creating C objects, or, in other words, creating instances of C structs in your Zig code
is actually something quite easy to do. You first need to import the C header file (like I described in @sec-import-c-header) that defines
the C struct that you are trying to instantiate in your Zig code. After that, you can just
create a new object in your Zig code, and annotate it with the data type of the C struct.

For example, suppose we have a C header file called `user.h`, and that this header file is declaring a new struct named `User`.
This C header file is exposed below:

```c
#include <stdint.h>

typedef struct {
    uint64_t id;
    char* name;
} User;
```

This `User` C struct have two distinct fields, or two struct members, named `id` and `name`.
The field `id` is an unsigned 64-bit integer value, while the field `name` is just a standard C string.
Now, suppose that I want to create an instance of this `User` struct in my Zig code.
I can do that by importing this `user.h` header file into my Zig code, and creating
a new object with type `User`. These steps are reproduced in the code example below.

Notice that I have used the keyword `undefined` in this example. This allows me to
create the `new_user` object without the need to provide an initial value to the object.
As consequence, the underlying memory associated with this `new_user` object is uninitialized,
i.e., the memory is currently populated with "garbage" values.
Thus, this expression have the exact same effect of the expression `User new_user;` in C,
which means "declare a new object named `new_user` of type `User`".

It's our responsibility to properly initialize this memory associated with this `new_user` object,
by assigning valid values to the members (or the fields) of the C struct. In the example below,
I'm assigning the integer 1 to the member `id`. I am also saving the string `"pedropark99"` into the member `name`.
Notice in this example that I manually add the null character (zero byte) to the end of the allocated array
for this string. This null character marks the end of the array in C.

```{zig}
#| auto_main: false
#| eval: false
const std = @import("std");
const c = @cImport({
    @cInclude("user.h");
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var new_user: c.User = undefined;
    new_user.id = 1;
    var user_name = try allocator.alloc(u8, 12);
    defer allocator.free(user_name);
    @memcpy(user_name[0..(user_name.len - 1)], "pedropark99");
    user_name[user_name.len - 1] = 0;
    new_user.name = user_name.ptr;
}
```

So, in this example above, we are manually initializing each field of the C struct.
We could say that, in this instance, we are "manually instantiating
the C struct object". However, when we use C libraries in our Zig code, we rarely need
to manually instantiate the C structs like that. Only because C libraries
usually provide a "constructor function" in their public APIs. As consequence, we normally rely on
these constructor functions to properly initialize the C structs, and
the struct fields for us.

For example, consider the Harfbuzz C library. This a text shaping C library,
and it works around a "buffer object", or, more specifically, an instance of
the C struct `hb_buffer_t`. Therefore, we need to create an instance of
this C struct if we want to use this C library. Luckily, this library offers
the function `hb_buffer_create()`, which we can use to create such object.
So the Zig code necessary to create such object would probably look something like this:

```{zig}
#| eval: false
const c = @cImport({
    @cInclude("hb.h");
});
var buf: c.hb_buffer_t = c.hb_buffer_create();
// Do stuff with the "buffer object"
```

Therefore, we do not need to manually create an instance of the C struct
`hb_buffer_t` here, and manually assign valid values to each field in this C struct.
Because the constructor function `hb_buffer_create()` is doing this heavy job for us.

Since this `buf` object, and also, the `new_user` object from previous examples, are instances of C structs, these
objects are by themselves C compatible values. They are C objects defined in our Zig code. As consequence,
you can freely pass these objects as input to any C function that expects to receive this type
of C struct as input. You do not need to use any special syntax, or, to convert them in
any special manner to use them in C code. This is how we create and use C objects in our Zig code.



## Passing C structs across Zig functions {#sec-pass-c-structs}

Now that we have learned how to create/declare C objects in our Zig code, we
need to learn how to pass these C objects as inputs to Zig functions.
As I described in @sec-c-inputs, we can freely pass these C objects as inputs to C code
that we call from our Zig code. But what about passing these C objects to Zig functions?

In essence, this specific case requires one small adjustment in the Zig function declaration.
All you need to do, is to make sure that you pass your C object *by reference* to the function,
instead of passing it *by value*. To do that, you have to annotate the data type of the function argument
that is receiving this C object as "a pointer to the C struct", instead of annotating it as "an instance of the C struct".

Let's consider the C struct `User` from the `user.h` C header file that we have used in @sec-c-inputs.
Now, consider that we want to create a Zig function that sets the value of the `id` field
in this C struct, like the `set_user_id()` function declared below.
Notice that the `user` argument in this function is annotated as a pointer (`*`) to a `c.User` object.

Therefore, all you have to do when passing C objects to Zig functions, is to add `*` to the
data type of the function argument that is receiving the C object. This will make sure that
the C object is passed *by reference* to the function.

Because we have transformed the function argument into a pointer,
everytime that you have to access the value pointed by this input pointer inside the function body, for whatever reason (e.g. you want
to read, update, or delete this value), you have to dereference the pointer with the `.*` syntax that we
learned from @sec-pointer. Notice that the `set_user_id()` function is using this syntax to alter
the value in the `id` field of the `User` struct pointed by the input pointer.

```{zig}
#| auto_main: false
#| eval: false
const std = @import("std");
const c = @cImport({
    @cInclude("user.h");
});
fn set_user_id(id: u64, user: *c.User) void {
    user.*.id = id;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var new_user: c.User = undefined;
    new_user.id = 1;
    var user_name = try allocator.alloc(u8, 12);
    defer allocator.free(user_name);
    @memcpy(user_name[0..(user_name.len - 1)], "pedropark99");
    user_name[user_name.len - 1] = 0;
    new_user.name = user_name.ptr;

    set_user_id(25, &new_user);
    try stdout.print("New ID: {any}\n", .{new_user.id});
    try stdout.flush();
}
```

```
New ID: 25
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Project 4 - Developing an image filter

In this chapter we are going to build a new project. The objective of
this project is to write a program that applies a filter over an image.
More specifically, a "grayscale filter", which transforms
any color image into a grayscale image.

We are going to use the image displayed in @fig-pascal in this project.
In other words, we want to transform this colored image into a grayscale image,
by using our "image filter program" written in Zig.

![A photo of the chilean-american actor Pedro Pascal. Source: Google Images.](../ZigExamples/image_filter/pedro_pascal.png){#fig-pascal}

We don't need to write a lot of code to build such "image filter program". However, we first need
to understand how digital images work. That is why we begin this chapter
by explaining the theory behind digital images and how colors are represented in modern computers.
We also give a brief explanation about the PNG (Portable Network Graphics) file format, which is the format used
in the example images.

At the end of this chapter, we should have a full example of a program that takes the PNG image displayed in @fig-pascal
as input, and writes a new image to the current working directory that is the grayscale version of this input image.
This grayscale version of @fig-pascal is exposed in @fig-pascal-gray.
You can find the full source code of this small project at the `ZigExamples/image_filter`
[folder at the official repository of this book](https://github.com/pedropark99/zig-book/tree/main/ZigExamples/image_filter)[^img-filter-folder].


![The grayscale version of the photo.](../ZigExamples/image_filter/pedro_pascal_filter.png){#fig-pascal-gray}


## How we see things? {#sec-eyes}

In this section, I want to briefly describe to you how we (humans) actually see things with our own eyes.
I mean, how our eyes work? If you do have a very basic understanding of how our eyes work, you will understand
more easily how digital images are made. Because the techniques behind digital images
were developed by taking a lot of inspiration from how our human eyes work.

You can interpret a human eye as a light sensor, or, a light receptor. The eye receives some amount of light as input,
and it interprets the colors that are present in this "amount of light".
If no amount of light hits the eye, then, the eye cannot extract color from it, and as result,
we end up seeing nothing, or, more precisely, we see complete blackness.

Therefore, everything depends on light. What we actually see are the colors (blue, red, orange, green, purple, yellow, etc.) that
are being reflected from the light that is hitting our eyes. **Light is the source of all colors!**
This is what Isaac Newton discovered on his famous prism experiment[^newton] in the 1660s.

[^newton]: <https://library.si.edu/exhibition/color-in-a-new-light/science>

Inside our eyes, we have a specific type of cell called the "cone cell".
Our eye have three different types, or, three different versions of these "cone cells".
Each type of cone cell is very sensitive to a specific spectrum of the light. More specifically,
to the spectrums that define the colors red, green and blue.
So, in summary, our eyes have specific types of cells that
are highly sensitive to these three colors (red, green and blue).

These are the cells responsible for perceiving the color present in the light that hits our eyes.
As a result, our eyes perceives color as a mixture of these three colors (red, green and blue). By having an amount
of each one of these three colors, and mixing them together, we can get any other visible color
that we want. So every color that we see is perceived as a specific mixture of blues, greens and reds,
like 30% of red, plus 20% of green, plus 50% of blue.

When these cone cells perceive (or, detect) the colors that are found in the
light that is hitting our eyes, these cells produce electrical signals, which are sent to the brain.
Our brain interprets these electrical signals, and use them to form the image that we are seeing
inside our head.

Based on what we have discussed here, the bullet points exposed below describes the sequence of events that
composes this very simplified version of how our human eyes work:

1. Light hits our eyes.
1. The cone cells perceive the colors that are present in this light.
1. Cone cells produce electrical signals that describes the colors that were perceived in the light.
1. The electrical signals are sent to the brain.
1. Brain interprets these signals, and form the image based on the colors identified by these electrical signals.


## How digital images work? {#sec-digital-img}

A digital image is a "digital representation" of an image that we see with our eyes.
In other words, a digital image is a "digital representation" of the colors that we see
and perceive through the light.
In the digital world, we have two types of images, which are: vector images and raster images.
Vector images are not described here. So just remember that the content discussed here
**is related solely to raster images**, and not vector images.

A raster image is a type of digital image that is represented as a 2D (two dimensional) matrix
of pixels. In other words, every raster image is basically a rectangle of pixels, and each pixel have a particular color.
So, a raster image is just a rectangle of pixels, and each of these pixels are displayed in the screen of your computer (or the screen
of any other device, e.g. laptop, tablet, smartphone, etc.) as a color.

@fig-raster demonstrates this idea. If you take any raster image, and you zoom into it very hard,
you will see the actual pixels of the image. JPEG, TIFF and PNG are file formats that are commonly
used to store raster images.

![Zooming over a raster image to see the pixels. Source: Google Images.](../Figures/imagem-raster.png){#fig-raster}

The more pixels the image has, the more information and detail we can include in the image.
The more accurate, sharp and pretty the image will look. This is why photographic cameras
usually produce big raster images, with several megapixels of resolution, to include as much detail as possible into the final image.
As an example, a digital image with dimensions of 1920 pixels wide and 1080 pixels high, would be a image that
contains $1920 \times 1080 = 2073600$ pixels in total. You could also say that the "total area" of the image is
of 2073600 pixels, although the concept of "area" is not really used here in computer graphics.

Most digital images we see in our modern world uses the RGB color model. RGB stands for (red, green and blue).
So the color of each pixel in these raster images are usually represented as a mixture of red, green and blue,
just like in our eyes. That is, the color of each pixel is identified by a set of
three different integer values. Each integer value identifies the "amount" of each color (red, green and blue).
For example, the set `(199, 78, 70)` identifies a color that is more close to red. We have 199 of red, 78 of green,
and 70 of blue. In contrast, the set `(129, 77, 250)` describes a color that is more close to purple. Et cetera.



### Images are displayed from top to bottom

This is not a rule written in stone, but the big majority of digital images are displayed from top
to bottom and left to right. Most computers screens also follow this pattern. So, the first pixels
in the image are the ones that are at the top and left corner of the image. You can find a visual representation
of this logic in @fig-img-display.

Also notice in @fig-img-display that, because a raster image is essentially a 2D matrix of pixels,
the image is organized into rows and columns of pixels. The columns are defined by the horizontal x axis,
while the rows are defined by the vertical y axis.

Each pixel (i.e., the gray rectangles) exposed in @fig-img-display contains a number inside of it.
These numbers are the indexes of the pixels. You can notice that the first pixels are in the top and left
corner, and also, that the indexes of these pixels "grow to the sides", or, in other words, they grow in the direction of the horizontal x axis.
Most raster images are organized as rows of pixels. Thus, when these digital images are
displayed, the screen display the first row of pixels, then, the second row, then, the third row, etc.

![How the pixels of raster images are displayed.](./../Figures/image-display.png){#fig-img-display}






### Representing the matrix of pixels in code {#sec-pixel-repr}

Ok, we know already that raster images are represented as 2D matrices of pixels.
But we do not have a notion of a 2D matrix in Zig. Actually, most low-level languages in general
(Zig, C, Rust, etc.) do not have such notion.
So how can we represent such matrix of pixels in Zig, or any other low-level language?
The strategy that most programmers choose in this situation is to just use a normal 1D array to store the values of
this 2D matrix. In other words, you just create an normal 1D array, and store all values from both dimensions into this 1D array.

As an example, suppose we have a very small image of dimensions 4x3.
Since a raster image is represented as a 2D matrix of pixels, and each pixel
is represented by 3 "unsigned 8-bit" integer values, we have 12 pixels in
total in this image, which are represented by $3 \times 12 = 36$ integer values.
Therefore, we need to create an array of 36 `u8` values to store this small image.

The reason why unsigned 8-bit integer (`u8`) values are used to represent the amounts of each color,
instead of any other integer type, is because they take the minimum amount of space as possible, or,
the minimum amount of bits as possible. Which helps to reduces the binary size of the image, i.e., the 2D matrix.
Also, they convey a good amount of precision and detail about the colors, even though they can represent
a relatively small range (from 0 to 255) of "color amounts".

Coming back to our initial example of a 4x3 image,
the `matrix` object exposed below could be an example of an 1D array that stores
the data that represents this 4x3 image.

```{zig}
#| eval: false
const matrix = [_]u8{
    201, 10, 25, 185, 65, 70,
    65, 120, 110, 65, 120, 117,
    98, 95, 12, 213, 26, 88,
    143, 112, 65, 97, 99, 205,
    234, 105, 56, 43, 44, 216,
    45, 59, 243, 211, 209, 54,
};
```

The first three integer values in this array are the color amounts of the first pixel in the image.
The next three integers are the colors amounts for the second pixel.
And the sequence goes on in this pattern. Having that in mind, the size of the array that stores
a raster image is usually a multiple of 3. In this case, the array have a size of 36.

I mean, the size of the array is **usually** a multiple of 3, because in specific circumstances,
it can also be a multiple of 4. This happens when a transparency amount is
also included into the raster image. In other words, there are some types of raster images
that uses a different color model, which is the RGBA (red, green, blue and alpha)
color model. The "alpha" corresponds to an amount of transparency in the pixel.
So every pixel in a RGBA image is represented by a red, green, blue and alpha values.

Most raster images uses the standard RGB model, so, for the most part, you will
see arrays sizes that are multiples of 3. But some images, especially the ones
that are stored in PNG files, might be using the RGBA model, and, therefore, are
represented by an array whose size is a multiple of 4.

In our case here, the example image of our project (@fig-pascal) is a raster image
stored in a PNG file, and this specific image is using the RGBA color model. Therefore,
each pixel in the image is represented by 4 different integer values, and, as consequence,
to store this image in our Zig code, we need to create an array whose size is a multiple of 4.


## The PNG library that we are going to use

Let's begin our project by focusing on writing the necessary Zig code to
read the data from the PNG file. In other words, we want to read the PNG file exposed
in @fig-pascal, and parse its data to extract the 2D matrix of pixels that represents the image.

As we have discussed in @sec-pixel-repr, the image that we are using as example here
is a PNG file that uses the RGBA color model, and, therefore, each pixel of the image
is represented by 4 integer values. You can download this image by visiting the `ZigExamples/image_filter`
[folder at the official repository of this book](https://github.com/pedropark99/zig-book/tree/main/ZigExamples/image_filter)[^img-filter-folder].
You can also find in this folder the complete source code of this small project that we
are developing here.

[^img-filter-folder]: <https://github.com/pedropark99/zig-book/tree/main/ZigExamples/image_filter>

There are some C libraries available that we can use to read and parse PNG files.
The most famous and used of all is `libpng`, which is the "official library" for reading and writing
PNG files. Although this library is available on most operating system, it's well known
for being complex and hard to use.

That is why, I'm going to use a more modern alternative here in this project, which is the `libspng` library.
I choose to use this C library here, because it's much, much simpler to use than `libpng`,
and it also offers very good performance for all operations. You can checkout the
[official website of the library](https://libspng.org/)[^libspng]
to know more about it. You will also find there some documentation that might help you to understand and
follow the code examples exposed here.

[^libspng]: <https://libspng.org/>


First of all, remember to build and install this `libspng` into your system. Because
if you don't do this step, the `zig` compiler will not be able to find the files and resources of
this library in your computer, and link them with the Zig source code that we are writing together here.
There is good information about how to build and install the library at the
[build section of the library documentation](https://libspng.org/docs/build/)[^lib-build].

[^lib-build]: <https://libspng.org/docs/build/>




## Reading the PNG file

In order to extract the pixel data from the PNG file, we need to read and decode the file.
A PNG file is just a binary file written in the "PNG format". Luckily, the `libspng` library offers
a function called `spng_decode_image()` that does all this heavy work for us.

Now, since `libspng` is a C library, most of the file and I/O operations in this library are made by using
a `FILE` C pointer. Because of that, is probably a better idea to use the `fopen()` C function
to open our PNG file, instead of using the `openFile()` method that I introduced in @sec-filesystem.
That is why I'm importing the `stdio.h` C header in this project, and using the `fopen()` C function to open the file.

If you look at the snippet below, you can see that we are:

1. opening the PNG file with `fopen()`.
1. creating the `libspng` context with `spng_ctx_new()`.
1. using `spng_set_png_file()` to specify the `FILE` object that reads the PNG file that we are going to use.

Every operation in `libspng` is made through a "context object". In our snippet below, this object is `ctx`.
Also, to perform an operation over a PNG file, we need to specify which exact PNG file we are referring to.
This is the job of `spng_set_png_file()`. We are using this function to specify the file descriptor
object that reads the PNG file that we want to use.


```{zig}
#| eval: false
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
    @cInclude("spng.h");
});

const path = "pedro_pascal.png";
const file_descriptor = c.fopen(path, "rb");
if (file_descriptor == null) {
    @panic("Could not open file!");
}
const ctx = c.spng_ctx_new(0) orelse unreachable;
_ = c.spng_set_png_file(
    ctx, @ptrCast(file_descriptor)
);
```

Before we continue, is important to emphasize the following: since we have opened the file with `fopen()`,
we have to remember to close the file at the end of the program, with `fclose()`.
In other words, after we have done everything that we wanted to do with the PNG file
`pedro_pascal.png`, we need to close this file, by applying `fclose()` over the file descriptor object.
We could use also the `defer` keyword to help us in this task, if we want to.
This code snippet below demonstrates this step:

```{zig}
#| eval: false
if (c.fclose(file_descriptor) != 0) {
    return error.CouldNotCloseFileDescriptor;
}
```




### Reading the image header section

Now, the context object `ctx` is aware of our PNG file `pedro_pascal.png`, because it has access to
a file descriptor object to this file. The first thing that we are going to do is to read the
"image header section" of the PNG file. This "image header section" is the section
of the file that contains some basic information about the PNG file, like, the bit depth of the pixel data
of the image, the color model used in the file, the dimensions of the image (height and width in number of pixels),
etc.

To make things easier, I will encapsulate this "read image header" operation into a
nice and small function called `get_image_header()`. All that this function needs to do
is to call the `spng_get_ihdr()` function. This function from `libspng` is responsible
for reading the image header data, and storing it into a C struct named `spng_ihdr`.
Thus, an object of type `spng_ihdr` is a C struct that contains the data from the
image header section of the PNG file.

Since this Zig function is receiving a C object (the `libspng` context object) as input, I marked
the function argument `ctx` as "a pointer to the context object" (`*c.spng_ctx`), following the recommendations
that we have discussed in @sec-pass-c-structs.

```{zig}
#| eval: false
fn get_image_header(ctx: *c.spng_ctx) !c.spng_ihdr {
    var image_header: c.spng_ihdr = undefined;
    if (c.spng_get_ihdr(ctx, &image_header) != 0) {
        return error.CouldNotGetImageHeader;
    }

    return image_header;
}

var image_header = try get_image_header(ctx);
```

Also notice in this function, that I'm checking if the `spng_get_ihdr()` function call have
returned or not an integer value that is different than zero. Most functions from the
`libspng` library return a code status as result, and the code status "zero" means
"success". So any code status that is different than zero means that an error
occurred while running `spng_get_ihdr()`. This is why I'm returning an error value from
the function in case the code status returned by the function is different than zero.


### Allocating space for the pixel data

Before we read the pixel data from the PNG file, we need to allocate enough space to hold this data.
But in order to allocate such space, we first need to know how much space we need to allocate.
The dimensions of the image are obviously needed to calculate the size of this space. But there are
other elements that also affect this number, such as the color model used in the image, the bit depth, and others.

Anyway, all of this means that calculating the size of the space that we need, is not a simple task.
That is why the `libspng` library offers an utility function named
`spng_decoded_image_size()` to calculate this size for us. Once again, I'm going
to encapsulate the logic around this C function into a nice and small Zig function
named `calc_output_size()`. You can see below that this function returns a nice
integer value as result, informing the size of the space that we need to allocate.


```{zig}
#| eval: false
fn calc_output_size(ctx: *c.spng_ctx) !u64 {
    var output_size: u64 = 0;
    const status = c.spng_decoded_image_size(
        ctx, c.SPNG_FMT_RGBA8, &output_size
    );
    if (status != 0) {
        return error.CouldNotCalcOutputSize;
    }
    return output_size;
}
```



You might quest yourself what the value `SPNG_FMT_RGBA8` means. This value is actually an enum
value defined in the `spng.h` C header file. This enum is used to identify a "PNG format".
More precisely, it identifies a PNG file that uses the RGBA color model and 8 bit depth.
So, by providing this enum value as input to the `spng_decoded_image_size()` function,
we are saying to this function to calculate the size of the decoded pixel data, by considering
a PNG file that follows this "RGBA color model with 8 bit depth" format.

Having this function, we can use it in conjunction with an allocator object, to allocate an
array of bytes (`u8` values) that is big enough to store the decoded pixel data of the image.
Notice that I'm using `@memset()` to initialize the entire array to zero.

```{zig}
#| eval: false
const output_size = try calc_output_size(ctx);
var buffer = try allocator.alloc(u8, output_size);
@memset(buffer[0..], 0);
```


### Decoding the image data

Now that we have the necessary space to store the decoded pixel data of the image,
we can start to actually decode and extract this pixel data from the image,
by using the `spng_decode_image()` C function.

The `read_data_to_buffer()` Zig function exposed below summarises the necessary
steps to read this decoded pixel data, and store it into an input buffer.
Notice that this function is encapsulating the logic around the `spng_decode_image()` function.
Also, we are using the `SPNG_FMT_RGBA8` enum value once again to inform the corresponding function,
that the PNG image being decoded, uses the RGBA color model and 8 bit depth.

```{zig}
#| eval: false
fn read_data_to_buffer(ctx: *c.spng_ctx, buffer: []u8) !void {
    const status = c.spng_decode_image(
        ctx,
        buffer.ptr,
        buffer.len,
        c.SPNG_FMT_RGBA8,
        0
    );

    if (status != 0) {
        return error.CouldNotDecodeImage;
    }
}
```

Having this function at hand, we can apply it over our context object, and also, over
the buffer object that we have allocated in the previous section to hold the decoded pixel data
of the image:

```{zig}
#| eval: false
try read_data_to_buffer(ctx, buffer[0..]);
```


### Looking at the pixel data

Now that we have the pixel data stored in our "buffer object", we can take
a quick look at the bytes. In the example below, we are looking at the first
12 bytes in the decoded pixel data.

If you take a close look at these values, you might notice that every 4 bytes
in the sequence is 255. Which, coincidentally is the maximum possible integer value
to be represented by a `u8` value. So, if the range from 0 to 255, which is the range
of integer values that can be represented by an `u8` value, can be represented as a scale from 0% to 100%,
these 255 values are essentially 100% in that scale.

If you recall from @sec-pixel-repr, I have
described in that section that our `pedro_pascal.png` PNG file uses the RGBA color model,
which adds an alpha (or transparency) byte to each pixel in the image.
As consequence, each pixel in the image is represented by 4 bytes. Since we are looking
here are the first 12 bytes in the image, it means that we are looking at the data from
the first $12 / 4 = 3$ pixels in the image.

So, based on how these first 12 bytes (or these 3 pixels) look, with these 255 values at every 4 bytes, we can say that is likely
that every pixel in the image have alpha (or transparency) setted to 100%. This might not be true,
but, is the most likely possibility. Also, if we look at the image itself, which if your recall is
exposed in @fig-pascal, we can see that the transparency does not change across the image,
which enforces this theory.


```{zig}
#| eval: false
try stdout.print("{any}\n", .{buffer[0..12]});
try stdout.flush();
```

```
{
    200, 194, 216, 255, 203, 197,
    219, 255, 206, 200, 223, 255
}
```


We can see in the above result that the first pixel in this image have 200 of red, 194 of green, and 216 of blue.
How do I know the order in which the colors appears in the sequence? If you have not guessed that yet,
is because of the acronym RGB. First RED, then GREEN, then BLUE. If we scale these integer values
according to our scale of 0% to 100% (0 to 255), we get 78% of red, 76% of green and 85% of blue.



## Applying the image filter

Now that we have the data of each pixel in the image, we can focus on applying our image
filter over these pixels. Remember, our objective here is to apply a grayscale filter over
the image. A grayscale filter is a filter that transforms a colored image into a grayscale image.

There are different formulas and strategies to transform a colored image into a grayscale image.
But all of these different strategies normally involve applying some math over the colors of each pixel.
In this project, we are going to use the most general formula, which is exposed below.
This formula considers $r$ as the red of the pixel, $g$ as the green, $b$ as the blue, and $p'$ as the
linear luminance of the pixel.

$$
    p' = (0.2126 \times r) + (0.7152 \times g) + (0.0722 \times b)
$${#eq-grayscale}

This @eq-grayscale is the formula to calculate the linear luminance of a pixel. It's worth noting that this formula
works only for images whose pixels are using the sRGB color space, which is the standard color space
for the web. Thus, ideally, all images on the web should use this color space. Luckily,
this is our case here, i.e., the `pedro_pascal.png` image is using this sRGB color space, and, as consequence,
we can use the @eq-grayscale. You can read more about this formula at the Wikipedia page for grayscale [@wiki_grayscale].

The `apply_image_filter()` function exposed below summarises the necessary steps to
apply @eq-grayscale over the pixels in the image. We just apply this function
over our buffer object that contains our pixel data, and, as result, the pixel
data stored in this buffer object should now represent the grayscale version of our image.

```{zig}
#| eval: false
fn apply_image_filter(buffer:[]u8) !void {
    const len = buffer.len;
    const red_factor: f16 = 0.2126;
    const green_factor: f16 = 0.7152;
    const blue_factor: f16 = 0.0722;
    var index: u64 = 0;
    while (index < len) : (index += 4) {
        const rf: f16 = @floatFromInt(buffer[index]);
        const gf: f16 = @floatFromInt(buffer[index + 1]);
        const bf: f16 = @floatFromInt(buffer[index + 2]);
        const y_linear: f16 = (
            (rf * red_factor) + (gf * green_factor)
            + (bf * blue_factor)
        );
        buffer[index] = @intFromFloat(y_linear);
        buffer[index + 1] = @intFromFloat(y_linear);
        buffer[index + 2] = @intFromFloat(y_linear);
    }
}

try apply_image_filter(buffer[0..]);
```



## Saving the grayscale version of the image

Since we have now the grayscale version of our image stored in our buffer object,
we need to encode this buffer object back into the "PNG format", and save the encoded data into
a new PNG file in our filesystem, so that we can access and see the grayscale version of our image
that was produced by our small program.

To do that, the `libspng` library help us once again by offering an "encode data to PNG" type of function,
which is the `spng_encode_image()` function. But in order to "encode data to PNG" with `libspng`, we need
to create a new context object. This new context object must use an "encoder context", which
is identified by the enum value `SPNG_CTX_ENCODER`.

The `save_png()` function exposed below, summarises all the necessary steps to save the
grayscale version of our image into a new PNG file in the filesystem. By default, this
function will save the grayscale image into a file named `pedro_pascal_filter.png` in the CWD.

Notice in this code example that we are using the same image header object (`image_header`) that we have
collected previously with the `get_image_header()` function. Remember, this image header object
is a C struct (`spng_ihdr`) that contains basic information about our PNG file, such as
the dimensions of the image, the color model used, etc.

If we wanted to save a very different image in this new PNG file, e.g. an image
with different dimensions, or, an image that uses a different color model, a different bit depth, etc.
we would have to create a new image header (`spng_ihdr`) object that describes the properties
of this new image.

But we are essentially saving the same image that we have begin with here (the dimensions of
the image, the color model, etc. are all still the same). The only difference
between the two images are the colors of the pixels, which are now "shades of gray".
As consequence, we can safely use the exact same image header data in this new PNG file.



```{zig}
#| eval: false
fn save_png(image_header: *c.spng_ihdr, buffer: []u8) !void {
    const path = "pedro_pascal_filter.png";
    const file_descriptor = c.fopen(path.ptr, "wb");
    if (file_descriptor == null) {
        return error.CouldNotOpenFile;
    }
    const ctx = (
        c.spng_ctx_new(c.SPNG_CTX_ENCODER)
        orelse unreachable
    );
    defer c.spng_ctx_free(ctx);
    _ = c.spng_set_png_file(ctx, @ptrCast(file_descriptor));
    _ = c.spng_set_ihdr(ctx, image_header);

    const encode_status = c.spng_encode_image(
        ctx,
        buffer.ptr,
        buffer.len,
        c.SPNG_FMT_PNG,
        c.SPNG_ENCODE_FINALIZE
    );
    if (encode_status != 0) {
        return error.CouldNotEncodeImage;
    }
    if (c.fclose(file_descriptor) != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}

try save_png(&image_header, buffer[0..]);
```

After we execute this `save_png()` function, we should have a new PNG file
inside our CWD, named `pedro_pascal_filter.png`. If we open this PNG file,
we will see the same image exposed in @fig-pascal-gray.


## Building our project

Now that we have written the code, let's discuss how can we build/compile this project.
To do that, I'm going to create a `build.zig` file in the root directory of our project,
and start writing the necessary code to compile the project, using the knowledge
that we have acquired from @sec-build-system.


We first create the build target for our executable file, that executes our
Zig code. Let's suppose that all of our Zig code was written into a Zig module
named `image_filter.zig`. The `exe` object exposed in the build script below
describes the build target for our executable file.

Since we have used some C code from the `libspng` library in our Zig code,
we need to link our Zig code (which is in the `exe` build target) to both
the C Standard Library, and, to the `libspng` library. We do that, by calling
the `linkLibC()` and `linkSystemLibrary()` methods from our `exe` build target.

```{zig}
#| eval: false
const std = @import("std");
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "image_filter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/image_filter.zig"),
            .target = b.graph.host,
            .link_libc = true
        })
    });
    // Link to libspng library:
    exe.root_module.linkSystemLibrary("spng", .{});
    // Link to math library:
    exe.root_module.linkSystemLibrary("m", .{});
    b.installArtifact(exe);
}
```

Since we are using the `linkSystemLibrary()` method, it means that the library
files for `libspng` are searched in your system to be linked with the `exe` build target.
If you have not yet built and installed the `libspng` library into your system, this
linkage step will likely not work. Because it will not find the library files in your system.

So, just remember to install `libspng` in your system, if you want to build this project.
Having this build script above written, we can finally build our project by
running the `zig build` command in the terminal.

```bash
zig build
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```



# Introducing threads and parallelism in Zig {#sec-thread}

Threads are available in Zig through the `Thread` struct from the Zig Standard Library.
This struct represents a kernel thread, and it follows a POSIX Thread pattern,
meaning that, it works similarly to a thread from the `pthread` C library, which is usually available on any distribution
of the GNU C Compiler (`gcc`). If you are not familiar with threads, I will give you some theory behind it first, shall we?


## What are threads? {#sec-what-thread}

A thread is basically a separate context of execution.
We use threads to introduce parallelism into our program,
which in most cases, makes the program run faster, because we have multiple tasks
being performed at the same time, parallel to each other.

Programs are normally single-threaded by default. Which means that each program
usually runs on a single thread, or, a single context of execution. When we have only one thread running, we have no
parallelism. And when we don't have parallelism, the commands are executed sequentially, that is,
only one command is executed at a time, one after another. By creating multiple threads inside our program,
we start to execute multiple commands at the same time.

Programs that create multiple threads are very common in the wild. Because many different types
of applications are well suited for parallelism. Good examples are video and photo-editing applications
(e.g. Adobe Photoshop or DaVinci Resolve), games (e.g. The Witcher 3), and also web browsers
(e.g. Google Chrome, Firefox, Microsoft Edge, etc).
For example, in web browsers, threads are normally used to implement tabs.
The tabs in a web browsers usually run as separate threads in the main process of
the web browser. That is, each new tab that you open in your web browser
usually runs on a separate thread of execution.

By running each tab in a separate thread, we allow all open tabs in the browser to run at the same time,
and independently from each other. For example, you might have YouTube or Spotify currently open in
a tab, and you are listening to some podcast in that tab while at the same time
working in another tab, writing an essay on Google Docs. Even if you are not looking
into the YouTube tab, you can still hear the podcast only because this YouTube tab is running in parallel
with the other tab where Google Docs is running.

Without threads, the other alternative would be to run each tab as a completely separate
process in your computer. But that would be a bad choice because just a few tabs would already consume
too much power and resources from your computer. In other words, it's very expensive to create a completely new process,
compared to creating a new thread of execution. Also, the chances of you experiencing lag and overhead
while using the browser would be significant. Threads are faster to create, and they also consume
much, much less resources from the computer, especially because they share some resources
with the main process.

Therefore, it's the use of threads in modern web browsers that allow you to hear the podcast
at the same time while you are writing something on Google Docs.
Without threads, a web browser would probably be limited to just one single tab.

Threads are also well-suited for anything that involves serving requests or orders.
Because serving a request takes time, and usually involves a lot of "waiting time".
In other words, we spend a lot of time in idle, waiting for something to complete.
For example, consider a restaurant. Serving orders in a restaurant usually involves
the following steps:

1. receive order from the client.
1. pass the order to the kitchen, and wait for the food to be cooked.
1. start cooking the food in the kitchen.
1. when the food is fully cooked deliver this food to the client.

If you think about the bullet points above, you will notice that one big moment of waiting time
is present in this whole process, which is while the food is being cooked
inside the kitchen. While the food is being prepped, both the waiter and the client
themselves are waiting for the food to be ready and delivered.

If we write a program to represent this restaurant, more specifically, a single-threaded program, then
this program would be very inefficient. Because the program would stay in idle, waiting for a considerable amount
of time on the "check if food is ready" step. Consider the code snippet exposed below that could
potentially represent such program.

The problem with this program is the while loop. This program will spend a lot of time
waiting on the while loop, doing nothing more than just checking if the food is ready.
This is a waste of time. Instead of waiting for something to happen, the waiter
could just send the order to the kitchen, and just move on, and continue with receiving
more orders from other clients, and sending more orders to the kitchen, instead
of doing nothing and waiting for the food to be ready.

```{zig}
#| eval: false
#| build_type: "lib"
#| auto_main: true
const order = Order.init("Pizza Margherita", n = 1);
const waiter = Waiter.init();
waiter.receive_order(order);
waiter.ask_kitchen_to_cook();
var food_not_ready = true;
while (food_not_ready) {
    food_not_ready = waiter.is_food_ready();
}
const food = waiter.get_food_from_kitchen();
waiter.send_food_to_client(food);
```

This is why threads would be a great fit for this program. We could use threads
to free the waiters from their "waiting duties", so they can go on with their
other tasks, and receive more orders. Take a look at the next example, where I have re-written the above
program into a different program that uses threads to cook and deliver the orders.

You can see in this program that when a waiter receives a new order
from a client, this waiter executes the `send_order()` function.
The only thing that this function does is to create a new thread
and detaches it. Since creating a thread is a very fast operation,
this `send_order()` function returns almost immediately,
so the waiter spends almost no time worrying about the order, and just
move on and tries to get the next order from the clients.

Inside the new thread created, the order gets cooked by a chef, and when the
food is ready, it's delivered to the client's table.


```{zig}
#| eval: false
fn cook_and_deliver_order(order: *Order) void {
    const chef = Chef.init();
    const food = chef.cook(order.*);
    chef.deliver_food(food);
}
fn send_order(order: Order) void {
    const cook_thread = Thread.spawn(
        .{}, cook_and_deliver_order, .{&order}
    );
    cook_thread.detach();
}

const waiter = Waiter.init();
while (true) {
    const order = waiter.get_new_order();
    if (order) {
        send_order(order);
    }
}
```



## Threads versus processes

When we run a program, this program is executed as a *process* in the operating system.
This is a one to one relationship, each program or application that you execute
is a separate process in the operating system. But each program, or each process,
can create and contain multiple threads inside of it. Therefore,
processes and threads have a one to many relationship.

This also means that every thread that we create is always associated with a particular process in our computer.
In other words, a thread is always a subset (or a children) of an existing process.
All threads share some of the resources associated with the process from which they were created.
And because threads share resources with the process, they are very good for making communication
between tasks easier.

For example, suppose that you were developing a big and complex application
that would be much simpler if you could split it in two, and make these two separate pieces talk
with each other. Some programmers opt to effectively write these two pieces of the codebase as two
completely separate programs, and then, they use IPC (*inter-process communication*) to make these
two separate programs/processes talk to each other, and make them work together.

However, some programmers find IPC hard to deal with, and, as consequence,
they prefer to write one piece of the codebase as the "main part of the program",
or, as the part of the code that runs as the process in the operating system,
while the other piece of the codebase is written as a task to be executed in
a new thread. A process and a thread can easily comunicate with each other
through both control flow, and also, through data, because they share and have
access to the same standard file descriptors (`stdout`, `stdin`, `stderr`), and also to the
same memory space on the heap and global data section.


In more details, each thread that you create have a separate stack frame reserved just for that thread,
which essentially means that each local object that you create inside this thread, is local to that
thread, i.e., the other threads cannot see this local object. Unless this object that you have created
is an object that lives on the heap. In other words, if the memory associated with this object
is on the heap, then, the other threads can potentially access this object.

Therefore, objects that are stored in the stack are local to the thread where they were created.
But objects that are stored on the heap are potentially accessible to other threads. All of this means that,
each thread has its own separate stack frame, but, at the same time, all threads share
the same heap, the same standard file descriptors (which means that they share the same `stdout`, `stdin`, `stderr`),
and the same global data section in the program.



## Creating a thread

We create new threads in Zig by first importing the `Thread` struct into
our current Zig module and then calling the `spawn()` method of this struct,
which creates (or "spawns") a new thread of execution from our current process.
This method has three arguments, which are, respectively:

1. a `SpawnConfig` object, which contains configurations for the spawn process.
1. the name of the function that is going to be executed (or that is going to be "called") inside this new thread.
1. a list of arguments (or inputs) to be passed to the function provided in the second argument.

With these three arguments, you can control how the thread gets created, and also, specify which
work (or "tasks") will be performed inside this new thread. A thread is just a separate context of execution,
and we usually create new threads in our code because we want to perform some work inside this
new context of execution. And we specify which exact work, or which exact steps that are going to be
performed inside this context by providing the name of a function as the second argument of the `spawn()` method.

Thus, when this new thread gets created, this function that you provided as input to the `spawn()`
method gets called, or gets executed inside this new thread. You can control the
arguments, or the inputs that are passed to this function when it gets called by providing
a list of arguments (or a list of inputs) in the third argument of the `spawn()` method.
These arguments are passed to the function in the same order that they are
provided to `spawn()`.

Furthermore, the `SpawnConfig` is a struct object with only two possible fields, or, two possible members, that you
can set to tailor the spawn behaviour. These fields are:

- `stack_size`: you can provide a `usize` value to specify the size (in bytes) of the thread's stack frame. By default, this value is: $16 \times 1024 \times 1024$.
- `allocator`: you can provide an allocator object to be used when allocating memory for the thread.

To use one of these two fields (or "configs"), you just have to create a new object of type `SpawnConfig`,
and provide this object as input to the `spawn()` method. But, if you are not interested in using
one of these configs, and you are ok with using just the defaults, you can just provide an anonymous
struct literal (`.{}`) in place of this `SpawnConfig` argument.

As our first, and very simple example, consider the code exposed below.
Inside the same program, you can create multiple threads of execution if you want to.
But, in this first example, we are creating just a single thread of execution, because
we call `spawn()` only once.

Also, notice in this example that we are executing the function `do_some_work()`
inside the new thread. Since this function receives no inputs, because it has
no arguments, we have passed an empty list in this instance, or more precisely,
an empty, anonymous struct (`.{}`) in the third argument of `spawn()`.


```{zig}
#| eval: true
#| auto_main: false
#| build_type: "run"
const std = @import("std");
const Thread = std.Thread;
const duration = std.Io.Duration.fromSeconds(1);
const clock: std.Io.Clock = .awake;

fn do_some_work(io: std.Io) !void {
    std.debug.print("Starting the work.\n", .{});
    try std.Io.sleep(io, duration, clock);
    std.debug.print("Finishing the work.\n", .{});
}

pub fn main(init: std.process.Init) !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{init.io});
    thread.join();
}
```

Notice the use of `try` when calling the `spawn()` method. This means
that this method can return an error in some circumstances. One circumstance
in particular is when you attempt to create a new thread, when you have already
created too much (i.e., you have exceeded the quota of concurrent threads in your system).

But, if the new thread is successfully created, the `spawn()` method returns a handler
object (which is just an object of type `Thread`) to this new thread. You can use
this handler object to effectively control all aspects of the thread.

When the thread gets created, the function that you provided as input to `spawn()`
gets invoked (i.e., gets called) to start the execution on this new thread.
In other words, every time you call `spawn()`, not only is a new thread created,
but the "start work button" of this thread is also automatically pressed.
So the work being performed in this thread starts as soon as the thread is created.
This is similar to how `pthread_create()` from the `pthreads` library in C works,
which also starts the execution as soon as the thread is created.


## Returning from a thread

We have learned in the previous section that the execution of the thread starts as soon as
the thread is created. Now, we will learn how to "join" or "detach" a thread in Zig.
"Join" and "detach" are operations that control how the thread returns to
the main thread, or to the main process in our program.

We perform these operations by using the methods `join()` and `detach()` from the thread handler object.
Every thread that you create can be marked as either *joinable* or *detached* [@linux_pthread_create].
You can turn a thread into a *detached* thread by calling the `detach()` method
from the thread handler object. But if you call the `join()` method instead, then this thread
becomes a *joinable* thread.

A thread cannot be both *joinable* and *detached*. Which in general means
that you cannot call both `join()` and `detach()` on the same thread.
But a thread must be one of the two, meaning that, you should always call
either `join()` or `detach()` over a thread. If you don't call
one of these two methods over your thread, you introduce undefined behaviour into your program,
which is described in @sec-not-call-join-detach.

Now, let's describe what each of these two methods do to your thread.


### Joining a thread

When you join a thread, you are essentially saying: "Hey! Could you please wait for the thread to finish,
before you continue with your execution?". For example, if we come back to our first and simplest example
of a thread in Zig, we created a single thread inside the `main()` function of our program
and just called `join()` on this thread at the end. This section of the code example is reproduced below.

Because we are joining this new thread inside the `main()`'s scope, it means that the
execution of the `main()` function is temporarily stopped, to wait for the execution of the thread
to finish. That is, the execution of `main()` stops temporarily at the line where `join()` gets called,
and it will continue only after the thread has finished its tasks.

```{zig}
#| eval: false
pub fn main() !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{});
    thread.join();
}
```

Because we have joined this new thread inside the `main()` scope, we have a
guarantee that this new thread will finish before the end of the execution of `main()`.
Because it's guaranteed that `main()` will wait for the thread to finish its tasks.

In the example above, there are no more expressions after the `join()` call. We just have the end
of the `main()`'s scope, and, therefore, the execution of our program just ends after the thread finishes its tasks,
since there is nothing more to do. But what if we had more stuff to do after the join call?

To demonstrate this other possibility, consider the next example exposed
below. Here, we create a `print_id()` function, that just receives an id
as input, and prints it to `stdout`. In this example, we are creating two
new threads, one after another. Then, we join the first thread, then,
we wait for two whole seconds, then, at last, we join the second thread.

The idea behind this example is that the last `join()` call is executed
only after the first thread finishes its task (i.e., the first `join()` call),
and the two-second delay. If you compile and run this
example, you will notice that most messages are quickly printed to `stdout`,
i.e., they appear almost instantly on your screen.
However, the last message ("Joining thread 2") takes around 2 seconds to appear
on the screen.


```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
fn print_id(id: *const u8) !void {
    std.debug.print("Thread ID: {d}\n", .{id.*});
}

pub fn main(init: std.process.Init) !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    const thread2 = try Thread.spawn(.{}, print_id, .{&id2});
    std.debug.print("Joining thread 1\n", .{});
    thread1.join();

    const duration = std.Io.Duration.fromNanoseconds(1000);
    try std.Io.sleep(init.io, duration, clock);

    std.debug.print("Joining thread 2\n", .{});
    thread2.join();
}
```

```
Thread ID: Joining thread 1
1
Thread ID: 2
Joining thread 2
```

This demonstrates that both threads finish their work (i.e., printing the IDs)
very fast, before the two seconds of delay end. Because of that, the last `join()` call
returns pretty much instantly. Because when this last `join()` call happens, the second
thread has already finished its task.

Now, if you compile and run this example, you will also notice that, in some cases,
the messages intertwine with each other. In other words, you might see
the message "Joining thread 1" inserted in the middle of the message "Thread 1",
or vice-versa. This happens because:

- the threads are executing basically at the same time as the main process of the program (i.e., the `main()` function).
- the threads share the same `stdout` from the main process of the program, which means that the messages that the threads produce are sent to exact same place as the messages produced by the main process.

Both of these points were described previously in @sec-what-thread.
So the messages might get intertwined because they are being produced and
sent to the same `stdout` roughly at the same time.
Anyway, when you call `join()` over a thread, the current process will wait
for the thread to finish before it continues, and, when the thread finishes its
task, the resources associated with this thread are automatically freed, and
the current process continues with its execution.


### Detaching a thread

When you detach a thread, the resources associated with this thread are automatically
released back to the system, without the need for another thread to join with this terminated thread.

In other words, when you call `detach()` on a thread it's like when your children become adults,
i.e., they become independent from you. A detached thread frees itself, and when this thread finishes its
tasks, it does not report the results back to you. Thus, you normally mark a thread as *detached*
when you don't need to use the return value of the thread, or when you don't care about
when exactly the thread finishes its job, i.e., the thread solves everything by itself.

Take the code example below. We create a new thread, detach it, and then, we just
print a final message before we end our program. We use the same `print_id()`
function that we have used over the previous examples.


```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
const Thread = std.Thread;
fn print_id(id: *const u8) !void {
    std.debug.print("Thread ID: {d}\n", .{id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    thread1.detach();
    std.debug.print("Finish main\n", .{});
}
```

```
Finish main
```

Now, if you look closely at the output of this code example, you will notice
that only the final message in main was printed to the console. The message
that was supposed to be printed by `print_id()` did not appear in the console.
Why? It's because the main process of our program has finished first,
before the thread was able to say anything.

And that is perfectly ok behaviour, because the thread was detached, so it was
able to free itself, without the need to wait for the main process.
If you ask main to sleep (or "wait") for some extra nanoseconds, before it ends, you will likely
see the message printed by `print_id()`, because you give enough time for the thread to
finish before the main process ends.



## Mutexes

Mutexes are a classic component of every thread library. In essence, a mutex is a *Mutually Exclusive Flag*, and this flag
acts like a type of "lock", or as a gate keeper to a particular section of your code. Mutexes are related to thread synchronization,
more specifically, they prevent you from having some classic race conditions in your program,
and, therefore, major bugs and undefined behaviour that are usually difficult to track and understand.

The main idea behind a mutex is to help us to control the execution of a particular section of the code, and to
prevent two or more threads from executing this particular section of the code at the same time.
Many programmers like to compare a mutex to a bathroom door (which typically has a lock).
When a thread locks its own mutex object, it's like if the bathroom door was locked.
Therefore, other people (in this case, other threads) who want to use the same bathroom at the same time
must be patient and simply wait for the current occupant (or thread) to unlock the door and get out of the bathroom.

Some other programmers also like to explain mutexes by using the analogy of "each person will have their turn to speak".
This is the analogy used in the [*Multithreading Code* video from the Computerphile project](https://www.youtube.com/watch?v=7ENFeb-J75k&ab_channel=Computerphile)[^computerphile].
Imagine if you are in a conversation circle. There is a moderator in this circle, which is the person that decides who
has the right to speak at that particular moment. The moderator gives a green card (or some sort of an authorization card) to the person that
is going to speak, and, as a result, everyone else must be silent and hear this person that has the green card.
When the person finishes talking, they give the green card back to the moderator, and the moderator decides
who is going to talk next, and delivers the green card to that person. And the cycle goes on like this.

[^computerphile]: <https://www.youtube.com/watch?v=7ENFeb-J75k&ab_channel=Computerphile>


A mutex acts like the moderator in this conversation circle. The mutex authorizes one single thread to execute a specific section of the code,
and it also blocks the other threads from executing this same section of the code. If these other threads want to execute this same
piece of the code, they are forced to wait for the the authorized thread to finish first.
When the authorized thread finishes executing this code, the mutex authorizes the next thread to execute this code,
while the remaining threads remain blocked. Therefore, a mutex is like a moderator that does a "each
thread will have their turn to execute this section of the code" type of control.


Mutexes are especially used to prevent data race problems from happening. A data race problem happens when two or more threads
are trying to read from or write to the same shared object at the same time.
So, when you have an object that is shared will all threads, and, you want to avoid two or more threads from
accessing this same object at the same time, you can use a mutex to lock the part of the code that access this specific object.
When a thread tries to run this code that is locked by a mutex, this thread stops its execution,
and patiently waits for this section of the codebase to be unlocked to continue.

Notice that mutexes are normally used to lock areas of the codebase that access/modify data that is **shared** with all threads,
i.e., objects that are either stored in the global data section, or in the heap space of your program.
So mutexes are not normally used on areas of the codebase that access/modify objects that are local to the thread.



### Critical section {#sec-critical-section}

Critical section is a concept commonly associated with mutexes and thread synchronization.
In essence, a critical section is the section of the program that a thread access/modify a shared resource
(i.e., an object, a file descriptor, something that all threads have access to). In other words,
a critical section is the section of the program where race conditions might happen, and, therefore,
where undefined behaviour can be introduced into the program.

When we use mutexes in our program, the critical section defines the area of the codebase that we want to lock.
So we normally lock the mutex object at the beginning of the critical section,
and then, we unlock it at the end of the critical section.
The two bullet points exposed below comes from the "Critical Section" article from GeekFromGeeks,
and they summarise well the role that a critical section plays in the thread synchronization problem [@geeks_critical_section].


1. The critical section must be executed as an atomic operation, which means that once one thread or process has entered the critical section, all other threads or processes must wait until the executing thread or process exits the critical section. The purpose of synchronization mechanisms is to ensure that only one thread or process can execute the critical section at a time.
1. The concept of a critical section is central to synchronization in computer systems, as it is necessary to ensure that multiple threads or processes can execute concurrently without interfering with each other. Various synchronization mechanisms such as semaphores, mutexes, monitors, and condition variables are used to implement critical sections and ensure that shared resources are accessed in a mutually exclusive manner.


### Atomic operations {#sec-atomic-operation}

You will also see the term "atomic operation" a lot when reading about threads, race conditions and mutexes.
In summary, an operation is categorized as "atomic" when a context switch cannot occur in
the middle of the operation. In other words, this operation is always done from beginning to end, without interruptions
of another process or operation in the middle of its execution phase.

Not many operations today are atomic. But why do atomic operations matter here? It's because data races
(which is a type of a race condition) cannot happen on operations that are atomic.
So if a particular line in your code performs an atomic operation, then this line will never
suffer from a data race problem. Therefore, programmers sometimes use an atomic operation
to protect themselves from data race problems in their code.

When you have an operation that is compiled into just one single assembly instruction, this operation might be atomic,
because it's just one assembly instruction. But this is not guaranteed. This is usually true for old CPU architectures
(such as `x86`). But nowadays, most assembly instructions in modern CPU architectures are broken down into multiple micro-tasks,
which inherently makes the operation non-atomic, even if it consists of a single assembly instruction.

The Zig Standard Library offers some atomic functionality in the `std.atomic` module.
In this module, you will find a public and generic function called `Value()`. With this function we create an "atomic object", which is
a value that contains some native atomic operations, most notably, a `load()` and a `fetchAdd()` operation.
If you have experience with multithreading in C++, you probably have recognized this pattern. So yes, this generic
"atomic object" in Zig is essentially identical to the template struct `std::atomic` from the C++ Standard Library.
It's important to emphasize that only primitive data types (i.e., the types presented in @sec-primitive-data-types)
are supported by these atomic operations in Zig.





### Data races and race conditions

To understand why mutexes are used, we need to understand better the problem that they seek
to solve, which can be summarized into data race problems. A data race problem is a type of a race condition,
which happens when one thread is accessing a particular memory location (i.e., a particular shared object) at the same
time that another thread is trying to write/save new data into this same memory location (i.e., the same shared object).

We can simply define a race condition as any type of bug in your program that is based
on a "who gets there first" problem. A data race problem is a type of a race condition, because it occurs when two or more parties
are trying to read and write into the same memory location at the same time, and, therefore, the end result of this operation
depends completely on who gets to this memory location first.
As a consequence, a program that has a data race problem will likely produce a different result each time that we execute it.

Thus, race conditions produce undefined behaviour and unpredictability because the program produces
a different answer each time a different person gets to the target location before the others.
And, we have no easy way to either predict or control who is getting to this target location first.
In other words, each time your program runs, you may get a different answer because a different person,
function, or part of the code finishes its tasks before the others.

As an example, consider the code snippet exposed below. In this example, we create a global counter
variable, and we also create an `increment()` function, whose job is to just increment this global counter
variable in a for loop.

Since the for loop iterates 1 hundred thousand times, and, we create two separate threads
in this code example, what number do you expect to see in the final message printed to `stdout`?
The answer should be 2 hundred thousand. Right? Well, in theory, this program was supposed
to print 2 hundred thousand at the end, but in practice, every time that I execute this program
I get a different answer.

In the example exposed below, you can see that this time the end
result was 117254, instead of the expected 200000. The second time I executed this program,
I got the number 108592 as the result. So the end result of this program is varying, but it never gets
to the expected 200000 that we want.


```{zig}
#| eval: true
#| auto_main: false
#| build_type: "lib"
const std = @import("std");
const Thread = std.Thread;
var counter: usize = 0;
// Function to increment the counter
fn increment() void {
    for (0..100000) |_| {
        counter += 1;
    }
}

pub fn main() !void {
    const thr1 = try Thread.spawn(.{}, increment, .{});
    const thr2 = try Thread.spawn(.{}, increment, .{});
    thr1.join();
    thr2.join();
    std.debug.print("Couter value: {d}\n", .{counter});
}
```

```
Couter value: 117254
```


Why this is happening? The answer is: because this program contains a data race problem.
This program would print the correct number 200000 if and only if the first thread finishes
its tasks before the second thread starts to execute. But that is very unlikely to happen.
Because the process of creating the thread is too fast, and therefore, both threads start to execute roughly
at the same time. If you change this code to add some nanoseconds of sleep between the first and the second calls to `spawn()`,
you will increase the chances of the program producing the "correct result".

So the data race problem happens because both threads are reading and writing to the same
memory location at roughly the same time. In this example, each thread is essentially performing
three basic operations at each iteration of the for loop, which are:

1. reading the current value of `count`.
1. incrementing this value by 1.
1. writing the result back into `count`.

Ideally, a thread B should read the value of `count`, only after the other thread A has finished
writing the incremented value back into the `count` object. Therefore, in the ideal scenario, which is demonstrated
in @tbl-data-race-ideal, the threads should work in sync with each other. But the reality is that these
threads are out of sync, and because of that, they suffer from a data race problem, which is demonstrated
in @tbl-data-race-not.

Notice that, in the data race scenario (@tbl-data-race-not), the read performed by a thread B happens
before the write operation of thread A, and that ultimately leads to wrong results at the end of the program.
Because when thread B reads the value of the `count` variable, thread A is still processing
the initial value from `count`, and has not yet written the new, incremented value back to `count`. As a result,
thread B ends up reading the same initial (or "old") value from `count` instead of
the updated, incremented value that thread A would have written.


::: {#tbl-data-race-ideal}

| Thread 1    | Thread 2    | Integer value |
|-------------|-------------|---------------|
| read value  |             | 0             |
| increment   |             | 1             |
| write value |             | 1             |
|             | read value  | 1             |
|             | increment   | 2             |
|             | write value | 2             |

: An ideal scenario for two threads incrementing the same integer value
:::

::: {#tbl-data-race-not}

| Thread 1    | Thread 2    | Integer value |
|-------------|-------------|---------------|
| read value  |             | 0             |
|             | read value  | 0             |
| increment   |             | 1             |
|             | increment   | 1             |
| write value |             | 1             |
|             | write value | 1             |

: A data race scenario when two threads are incrementing the same integer value
:::


If you think about these diagrams exposed in form of tables, you will notice that they relate back to our discussion of atomic operations
in @sec-atomic-operation. Remember, atomic operations are operations that the CPU executes
from beginning to end, without interruptions from other threads or processes. So,
the scenario exposed in @tbl-data-race-ideal does not suffer from a data race, because
the operations performed by thread A are not interrupted in the middle by the operations
from thread B.

If we also think about the discussion of critical section from @sec-critical-section, we can identify
the section that representes the critical section of the program, which is the section that is vulnerable
to data race conditions. In this example, the critical section of the program is the line where we increment
the `counter` variable (`counter += 1`). So, ideally, we want to use a mutex, and lock right before this line, and then
unlock right after this line.




### Using mutexes in Zig

Now that we know the problem that mutexes seek to solve, we can learn how to use them in Zig.
Mutexes in Zig are available through the `std.Thread.Mutex` struct from the Zig Standard Library.
If we take the same code from the previous example, and improve it with mutexes, to solve
our data race problem, we get the code example below.

Notice that this time, we had to alter the `increment()` function to receive a pointer to
the `Mutex` object as input. All that we need to do, to make this program safe against
data race problems, is to call the `lock()` method at the beginning of
the critical section, and then, call `unlock()` at the end of the critical section.
Notice that the output of this program is now the correct number of 200000.

```{zig}
#| build_type: "run"
#| auto_main: false
const std = @import("std");
const Thread = std.Thread;
const Mutex = std.Io.Mutex;
const State = Mutex.State;
var counter: usize = 0;

fn increment(io: std.Io, mutex: *Mutex) !void {
    for (0..100000) |_| {
        try mutex.lock(io);
        counter += 1;
        mutex.unlock(io);
    }
}

pub fn main(init: std.process.Init) !void {
    var mutex: Mutex = .{
        .state=std.atomic.Value(State).init(.unlocked)
    };

    const thr1 = try Thread.spawn(.{}, increment, .{init.io, &mutex});
    const thr2 = try Thread.spawn(.{}, increment, .{init.io, &mutex});
    thr1.join();
    thr2.join();
    std.debug.print("Couter value: {d}\n", .{counter});
}
```




## Read/Write locks

Mutexes are normally used when it's not always safe for two or more threads running the same
piece of code at the same time. In contrast, read/write locks are normally used in situations
where you have a mixture of scenarios, i.e., there are some pieces of the codebase that are safe
to run in parallel, and other pieces that are not safe.

For example, suppose that you have multiple threads that uses the same shared file in the filesystem to store some configurations, or
statistics. If two or more threads try to read the data from this same file at the same time, nothing bad happens.
So this part of the codebase is perfectly safe to be executed in parallel, with multiple threads reading the same file at the same time.

However, if two or more threads try to write data into this same file at the same time, then we cause some race condition
problems. So this other part of the codebase is not safe to be executed in parallel.
More specifically, a thread might end up writing data in the middle of the data written by the other thread.
This process of two or more threads writing to the same location might lead to data corruption.
This specific situation is usually called a *torn write*.

Thus, what we can extract from this example is that there are certain types of operations that cause
a race condition, but there are also other types of operations that do not cause a race condition problem.
You could also say that there are types of operations that are susceptible to race condition problems,
and there are other types of operations that are not.

A read/write lock is a type of lock that acknowledges the existence of this specific scenario, and you can
use this type of lock to control which parts of the codebase are safe to run in parallel and which parts are not.



### Exclusive lock vs shared lock

Therefore, a read/write lock is a little different from a mutex. Because a mutex is always an *exclusive lock*, meaning that, only
one thread is allowed to execute at all times. With an exclusive lock, the other threads are always "excluded",
i.e., they are always blocked from executing. But in a read/write lock, the other threads might be authorized
to run at the same time, depending on the type of lock that they acquire.

We have two types of locks in a read/write lock, which are: an exclusive lock and a shared lock. An exclusive lock works exactly the same
as a mutex, while a shared lock is a lock that does not block the other threads from running at the same time.
In the `pthreads` C library, read/write locks are available through the `pthread_rwlock_t` C struct. With
this C struct, you can create:

- a "write lock", which corresponds to an exclusive lock.
- a "read lock", which corresponds to a shared lock.

The terminology might be a little different compared to Zig. But the meaning is still the same.
Therefore, just remember this relationship, write locks are exclusive locks, while read locks are shared locks.

When a thread tries to acquire a read lock (i.e., a shared lock), this thread gets the shared lock
if and only if another thread does not currently hold a write lock (i.e., an exclusive lock), and also
if there are no other threads already in the queue,
waiting for their turn to acquire a write lock. In other words, the thread in the queue has attempted
to get a write lock earlier, but this thread was blocked
because there was another thread running that already had a write lock. As a consequence, this thread is in the queue to get a write lock,
and it's currently waiting for the other thread with a write lock to finish its execution.

When a thread tries to acquire a read lock, but it fails in acquiring this read lock, either because there is
a thread with a write lock already running, or because there is a thread in the queue to get a write lock,
the execution of this thread is instantly blocked, i.e., paused. This thread will indefinitely attempt to get the
read lock, and its execution will be unblocked (or unpaused) only after this thread successfully acquires the read lock.

If you think deeply about this dynamic between read locks versus write locks, you might notice that a read lock is basically a safety mechanism.
More specifically, it's a way for us to
allow a particular thread to run together with the other threads only when it's safe to. In other words, if there is currently
a thread with a write lock running, then it's very likely not safe for the thread that is trying to acquire the read lock to run now.
As a consequence, the read lock protects this thread from running into dangerous waters, and patiently waits for the
"write lock" thread to finishes its tasks before it continues.

On the other hand, if there are only "read lock" (i.e., "shared lock") threads currently running
(i.e., not a single "write lock" thread currently exists), then it
is perfectly safe for this thread that is acquiring the read lock to run in parallel with the other
threads. As a result, the read lock just
allows for this thread to run together with the other threads.

Thus, by using read locks (shared locks) in conjunction with write locks (exclusive locks), we can control which regions or sections
of our multithreaded code is safe to have parallelism, and which sections are not safe to have parallelism.





### Using read/write locks in Zig

The Zig Standard Library supports read/write locks through the `std.Thread.RwLock` module.
If you want a particular thread to acquire a shared lock (i.e., a read lock), you should
call the `lockShared()` method from the `RwLock` object. But, if you want this thread
to acquire an exclusive lock (i.e., a write lock) instead, then you should call the
`lock()` method from the `RwLock` object.

As with mutexes, we also have to unlock the shared or exclusive locks that we acquire through a read/write lock object,
once we are at the end of our "critical section". If you have acquired an exclusive lock, then, you unlock
this exclusive lock by calling the `unlock()` method from the read/write lock object. In contrast,
if you have acquired a shared lock instead, then, call `unlockShared()` to unlock this shared lock.

As a simple example, the snippet below creates three separate threads responsible for reading the
current value in a `counter` object, and it also creates another thread responsible for writing
new data into the `counter` object (incrementing it, more specifically).

```{zig}
#| eval: true
#| build_type: "lib"
#| auto_main: false
const std = @import("std");
const Thread = std.Thread;
const RwLock = std.Io.RwLock;
const duration = std.Io.Duration.fromSeconds(2);
const clock: std.Io.Clock = .awake;
var counter: u32 = 0;

fn reader(io: std.Io, id: u32, lock: *RwLock) !void {
    while (true) {
        if (lock.tryLockShared(io)) {
            std.debug.print("Thread {d}: {d}\n", .{id, counter});
            _ = lock.unlockShared(io);
            try std.Io.sleep(io, duration, clock);
        }
    }
}

fn writer(io: std.Io, lock: *RwLock) !void {
    while (true) {
        if (lock.tryLock(io)) {
            counter += 1;
            _ = lock.unlock(io);
            try std.Io.sleep(io, duration, clock);
        }
    }
}

pub fn main(init: std.process.Init) !void {
    var lock: RwLock = .init;
    const thr1 = try Thread.spawn(.{}, reader, .{init.io, 1, &lock});
    const thr2 = try Thread.spawn(.{}, reader, .{init.io, 2, &lock});
    const thr3 = try Thread.spawn(.{}, reader, .{init.io, 3, &lock});
    const wthread = try Thread.spawn(.{}, writer, .{init.io, &lock});

    thr1.join();
    thr2.join();
    thr3.join();
    wthread.join();
}
```


## Yielding a thread

The `Thread` struct supports yielding through the `yield()` method.
Yielding a thread means that the execution of the thread is temporarily stopped,
and it moves to the end of the priority queue managed by the scheduler of
your operating system.

That is, when you yield a thread, you are essentially saying the following to your OS:
"Hey! Could you please stop executing this thread for now, and comeback to continue it later?".
You could also interpret this yield operation as: "Could you please deprioritize this thread,
to focus on doing other things instead?".
So this yield operation is also a way for you
to stop a particular thread, so that you can work and prioritize other threads instead.

It's important to say that, yielding a thread is a "not so common" thread operation these days.
In other words, not many programmers use yielding in production, simply because it's hard to use
this operation and make it work properly, and also, there
are better alternatives. Most programmers prefer to use `join()` instead.
In fact, most of the time, when you see someone using this "yield" operation in some code example,
they are usually doing so to help debug race conditions in their applications.
That is, this "yield" operation is mostly used as a debug tool nowadays.

Anyway, if you want to yield a thread, just call the `yield()` method from it, like this:

```{zig}
#| eval: false
thread.yield();
```






## Common problems in threads



### Deadlocks

A deadlock occurs when two or more threads are blocked forever,
waiting for each other to release a resource. This usually happens when multiple locks are involved,
and the order of acquiring them is not well managed.

The code example below demonstrates a deadlock situation. We have two different threads that execute
two different functions (`do_some_work1()` and `do_some_work2()`) in this example. And we also have two separate
mutexes. If you compile and run this code example, you will notice that the program just runs indefinitely,
without ending.

When we look into the first thread, which executes the `do_some_work1()` function, we can
notice that this function acquires the `mut1` lock first. Because this is the first operation
that is executed inside this thread, which is the first thread created in the program.
After that, the function sleeps for 1 second, to
simulate some type of work, and then, the function tries to acquire the `mut2` lock.

On the other hand, when we look into the second thread, which executes the `do_some_work2()` function,
we can see that this function acquires the `mut2` lock first. Because when this thread gets created and it tries
to acquire this `mut2` lock, the first thread is still sleeping on that "sleep 1 second" line.
After acquiring `mut2`, the `do_some_work2()` function also sleeps for 1 second, to
simulate some type of work, and then the function tries to acquire the `mut1` lock.

This creates a deadlock situation, because after the "sleep for 1 second" line in both threads,
thread 1 is trying to acquire the `mut2` lock, but this lock is currently being used by thread 2.
However, at this moment, thread 2 is also trying to acquire the `mut1` lock, which is currently
being used by thread 1. Therefore, both threads end up waiting for ever. Waiting for their peer to
free the lock that they want to acquire.


```{zig}
#| eval: false
const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromSeconds(1);
const State = std.Io.Mutex.State;
var mut1: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};
var mut2: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};

fn do_some_work1(io: std.Io) !void {
    try mut1.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut2.lock(io);
    std.debug.print("Doing some work 1\n", .{});
    mut2.unlock(io);
    mut1.unlock(io);
}

fn do_some_work2(io: std.Io) !void {
    try mut2.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut1.lock(io);
    std.debug.print("Doing some work 2\n", .{});
    mut1.unlock(io);
    mut2.unlock(io);
}

pub fn main(init: std.process.Init) !void {
    const thr1 = try Thread.spawn(.{}, do_some_work1, .{init.io});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{init.io});
    thr1.join();
    thr2.join();
}
```


### Not calling `join()` or `detach()` {#sec-not-call-join-detach}

When you do not call either `join()` or `detach()` over a thread, then this thread becomes a "zombie thread",
because it does not have a clear "return point".
You could also interpret this as: "nobody is properly responsible for managing the thread".
When we don't establish if a thread is either *joinable* or *detached*,
nobody becomes responsible for dealing with the return value of this thread, and also,
nobody becomes responsible for clearing (or freeing) the resources associated with this thread.

You don't want to be in this situation, so remember to always use `join()` or `detach()`
on the threads that you create. When you don't use one of these methods, we lose
control over the thread, and its resources are never freed
(i.e., you have leaked resources in the system).


### Cancelling or killing a particular thread

When we think about the `pthreads` C library, there is a possible way to asynchronously kill or cancel
a thread, which is by sending a `SIGTERM` signal to the thread through the `pthread_kill()` function.
But canceling a thread like this is bad. It's dangerously bad. As a consequence, the Zig implementation
of threads does not have a similar function, or, a similar way to asynchronously cancel or kill
a thread.

Therefore, if you want to cancel a thread in the middle of its execution in Zig,
then one good strategy that you can take is to use control flow in conjunction with `join()`.
More specifically, you can design your thread around a while loop that is constantly
checking if the thread should continue running.
If it's time to cancel the thread, we could make the while loop break, and join the thread with the main thread
by calling `join()`.

The code example below demonstrates to some extent this strategy.
Here, we are using control flow to break the while loop, and exit the thread earlier than
what we have initially planned to. This example also demonstrates how can we use
atomic objects in Zig with the `Value()` generic function that we have mentioned in @sec-atomic-operation.


```{zig}
#| auto_main: false
#| build_type: "run"
const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromSeconds(2);
var running = std.atomic.Value(bool).init(true);
var counter: u64 = 0;

fn do_more_work(io: std.Io) !void {
    try std.Io.sleep(io, duration, clock);
}

fn work(io: std.Io) !void {
    while (running.load(.monotonic)) {
        for (0..10000) |_| {
            counter += 1;
        }
        if (counter > 15000) {
            std.debug.print("Time to cancel the thread.\n", .{});
            running.store(false, .monotonic);
        } else {
            std.debug.print("Time to do more work.\n", .{});
            try do_more_work(io);
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const thread = try Thread.spawn(.{}, work, .{init.io});
    thread.join();
}
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---


```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "lib"
)
```




# Introducing Vectors and SIMD {#sec-vectors-simd}

In this chapter, I want to discuss vectors in Zig, which are
related to SIMD operations (i.e., they have no relationship with the `std::vector` class
from C++).

## What is SIMD?

SIMD (*Single Instruction/Multiple Data*) is a group of operations that are widely used
on video/audio editing programs, and also in graphics applications. SIMD is not a new technology,
but the massive use of SIMD on normal desktop computers is somewhat recent. In the old days, SIMD
was only used on "supercomputer models".

Most modern CPU models (from AMD, Intel, etc.) these days (either in a desktop or in a
notebook model) have support for SIMD operations. So, if you have a very old CPU model installed in your
computer, then, it's possible that you have no support for SIMD operations in your computer.

Why have people started using SIMD in their software? The answer is performance.
But what does SIMD precisely do to achieve better performance? Well, in essence, SIMD operations are a different
strategy to get parallel computing in your program, and therefore, make faster calculations.

The basic idea behind SIMD is to have a single instruction that operates over multiple data
at the same time. When you perform a normal scalar operation, like for example, four add instructions,
each addition is performed separately, one after another. But with SIMD, these four add instructions
are translated into a single instruction, and, as consequence, the four additions are performed
in parallel, at the same time.

Currently, the `zig` compiler allows you to apply the following group of operators on vector objects.
When you apply one of these operators on vector objects, SIMD is used to make the calculations, and,
therefore, these operators are applied element-wise and in parallel by default.

- Arithmetic (`+`, `-`, `/`, `*`, `@divFloor()`, `@sqrt()`,  `@ceil()`, `@log()`, etc.).
- Bitwise operators (`>>`, `<<`, `&`, `|`, `~`, etc.).
- Comparison operators (`<`, `>`, `==`, etc.).


## Vectors {#sec-what-vectors}

A SIMD operation is usually performed through a *SIMD intrinsic*, which is just a fancy
name for a function that performs a SIMD operation. These SIMD intrinsics (or "SIMD functions")
always operate over a special type of object, which are called "vectors". So,
in order to use SIMD, you have to create a "vector object".

A vector object is usually a fixed-sized block of 128 bits (16 bytes).
As a consequence, most vectors that you find in the wild are essentially arrays that contains 2 values of 8 bytes each,
or, 4 values of 4 bytes each, or, 8 values of 2 bytes each, etc.
However, different CPU models may have different extensions (or, "implementations") of SIMD,
which may offer more types of vector objects that are bigger in size (256 bits or 512 bits)
to accomodate more data into a single vector object.

You can create a new vector object in Zig by using the `@Vector()` built-in function. Inside this function,
you specify the vector length (number of elements in the vector), and the data type of the elements
of the vector. Only primitive data types are supported in these vector objects.
In the example below, I'm creating two vector objects (`v1` and `v2`) of 4 elements of type `u32` each.

Also notice in the example below, that a third vector object (`v3`) is created from the
sum of the previous two vector objects (`v1` plus `v2`). Therefore,
math operations over vector objects take place element-wise by default, because
the same operation (in this case, addition) is transformed into a single instruction
that is replicated in parallel, across all elements of the vectors.


```{zig}
#| auto_main: true
#| build_type: "run"
const v1 = @Vector(4, u32){4, 12, 37, 9};
const v2 = @Vector(4, u32){10, 22, 5, 12};
const v3 = v1 + v2;
try stdout.print("{any}\n", .{v3});
try stdout.flush();
```

This is how SIMD introduces more performance in your program. Instead of using a for loop
to iterate through the elements of `v1` and `v2`, and adding them together, one element at a time,
we enjoy the benefits of SIMD, which performs all 4 additions in parallel, at the same time.

Therefore, the `@Vector` structure is essentially the Zig representation of SIMD vector objects.
The elements in these vector objects will be operated in parallel, if, and only if your current CPU model
supports SIMD operations. If your CPU model does not have support for SIMD, then, the `@Vector` structure will
likely produce a similar performance from a "for loop solution".


### Transforming arrays into vectors

There are different ways to transform a normal array into a vector object.
You can either use implicit conversion (which is when you assign the array to
a vector object directly), or, use slices to create a vector object from a normal array.

In the example below, we are implicitly converting the array `a1` into a vector object (`v1`)
of length 4. We first explicitly annotate the data type of the vector object,
and then, we assign the array object to this vector object.

Also notice in the example below, that a second vector object (`v2`) is also created
by taking a slice of the array object (`a1`), and then, storing the pointer to this
slice (`.*`) into this vector object.


```{zig}
#| auto_main: true
#| build_type: "run"
const a1 = [4]u32{4, 12, 37, 9};
const v1: @Vector(4, u32) = a1;
const v2: @Vector(2, u32) = a1[1..3].*;
_ = v1; _ = v2;
```


It's worth emphasizing that only arrays and slices whose sizes
are compile-time known can be transformed into vectors. Vectors in general
are structures that work only with compile-time known sizes. Therefore, if
you have an array whose size is runtime known, then, you first need to
copy it into an array with a compile-time known size, before transforming it into a vector.



### The `@splat()` function

You can use the `@splat()` built-in function to create a vector object that is filled
with the same value across all of its elements. This function was created to offer a quick
and easy way to directly convert a scalar value (a.k.a. a single value, like a single character, or a single integer, etc.)
into a vector object.

Thus, we can use `@splat()` to convert a single value, like the integer `16` into a vector object
of length 1. But we can also use this function to convert the same integer `16` into a
vector object of length 10, that is filled with 10 `16` values. The example below demonstrates
this idea.

```{zig}
#| auto_main: true
#| build_type: "run"
const v1: @Vector(10, u32) = @splat(16);
try stdout.print("{any}\n", .{v1});
try stdout.flush();
```



### Careful with vectors that are too big

As I described in @sec-what-vectors, each vector object is usually a small block of 128, 256 or 512 bits.
This means that a vector object is usually small in size, and when you try to go in the opposite direction,
by creating a vector object that is very big in size (i.e., sizes that are close to $2^{20}$),
you usually end up with crashes and loud errors from the compiler.

For example, if you try to compile the program below, you will likely face segmentation faults, or LLVM errors during
the build process. Just be careful to not create vector objects that are too big in size.

```{zig}
#| eval: false
const v1: @Vector(1000000, u32) = @splat(16);
_ = v1;
```

```
Segmentation fault (core dumped)
```
---
engine: knitr
knitr: true
syntax-definition: "../Assets/zig.xml"
---

```{r}
#| include: false
source("../zig_engine.R")
knitr::opts_chunk$set(
    auto_main = FALSE,
    build_type = "run"
)
```



::::: {.content-visible when-format="html"}

# References {.unnumbered}

::: {#refs}
:::

:::::
