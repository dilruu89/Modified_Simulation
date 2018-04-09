module RecordLinkageSim

using Distributions
using Probabilities

import Base:length, size,isequal, ==, !=, rand

include("field.jl")
include("record.jl")
#include("record_compare.jl")
#include("record_io.jl")
#include("error_rates.jl")

end
