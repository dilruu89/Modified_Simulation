using Distributions
import Base: length, size, isequal, ==, !=, rand
export FieldDefinition

type FieldDefinition
    name::AbstractString
    tolerance::Integer
    dist::Distributions.Distribution{Univariate,Discrete}
end

isequal(f1::FieldDefinition, f2::FieldDefinition)=(f1.name==f2name && f1.tolerance==f2.tolerance && f1.dist==f2.dist)
==(f1::FieldDefinition, f2::FieldDefinition)=isequal(f1,f2)
!=(f1::FieldDefinition, f2::FieldDefinition)=!isequal(f1,f2)

isequal(F1::Array{FieldDefinition,1},F2::Array{FieldDefinition,1})=(length(F1)==length(F2) && all(F1.=F2))
==(F1::Array{FieldDefinition,1},F2::Array{FieldDefinition,1})=isequal(F1,F2)
!=(F1::Array{FieldDefinition,1},F2::Array{FieldDefinition,1})=!isequal(F1,F2)
