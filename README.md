# Intro

VimBindings is a Julia package which brings some vim keybindings to the Julia REPL.

VimBindings is early in development and is not yet recommended for daily use. For the brave, feel free to give it a try!

# Features
- [x] Normal mode
- [x] Basic navigation (`h`, `j`, `k`, `l`,)
- [x] Binding escape key from Julia REPL (see https://github.com/caleb-allen/VimBindings.jl/issues/8)
- [x] Basic editing (e.g. `dw`, `cw`, `x`)
- [ ] Less basic editing (e.g. `diw`, `cfx`)
- [x] History integration (partial)
- [ ] Visual mode
- [ ] Registers
- [ ] Undo/Redo
- [ ] Macros

# Installation

```julia
] add https://github.com/caleb-allen/VimBindings.jl

```

# Usage

The VimBindings package must be loaded before the REPL to correctly bind the `Esc` key (see https://github.com/caleb-allen/VimBindings.jl/issues/8). You can do this in your startup config:
```julia
# ~/.julia/config/startup.jl
atreplinit() do repl
    @eval using VimBindings
end
```

After starting the REPL, call `VimBindings.init()`

You may see warnings about method definitions being overwritten. VimBindings.jl overwrites some methods in order to hook into REPL functionality, and you can safely ignore these warnings.


```julia
julia> VimBindings.init()
julia[i]> # You now have vim bindings!
```

VimBindings begins in `insert` mode, and the Julia REPL can be used in its original, familiar fasion.

Switch to `normal` mode by pressing Esc, where you can navigate with `h`, `j`, `k`, `l`, etc.
```julia
julia[i]> println("Hello world!") # user presses Esc
julia[n]> println("Hello world!") # normal mode!
```
![gif of usage](https://raw.githubusercontent.com/caleb-allen/VimBindings.jl/master/vimbindings.gif)


# Feedback

VimBindings.jl is early in development and likely has bugs! Issues with bug reports or general feedback is welcome.