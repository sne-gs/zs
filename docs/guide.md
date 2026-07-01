# Zig Guide

Source: https://zig.guide/ (Zig 0.15.2)

---

- 
- Getting Started
- Welcome
Version: Zig 0.15.2# Welcome

[Zig](https://ziglang.org) is a general-purpose programming language and
toolchain for maintaining **robust**, **optimal**, and **reusable** software.

warningThe latest release of Zig is 0.15.2 and is currently unstable.

To follow this guide, we assume you have:

- Prior experience programming

- Some understanding of low-level programming concepts

Knowing a language like C, C++, Rust, Go, Pascal, or similar will help you follow
this guide. You must have an editor, terminal, and internet connection available
to you.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/00-getting-started/01-welcome.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Getting Started
- Installation
Version: Zig 0.15.2On this page# Installation

- Linux
- Windows
- macOS
Consider getting Zig from your distribution's [package manager](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager). Most major linux distros package the latest Zig release.

### Installing manually​

- [Download](https://ziglang.org/download/#release-0.15.2) a prebuilt version of Zig.
Choose a build of Zig 0.15.2 for Linux that matches your CPU architecture. If you're unsure which architecture you're using, this can be found with:

```zig
uname -m
```

- Extract the archive using tar, e.g.

```zig
tar xf zig-linux-x86_64-0.15.2.tar.xz
```

- Add the location of your Zig binary to your path, e.g.

```zig
echo 'export PATH="$HOME/zig-linux-x86_64-0.15.2:$PATH"' >> ~/.bashrc
```

Consider getting Zig from a package manager such as [chocolatey](https://chocolatey.org/), [scoop](https://scoop.sh/), or [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget).

All commands shown are to be used inside Powershell.

```zig
choco install zig
```

```zig
winget install zig.zig
```

```zig
scoop install zig
```

### Installing manually​

- [Download](https://ziglang.org/download/#release-0.15.2) a prebuilt version of Zig.
Choose a build of Zig 0.15.2 for Windows that matches your CPU architecture. Most Windows systems use `x86_64`, also known as `AMD64`. If you're unsure which architecture you're using, this can be found with:

```zig
$Env:PROCESSOR_ARCHITECTURE
```

- Extract Zig.

- Add Zig to your path:
Current User
- System Wide

```zig
[Environment]::SetEnvironmentVariable(    "Path",    [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\_\zig-windows-_",    "User")
```

```zig
[Environment]::SetEnvironmentVariable(    "Path",    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\_\zig-windows-_",    "Machine")
```

Close your terminal and create a new one.

Consider getting Zig from a package manager such as [brew](https://brew.sh/).

```zig
brew install zig
```

### Verifying your install​

Verify your installation with `zig version`. The output should look like this:

```zig
$ zig version0.15.2
```

### Extras​

For completions and go-to-definition in your editor, consider installing the [Zig Language Server](https://github.com/zigtools/zls/#installation).

Consider joining a [Zig community](https://github.com/ziglang/zig/wiki/Community).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/00-getting-started/02-installation.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Getting Started
- Hello World
Version: Zig 0.15.2# Hello World

Create a file called `main.zig`, with the following contents:

```zig
const std = @import("std");pub fn main() void {    std.debug.print("Hello, {s}!\n", .{"World"});}
```

Use `zig run main.zig` to build and run it. In this example, `Hello, World!`
will be written to stderr, and is assumed to never fail.

found 'invalid bytes'Make sure your `main.zig` file is UTF-8 encoded as the Zig compiler does not currently support other encodings. To re-encode your file as UTF-8, run `zig fmt main.zig` and reopen the file in your editor.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/00-getting-started/03-hello-world.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Getting Started
- Running Tests
Version: Zig 0.15.2On this page# Running Tests

In this guide, code examples are often given as runnable tests. Before proceeding, make sure that you can run them successfully.

### Success​

Save the following text as `test_pass.zig`, and run `zig test test_pass.zig`; you should read `All 1 tests  passed.` in your terminal.

```zig
const std = @import("std");const expect = std.testing.expect;test "always succeeds" {    try expect(true);}
```

noteSome code examples in this guide will have their imports at the top hidden, make sure to get them by clicking the copy button on the top-right of the code block.

Try the same test without the `try` keyword. What happened?

### Failure​

Now, save the following text as `test_fail.zig` and observe it fail.

```zig
const std = @import("std");const expect = std.testing.expect;test "always fails" {    try expect(false);}
```

Which should output something like:

```zig
Test [1/1] test.always fails... FAIL (TestUnexpectedResult)/usr/lib/zig/std/testing.zig:515:14: 0x2241ef in expect (test)    if (!ok) return error.TestUnexpectedResult;             ^[...]/test_fail:5:5: 0x224305 in test.always fails (test)    try expect(false);    ^0 passed; 0 skipped; 1 failed.
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/00-getting-started/04-running-tests.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Assignment
Version: Zig 0.15.2# Assignment

Value assignment has the following syntax:
`(const|var) identifier[: type] = value`.

- `const` indicates that `identifier` is a **constant** that stores an immutable
value.

- `var` indicates that `identifier` is a **variable** that stores a mutable
value.

- `: type` is a type annotation for `identifier`, and may be omitted if the data
type of `value` can be inferred.

```zig
const constant: i32 = 5; // signed 32-bit constantvar variable: u32 = 5000; // unsigned 32-bit variable// @as performs an explicit type coercionconst inferred_constant = @as(i32, 5);var inferred_variable = @as(u32, 5000);
```

Constants and variables *must* have a value. If no known value can be given, the
[`undefined`](https://ziglang.org/documentation/master/#undefined) value, which
coerces to any type, may be used as long as a type annotation is provided.

```zig
const a: i32 = undefined;var b: u32 = undefined;
```

Coming from JavaScript?▼If you're familiar with JavaScript, you might be used to using `undefined` as a
way to represent a variable that hasn't been initialised, or to represent an
absense of value.

However in Zig, using `undefined` like this is a bad idea as `undefined` works
very differently. In JavaScript, values can be checked for being undefined,
whereas in Zig, an undefined value is impossible to detect. Usage of undefined
values is not safe. Zig's undefined is "undefined" as in "undefined behaviour",
and should not be used as a stand-in for an optional.

Need optionals? These are [covered later](https://zig.guide/language-basics/optionals).

Where possible, `const` values are preferred over `var` values.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/01-assignment.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Arrays
Version: Zig 0.15.2# Arrays

Arrays are denoted by `[N]T`, where `N` is the number of elements in the array
and `T` is the type of those elements (i.e., the array's child type).

For array literals, `N` may be replaced by `_` to infer the size of the array.

```zig
const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' };
```

To get the size of an array, simply access the array's `len` field.

```zig
const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };const length = array.len; // 5
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/02-arrays.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- If Expressions
Version: Zig 0.15.2# If Expressions

Zig's if statements accept `bool` values (i.e. `true` or `false`). Unlike languages
like C or JavaScript, there are no values that implicitly coerce to bool values.

Ternary conditional operators (cond ? a : b) do not exist in zig.

```zig
const expect = @import("std").testing.expect;test "if statement" {    const a = true;    var x: u16 = 0;    if (a) {        x += 1;    } else {        x += 2;    }    try expect(x == 1);}
```

If statements also work as expressions.

```zig
const expect = @import("std").testing.expect;test "if statement expression" {    const a = true;    var x: u16 = 0;    x += if (a) 1 else 2;    try expect(x == 1);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/03-if.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- While loops
Version: Zig 0.15.2# While loops

Zig's while loop has three parts - a condition, a block and a continue
expression.

Without a continue expression.

```zig
const expect = @import("std").testing.expect;test "while" {    var i: u8 = 2;    while (i 
With a continue expression.

```zig
const expect = @import("std").testing.expect;test "while with continue expression" {    var sum: u8 = 0;    var i: u8 = 1;    while (i 
With a `continue`.

```zig
const expect = @import("std").testing.expect;test "while with continue" {    var sum: u8 = 0;    var i: u8 = 0;    while (i 
With a `break`.

```zig
const expect = @import("std").testing.expect;test "while with break" {    var sum: u8 = 0;    var i: u8 = 0;    while (i [Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/04-while-loops.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- For loops
Version: Zig 0.15.2# For loops

For loops are used to iterate over arrays (and other types, to be discussed
later). For loops follow this syntax. Like while, for loops can use `break` and
`continue`. Here, we've had to assign values to `_`, as Zig does not allow us to
have unused values.

```zig
const expect = @import("std").testing.expect;test "for" {    //character literals are equivalent to integer literals    const string = [_]u8{ 'a', 'b', 'c' };    for (string, 0..) |character, index| {        _ = character;        _ = index;    }    for (string) |character| {        _ = character;    }    for (string, 0..) |_, index| {        _ = index;    }    for (string) |_| {}}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/05-for-loops.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Functions
Version: Zig 0.15.2# Functions

**All function arguments are immutable** - if a copy is desired the user must
explicitly make one. Unlike variables, which are snake_case, functions are
camelCase. Here's an example of declaring and calling a simple function.

```zig
const expect = @import("std").testing.expect;fn addFive(x: u32) u32 {    return x + 5;}test "function" {    const y = addFive(0);    try expect(@TypeOf(y) == u32);    try expect(y == 5);}
```

Recursion is allowed:

```zig
const expect = @import("std").testing.expect;fn fibonacci(n: u16) u16 {    if (n == 0 or n == 1) return n;    return fibonacci(n - 1) + fibonacci(n - 2);}test "function recursion" {    const x = fibonacci(10);    try expect(x == 55);}
```

When recursion happens, the compiler is no longer able to work out the maximum
stack size, which may result in unsafe behaviour - a stack overflow. Details on
how to achieve safe recursion will be covered in the future.

Values can be ignored using `_` instead of a variable or const declaration. This
does not work at the global scope (i.e. it only works inside functions and
blocks) and is useful for ignoring the values returned from functions if you do
not need them.

```zig
_ = 10;
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/06-functions.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Defer
Version: Zig 0.15.2# Defer

Defer is used to execute a statement upon exiting the current block.

```zig
const expect = @import("std").testing.expect;test "defer" {    var x: i16 = 5;    {        defer x += 2;        try expect(x == 5);    }    try expect(x == 7);}
```

When there are multiple defers in a single block, they are executed in reverse
order.

```zig
const expect = @import("std").testing.expect;test "multi defer" {    var x: f32 = 5;    {        defer x += 2;        defer x /= 2;    }    try expect(x == 4.5);}
```

Defer is useful to ensure that resources are cleaned up when they are no longer needed.
Instead of needing to remember to manually free up the resource,
you can add a defer statement right next to the statement that allocates the resource.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/07-defer.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Errors
Version: Zig 0.15.2# Errors

An error set is like an enum (details on Zig's enums later), where each error in
the set is a value. There are no exceptions in Zig; errors are values. Let's
create an error set.

```zig
const FileOpenError = error{    AccessDenied,    OutOfMemory,    FileNotFound,};
```

Error sets coerce to their supersets.

```zig
const expect = @import("std").testing.expect;const FileOpenError = error{    AccessDenied,    OutOfMemory,    FileNotFound,};const AllocationError = error{OutOfMemory};test "coerce error from a subset to a superset" {    const err: FileOpenError = AllocationError.OutOfMemory;    try expect(err == FileOpenError.OutOfMemory);}
```

An error set type and another type can be combined with the `!` operator to form
an error union type. Values of these types may be an error value or a value of
the other type.

Let's create a value of an error union type. Here
[`catch`](https://ziglang.org/documentation/master/#catch) is used, which is
followed by an expression which is evaluated when the value preceding it is an
error. The catch here is used to provide a fallback value, but could instead be
a [`noreturn`](https://ziglang.org/documentation/master/#noreturn) - the type of
`return`, `while (true)` and others.

```zig
const expect = @import("std").testing.expect;const FileOpenError = error{    AccessDenied,    OutOfMemory,    FileNotFound,};const AllocationError = error{OutOfMemory};test "error union" {    const maybe_error: AllocationError!u16 = 10;    const no_error = maybe_error catch 0;    try expect(@TypeOf(no_error) == u16);    try expect(no_error == 10);}
```

Functions often return error unions. Here's one using a catch, where the `|err|`
syntax receives the value of the error. This is called **payload capturing**,
and is used similarly in many places. We'll talk about it in more detail later
in the chapter. Side note: some languages use similar syntax for lambdas - this
is not true for Zig.

```zig
const expect = @import("std").testing.expect;fn failingFunction() error{Oops}!void {    return error.Oops;}test "returning an error" {    failingFunction() catch |err| {        try expect(err == error.Oops);        return;    };}
```

`try x` is a shortcut for `x catch |err| return err`, and is commonly used where
handling an error isn't appropriate. Zig's
[`try`](https://ziglang.org/documentation/master/#try) and
[`catch`](https://ziglang.org/documentation/master/#catch) are unrelated to
try-catch in other languages.

```zig
const expect = @import("std").testing.expect;fn failingFunction() error{Oops}!void {    return error.Oops;}fn failFn() error{Oops}!i32 {    try failingFunction();    return 12;}test "try" {    const v = failFn() catch |err| {        try expect(err == error.Oops);        return;    };    try expect(v == 12); // is never reached}
```

[`errdefer`](https://ziglang.org/documentation/master/#errdefer) works like
[`defer`](https://ziglang.org/documentation/master/#defer), but only executing
when the function is returned from with an error inside of the
[`errdefer`](https://ziglang.org/documentation/master/#errdefer)'s block.

```zig
const expect = @import("std").testing.expect;fn failingFunction() error{Oops}!void {    return error.Oops;}var problems: u32 = 98;fn failFnCounter() error{Oops}!void {    errdefer problems += 1;    try failingFunction();}test "errdefer" {    failFnCounter() catch |err| {        try expect(err == error.Oops);        try expect(problems == 99);        return;    };}
```

Error unions returned from a function can have their error sets inferred by not
having an explicit error set. This inferred error set contains all possible
errors that the function may return.

```zig
fn createFile() !void {    return error.AccessDenied;}test "inferred error set" {    //type coercion successfully takes place    const x: error{AccessDenied}!void = createFile();    //Zig does not let us ignore error unions via _ = x;    //we must unwrap it with "try", "catch", or "if" by any means    _ = x catch {};}
```

Error sets can be merged.

```zig
const A = error{ NotDir, PathNotFound };const B = error{ OutOfMemory, PathNotFound };const C = A || B;
```

`anyerror` is the global error set, which due to being the superset of all error
sets, can have an error from any set coerced to it. Its usage should be
generally avoided.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/08-errors.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Switch
Version: Zig 0.15.2# Switch

Zig's `switch` works as both a statement and an expression. The types of all
branches must coerce to the type which is being switched upon. All possible
values must have an associated branch - values cannot be left out. Cases cannot
fall through to other branches.

An example of a switch statement. The else is required to satisfy the
exhaustiveness of this switch.

```zig
const expect = @import("std").testing.expect;test "switch statement" {    var x: i8 = 10;    switch (x) {        -1...1 => {            x = -x;        },        10, 100 => {            //special considerations must be made            //when dividing signed integers            x = @divExact(x, 10);        },        else => {},    }    try expect(x == 1);}
```

Here is the former, but as a switch expression.

```zig
const expect = @import("std").testing.expect;test "switch expression" {    var x: i8 = 10;    x = switch (x) {        -1...1 => -x,        10, 100 => @divExact(x, 10),        else => x,    };    try expect(x == 1);}
```

infoNow is the perfect time to use what you've learned and [solve a problem together](https://zig.guide/posts/fizz-buzz).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/09-switch.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Runtime Safety
Version: Zig 0.15.2# Runtime Safety

Zig provides a level of safety, where problems may be found during execution.
Safety can be left on, or turned off. Zig has many cases of so-called
**detectable illegal behaviour**, meaning that illegal behaviour will be caught
(causing a panic) with safety on, but will result in undefined behaviour with
safety off. Users are strongly recommended to develop and test their software
with safety on, despite its speed penalties.

For example, runtime safety protects you from out of bounds indices.

```zig
test "out of bounds" {    const a = [3]u8{ 1, 2, 3 };    var index: u8 = 5;    const b = a[index];    _ = b;    index = index;}
```

```zig
test "out of bounds"...index out of bounds.\tests.zig:43:14: 0x7ff698cc1b82 in test "out of bounds" (test.obj)    const b = a[index];             ^
```

The user may disable runtime safety for the current block using the built-in
function
[`@setRuntimeSafety`](https://ziglang.org/documentation/master/#setRuntimeSafety).

```zig
test "out of bounds, no safety" {    @setRuntimeSafety(false);    const a = [3]u8{ 1, 2, 3 };    var index: u8 = 5;    const b = a[index];    _ = b;    index = index;}
```

Safety is off for some build modes (to be discussed later).

# Unreachable

[`unreachable`](https://ziglang.org/documentation/master/#unreachable) is an
assertion to the compiler that this statement will not be reached. It can tell
the compiler that a branch is impossible, which the optimiser can then take
advantage of. Reaching an
[`unreachable`](https://ziglang.org/documentation/master/#unreachable) is
detectable illegal behaviour.

As it is of the type
[`noreturn`](https://ziglang.org/documentation/master/#noreturn), it is
compatible with all other types. Here it coerces to u32.

```zig
test "unreachable" {    const x: i32 = 1;    const y: u32 = if (x == 2) 5 else unreachable;    _ = y;}
```

```zig
test "unreachable"...reached unreachable code.\tests.zig:211:39: 0x7ff7e29b2049 in test "unreachable" (test.obj)    const y: u32 = if (x == 2) 5 else unreachable;                                      ^
```

Here is an unreachable being used in a switch.

```zig
const expect = @import("std").testing.expect;fn asciiToUpper(x: u8) u8 {    return switch (x) {        'a'...'z' => x + 'A' - 'a',        'A'...'Z' => x,        else => unreachable,    };}test "unreachable switch" {    try expect(asciiToUpper('a') == 'A');    try expect(asciiToUpper('A') == 'A');}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/10-runtime-safety.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Pointers
Version: Zig 0.15.2# Pointers

Normal pointers in Zig cannot have 0 or null as a value. They follow the syntax
`*T`, where `T` is the child type.

Referencing is done with `&variable`, and dereferencing is done with
`variable.*`.

```zig
const expect = @import("std").testing.expect;fn increment(num: *u8) void {    num.* += 1;}test "pointers" {    var x: u8 = 1;    increment(&x);    try expect(x == 2);}
```

Trying to set a `*T` to the value 0 is detectable illegal behaviour.

```zig
test "naughty pointer" {    var x: u16 = 5;    x -= 5;    var y: *u8 = @ptrFromInt(x);    y = y;}
```

```zig
Test [23/126] test.naughty pointer... thread 21598 panic: cast causes pointer to be null./test-c1.zig:252:18: 0x260a91 in test.naughty pointer (test)    var y: *u8 = @ptrFromInt(x);                 ^
```

Zig also has const pointers, which cannot be used to modify the referenced data.
Referencing a const variable will yield a const pointer.

```zig
test "const pointers" {    const x: u8 = 1;    var y = &x;    y.* += 1;}
```

```zig
error: cannot assign to constant    y.* += 1;        ^
```

A `*T` coerces to a `*const T`.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/11-pointers.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Pointer Sized Integers
Version: Zig 0.15.2# Pointer Sized Integers

`usize` and `isize` are given as unsigned and signed integers which are the same
size as pointers.

```zig
test "usize" {    try expect(@sizeOf(usize) == @sizeOf(*u8));    try expect(@sizeOf(isize) == @sizeOf(*u8));}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/12-pointer-sized-integers.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Many-item Pointers
Version: Zig 0.15.2# Many-item Pointers

Most programs need to keep track of buffers which don't have compile-time known
lengths. Many-item pointers are used for these. These act similarly to their
single-item counterparts, using the syntax `[*]T` instead of `*T`.

Here's a rundown of the differences between single and multi-item pointers.

Single-item pointersMulti-item pointersDereferenceableYes, e.g. `ptr.*`NoIndexableNoYes, e.g. `ptr[0]`Supports ArithmeticNoYes, e.g. `ptr + 1` or `ptr - 1`Item sizeAny size, including unknownMust be knownCoerces from an array pointerNoYes
Many-item pointers can have all of the same attributes, such as `const`, as
single-item pointers.

In this example code, we've written a function that can take in a buffer of any
length. Notice how a single-item pointer to an array of bytes coerces into a
many-item pointer of bytes.

```zig
const expect = @import("std").testing.expect;fn doubleAllManypointer(buffer: [*]u8, byte_count: usize) void {    var i: usize = 0;    while (i 
Think about what might happen if you passed that function the incorrect
`byte_count`. The programmer is expected to keep track of (or otherwise know)
the length of these buffers. It's worth noting that this function is effectively
trusting us to pass us a valid length for the given buffer.

We can convert from a many-item pointer to a single-item pointer by either
indexing an element and dereferencing that, or by using `@ptrCast` to cast the
pointer type. This is only valid when the buffer has a length of at least 1.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/13-many-item-pointers.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Slices
Version: Zig 0.15.2# Slices

Slices can be thought of many-item pointers (`[*]T`) with a length (`usize`).
These use the syntax `[]T`. Slices are easier to use safely and more convinient
than many-item pointers, as they store the valid length of the buffer with them.
Slices are sometimes referred to as "fat pointers" as they're typically double
the size of a normal pointer. Slices are the most common way to pass around
buffers in Zig.

Coming from Go?▼Slicing in Zig is similar to slicing in Go, but you replace `array[start:end]`
with `array[start..end]`.

Moreover, in Go, there is no explicit ownership or memory management, meaning
that slices point to memory owned by the garbage collector. However in Zig,
slices point to manually-managed memory; slices are not tied to memory
allocation. This has important implications:

- The validity and lifetime of the backing memory is in the hands of the
programmer.

- Zig slices do not have a Cap field, as they do not resize.

For a resizeable/appendable buffer with ownership, have a look at
[ArrayList](https://zig.guide/standard-library/arraylist).

Unlike many-item pointers, `for` loops work on slices.

The syntax `x[n..m]` is used to create a slice from an array, an operation known
as **slicing**. This creates a "slice" - a view into the array consisting of a
pointer and a length. Slicing includes the first element (`n`), but excludes the
last element (`m`).

In this example, a `const` slice is used in the `total` function as it doesn't
write to the slice's buffer.

```zig
const expect = @import("std").testing.expect;fn total(values: []const u8) usize {    var sum: usize = 0;    for (values) |v| sum += v;    return sum;}test "slices" {    const array = [_]u8{ 1, 2, 3, 4, 5 };    const slice = array[0..3];    try expect(total(slice) == 6);}
```

When these `n` and `m` values are both known at compile time, slicing will
actually produce a pointer to an array. This is not an issue as a pointer to an
array i.e. `*[N]T` will coerce to a slice - `[]T`.

```zig
const expect = @import("std").testing.expect;test "slices 2" {    const array = [_]u8{ 1, 2, 3, 4, 5 };    const slice = array[0..3];    try expect(@TypeOf(slice) == *const [3]u8);}
```

The syntax `x[n..]` can also be used when you want to slice to the end.

```zig
test "slices 3" {    var array = [_]u8{ 1, 2, 3, 4, 5 };    var slice = array[0..];    _ = slice;}
```

Let's again compare our pointer types.

Feature`*T``*[N]T``[*]T``[]T`DereferenceableYes, e.g. `ptr.*`NoNoNoIndexableNoYesYesYesSliceableNoYesYesYesElement CountAlways 1Compile-time knownUnknownRuntime knownArithmeticNoNoYes, e.g. `ptr + 1` or `ptr - 1`NoSize@sizeOf(usize)@sizeOf(usize)@sizeOf(usize)@sizeOf(usize) * 2AttributesYesYesYesYes
infoWe can now apply our knowledge and [make another program together](https://zig.guide/posts/fahrenheit-to-celsius).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/14-slices.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Enums
Version: Zig 0.15.2# Enums

Zig's enums allow you to define types with a restricted set of named values.

Let's declare an enum.

```zig
const Direction = enum { north, south, east, west };
```

Enums types may have specified (integer) tag types.

```zig
const Value = enum(u2) { zero, one, two };
```

Enum's ordinal values start at 0. They can be accessed with the built-in
function
[`@intFromEnum`](https://ziglang.org/documentation/master/#intFromEnum).

```zig
const expect = @import("std").testing.expect;const Value = enum(u2) { zero, one, two };test "enum ordinal value" {    try expect(@intFromEnum(Value.zero) == 0);    try expect(@intFromEnum(Value.one) == 1);    try expect(@intFromEnum(Value.two) == 2);}
```

Values can be overridden, with the next values continuing from there.

```zig
const expect = @import("std").testing.expect;const Value2 = enum(u32) {    hundred = 100,    thousand = 1000,    million = 1000000,    next,};test "set enum ordinal value" {    try expect(@intFromEnum(Value2.hundred) == 100);    try expect(@intFromEnum(Value2.thousand) == 1000);    try expect(@intFromEnum(Value2.million) == 1000000);    try expect(@intFromEnum(Value2.next) == 1000001);}
```

Enums can be given methods. These act as namespaced functions that can be called
with the dot syntax.

```zig
const expect = @import("std").testing.expect;const Suit = enum {    clubs,    spades,    diamonds,    hearts,    pub fn isClubs(self: Suit) bool {        return self == Suit.clubs;    }};test "enum method" {    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));}
```

Enums can also be given `var` and `const` declarations. These act as namespaced
globals and their values are unrelated and unattached to instances of the enum
type.

```zig
const expect = @import("std").testing.expect;const Mode = enum {    var count: u32 = 0;    on,    off,};test "hmm" {    Mode.count += 1;    try expect(Mode.count == 1);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/15-enums.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Structs
Version: Zig 0.15.2# Structs

Structs are Zig's most common kind of composite data type, allowing you to
define types that can store a fixed set of named fields. Zig gives no guarantees
about the in-memory order of fields in a struct or its size. Like arrays,
structs are also neatly constructed with `T{}` syntax. Here is an example of
declaring and filling a struct.

```zig
const Vec3 = struct { x: f32, y: f32, z: f32 };test "struct usage" {    const my_vector: Vec3 = .{        .x = 0,        .y = 100,        .z = 50,    };    _ = my_vector;}
```

Struct fields cannot be implicitly uninitialised:

```zig
test "missing struct field" {    const my_vector: Vec3 = .{        .x = 0,        .z = 50,    };    _ = my_vector;}
```

```zig
error: missing field: 'y'    const my_vector: Vec3 = .{                        ^
```

Fields may be given defaults:

```zig
const Vec4 = struct { x: f32 = 0, y: f32 = 0, z: f32 = 0, w: f32 = 0 };test "struct defaults" {    const my_vector: Vec4 = .{        .x = 25,        .y = -50,    };    _ = my_vector;}
```

Like enums, structs may also contain functions and declarations.

Structs have the unique property that when given a pointer to a struct, one
level of dereferencing is done automatically when accessing fields. Notice how,
in this example, `self.x` and `self.y` are accessed in the swap function without
needing to dereference the self pointer.

```zig
const expect = @import("std").testing.expect;const Stuff = struct {    x: i32,    y: i32,    fn swap(self: *Stuff) void {        const tmp = self.x;        self.x = self.y;        self.y = tmp;    }};test "automatic dereference" {    var thing = Stuff{ .x = 10, .y = 20 };    thing.swap();    try expect(thing.x == 20);    try expect(thing.y == 10);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/16-structs.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Unions
Version: Zig 0.15.2# Unions

Zig's unions allow you to define types that store one value of many possible
typed fields; only one field may be active at one time.

Bare union types do not have a guaranteed memory layout. Because of this, bare
unions cannot be used to reinterpret memory. Accessing a field in a union that
is not active is detectable illegal behaviour.

```zig
const Result = union {    int: i64,    float: f64,    bool: bool,};test "simple union" {    var result = Result{ .int = 1234 };    result.float = 12.34;}
```

```zig
test "simple union"...access of inactive union field.\tests.zig:342:12: 0x7ff62c89244a in test "simple union" (test.obj)    result.float = 12.34;           ^
```

Tagged unions are unions that use an enum to detect which field is active. Here
we make use of payload capturing again, to switch on the tag type of a union
while also capturing the value it contains. Here we use a *pointer capture*;
captured values are immutable, but with the `|*value|` syntax, we can capture a
pointer to the values instead of the values themselves. This allows us to use
dereferencing to mutate the original value.

```zig
const expect = @import("std").testing.expect;const Tag = enum { a, b, c };const Tagged = union(Tag) { a: u8, b: f32, c: bool };test "switch on tagged union" {    var value = Tagged{ .b = 1.5 };    switch (value) {        .a => |*byte| byte.* += 1,        .b => |*float| float.* *= 2,        .c => |*b| b.* = !b.*,    }    try expect(value.b == 3);}
```

The tag type of a tagged union can also be inferred. This is equivalent to the
Tagged type above.

```zig
const Tagged = union(enum) { a: u8, b: f32, c: bool };
```

`void` member types can have their type omitted from the syntax. Here, none is
of type `void`.

```zig
const Tagged2 = union(enum) { a: u8, b: f32, c: bool, none };
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/17-unions.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Integer Rules
Version: Zig 0.15.2# Integer Rules

Zig supports hex, octal and binary integer literals.

```zig
const decimal_int: i32 = 98222;const hex_int: u8 = 0xff;const another_hex_int: u8 = 0xFF;const octal_int: u16 = 0o755;const binary_int: u8 = 0b11110000;
```

Underscores may also be placed between digits as a visual separator.

```zig
const one_billion: u64 = 1_000_000_000;const binary_mask: u64 = 0b1_1111_1111;const permissions: u64 = 0o7_5_5;const big_address: u64 = 0xFF80_0000_0000_0000;
```

"Integer Widening" is allowed, which means that integers of a type may coerce to
an integer of another type, providing that the new type can fit all of the
values that the old type can.

```zig
const expect = @import("std").testing.expect;test "integer widening" {    const a: u8 = 250;    const b: u16 = a;    const c: u32 = b;    try expect(c == a);}
```

If you have a value stored in an integer that cannot coerce to the type that you
want, [`@intCast`](https://ziglang.org/documentation/master/#intCast) may be
used to explicitly convert from one type to the other. If the value given is out
of the range of the destination type, this is detectable illegal behaviour.

```zig
const expect = @import("std").testing.expect;test "@intCast" {    const x: u64 = 200;    const y = @as(u8, @intCast(x));    try expect(@TypeOf(y) == u8);}
```

Integers, by default, are not allowed to overflow. Overflows are detectable
illegal behaviour. Sometimes, being able to overflow integers in a well-defined
manner is a wanted behaviour. For this use case, Zig provides overflow
operators.

Normal OperatorWrapping Operator++%--%**%+=+%=-=-%=*=*%=

```zig
const expect = @import("std").testing.expect;test "well defined overflow" {    var a: u8 = 255;    a +%= 1;    try expect(a == 0);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/18-integer-rules.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Floats
Version: Zig 0.15.2# Floats

Zig's floats are strictly IEEE-compliant unless
[`@setFloatMode(.Optimized)`](https://ziglang.org/documentation/master/#setFloatMode)
is used, which is equivalent to GCC's `-ffast-math`. Floats coerce to larger
float types.

```zig
const expect = @import("std").testing.expect;test "float widening" {    const a: f16 = 0;    const b: f32 = a;    const c: f128 = b;    try expect(c == @as(f128, a));}
```

Floats support multiple kinds of literal.

```zig
const floating_point: f64 = 123.0E+77;const another_float: f64 = 123.0;const yet_another: f64 = 123.0e+77;const hex_floating_point: f64 = 0x103.70p-5;const another_hex_float: f64 = 0x103.70;const yet_another_hex_float: f64 = 0x103.70P-5;
```

Underscores may also be placed between digits.

```zig
const lightspeed: f64 = 299_792_458.000_000;const nanosecond: f64 = 0.000_000_001;const more_hex: f64 = 0x1234_5678.9ABC_CDEFp-10;
```

Integers and floats may be converted using the built-in functions
[`@floatFromInt`](https://ziglang.org/documentation/0.12.0/#floatFromInt) and
[`@intFromFloat`](https://ziglang.org/documentation/0.12.0/#intFromFloat).
[`@floatFromInt`](https://ziglang.org/documentation/0.12.0/#floatFromInt) is
always safe, whereas
[`@intFromFloat`](https://ziglang.org/documentation/0.12.0/#intFromFloat) is
detectable illegal behaviour if the float value cannot fit in the integer
destination type.

```zig
const expect = @import("std").testing.expect;test "int-float conversion" {    const a: i32 = 0;    const b = @as(f32, @floatFromInt(a));    const c = @as(i32, @intFromFloat(b));    try expect(c == a);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/19-floats.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Labelled Blocks
Version: Zig 0.15.2# Labelled Blocks

Blocks in Zig are expressions and can be given labels, which are used to yield
values. Here, we are using a label called `blk`. Blocks yield values, meaning
they can be used in place of a value. The value of an empty block `{}` is a
value of the type `void`.

```zig
test "labelled blocks" {    const count = blk: {        var sum: u32 = 0;        var i: u32 = 0;        while (i 
This can be seen as being equivalent to C's `i++`.

```zig
blk: {    const tmp = i;    i += 1;    break :blk tmp;}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/20-labelled-blocks.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Labelled Loops
Version: Zig 0.15.2# Labelled Loops

Loops can be given labels, allowing you to `break` and `continue` to outer
loops.

```zig
test "nested continue" {    var count: usize = 0;    outer: for ([_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 }) |_| {        for ([_]i32{ 1, 2, 3, 4, 5 }) |_| {            count += 1;            continue :outer;        }    }    try expect(count == 8);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/21-labelled-loops.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Loops as Expressions
Version: Zig 0.15.2# Loops as Expressions

Like `return`, `break` accepts a value. This can be used to yield a value from a
loop. Loops in Zig also have an `else` branch, which is evaluated when the loop
is not exited with a `break`.

```zig
fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {    var i = begin;    return while (i [Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/22-loops-as-expressions.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Optionals
Version: Zig 0.15.2# Optionals

Optionals use the syntax `?T` and are used to store the data
[`null`](https://ziglang.org/documentation/master/#null), or a value of type
`T`.

```zig
const expect = @import("std").testing.expect;test "optional" {    var found_index: ?usize = null;    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };    for (data, 0..) |v, i| {        if (v == 10) found_index = i;    }    try expect(found_index == null);}
```

Optionals support the `orelse` expression, which acts when the optional is
[`null`](https://ziglang.org/documentation/master/#null). This unwraps the
optional to its child type.

```zig
const expect = @import("std").testing.expect;test "orelse" {    const a: ?f32 = null;    const fallback_value: f32 = 0;    const b = a orelse fallback_value;    try expect(b == 0);    try expect(@TypeOf(b) == f32);}
```

`.?` is a shorthand for `orelse unreachable`. This is used for when you know it
is impossible for an optional value to be null, and using this to unwrap a
[`null`](https://ziglang.org/documentation/master/#null) value is detectable
illegal behaviour.

```zig
const expect = @import("std").testing.expect;test "orelse unreachable" {    const a: ?f32 = 5;    const b = a orelse unreachable;    const c = a.?;    try expect(b == c);    try expect(@TypeOf(c) == f32);}
```

Both `if` expressions and `while` loops support taking optional values as conditions,
allowing you to "capture" the inner non-null value.

Here we use an `if` optional payload capture; a and b are equivalent here.
`if (b) |value|` captures the value of `b` (in the cases where `b` is not null),
and makes it available as `value`. As in the union example, the captured value
is immutable, but we can still use a pointer capture to modify the value stored
in `b`.

```zig
const expect = @import("std").testing.expect;test "if optional payload capture" {    const a: ?i32 = 5;    if (a != null) {        const value = a.?;        _ = value;    }    var b: ?i32 = 5;    if (b) |*value| {        value.* += 1;    }    try expect(b.? == 6);}
```

And with `while`:

```zig
const expect = @import("std").testing.expect;var numbers_left: u32 = 4;fn eventuallyNullSequence() ?u32 {    if (numbers_left == 0) return null;    numbers_left -= 1;    return numbers_left;}test "while null capture" {    var sum: u32 = 0;    while (eventuallyNullSequence()) |value| {        sum += value;    }    try expect(sum == 6); // 3 + 2 + 1}
```

Optional pointer and optional slice types do not take up any extra memory
compared to non-optional ones. This is because internally they use the 0 value
of the pointer for `null`.

This is how null pointers in Zig work - they must be unwrapped to a non-optional
before dereferencing, which stops null pointer dereferences from happening
accidentally.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/23-optionals.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Comptime
Version: Zig 0.15.2# Comptime

Blocks of code may be forcibly executed at compile time using the
[`comptime`](https://ziglang.org/documentation/master/#comptime) keyword. In
this example, the variables x and y are equivalent.

```zig
const expect = @import("std").testing.expect;fn fibonacci(n: u16) u16 {    if (n == 0 or n == 1) return n;    return fibonacci(n - 1) + fibonacci(n - 2);}test "comptime blocks" {    const x = comptime fibonacci(10);    const y = comptime blk: {        break :blk fibonacci(10);    };    try expect(y == 55);    try expect(x == 55);}
```

Integer literals are of the type `comptime_int`. These are special in a way that
they have no size (they cannot be used at runtime!), and they have arbitrary
precision. `comptime_int` values coerce to any integer type that can hold them.
They also coerce to floats. Character literals are of this type.

```zig
const expect = @import("std").testing.expect;test "comptime_int" {    const a = 12;    const b = a + 10;    const c: u4 = a;    const d: f32 = b;    try expect(c == 12);    try expect(d == 22);}
```

`comptime_float` is also available, which internally is an `f128`. These cannot
be coerced to integers, even if they hold an integer value.

Types in Zig are values of the type `type`. These are available at compile time.
We have previously encountered them by checking
[`@TypeOf`](https://ziglang.org/documentation/master/#TypeOf) and comparing with
other types, but we can do more.

```zig
const expect = @import("std").testing.expect;test "branching on types" {    const a = 5;    const b: if (a 
Function parameters in Zig can be tagged as being
[`comptime`](https://ziglang.org/documentation/master/#comptime). This means
that the value passed to that function parameter must be known at compile time.
Let's make a function that returns a type. Notice how this function is
PascalCase, as it returns a type.

```zig
const expect = @import("std").testing.expect;fn Matrix(    comptime T: type,    comptime width: comptime_int,    comptime height: comptime_int,) type {    return [height][width]T;}test "returning a type" {    try expect(Matrix(f32, 4, 4) == [4][4]f32);}
```

We can reflect upon types using the built-in
[`@typeInfo`](https://ziglang.org/documentation/master/#typeInfo), which takes
in a `type` and returns a tagged union. This tagged union type can be found in
[`std.builtin.Type`](https://ziglang.org/documentation/master/std/#std.builtin.Type)
(info on how to make use of imports and std later).

```zig
const expect = @import("std").testing.expect;fn addSmallInts(comptime T: type, a: T, b: T) T {    return switch (@typeInfo(T)) {        .comptime_int => a + b,        .int => |info| if (info.bits  @compileError("only ints accepted"),    };}test "typeinfo switch" {    const x = addSmallInts(u16, 20, 30);    try expect(@TypeOf(x) == u16);    try expect(x == 50);}
```

We can use the [`@Type`](https://ziglang.org/documentation/master/#Type)
function to create a type from a
[`@typeInfo`](https://ziglang.org/documentation/master/#typeInfo).
[`@Type`](https://ziglang.org/documentation/master/#Type) is implemented for
most types but is notably unimplemented for enums, unions, functions, and
structs.

Here anonymous struct syntax is used with `.{}`, because the `T` in `T{}` can be
inferred. Anonymous structs will be covered in detail later. In this example we
will get a compile error if the `Int` tag isn't set.

```zig
const expect = @import("std").testing.expect;fn GetBiggerInt(comptime T: type) type {    return @Type(.{        .int = .{            .bits = @typeInfo(T).int.bits + 1,            .signedness = @typeInfo(T).int.signedness,        },    });}test "@Type" {    try expect(GetBiggerInt(u8) == u9);    try expect(GetBiggerInt(i31) == i32);}
```

Returning a struct type is how you make generic data structures in Zig. The
usage of [`@This`](https://ziglang.org/documentation/master/#This) is required
here, which gets the type of the innermost struct, union, or enum. Here
[`std.mem.eql`](https://ziglang.org/documentation/master/std/#std;mem.eql) is
also used which compares two slices.

```zig
const expect = @import("std").testing.expect;fn Vec(    comptime count: comptime_int,    comptime T: type,) type {    return struct {        data: [count]T,        const Self = @This();        fn abs(self: Self) Self {            var tmp = Self{ .data = undefined };            for (self.data, 0..) |elem, i| {                tmp.data[i] = if (elem 
The types of function parameters can also be inferred by using `anytype` in
place of a type. [`@TypeOf`](https://ziglang.org/documentation/master/#TypeOf)
can then be used on the parameter.

```zig
const expect = @import("std").testing.expect;fn plusOne(x: anytype) @TypeOf(x) {    return x + 1;}test "inferred function parameter" {    try expect(plusOne(@as(u32, 1)) == 2);}
```

Comptime also introduces the operators `++` and `**` for concatenating and
repeating arrays and slices. These operators do not work at runtime.

```zig
const expect = @import("std").testing.expect;const eql = @import("std").mem.eql;test "++" {    const x: [4]u8 = undefined;    const y = x[0..];    const a: [6]u8 = undefined;    const b = a[0..];    const new = y ++ b;    try expect(new.len == 10);}test "**" {    const pattern = [_]u8{ 0xCC, 0xAA };    const memory = pattern ** 3;    try expect(eql(u8, &memory, &[_]u8{ 0xCC, 0xAA, 0xCC, 0xAA, 0xCC, 0xAA }));}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/24-comptime.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Payload Captures
Version: Zig 0.15.2# Payload Captures

Payload captures use the syntax `|value|` and appear in many places, some of
which we've seen already. Wherever they appear, they are used to "capture" the
value from something.

With if statements and optionals.

```zig
const expect = @import("std").testing.expect;test "optional-if" {    const maybe_num: ?usize = 10;    if (maybe_num) |n| {        try expect(@TypeOf(n) == usize);        try expect(n == 10);    } else {        unreachable;    }}
```

With if statements and error unions. The else with the error capture is required
here.

```zig
const expect = @import("std").testing.expect;test "error union if" {    const ent_num: error{UnknownEntity}!u32 = 5;    if (ent_num) |entity| {        try expect(@TypeOf(entity) == u32);        try expect(entity == 5);    } else |err| {        _ = err catch {};        unreachable;    }}
```

With while loops and optionals. This may have an else block.

```zig
const expect = @import("std").testing.expect;test "while optional" {    const sequence = [_]?u8{ 0xFF, 0xCC, 0x00, null };    var i: usize = 0;    while (sequence[i]) |num| : (i += 1) {        try expect(@TypeOf(num) == u8);    }    try expect(i == 3);    try expect(sequence[i] == null);}
```

With while loops and error unions. The else with the error capture is required
here.

```zig
const expect = @import("std").testing.expect;var numbers_left2: u32 = undefined;fn eventuallyErrorSequence() !u32 {    return if (numbers_left2 == 0) error.ReachedZero else blk: {        numbers_left2 -= 1;        break :blk numbers_left2;    };}test "while error union capture" {    var sum: u32 = 0;    numbers_left2 = 3;    while (eventuallyErrorSequence()) |value| {        sum += value;    } else |err| {        try expect(err == error.ReachedZero);    }}
```

For loops.

```zig
const expect = @import("std").testing.expect;test "for capture" {    const x = [_]i8{ 1, 5, 120, -5 };    for (x) |v| try expect(@TypeOf(v) == i8);}
```

Switch cases on tagged unions.

```zig
const expect = @import("std").testing.expect;const Info = union(enum) {    a: u32,    b: []const u8,    c,    d: u32,};test "switch capture" {    const b: Info = .{ .a = 10 };    const x = switch (b) {        .b => |str| blk: {            try expect(@TypeOf(str) == []const u8);            break :blk 1;        },        .c => 2,        //if these are of the same type, they        //may be inside the same capture group        .a, .d => |num| blk: {            try expect(@TypeOf(num) == u32);            break :blk num * 2;        },    };    try expect(x == 20);}
```

As we saw in the Union and Optional sections above, values captured with the
`|val|` syntax are immutable (similar to function arguments), but we can use
pointer capture to modify the original values. This captures the values as
pointers that are themselves still immutable, but because the value is now a
pointer, we can modify the original value by dereferencing it:

```zig
const expect = @import("std").testing.expect;const eql = @import("std").mem.eql;test "for with pointer capture" {    var data = [_]u8{ 1, 2, 3 };    for (&data) |*byte| byte.* += 1;    try expect(eql(u8, &data, &[_]u8{ 2, 3, 4 }));}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/25-payload-captures.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Inline Loops
Version: Zig 0.15.2# Inline Loops

`inline` loops are unrolled, and allow some things to happen that only work at
compile time. Here we use a
[`for`](https://ziglang.org/documentation/master/#inline-for), but a
[`while`](https://ziglang.org/documentation/master/#inline-while) works
similarly.

```zig
test "inline for" {    const types = [_]type{ i32, f32, u8, bool };    var sum: usize = 0;    inline for (types) |T| sum += @sizeOf(T);    try expect(sum == 10);}
```

Using these for performance reasons is inadvisable unless you've tested that
explicitly unrolling is faster; the compiler tends to make better decisions here
than you.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/26-inline-loops.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Opaque
Version: Zig 0.15.2# Opaque

[`opaque`](https://ziglang.org/documentation/master/#opaque) types in Zig have
an unknown (albeit non-zero) size and alignment. Because of this these data
types cannot be stored directly. These are used to maintain type safety with
pointers to types that we don't have information about.

```zig
const Window = opaque {};const Button = opaque {};extern fn show_window(*Window) callconv(.C) void;test "opaque" {    var main_window: *Window = undefined;    show_window(main_window);    var ok_button: *Button = undefined;    show_window(ok_button);}
```

```zig
./test-c1.zig:653:17: error: expected type '*Window', found '*Button'    show_window(ok_button);                ^./test-c1.zig:653:17: note: pointer type child 'Button' cannot cast into pointer type child 'Window'    show_window(ok_button);                ^
```

Opaque types may have declarations in their definitions (the same as structs,
enums and unions).

```zig
const Window = opaque {    fn show(self: *Window) void {        show_window(self);    }};extern fn show_window(*Window) callconv(.C) void;test "opaque with declarations" {    var main_window: *Window = undefined;    main_window.show();}
```

The typical usecase of opaque is to maintain type safety when interoperating
with C code that does not expose complete type information.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/27-opaque.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Anonymous Structs
Version: Zig 0.15.2# Anonymous Structs

The struct type may be omitted from a struct literal. These literals may coerce
to other struct types.

```zig
const expect = @import("std").testing.expect;test "anonymous struct literal" {    const Point = struct { x: i32, y: i32 };    const pt: Point = .{        .x = 13,        .y = 67,    };    try expect(pt.x == 13);    try expect(pt.y == 67);}
```

Anonymous structs may be completely anonymous i.e. without being coerced to
another struct type.

```zig
const expect = @import("std").testing.expect;test "fully anonymous struct" {    try dump(.{        .int = @as(u32, 1234),        .float = @as(f64, 12.34),        .b = true,        .s = "hi",    });}fn dump(args: anytype) !void {    try expect(args.int == 1234);    try expect(args.float == 12.34);    try expect(args.b);    try expect(args.s[0] == 'h');    try expect(args.s[1] == 'i');}
```

Anonymous structs without field names may be created and are referred to as
**tuples**. These have many of the properties that arrays do; tuples can be
iterated over, indexed, can be used with the `++` and `**` operators, and have a
len field. Internally, these have numbered field names starting at `"0"`, which
may be accessed with the special syntax `@"0"` which acts as an escape for the
syntax - things inside `@""` are always recognised as identifiers.

An `inline` loop must be used to iterate over the tuple here, as the type of
each tuple field may differ.

```zig
const expect = @import("std").testing.expect;test "tuple" {    const values = .{        @as(u32, 1234),        @as(f64, 12.34),        true,        "hi",    } ++ .{false} ** 2;    try expect(values[0] == 1234);    try expect(values[4] == false);    inline for (values, 0..) |v, i| {        if (i != 2) continue;        try expect(v);    }    try expect(values.len == 6);    try expect(values.@"3"[0] == 'h');}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/28-anonymous-structs.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Sentinel Termination
Version: Zig 0.15.2# Sentinel Termination

Arrays, slices and many pointers may be terminated by a value of their child
type. This is known as sentinel termination. These follow the syntax `[N:t]T`,
`[:t]T`, and `[*:t]T`, where `t` is a value of the child type `T`.

An example of a sentinel terminated array. The built-in
[`@ptrCast`](https://ziglang.org/documentation/master/#ptrCast) is used to
perform an unsafe type conversion. This shows us that the last element of the
array is followed by a 0 byte.

```zig
const expect = @import("std").testing.expect;test "sentinel termination" {    const terminated = [3:0]u8{ 3, 2, 1 };    try expect(terminated.len == 3);    try expect(@as(*const [4]u8, @ptrCast(&terminated))[3] == 0);}
```

The types of string literals is `*const [N:0]u8`, where N is the length of the
string. This allows string literals to coerce to sentinel terminated slices, and
sentinel terminated many pointers. Note: string literals are UTF-8 encoded.

```zig
const expect = @import("std").testing.expect;test "string literal" {    try expect(@TypeOf("hello") == *const [5:0]u8);}
```

`[*:0]u8` and `[*:0]const u8` perfectly model C's strings.

```zig
const expect = @import("std").testing.expect;test "C string" {    const c_string: [*:0]const u8 = "hello";    var array: [5]u8 = undefined;    var i: usize = 0;    while (c_string[i] != 0) : (i += 1) {        array[i] = c_string[i];    }}
```

Sentinel terminated types coerce to their non-sentinel-terminated counterparts.

```zig
const expect = @import("std").testing.expect;test "coercion" {    const a: [*:0]u8 = undefined;    const b: [*]u8 = a;    const c: [5:0]u8 = undefined;    const d: [5]u8 = c;    const e: [:0]f32 = undefined;    const f: []f32 = e;    _ = .{ b, d, f }; //ignore unused}
```

Sentinel terminated slicing is provided which can be used to create a sentinel
terminated slice with the syntax `x[n..m:t]`, where `t` is the terminator value.
Doing this is an assertion from the programmer that the memory is terminated
where it should be - getting this wrong is detectable illegal behaviour.

```zig
const expect = @import("std").testing.expect;test "sentinel terminated slicing" {    var x = [_:0]u8{255} ** 3;    const y = x[0..3 :0];    _ = y;}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/29-sentinel-termination.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Vectors
Version: Zig 0.15.2# Vectors

Zig provides vector types for SIMD. These are not to be conflated with vectors
in a mathematical sense, or vectors like C++'s std::vector (for this, see
"Arraylist" in chapter 2). Vectors may be created using the
[`@Type`](https://ziglang.org/documentation/master/#Type) built-in we used
earlier, and
[`std.meta.Vector`](https://ziglang.org/documentation/master/std/#std;meta.Vector)
provides a shorthand for this.

Vectors can only have child types of booleans, integers, floats and pointers.

Operations between vectors with the same child type and length can take place.
These operations are performed on each of the values in the
vector.[`std.meta.eql`](https://ziglang.org/documentation/master/std/#std;meta.eql)
is used here to check for equality between two vectors (also useful for other
types like structs).

```zig
const expect = @import("std").testing.expect;const meta = @import("std").meta;test "vector add" {    const x: @Vector(4, f32) = .{ 1, -10, 20, -1 };    const y: @Vector(4, f32) = .{ 2, 10, 0, 1 };    const z = x + y;    try expect(meta.eql(z, @Vector(4, f32){ 3, 0, 20, 0 }));}
```

Vectors are indexable.

```zig
const expect = @import("std").testing.expect;test "vector indexing" {    const x: @Vector(4, u8) = .{ 255, 0, 255, 0 };    try expect(x[0] == 255);}
```

The built-in function
[`@splat`](https://ziglang.org/documentation/master/#splat) may be used to
construct a vector where all of the values are the same. Here we use it to
multiply a vector by a scalar.

```zig
const expect = @import("std").testing.expect;const meta = @import("std").meta;test "vector * scalar" {    const x: @Vector(3, f32) = .{ 12.5, 37.5, 2.5 };    const y = x * @as(@Vector(3, f32), @splat(2));    try expect(meta.eql(y, @Vector(3, f32){ 25, 75, 5 }));}
```

Vectors do not have a `len` field like arrays, but may still be looped over.

```zig
const expect = @import("std").testing.expect;test "vector looping" {    const x = @Vector(4, u8){ 255, 0, 255, 0 };    const sum = blk: {        var tmp: u10 = 0;        var i: u8 = 0;        while (i 
Vectors coerce to their respective arrays.

```zig
const expect = @import("std").testing.expect;const arr: [4]f32 = @Vector(4, f32){ 1, 2, 3, 4 };
```

It is worth noting that using explicit vectors may result in slower software if
you do not make the right decisions - the compiler's auto-vectorisation is
fairly smart as-is.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/30-vectors.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Language
- Imports
Version: Zig 0.15.2# Imports

The built-in function
[`@import`](https://ziglang.org/documentation/master/#import) takes in a file,
and gives you a struct type based on that file. All declarations labelled as
`pub` (for public) will end up in this struct type, ready for use.

`@import("std")` is a special case in the compiler, and gives you access to the
standard library. Other
[`@import`](https://ziglang.org/documentation/master/#import)s will take in a
file path, or a package name (more on packages in a later chapter).

We will explore more of the standard library in later chapters.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/01-language-basics/31-imports.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Allocators
Version: Zig 0.15.2# Allocators

The Zig standard library provides a pattern for allocating memory, which allows
the programmer to choose precisely how memory allocations are done within the
standard library - no allocations happen behind your back in the standard
library.

The most fundamental allocator is
[`std.heap.page_allocator`](https://ziglang.org/documentation/master/std/#std.heap.page_allocator).
Whenever this allocator makes an allocation, it will ask your OS for entire
pages of memory; an allocation of a single byte will likely reserve multiple
kibibytes. As asking the OS for memory requires a system call, this is also
extremely inefficient for speed.

Here, we allocate 100 bytes as a `[]u8`. Notice how defer is used in conjunction
with a free - this is a common pattern for memory management in Zig.

```zig
const std = @import("std");const expect = std.testing.expect;test "allocation" {    const allocator = std.heap.page_allocator;    const memory = try allocator.alloc(u8, 100);    defer allocator.free(memory);    try expect(memory.len == 100);    try expect(@TypeOf(memory) == []u8);}
```

The
[`std.heap.FixedBufferAllocator`](https://ziglang.org/documentation/master/std/#std.heap.FixedBufferAllocator)
is an allocator that allocates memory into a fixed buffer and does not make any
heap allocations. This is useful when heap usage is not wanted, for example,
when writing a kernel. It may also be considered for performance reasons. It
will give you the error `OutOfMemory` if it has run out of bytes.

```zig
const std = @import("std");const expect = std.testing.expect;test "fixed buffer allocator" {    var buffer: [1000]u8 = undefined;    var fba: std.heap.FixedBufferAllocator = .init(&buffer);    const allocator = fba.allocator();    const memory = try allocator.alloc(u8, 100);    defer allocator.free(memory);    try expect(memory.len == 100);    try expect(@TypeOf(memory) == []u8);}
```

[`std.heap.ArenaAllocator`](https://ziglang.org/documentation/master/std/#std.heap.ArenaAllocator)
takes in a child allocator and allows you to allocate many times and only free
once. Here, `.deinit()` is called on the arena, which frees all memory. Using
`allocator.free` in this example would be a no-op (i.e. does nothing).

```zig
const std = @import("std");const expect = std.testing.expect;test "arena allocator" {    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);    defer arena.deinit();    const allocator = arena.allocator();    _ = try allocator.alloc(u8, 1);    _ = try allocator.alloc(u8, 10);    _ = try allocator.alloc(u8, 100);}
```

`alloc` and `free` are used for slices. For single items, consider using
`create` and `destroy`.

```zig
const std = @import("std");const expect = std.testing.expect;test "allocator create/destroy" {    const byte = try std.heap.page_allocator.create(u8);    defer std.heap.page_allocator.destroy(byte);    byte.* = 128;}
```

The Zig standard library also has a general-purpose debug allocator. This is a safe
allocator that can prevent double-free, use-after-free and can detect leaks.
Safety checks and thread safety can be turned off via its configuration struct
(left empty below). Zig's DebugAllocator is designed for safety over performance, but may
still be many times faster than page_allocator.

```zig
const std = @import("std");const expect = std.testing.expect;test "DebugAllocator" {    var gpa: std.heap.DebugAllocator(.{}) = .init;    const allocator = gpa.allocator();    defer {        const deinit_status = gpa.deinit();        //fail test; can't try in defer as defer is executed after we return        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");    }    const bytes = try allocator.alloc(u8, 100);    defer allocator.free(bytes);}
```

For high performance (but very few safety features!), the Zig standard library offers
[`std.heap.SmpAllocator`](https://ziglang.org/documentation/master/std/#std.heap.SmpAllocator).
This is a general-purpose allocator designed for [maximum performance](https://ziglang.org/download/0.14.0/release-notes.html#SmpAllocator)
on multithreaded machines.

```zig
const std = @import("std");const expect = std.testing.expect;test "SmpAllocator" {    const allocator = std.heap.smp_allocator;    const bytes = try allocator.alloc(u8, 100);    defer allocator.free(bytes);}
```

As an alternative when SmpAllocator is not available or desired, the libc allocator
[`std.heap.c_allocator`](https://ziglang.org/documentation/master/std/#std.heap.c_allocator) may be considered.
This, however, has the disadvantage of requiring linking Libc, which can be done with `-lc`.

Benjamin Feng's talk
[What's a Memory Allocator Anyway?](https://www.youtube.com/watch?v=vHWiDx_l4V0)
goes into more detail on this topic, and covers the implementation of
allocators.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/01-allocators.mdx)Last updated on **Jan 4, 2026** by **kibels**

---

- 
- Standard Library
- ArrayList
Version: Zig 0.15.2# ArrayList

The
[`std.ArrayList`](https://ziglang.org/documentation/master/std/#std.ArrayList)
is commonly used throughout Zig, and serves as a buffer that can change in
size. `std.ArrayList(T)` is similar to C++'s `std::vector` and Rust's
`Vec`. The `deinit()` method frees all of the ArrayList's memory. The memory
can be read from and written to via its slice field - `.items`.

Here we will introduce the usage of the testing allocator. This is a special
allocator that only works in tests and can detect memory leaks. In your code,
use whatever allocator is appropriate.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const ArrayList = std.ArrayList;const allocator = std.testing.allocator;test "arraylist" {    var list: ArrayList(u8) = .empty;    defer list.deinit(allocator);    try list.append(allocator, 'H');    try list.append(allocator, 'e');    try list.append(allocator, 'l');    try list.append(allocator, 'l');    try list.append(allocator, 'o');    try list.appendSlice(allocator, " World!");    try expect(eql(u8, list.items, "Hello World!"));}
```

Coming from C++?▼Zig's `std.ArrayList` is very comparable to C++'s `std::vector`.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/02-arraylist.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Filesystem
Version: Zig 0.15.2# Filesystem

Let's create and open a file in our current working directory, write to it, and
then read from it. Here we have to use `.seekTo` to go back to the start of the
file before reading what we have written.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;test "createFile, write, seekTo, read" {    const file = try std.fs.cwd().createFile(        "junk_file.txt",        .{ .read = true },    );    defer file.close();    try file.writeAll("Hello File!");    var buffer: [100]u8 = undefined;    try file.seekTo(0);    const bytes_read = try file.readAll(&buffer);    try expect(eql(u8, buffer[0..bytes_read], "Hello File!"));}
```

The functions
[`std.fs.openFileAbsolute`](https://ziglang.org/documentation/master/std/#std.fs.openFileAbsolute)
and similar absolute functions exist, but we will not test them here.

We can get various information about files by using `.stat()` on them. `Stat`
also contains fields for .inode and .mode, but they are not tested here as they
rely on the current OS' types.

When the Enum type is known from context, it can be omitted, so we can
compare `stat.kind` to `.file` instead of `Kind.file`.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;test "file stat" {    const file = try std.fs.cwd().createFile(        "junk_file2.txt",        .{ .read = true },    );    defer file.close();    const stat = try file.stat();    try expect(stat.size == 0);    try expect(stat.kind == .file);    try expect(stat.ctime 
We can make directories and iterate over their contents. Here we will use an
iterator (discussed later). This directory (and its contents) will be deleted
after this test finishes.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;test "make dir" {    try std.fs.cwd().makeDir("test-tmp");    var iter_dir = try std.fs.cwd().openDir(        "test-tmp",        .{ .iterate = true },    );    defer {        iter_dir.close();        std.fs.cwd().deleteTree("test-tmp") catch unreachable;    }    _ = try iter_dir.createFile("x", .{});    _ = try iter_dir.createFile("y", .{});    _ = try iter_dir.createFile("z", .{});    var file_count: usize = 0;    var iter = iter_dir.iterate();    while (try iter.next()) |entry| {        if (entry.kind == .file) file_count += 1;    }    try expect(file_count == 3);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/03-filesystem.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Readers and Writers
Version: Zig 0.15.2# Readers and Writers

[`std.io.Writer`](https://ziglang.org/documentation/master/std/#std.io.Writer)
and
[`std.io.Reader`](https://ziglang.org/documentation/master/std/#std.io.Reader)
provide standard ways of making use of IO. `std.ArrayList(u8)` has a `writer`
method which gives us a writer. Let's use it.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const ArrayList = std.ArrayList;const allocator = std.testing.allocator;test "io writer usage" {    var list: ArrayList(u8) = .empty;    defer list.deinit(allocator);    try list.print(allocator, "Hello {s}!", .{"World"});    try expect(eql(u8, list.items, "Hello World!"));}
```

Here we will use a reader to copy the file's contents into an allocated buffer.
The second argument of
[`readAllAlloc`](https://ziglang.org/documentation/master/std/#std.io.Reader.readAllAlloc)
is the maximum size that it may allocate; if the file is larger than this, it
will return `error.StreamTooLong`.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;test "io reader usage" {    const message = "Hello File!";    const file = try std.fs.cwd().createFile(        "junk_file2.txt",        .{ .read = true },    );    defer file.close();    try file.writeAll(message);    try file.seekTo(0);    var file_buffer: [1024]u8 = undefined;    var file_reader = file.reader(&file_buffer);    const contents = try file_reader.interface.readAlloc(        test_allocator,        message.len,    );    defer test_allocator.free(contents);    try expect(eql(u8, contents, message));}
```

A common usecase for readers is to read until the next line (e.g. for user
input). Here we will do this with the
[`std.fs.File.stdin()`](https://ziglang.org/documentation/0.15.2/std/#std.fs.File.stdin)
file.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;test "read until next line" {    var stdout_buf: [1024]u8 = undefined;    var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);    const stdout: *std.io.Writer = &stdout_writer.interface;    var stdin_buf: [1024]u8 = undefined;    var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);    const stdin: *std.io.Reader = &stdin_reader.interface;    try stdout.writeAll("Enter your name\n");    try stdout.flush();    const bare_line = try stdin.takeDelimiter('\n') orelse unreachable;    const line = std.mem.trim(u8, bare_line, "\r");    try stdout.print("Your name is: \"{s}\"\n", .{line});    try stdout.flush();}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/04-readers-and-writers.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Formatting
Version: Zig 0.15.2# Formatting

[`std.fmt`](https://ziglang.org/documentation/master/std/#std.fmt) provides
ways to format data to and from strings.

A basic example of creating a formatted string. The format string must be
compile-time known. The `d` here denotes that we want a decimal number.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;test "fmt" {    const string = try std.fmt.allocPrint(        test_allocator,        "{d} + {d} = {d}",        .{ 9, 10, 19 },    );    defer test_allocator.free(string);    try expect(eql(u8, string, "9 + 10 = 19"));}
```

Writers conveniently have a `print` method, which works similarly.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const allocator = std.testing.allocator;test "print" {    var list: std.ArrayList(u8) = .empty;    defer list.deinit(allocator);    try list.print(        allocator,        "{} + {} = {}",        .{ 9, 10, 19 },    );    try expect(eql(u8, list.items, "9 + 10 = 19"));}
```

Take a moment to appreciate that you now know from top to bottom how printing
Hello World works.
[`std.debug.print`](https://ziglang.org/documentation/master/std/#std.debug.print)
works the same, except it writes to stderr and is protected by a mutex.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;test "hello world" {    const out_file = std.io.getStdOut();    try out_file.writer().print(        "Hello, {s}!\n",        .{"World"},    );}
```

We have used the `{s}` format specifier up until this point to print strings.
Here, we will use `{any}`, which gives us the default formatting.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;test "array printing" {    const string = try std.fmt.allocPrint(        test_allocator,        "{any} + {any} = {any}",        .{            @as([]const u8, &[_]u8{ 1, 4 }),            @as([]const u8, &[_]u8{ 2, 5 }),            @as([]const u8, &[_]u8{ 3, 9 }),        },    );    defer test_allocator.free(string);    try expect(eql(        u8,        string,        "{ 1, 4 } + { 2, 5 } = { 3, 9 }",    ));}
```

Let's create a type with custom formatting by giving it a `format` function.
This function must be marked as `pub` so that std.fmt can access it (more on
packages later). You may notice the usage of `{s}` instead of `{}` - this is the
format specifier for strings (more on format specifiers later). This is used
here as `{}` defaults to array printing over string printing.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;const Person = struct {    name: []const u8,    birth_year: i32,    death_year: ?i32,    pub fn format(        self: Person,        writer: *std.io.Writer,    ) !void {        try writer.print("{s} ({}-", .{            self.name, self.birth_year,        });        if (self.death_year) |year| {            try writer.print("{}", .{year});        }        try writer.writeAll(")");    }};test "custom fmt" {    const john: Person = .{        .name = "John Carmack",        .birth_year = 1970,        .death_year = null,    };    const john_string = try std.fmt.allocPrint(        test_allocator,        "{f}",        .{john},    );    defer test_allocator.free(john_string);    try expect(eql(        u8,        john_string,        "John Carmack (1970-)",    ));    const claude: Person = .{        .name = "Claude Shannon",        .birth_year = 1916,        .death_year = 2001,    };    const claude_string = try std.fmt.allocPrint(        test_allocator,        "{f}",        .{claude},    );    defer test_allocator.free(claude_string);    try expect(eql(        u8,        claude_string,        "Claude Shannon (1916-2001)",    ));}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/05-formatting.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- JSON
Version: Zig 0.15.2# JSON

Let's parse a JSON string into a struct type, using the streaming parser.

```zig
const std = @import("std");const expect = std.testing.expect;const test_allocator = std.testing.allocator;const Place = struct { lat: f32, long: f32 };test "json parse" {    const parsed = try std.json.parseFromSlice(        Place,        test_allocator,        \\{ "lat": 40.684540, "long": -74.401422 }    ,        .{},    );    defer parsed.deinit();    const place = parsed.value;    try expect(place.lat == 40.684540);    try expect(place.long == -74.401422);}
```

And using stringify to turn arbitrary data into a string.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;const Place = struct { lat: f32, long: f32 };test "json stringify" {    const x: Place = .{        .lat = 51.997664,        .long = -0.740687,    };    var string: std.io.Writer.Allocating = .init(test_allocator);    defer string.deinit();    try string.writer.print("{f}", .{std.json.fmt(x, .{})});    try std.testing.expectEqualStrings(        \\{"lat":51.99766540527344,"long":-0.7406870126724243}    , string.written());}
```

The JSON parser requires an allocator for JavaScript's string, array, and map
types.

```zig
const std = @import("std");const expect = std.testing.expect;const eql = std.mem.eql;const test_allocator = std.testing.allocator;test "json parse with strings" {    const User = struct { name: []u8, age: u16 };    const parsed = try std.json.parseFromSlice(User, test_allocator,        \\{ "name": "Joe", "age": 25 }    , .{});    defer parsed.deinit();    const user = parsed.value;    try expect(eql(u8, user.name, "Joe"));    try expect(user.age == 25);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/06-json.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Random Numbers
Version: Zig 0.15.2# Random Numbers

Here, we create a new prng using a 64-bit random seed. a, b, c, and d are given
random values via this prng. The expressions giving c and d values are
equivalent. `DefaultPrng` is `Xoroshiro128`; there are other prngs available in
`std.Random`.

```zig
const std = @import("std");test "random numbers" {    var prng: std.Random.DefaultPrng = .init(blk: {        var seed: u64 = undefined;        try std.posix.getrandom(std.mem.asBytes(&seed));        break :blk seed;    });    const rand = prng.random();    const a = rand.float(f32);    const b = rand.boolean();    const c = rand.int(u8);    const d = rand.intRangeAtMost(u8, 0, 255);    //suppress unused constant compile error    _ = .{ a, b, c, d };}
```

Cryptographically secure random is also available.

```zig
const std = @import("std");test "crypto random numbers" {    const rand = std.crypto.random;    const a = rand.float(f32);    const b = rand.boolean();    const c = rand.int(u8);    const d = rand.intRangeAtMost(u8, 0, 255);    //suppress unused constant compile error    _ = .{ a, b, c, d };}
```

infoWe can now use our knowledge of `std.Random` and [make a guessing game together](https://zig.guide/posts/a-guessing-game).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/07-random-numbers.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Crypto
Version: Zig 0.15.2# Crypto

[`std.crypto`](https://ziglang.org/documentation/master/std/#std.crypto)
includes many cryptographic utilities, including:

- AES (Aes128, Aes256)

- Diffie-Hellman key exchange (x25519)

- Elliptic-curve arithmetic (curve25519, edwards25519, ristretto255)

- Crypto secure hashing (blake2, Blake3, Gimli, Md5, sha1, sha2, sha3)

- MAC functions (Ghash, Poly1305)

- Stream ciphers (ChaCha20IETF, ChaCha20With64BitNonce, XChaCha20IETF, Salsa20,
XSalsa20)

This list is inexhaustive. For more in-depth information, try
[A tour of std.crypto in Zig 0.7.0 - Frank Denis](https://www.youtube.com/watch?v=9t6Y7KoCvyk).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/08-crypto.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Threads
Version: Zig 0.15.2# Threads

While Zig provides more advanced ways of writing concurrent and parallel code,
[`std.Thread`](https://ziglang.org/documentation/master/std/#std.Thread) is
available for making use of OS threads. Let's make use of an OS thread.

```zig
fn ticker(step: u8) void {    while (true) {        std.time.sleep(1 * std.time.ns_per_s);        tick += @as(isize, step);    }}var tick: isize = 0;test "threading" {    var thread = try std.Thread.spawn(.{}, ticker, .{@as(u8, 1)});    _ = thread;    try expect(tick == 0);    std.time.sleep(3 * std.time.ns_per_s / 2);    try expect(tick == 1);}
```

Threads, however, aren't particularly useful without strategies for thread
safety.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/09-threads.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Hash Maps
Version: Zig 0.15.2# Hash Maps

The standard library provides
[`std.AutoHashMap`](https://ziglang.org/documentation/master/std/#std.AutoHashMap),
which lets you easily create a hash map type from a key type and a value type.
These must be initiated with an allocator.

Let's put some values in a hash map.

```zig
test "hashing" {    const Point = struct { x: i32, y: i32 };    var map: std.AutoHashMap(u32, Point) = .init(test_allocator);    defer map.deinit();    try map.put(1525, .{ .x = 1, .y = -4 });    try map.put(1550, .{ .x = 2, .y = -3 });    try map.put(1575, .{ .x = 3, .y = -2 });    try map.put(1600, .{ .x = 4, .y = -1 });    try expect(map.count() == 4);    var sum = Point{ .x = 0, .y = 0 };    var iterator = map.iterator();    while (iterator.next()) |entry| {        sum.x += entry.value_ptr.x;        sum.y += entry.value_ptr.y;    }    try expect(sum.x == 10);    try expect(sum.y == -10);}
```

`.fetchPut` puts a value in the hash map, returning a value if there was
previously a value for that key.

```zig
test "fetchPut" {    var map: std.AutoHashMap(u8, f32) = .init(test_allocator);    defer map.deinit();    try map.put(255, 10);    const old = try map.fetchPut(255, 100);    try expect(old.?.value == 10);    try expect(map.get(255).? == 100);}
```

[`std.StringHashMap`](https://ziglang.org/documentation/master/std/#std.StringHashMap)
is also provided for when you need strings as keys.

```zig
test "string hashmap" {    var map: std.StringHashMap(enum { cool, uncool }) = .init(test_allocator);    defer map.deinit();    try map.put("loris", .uncool);    try map.put("me", .cool);    try expect(map.get("me").? == .cool);    try expect(map.get("loris").? == .uncool);}
```

[`std.StringHashMap`](https://ziglang.org/documentation/master/std/#std.StringHashMap)
and
[`std.AutoHashMap`](https://ziglang.org/documentation/master/std/#std.AutoHashMap)
are just wrappers for
[`std.HashMap`](https://ziglang.org/documentation/master/std/#std.HashMap). If
these two do not fulfil your needs, using
[`std.HashMap`](https://ziglang.org/documentation/master/std/#std.HashMap)
directly gives you much more control.

If having your elements backed by an array is wanted behaviour, try
[`std.ArrayHashMap`](https://ziglang.org/documentation/master/std/#std.ArrayHashMap)
and its wrapper
[`std.AutoArrayHashMap`](https://ziglang.org/documentation/master/std/#std.AutoArrayHashMap).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/10-hashmaps.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Stacks
Version: Zig 0.15.2# Stacks

[`std.ArrayList`](https://ziglang.org/documentation/master/std/#std.ArrayList)
provides the methods necessary to use it as a stack. Here's an example of
creating a list of matched brackets.

```zig
const std = @import("std");const eql = std.mem.eql;const expect = std.testing.expect;const test_allocator = std.testing.allocator;test "stack" {    const string = "(()())";    var stack: std.ArrayList(usize) = .empty;    defer stack.deinit(test_allocator);    const Pair = struct { open: usize, close: usize };    var pairs: std.ArrayList(Pair) = .empty;    defer pairs.deinit(test_allocator);    for (string, 0..) |char, i| {        if (char == '(') try stack.append(test_allocator, i);        if (char == ')')            try pairs.append(test_allocator, .{                .open = stack.pop() orelse                    @panic("mismatched brackets"),                .close = i,            });    }    const expected_pairs: []const Pair = &.{        .{ .open = 1, .close = 2 },        .{ .open = 3, .close = 4 },        .{ .open = 0, .close = 5 },    };    try std.testing.expectEqualDeep(expected_pairs, pairs.items);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/11-stacks.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Sorting
Version: Zig 0.15.2# Sorting

The standard library provides utilities for in-place sorting slices. Its basic
usage is as follows.

```zig
test "sorting" {    var data = [_]u8{ 10, 240, 0, 0, 10, 5 };    std.mem.sort(u8, &data, {}, comptime std.sort.asc(u8));    try expect(eql(u8, &data, &[_]u8{ 0, 0, 5, 10, 10, 240 }));    std.mem.sort(u8, &data, {}, comptime std.sort.desc(u8));    try expect(eql(u8, &data, &[_]u8{ 240, 10, 10, 5, 0, 0 }));}
```

[`std.sort.asc`](https://ziglang.org/documentation/master/std/#std.sort.asc)
and [`.desc`](https://ziglang.org/documentation/master/std/#std.sort.desc)
create a comparison function for the given type at comptime; if non-numerical
types should be sorted, the user must provide their own comparison function.

[`std.mem.sort`](https://ziglang.org/documentation/master/std/#std.mem.sort)
has a best case of O(n), and an average and worst case of O(n*log(n)).

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/12-sorting.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Iterators
Version: Zig 0.15.2# Iterators

It is a common idiom to have a struct type with a `next` function with an
optional in its return type, so that the function may return a null to indicate
that iteration is finished.

[`std.mem.SplitIterator`](https://ziglang.org/documentation/master/std/#std.mem.SplitIterator)
(and the subtly different
[`std.mem.TokenIterator`](https://ziglang.org/documentation/master/std/#std.mem.TokenIterator))
is an example of this pattern.

```zig
const std = @import("std");const eql = std.mem.eql;const expect = std.testing.expect;test "split iterator" {    const text = "robust, optimal, reusable, maintainable, ";    var iter = std.mem.splitSequence(u8, text, ", ");    try expect(eql(u8, iter.next().?, "robust"));    try expect(eql(u8, iter.next().?, "optimal"));    try expect(eql(u8, iter.next().?, "reusable"));    try expect(eql(u8, iter.next().?, "maintainable"));    try expect(eql(u8, iter.next().?, ""));    try expect(iter.next() == null);}
```

Some iterators have a `!?T` return type, as opposed to ?T. `!?T` requires that
we unpack the error union before the optional, meaning that the work done to get
to the next iteration may error. Here is an example of doing this with a loop.
[`cwd`](https://ziglang.org/documentation/master/std/#std;fs.cwd) has to be
opened with iterate permissions for the directory iterator to work.

```zig
const std = @import("std");const expect = std.testing.expect;test "iterator looping" {    var cwd = try std.fs.cwd().openDir(".", .{        .iterate = true,    });    defer cwd.close();    var file_count: usize = 0;    var iter = cwd.iterate();    while (try iter.next()) |entry| {        if (entry.kind == .file) file_count += 1;    }    try expect(file_count > 0);}
```

Here we will implement a custom iterator. This will iterate over a slice of
strings, yielding the strings which contain a given string.

```zig
const std = @import("std");const eql = std.mem.eql;const expect = std.testing.expect;const ContainsIterator = struct {    strings: []const []const u8,    needle: []const u8,    index: usize = 0,    fn next(self: *ContainsIterator) ?[]const u8 {        const index = self.index;        for (self.strings[index..]) |string| {            self.index += 1;            if (std.mem.indexOf(u8, string, self.needle)) |_| {                return string;            }        }        return null;    }};test "custom iterator" {    var iter = ContainsIterator{        .strings = &[_][]const u8{ "one", "two", "three" },        .needle = "e",    };    try expect(eql(u8, iter.next().?, "one"));    try expect(eql(u8, iter.next().?, "three"));    try expect(iter.next() == null);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/13-iterators.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Formatting specifiers
Version: Zig 0.15.2# Formatting specifiers

[`std.fmt`](https://ziglang.org/documentation/master/std/#std.fmt) provides
options for formatting various data types.

From here on, we'll be using `std.testing.expectEqualStrings`. This prints out
information if our strings aren't equal, and better conveys our intent over
using `std.testing.expect` and `std.mem.eql`. It's worth noting that the
"strings" we're operating on are just `[]const u8` values where we trust that
the buffer is valid UTF-8.

`std.fmt.fmtSliceHexLower` and `std.fmt.fmtSliceHexUpper` provide hex formatting
for strings as well as `{x}` and `{X}` for ints.

```zig
const std = @import("std");const eql = std.mem.eql;const expect = std.testing.expect;const bufPrint = std.fmt.bufPrint;const expectEqualStrings = std.testing.expectEqualStrings;test "hex" {    var b: [10]u8 = undefined;    try expectEqualStrings(        "FFFFFFFE",        try bufPrint(&b, "{X}", .{4294967294}),    );    try expectEqualStrings(        "fffffffe",        try bufPrint(&b, "{x}", .{4294967294}),    );    try expectEqualStrings(        "0xAAAAAAAA",        try bufPrint(&b, "0x{X}", .{2863311530}),    );    try expectEqualStrings(        "5a696721",        try bufPrint(&b, "{x}", .{"Zig!"}),    );}
```

`{d}` performs decimal formatting for numeric types.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "decimal float" {    var b: [4]u8 = undefined;    try expectEqualStrings(        "16.5",        try bufPrint(&b, "{d}", .{16.5}),    );}
```

`{c}` formats a byte into an ascii character.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "ascii fmt" {    var b: [1]u8 = undefined;    try expectEqualStrings(        "B",        try bufPrint(&b, "{c}", .{66}),    );}
```

`std.fmt.fmtIntSizeDec` and `std.fmt.fmtIntSizeBin` output memory sizes in
metric (1000) and power-of-two (1024) based notation.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "B Bi" {    var b: [32]u8 = undefined;    try expectEqualStrings("1B", try bufPrint(&b, "{B}", .{1}));    try expectEqualStrings("1B", try bufPrint(&b, "{Bi}", .{1}));    try expectEqualStrings("1.024kB", try bufPrint(&b, "{B}", .{1024}));    try expectEqualStrings("1KiB", try bufPrint(&b, "{Bi}", .{1024}));    try expectEqualStrings(        "1.073741824GB",        try bufPrint(&b, "{B}", .{1024 * 1024 * 1024}),    );    try expectEqualStrings(        "1GiB",        try bufPrint(&b, "{Bi}", .{1024 * 1024 * 1024}),    );}
```

`{b}` and `{o}` output integers in binary and octal format.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "binary, octal fmt" {    var b: [8]u8 = undefined;    try expectEqualStrings(        "11111110",        try bufPrint(&b, "{b}", .{254}),    );    try expectEqualStrings(        "376",        try bufPrint(&b, "{o}", .{254}),    );}
```

`{*}` performs pointer formatting, printing the address rather than the value.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "pointer fmt" {    var b: [16]u8 = undefined;    try expectEqualStrings(        "u8@deadbeef",        try bufPrint(&b, "{*}", .{@as(*u8, @ptrFromInt(0xDEADBEEF))}),    );}
```

`{e}` outputs floats in scientific notation.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "scientific" {    var b: [16]u8 = undefined;    try expectEqualStrings(        try bufPrint(&b, "{e}", .{3.14159}),        "3.14159e0",    );}
```

`{s}` outputs strings.

```zig
const std = @import("std");const eql = std.mem.eql;const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "string fmt" {    var b: [6]u8 = undefined;    const hello: [*:0]const u8 = "hello!";    try expectEqualStrings(        "hello!",        try bufPrint(&b, "{s}", .{hello}),    );}
```

This list is non-exhaustive.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/14-formatting-specifiers.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Standard Library
- Advanced Formatting
Version: Zig 0.15.2# Advanced Formatting

So far we have only covered formatting specifiers. Format strings actually
follow this format, where between each pair of square brackets is a parameter
you have to replace with something.

`{[position][specifier]:[fill][alignment][width].[precision]}`

NameMeaningPositionThe index of the argument that should be insertedSpecifierA type-dependent formatting optionFillA single character used for paddingAlignmentOne of three characters < ^ or >; these are for left, middle and right alignmentWidthThe total width of the field (characters)PrecisionHow many decimals a formatted number should have
Position usage.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "position" {    var b: [3]u8 = undefined;    try expectEqualStrings(        "aab",        try bufPrint(&b, "{0s}{0s}{1s}", .{ "a", "b" }),    );}
```

Fill, alignment and width being used.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "fill, alignment, width" {    var b: [6]u8 = undefined;    try expectEqualStrings(        "hi!  ",        try bufPrint(&b, "{s: 4}", .{"hi!"}),    );}
```

Using a specifier with precision.

```zig
const std = @import("std");const expectEqualStrings = std.testing.expectEqualStrings;const bufPrint = std.fmt.bufPrint;test "precision" {    var b: [4]u8 = undefined;    try expectEqualStrings(        "3.14",        try bufPrint(&b, "{d:.2}", .{3.14159}),    );}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/02-standard-library/15-advanced-formatting.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Build System
- Build Modes
Version: Zig 0.15.2# Build Modes

Zig provides four build modes, with debug being the default as it produces the
shortest compile times.

Runtime SafetyOptimizationsDebugYesNoReleaseSafeYesYes, SpeedReleaseSmallNoYes, SizeReleaseFastNoYes, Speed
These may be used with `zig run` and `zig test` with the arguments
`-O ReleaseSafe`, `-O ReleaseSmall`, and `-O ReleaseFast`.

Users are recommended to develop their software with runtime safety enabled,
despite its small speed disadvantage.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/03-build-system/01-build-modes.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Build System
- Emitting an Executable
Version: Zig 0.15.2# Emitting an Executable

The commands `zig build-exe`, `zig build-lib`, and `zig build-obj` can be used
to output executables, libraries, and objects, respectively. These commands take
in a source file and arguments.

Some common arguments:

- `-fsingle-threaded`, which asserts the binary is single-threaded. This will
turn thread-safety measures such as mutexes into no-ops.

- `-fstrip`, which removes debug info from the binary.

- `--dynamic`, which is used in conjunction with `zig build-lib` to output a
dynamic/shared library.

Let's create a tiny hello world. Save this as `tiny-hello.zig`, and run
`zig build-exe tiny-hello.zig -O ReleaseSmall -fstrip -fsingle-threaded`.

```zig
const std = @import("std");pub fn main() void {    std.io.getStdOut().writeAll(        "Hello World!",    ) catch unreachable;}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/03-build-system/02-emitting-an-executable.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Build System
- Cross-compilation
Version: Zig 0.15.2# Cross-compilation

By default, Zig will compile for your combination of CPU and OS. This can be
overridden by `-target`. Let's compile our tiny hello world to a 64-bit arm
Linux platform.

`zig build-exe .\tiny-hello.zig -O ReleaseSmall -fstrip -fsingle-threaded -target aarch64-linux`

[QEMU](https://www.qemu.org/) or similar may be used to conveniently test
executables made for foreign platforms.

Some CPU architectures that you can cross-compile for:

- `x86_64`

- `arm`

- `aarch64`

- `i386`

- `riscv64`

- `wasm32`

Some operating systems you can cross-compile for:

- `linux`

- `macos`

- `windows`

- `freebsd`

- `netbsd`

- `dragonfly`

- `UEFI`

Many other targets are available for compilation but aren't as well tested as
of now. See
[Zig's support table](https://ziglang.org/learn/overview/#wide-range-of-targets-supported)
for more information; the list of well-tested targets is slowly expanding.

As Zig compiles for your specific CPU by default, these binaries may not run on
other computers with slightly different CPU architectures. It may be useful to
instead specify a specific baseline CPU model for greater compatibility. Note:
Choosing an older CPU architecture will bring greater compatibility, but means
you also miss out on newer CPU instructions; there is an efficiency/speed versus
compatibility trade-off here.

Let's compile a binary for a sandybridge CPU (Intel x86_64, circa 2011), so we
can be reasonably sure that someone with an x86_64 CPU can run our binary. Here
we can use `native` in place of our CPU or OS, to use our system's.

`zig build-exe tiny-hello.zig -target x86_64-native -mcpu sandybridge`

Details on what architectures, OSes, CPUs, and ABIs (details on ABIs in the next
chapter) are available can be found by running `zig targets`. Note: the output
is long, and you may want to pipe it to a file, e.g.
`zig targets > targets.json`.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/03-build-system/03-cross-compilation.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Build System
- Zig Build
Version: Zig 0.15.2# Zig Build

The `zig build` system allows people to do more advanced things with their Zig
projects, including:

- Pulling in dependencies

- Building multiple artifacts (e.g. building both a static and a dynamic library)

- Providing additional configuration

- Doing custom tasks at build time

- Building with multiple steps (e.g. fetching and processing data before compiling)

The Zig build system allows you to fulfil these more complex use cases, without
bringing in any additional build tools or languages (e.g. cmake, python), all while making good
use of the compiler's in-built caching system.

# Hello Zig Build

Using the Zig build system requires writing some Zig code. Let's create a
directory structure as follows.

```zig
.├── build.zig└── src    └── main.zig
```

Defining a build function as shown below acts as our entry point to the build
system, which will allow us to define a graph of "steps" for the *build runner*
to perform. Place this code into `build.zig`.

```zig
const std = @import("std");pub fn build(b: *std.Build) void {    const exe = b.addExecutable(.{        .name = "hello",        .root_source_file = b.path("src/main.zig"),        .target = b.standardTargetOptions(.{}),        .optimize = b.standardOptimizeOption(.{}),    });    b.installArtifact(exe);}
```

Place your executable's entry point in `src/main.zig`.

```zig
const std = @import("std");pub fn main() void {    std.debug.print("Hello, {s}!\n", .{"Zig Build"});}
```

We can now run `zig build` which will output our executable.

```zig
$ zig build$ ./zig-out/bin/helloHello, Zig Build!
```

# Target & Optimisation Options

Previously, we've used `zig build-exe` with `-target` and `-O` to tell Zig what
target and optimisation mode to use. When using the Zig build system, these settings are
now passed into `b.addExecutable`.

Most Zig projects will want to use these standard options.

```zig
.target = b.standardTargetOptions(.{}),        .optimize = b.standardOptimizeOption(.{}),
```

When using `standardTargetOptions` and `standardOptimizeOption` your target will
default to native, meaning that the target of the executable will match the
computer that it was built on. The optimisation mode will default to debug.

If you run `zig build --help`, you can see that these functions have registered
project-specific build options.

```zig
Project-Specific Options:  -Dtarget=[string]            The CPU architecture, OS, and ABI to build for  -Dcpu=[string]               Target CPU features to add or subtract  -Doptimize=[enum]            Prioritize performance, safety, or binary size (-O flag)                                 Supported Values:                                   Debug                                   ReleaseSafe                                   ReleaseFast                                   ReleaseSmall
```

We can now supply them via arguments, e.g.

```zig
zig build -Dtarget=x86_64-windows -Dcpu=x86_64_v3 -Doptimize=ReleaseSafe
```

# Adding an Option

Thanks to the standard target and optimise options, we already have some useful
build options. In more advanced projects, you may want to add your own
project-specific options; here is a basic example of creating and using an option
that changes the executable's name.

```zig
const exe_name = b.option(        []const u8,        "exe_name",        "Name of the executable",    ) orelse "hello";    const exe = b.addExecutable(.{        .name = exe_name,        .root_source_file = b.path("src/main.zig"),        .target = b.standardTargetOptions(.{}),        .optimize = b.standardOptimizeOption(.{}),    });
```

If you now run `zig build --help`, we can see that the project-specific build
options have been expanded to include `exe_name`.

```zig
Project-Specific Options:  -Dexe_name=[string]          Name of the executable  -Dtarget=[string]            The CPU architecture, OS, and ABI to build for
```

```zig
$ zig build -Dtarget=x86_64-windows -Dexe_name="Hello!"$ file zig-out/bin/Hello\!.exezig-out/bin/Hello!.exe: PE32+ executable (console) x86-64, for MS Windows, 7 sections
```

# Adding a Run Step

We've previously used `zig run` as a convenient shortcut for calling `zig build-exe`
and then running the resulting binary. We can quite easily do something similar
using the Zig build system.

```zig
b.installArtifact(exe);    const run_exe = b.addRunArtifact(exe);    const run_step = b.step("run", "Run the application");    run_step.dependOn(&run_exe.step);
```

```zig
$ zig build runHello, Zig Build!
```

The Zig build system uses a DAG (directed acyclic graph) of steps that it runs
concurrently. Here we've created a step called "run", which depends on the
`run_exe` step, which depends on our compile step.

Let's have a look at the breakdown of steps in our build.

```zig
$ zig build run --summary allHello, Zig Build!Build Summary: 3/3 steps succeededrun success└─ run hello success 471us MaxRSS:3M   └─ zig build-exe hello Debug native success 881ms MaxRSS:220M
```

We will see more advanced build graphs as we progress.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/03-build-system/04-zig-build.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Build System
- Generating Documentation
Version: Zig 0.15.2# Generating Documentation

Zig's documentation generation makes use of *doc comments*, using `///`. These
doc comments will "attach" themselves to the declarations found under them.
File-level doc comments can also be made at the top of a file with `//!`.

The Zig compiler comes with documentation generation. This can be invoked by
adding `-femit-docs` to your `zig build-{exe, lib, obj}` or `zig run`command.
This documentation is saved into `./docs`, as a small static website.

Here we will save this file as `src/main.zig` and build documentation for it with
`zig build-lib -femit-docs src/main.zig`.

```zig
//! This module provides functions for dealing with spreadsheets.const std = @import("std");/// A spreadsheet positionpub const Pos = struct {    /// (0-indexed) row    x: u32,    /// (0-indexed) column    y: u32,    /// The top-left position    pub const zero: Pos = .{ .x = 0, .y = 0 };    /// Illegal position    pub const invalid_pos: Pos = .{        .x = std.math.maxInt(u32),        .y = std.math.maxInt(u32),    };};pub const OpenFileError = error{    /// Unexpected file extension    InvalidSheet,    FileNotFound,};pub const ParseError = error{    /// File header invalid    InvalidSheet,    InvalidPosition,};pub const OpenError = OpenFileError || ParseError;pub fn readCell(file: std.fs.File, pos: Pos) OpenError![]const u8 {    _ = file;    _ = pos;    @panic("todo");}
```

We should now have a folder called `docs/`. To view these docs nicely, you may
want to start a (local) static web server. Here's some commands you might be
able to use on your system without installing anything new:

- `caddy file-server --root docs/ --listen :8000`

- `python -m http.server 8000 -d docs/`

Take a few minutes to browse around. Notice that the left side of an error set
merge will take precedence over the right side, when it comes to differing doc
comments on the same error name. In our case this means that
`OpenError.InvalidSheet` will have the doc comment from
`OpenFileError.InvalidSheet`, rather than from `ParseError.InvalidSheet`.

The Zig compiler itself has the `zig std` command, which automatically serves a
web server with the standard library documentation, however as of writing this
server isn't exposed to the build system. The Zig standard library documentation
can also be found [here](https://ziglang.org/documentation/master/std/).

When using Zig Build, generated docs can be found by using `getEmittedDocs()` on
a Compile step. Here's an example of a `build.zig` that generates documentation:

```zig
const std = @import("std");pub fn build(b: *std.Build) void {    const target = b.standardTargetOptions(.{});    const optimize = b.standardOptimizeOption(.{});    const lib = b.addStaticLibrary(.{        .name = "lib",        .root_source_file = b.path("src/main.zig"),        .target = target,        .optimize = optimize,    });    b.installArtifact(lib);    const install_docs = b.addInstallDirectory(.{        .source_dir = lib.getEmittedDocs(),        .install_dir = .prefix,        .install_subdir = "docs",    });    const docs_step = b.step("docs", "Install docs into zig-out/docs");    docs_step.dependOn(&install_docs.step);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/03-build-system/06-generating-documentation.mdx)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- ABI
Version: Zig 0.15.2# ABI

An ABI *(application binary interface)* is a standard, pertaining to:

- The in-memory layout of types (i.e. a type's size, alignment, offsets, and the
layouts of its fields)

- The in-linker naming of symbols (e.g. name mangling)

- The calling conventions of functions (i.e. how a function call works at a
binary level)

By defining these rules and not breaking them, an ABI is said to be stable, and
this can be used to, for example, reliably link together multiple libraries,
executables, or objects which were compiled separately (potentially on different
machines or using different compilers). This allows for FFI *(foreign function
interface)* to take place, where we can share code between programming
languages.

Zig natively supports C ABIs for `extern` things; which C ABI is used depends on
the target you are compiling for (e.g. CPU architecture, operating system). This
allows for near-seamless interoperation with code that was not written in Zig;
the usage of C ABIs is standard amongst programming languages.

Zig internally does not use an ABI, meaning code should explicitly conform to a
C ABI where reproducible and defined binary-level behaviour is needed.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/01-abi.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- C Primitive Types
Version: Zig 0.15.2# C Primitive Types

Zig provides special `c_` prefixed types for conforming to the C ABI. These do
not have fixed sizes but rather change in size depending on the ABI being used.

TypeC EquivalentMinimum Size (bits)c_shortshort16c_ushortunsigned short16c_intint16c_uintunsigned int16c_longlong32c_ulongunsigned long32c_longlonglong long64c_ulonglongunsigned long long64c_longdoublelong doubleN/AanyopaquevoidN/A
Note: C's void (and Zig's `anyopaque`) has an unknown non-zero size. Zig's
`void` is a true zero-sized type.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/02-c-primitive-types.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Calling conventions
Version: Zig 0.15.2# Calling conventions

Calling conventions describe how functions are called. This includes how
arguments are supplied to the function (i.e. where they go - in registers or on
the stack, and how), and how the return value is received.

In Zig, the attribute `callconv` may be given to a function. The calling
conventions available may be found in
[std.builtin.CallingConvention](https://ziglang.org/documentation/master/std/#std.builtin.CallingConvention).
Here we make use of the cdecl calling convention.

```zig
fn add(a: u32, b: u32) callconv(.C) u32 {    return a + b;}
```

Marking your functions with the C calling convention is crucial when you're
calling Zig from C.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/03-calling-conventions.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Extern Structs
Version: Zig 0.15.2# Extern Structs

Normal structs in Zig do not have a defined layout; `extern` structs are
required for when you want the layout of your struct to match the layout of your
C ABI.

Let's create an extern struct. This test should be run with `x86_64` with a
`gnu` ABI, which can be done with `-target x86_64-native-gnu`.

```zig
const expect = @import("std").testing.expect;const Data = extern struct { a: i32, b: u8, c: f32, d: bool, e: bool };test "hmm" {    const x: Data = .{        .a = 10005,        .b = 42,        .c = -10.5,        .d = false,        .e = true,    };    const z = @as([*]const u8, @ptrCast(&x));    try expect(@as(*const i32, @ptrCast(@alignCast(z))).* == 10005);    try expect(@as(*const u8, @ptrCast(@alignCast(z + 4))).* == 42);    try expect(@as(*const f32, @ptrCast(@alignCast(z + 8))).* == -10.5);    try expect(@as(*const bool, @ptrCast(@alignCast(z + 12))).* == false);    try expect(@as(*const bool, @ptrCast(@alignCast(z + 13))).* == true);}
```

This is what the memory inside our `x` value looks like.

FieldaaaabccccdeBytes152700002A000000000028C100010000
Note how there are gaps in the middle and at the end - this is called "padding".
The data in this padding is undefined memory, and won't always be zero.

As our `x` value is that of an extern struct, we could safely pass it into a C
function expecting a `Data`, providing the C function was also compiled with the
same `gnu` ABI and CPU arch.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/04-extern-structs.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Alignment
Version: Zig 0.15.2# Alignment

For circuitry reasons, CPUs access primitive values at specific multiples in
memory. This could mean, for example, that the address of an `f32` value must be
a multiple of 4, meaning `f32` has an alignment of 4. This so-called "natural
alignment" of primitive data types depends on CPU architecture. All alignments
are powers of 2.

Data of a larger alignment also has the alignment of every smaller alignment;
for example, a value which has an alignment of 16 also has an alignment of 8, 4,
2 and 1.

We can make specially aligned data by using the `align(x)` property. Here we are
making data with a greater alignment.

```zig
const a1: u8 align(8) = 100;const a2 align(8) = @as(u8, 100);
```

And making data with a lesser alignment. Note: Creating data of a lesser
alignment isn't particularly useful.

```zig
const b1: u64 align(1) = 100;const b2 align(1) = @as(u64, 100);
```

Like `const`, `align` is also a property of pointers.

```zig
test "aligned pointers" {    const a: u32 align(8) = 5;    try expect(@TypeOf(&a) == *align(8) const u32);}
```

Let's make use of a function expecting an aligned pointer.

```zig
fn total(a: *align(64) const [64]u8) u32 {    var sum: u32 = 0;    for (a) |elem| sum += elem;    return sum;}test "passing aligned data" {    const x align(64) = [_]u8{10} ** 64;    try expect(total(&x) == 640);}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/05-alignment.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Packed Structs
Version: Zig 0.15.2# Packed Structs

By default, all struct fields in Zig are naturally aligned to that of
[`@alignOf(FieldType)`](https://ziglang.org/documentation/master/#alignOf) (the
ABI size), but without a defined layout. Sometimes you may want to have struct
fields with a defined layout that do not conform to your C ABI. `packed` structs
allow you to have extremely precise control of your struct fields, allowing you
to place your fields on a bit-by-bit basis.

Inside packed structs, Zig's integers take their bit-width in space (i.e. a
`u12` has an [`@bitSizeOf`](https://ziglang.org/documentation/master/#bitSizeOf)
of 12, meaning it will take up 12 bits in the packed struct). Bools also take up
1 bit, meaning you can implement bit flags easily.

```zig
const MovementState = packed struct {    running: bool,    crouching: bool,    jumping: bool,    in_air: bool,};test "packed struct size" {    try expect(@sizeOf(MovementState) == 1);    try expect(@bitSizeOf(MovementState) == 4);    const state: MovementState = .{        .running = true,        .crouching = true,        .jumping = true,        .in_air = true,    };    _ = state;}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/06-packed-structs.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Bit Aligned Pointers
Version: Zig 0.15.2# Bit Aligned Pointers

Similar to aligned pointers, bit-aligned pointers have extra information in
their type, which informs how to access the data. These are necessary when the
data is not byte-aligned. Bit alignment information is often needed to address
fields inside of packed structs.

```zig
test "bit aligned pointers" {    var x = MovementState{        .running = false,        .crouching = false,        .jumping = false,        .in_air = false,    };    const running = &x.running;    running.* = true;    const crouching = &x.crouching;    crouching.* = true;    try expect(@TypeOf(running) == *align(1:0:1) bool);    try expect(@TypeOf(crouching) == *align(1:1:1) bool);    try expect(@import("std").meta.eql(x, .{        .running = true,        .crouching = true,        .jumping = false,        .in_air = false,    }));}
```

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/07-bit-aligned-pointers.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- C Pointers
Version: Zig 0.15.2# C Pointers

Up until now, we have used the following kinds of pointers:

- single item pointers - `*T`

- many item pointers - `[*]T`

- slices - `[]T`

Unlike the aforementioned pointers, C pointers cannot deal with specially
aligned data and may point to the address `0`. C pointers coerce back and forth
between integers, and also coerce to single and multi item pointers. When a C
pointer of value `0` is coerced to a non-optional pointer, this is detectable
illegal behaviour.

Outside of automatically translated C code, the usage of `[*c]` is almost always
a bad idea, and should almost never be used.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/08-c-pointers.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Translate-C
Version: Zig 0.15.2# Translate-C

Zig provides the command `zig translate-c` for automatic translation from C
source code.

Create the file `main.c` with the following contents.

```zig
#include void int_sort(int* array, size_t count) {    for (int i = 0; i  array[j+1]) {                int temp = array[j];                array[j] = array[j+1];                array[j+1] = temp;            }        }    }}
```

Run the command `zig translate-c main.c` to get the equivalent Zig code output
to your console (stdout). You may wish to pipe this into a file with
`zig translate-c main.c > int_sort.zig` (warning for Windows users: piping in
PowerShell will produce a file with the incorrect encoding - use your editor to
correct this).

In another file you could use `@import("int_sort.zig")` to use this function.

Currently the code produced may be unnecessarily verbose, though translate-c
successfully translates most C code into Zig. You may wish to use translate-c to
produce Zig code before editing it into more idiomatic code; a gradual transfer
from C to Zig within a codebase is a supported use case.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/09-translate-c.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- cImport
Version: Zig 0.15.2# cImport

Zig's [`@cImport`](https://ziglang.org/documentation/master/#cImport) builtin is
unique in that it takes in an expression, which can only take in
[`@cInclude`](https://ziglang.org/documentation/master/#cInclude),
[`@cDefine`](https://ziglang.org/documentation/master/#cDefine), and
[`@cUndef`](https://ziglang.org/documentation/master/#cUndef). This works
similarly to translate-c, translating C code to Zig under the hood.

[`@cInclude`](https://ziglang.org/documentation/master/#cInclude) takes in a
path string and adds the path to the includes list.

[`@cDefine`](https://ziglang.org/documentation/master/#cDefine) and
[`@cUndef`](https://ziglang.org/documentation/master/#cUndef) define and
undefine things for the import.

These three functions work exactly as you'd expect them to work within C code.

Similar to [`@import`](https://ziglang.org/documentation/master/#import), this
returns a struct type with declarations. It is typically recommended to only use
one instance of [`@cImport`](https://ziglang.org/documentation/master/#cImport)
in an application to avoid symbol collisions; the types generated within one
cImport will not be equivalent to those generated in another.

cImport is only available when linking libc.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/10-c-import.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Linking libc
Version: Zig 0.15.2# Linking libc

Linking libc can be done via the command line via `-lc`, or via `build.zig`
using `exe.linkLibC();`. The libc used is that of the compilation's target; Zig
provides libc for many targets.

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/11-linking-libc.md)Last updated on **Jan 4, 2026** by **Sobeston**

---

- 
- Working with C
- Zig cc, Zig c++
Version: Zig 0.15.2# Zig cc, Zig c++

The Zig executable comes with Clang embedded inside it alongside libraries and
headers required to cross-compile for other operating systems and architectures.

This means that not only can `zig cc` and `zig c++` compile C and C++ code (with
Clang-compatible arguments), but it can also do so while respecting Zig's target
triple argument; the single Zig binary that you have installed has the power to
compile for several different targets without the need to install multiple
versions of the compiler or any addons. Using `zig cc` and `zig c++` also makes
use of Zig's caching system to speed up your workflow.

Using Zig, one can easily construct a cross-compiling toolchain for languages
that use a C and/or C++ compiler.

Some examples in the wild:

- [Using zig cc to cross compile LuaJIT to aarch64-linux from x86_64-linux](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html)

- [Using zig cc and zig c++ in combination with cgo to cross compile hugo from aarch64-macos to x86_64-linux, with full static linking](https://twitter.com/croloris/status/1349861344330330114)

[Edit this page](https://github.com/Sobeston/zig.guide/tree/master/website/versioned_docs/version-0.15.x/04-working-with-c/12-zig-cc.md)Last updated on **Jan 4, 2026** by **Sobeston**
