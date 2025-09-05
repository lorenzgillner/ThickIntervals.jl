# __precompile__(true)

module ThickIntervals

import IntervalArithmetic: NumTypes, Interval,
    interval, inf, sup, diam,
    +, -, *, /, 
    issubset_interval

export interval

struct ThickInterval{T<:NumTypes}
    lo :: Interval{T}
    hi :: Interval{T}
    
    function ThickInterval(lo::Interval{T}, hi::Interval{T}) where {T<:Real}
        if !issubset_interval(interval(sup(lo), inf(hi)), interval(inf(lo), sup(hi)))
            throw(ArgumentError("Invalid interval bounds"))
        end
        new{T}(lo, hi)
    end
end

export ThickInterval

function t2interval(lo::Interval{T}, hi::Interval{T}) where {T<:Real}
    ThickInterval(lo, hi)
end

function t2interval(outer_lo::T, inner_lo::T, inner_hi::T, outer_hi::T) where {T<:Real}
    return t2interval(interval(outer_lo, inner_lo), interval(inner_hi, outer_hi))
end

inf(x::ThickInterval) = x.lo
sup(x::ThickInterval) = x.hi
outer(x::ThickInterval) = interval(inf(inf(x)), sup(sup(x)))
inner(x::ThickInterval) = interval(sup(inf(x)), inf(sup(x)))

export t2interval, inf, sup, outer, inner

function Base.:+(a::ThickInterval, b::ThickInterval)
    return t2interval(inf(a) + inf(b), sup(a) + sup(b))
end

function Base.:-(a::ThickInterval, b::ThickInterval)
    return t2interval(inf(a) - sup(b), sup(a) - inf(b))
end

function Base.:*(a::ThickInterval, b::ThickInterval)
    Φ = [inf(a) * inf(b), inf(a) * sup(b), sup(a) * inf(b), sup(a) * sup(b)]
    return t2interval(minimum(Φ), maximum(Φ))
end

function Base.:/(a::ThickInterval, b::ThickInterval)
    if 0 ∈ b
        throw(DivideError("Division by interval containing zero"))
    end
    
    inv_b = t2interval(1/sup(b), 1/inf(b))
    
    return a * inv_b
end

# TODO relational operators

function inner_diam(a::ThickInterval)
    return diam(inner(a))
end

function outer_diam(a::ThickInterval)
    return diam(outer(a))
end

function thickness(a::ThickInterval)
    return outer_diam(a) - inner_diam(a)
end

# TODO use tribool/kleenean here?
function contains(a::ThickInterval, x::Real)
    if x ∈ inner(a)
        return :definitely
    elseif x ∈ outer(a)
        return :possibly
    else
        return :no
    end
end

function Base.show(io::IO, a::ThickInterval)
    print(io, "⟦$(inf(a)), $(sup(a))⟧")
end

export inner_diam, outer_diam, thickness, contains
end