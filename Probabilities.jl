module Probabilities


import Base: +, *, show, print, zero, one, convert, isequal, isless, log

export Probability, ProbArray, array, isclose, complement

type Probability
    val::Float64

    function Probability(val::Real)

        if val< -eps() || val> 1+eps()
            error("Value must be between 1 and 0")
        end

    end
end

end
