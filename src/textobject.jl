module TextObjects
using Match
using ..TextUtils
using REPL.LineEdit
export word, line, space

const LE = LineEdit

abstract type Selection end

"""
An inner selection
"""
struct Inner <: Selection end
"""
An "all" selection
"""
struct A <: Selection end

# abstract type TextObject end
struct TextObject{T<:Selection}

end

"""
Create a text object
"""
function textobject(buf::IOBuffer, name::String)
    m = match(r"^([ai])(.)$", name)
    selection = @match m[1] begin
        "i" => Inner()
        "a" => A()
    end

    fns = Dict(
        "w" => word,
    )
    object_fn::Function = fns[m[2]]
end


"""
For the "inner" commands: If the cursor was on the object, the operator applies to 
the object. If the cursor was on white space, the operator applies to the white 
space.
"""
function inner(buf,)::Tuple{Int, Int}
    # TODO 
    origin = position(buf)
    if eof(buf)
        if origin == 0
            return (origin, origin)
        else
            skip(buf, -1)
        end
    end
    c = peek(buf)
    if is_whitespace(c)
        return space(buf)
    else
        error("TODO")
        return word(buf)
    end
end

"""
  For non-block objects: For the "a" commands: The operator applies to the object
   and the white space after the object. If there is no white space after the object
    or when the cursor was in the white space before the object, the white space before
    the object is included.
"""
function a(object_fn)::Tuple{Int, Int}
    
end

"""
    A word consists of a sequence of letters, digits and underscores, or a
sequence of other non-blank characters, separated with white space (spaces,
tabs, <EOL>).  This can be changed with the 'iskeyword' option.  An empty line
is also considered to be a word.
"""
function word(buf::IOBuffer)::Tuple{Int,Int}
    origin = position(buf)

    eof(buf) && return (origin, origin)
    !is_word_char(peek(buf, Char)) && return (origin, origin)

    local start
    while !is_object_start(buf)
        skip(buf, -1)
    end
    start = position(buf)
    seek(buf, origin)


    local endd
    while !is_object_end(buf)
        skip(buf, 1)
    end
    endd = position(buf)
    seek(buf, origin)
    return (start, endd)
end

"""
    Identify the text object surrounding a space
"""
function space(buf::IOBuffer)::Tuple{Int, Int}
    # use origin rather than `mark` because
    # methods called below use their own marks
    origin = position(buf)
    local start
    eof(buf) && return (origin, origin)
    !is_whitespace(peek(buf, Char)) && return (origin, origin)
    while !is_whitespace_start(buf)
        skip(buf, -1)
    end
    start = position(buf)
    seek(buf, origin)


    local endd
    while !is_whitespace_end(buf)
        skip(buf, 1)
    end
    endd = position(buf)
    seek(buf, origin)
    return (start, endd)
end
function WORD(buf::IOBuffer)::Tuple{Int,Int}

end

function line(buf::IOBuffer)::Tuple{Int,Int}
    # find the line start
    mark(buf)
    if eof(buf)
        if position(buf) > 0
            LE.char_move_left(buf)
        end
    end

    while !eof(buf) && position(buf) > 0
        c = peek(buf, Char)
        if is_linebreak(c)
            skip(buf, 1)
            break
        end
        LE.char_move_left(buf)
    end
    start = position(buf)
    if ismarked(buf)
        reset(buf)
    end

    # find the line end
    mark(buf)
    while !eof(buf)
        c = read(buf, Char)
        if is_linebreak(c)
            LE.char_move_left(buf)
            break
        end
    end
    stop = position(buf)
    reset(buf)

    return (start, stop)
end

end
