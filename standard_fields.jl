using Distributions
export Fields

L=9

Fields=Array{FieldDefinition}(L)

Fields[1]=FieldDefinition("Birth Day",1,DiscreteUniform(1,365))
Fields[2]=FieldDefinition("Birth Year",1,DiscreteUniform(1,100))
Fields[3]=FieldDefinition("Country of birth (Exclude Australia)",1,DiscreteUniform(1,365))
Fields[4]=FieldDefinition("Sex",1,DiscreteUniform(1,2))
