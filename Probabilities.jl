module Probabilities


import Base: +, *, show, print, zero, one, convert, isequal, isless, log

export Probability, ProbArray, array, isclose, complement

type Probability
    val::Float64

    function Probability(val::Real)

        if val< -eps() || val> 1+eps()
                error("Value must be between 1 and 0")
        elseif val<0
            val=0
        elseif val>1
            val=1
        end
        new(val)
    end
end


+(a::Probability,b::Probability) = Probability(a.val+b.val -a.val*b.val)
+(a::Probability,b::Float64) =  a + convert(Probability,b)
+(a::Float64,b::Probability) = convert(Probability,a) + b
zero(::Type{Probability}) = Probability(zero(Float64))
one(::Type{Probability}) = Probability(one(Float64))

isclose(a::Probability,b::Probability) = (abs(a.val-b.val)<1.0e12)
print(io::IO, a::Probability) = print(io,a.val)
show(io::IO, a::Probability) = show(io,a.val)

complement(a::Probability) = Probability(1.0 - a.val)
convert(::Type{Probability}, a::Real) = Probability(a)
convert(::Type{Array{Probability}}, A::Real) = [Probability(A[i]) for i=1:length(A)]


for f in(:log,)
    @eval begin
        function($f)(a::Probability)
            return ($f)(a.val)
        end
    end

end

for f in(:isless,:isequal)
    @eval begin
        function($f)(a::Probability, b::Probability)
            return ($f)(a.val, b.val)
        end
    end

end

for f in(:isless,:isequal,:isclose)
    @eval begin
        ($f)(a::Probability,b::Float64) = ($f)(a + convert(Probability,b))
        ($f)(a::Float64,b::Probability) = ($f)(convert(Probability,a) + b)
    end

end

for f in(:*,)
    @eval begin
        function($f)(a::Probability, b::Probability)
            return ($f)(a.val, b.val)
        end
        function($f)(a::Probability,b::Float64)
            return ($f)(a.val, b)
        end
        function($f)(a::Float64,b::Probability)
            return ($f)(a, b.val)
        end
    end
end

ProbArray(A::Array) = map(Probability,A)
isclose(A::Array{Probability,1}, B::Array{Probability,1}) = length(A)==length(B) && all([isclose(A[i], B[i]) for i=1:length(A)])
convert(::Type{Float64}, a::Probability) = a.val
convert(::Type{Array{Float64}}, A::Array{Probability}) = (A[i].val for i=1:length(A))
Probability(A::Type{Array{Float64}}) = reshape([Probability(A[i]) for i=1:length(A)], size(A))
complement(P::Type{Array{Probability}}) = reshape([Probability(P[i]) for i=1:length(P)], size(P))


end
