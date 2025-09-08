# __precompile__(true)

module ThickIntervals

import IntervalArithmetic: NumTypes, Interval,
    bareinterval, interval, inf, sup, diam,
    +, -, *, /,
    issubset_interval

export interval

# Construction and basic properties

struct ThickInterval{T<:NumTypes} <: Real
    lo::Interval{T}
    hi::Interval{T}

    function ThickInterval(lo::Interval{T}, hi::Interval{T}) where {T<:Real}
        # TODO bounds checking
        new{T}(lo, hi)
    end
end

export ThickInterval

function thickinterval(lo::Interval{T}, hi::Interval{T}) where {T<:Real}
    ThickInterval(lo, hi)
end

function thickinterval(outer_lo::T, inner_lo::T, inner_hi::T, outer_hi::T) where {T<:Real}
    return thickinterval(interval(outer_lo, inner_lo), interval(inner_hi, outer_hi))
end

function thickinterval(x::T) where {T<:Real}
    return thickinterval(x, x, x, x)
end

inf(x::ThickInterval) = x.lo
sup(x::ThickInterval) = x.hi
outer(x::ThickInterval) = interval(inf(inf(x)), sup(sup(x)))
inner(x::ThickInterval) = interval(sup(inf(x)), inf(sup(x)))

export thickinterval, inf, sup, outer, inner

# Set-like operations

function Base.:>(a::ThickInterval, b::Real)
    return inf(outer(a)) > b
end

function Base.:<(a::ThickInterval, b::Real)
    return sup(outer(a)) < b
end

function Base.:∈(x::Real, a::ThickInterval)
    return x ∈ outer(a)
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

# Arithmetic operations

function Base.:+(a::ThickInterval, b::ThickInterval)
    return thickinterval(inf(a) + inf(b), sup(a) + sup(b))
end

function Base.:-(a::ThickInterval, b::ThickInterval)
    return thickinterval(inf(a) - sup(b), sup(a) - inf(b))
end

function Base.:*(a::ThickInterval, b::ThickInterval)
    Φ = [inf(a) * inf(b), inf(a) * sup(b), sup(a) * inf(b), sup(a) * sup(b)]
    return thickinterval(minimum(Φ), maximum(Φ))
end

function Base.:/(a::ThickInterval, b::ThickInterval)
    if 0 ∈ outer(b)
        throw(DivideError("Division by interval containing zero"))
    end

    inv_b = thickinterval(1 / sup(b), 1 / inf(b))

    return a * inv_b
end

# Utility functions

function inner_diam(a::ThickInterval)
    return diam(inner(a))
end

function outer_diam(a::ThickInterval)
    return diam(outer(a))
end

function thickness(a::ThickInterval)
    return outer_diam(a) - inner_diam(a)
end

function Base.show(io::IO, a::ThickInterval)
    print(io, "⟦$(inf(a)), $(sup(a))⟧")
end

export inner_diam, outer_diam, thickness, contains

# Promotion rules

Base.promote_rule(::Type{ThickInterval{T}}, ::Type{ThickInterval{S}}) where {T<:NumTypes,S<:NumTypes} =
    ThickInterval{promote_type(T, S)}

Base.promote_rule(::Type{ThickInterval{T}}, ::Type{S}) where {T<:NumTypes,S<:Real} =
    ThickInterval{promote_type(T, S)}

Base.promote_rule(::Type{T}, ::Type{ThickInterval{S}}) where {T<:Real,S<:NumTypes} =
    ThickInterval{promote_type(T, S)}

# Type conversions

function Base.convert(::Type{ThickInterval{T}}, x::Real) where {T<:NumTypes}
    x_ = interval(convert(T, x))
    return thickinterval(x_)
end

function Base.convert(::Type{ThickInterval{T}}, x::ThickInterval) where {T<:NumTypes}
    # If already a ThickInterval, convert inner types if needed
    return ThickInterval(convert(Interval{T}, inf(x)), convert(Interval{T}, sup(x)))
end

ThickInterval{T}(x::Real) where {T<:NumTypes} = convert(ThickInterval{T}, x)

end
