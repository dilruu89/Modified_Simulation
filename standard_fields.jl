using Distributions
export Fields

L=9

Fields=Array{FieldDefinition}(L)

Fields[1]=FieldDefinition("Birth Day",1,DiscreteUniform(1,365))
Fields[2]=FieldDefinition("Birth Year",1,DiscreteUniform(1,100))
Fields[3]=FieldDefinition("Country of birth (Exclude Australia)",1,DiscreteUniform(1,365))
Fields[4]=FieldDefinition("Sex",1,DiscreteUniform(1,2))

eye_color_freq = [8, 55, 2, 1, 8, 26]
Fields[5]=FieldDefinition("Eye Color",0,Categorical(eye_color_freq/sum(eye_color_freq)))
Fields[6] = FieldDefinition("name", 2 , DiscreteUniform(1,1000))
Fields[7] = FieldDefinition("address(meshblock)", 4 , DiscreteUniform(1,347627))
Fields[8] = FieldDefinition("address(SA1)", 4 , DiscreteUniform(1,1000))
Fields[9] = FieldDefinition("address", 0 , DiscreteUniform(1,1000))
