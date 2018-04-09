using Probabilities

x=Probability(1)
y=Probability(0.2)
z=convert(Probability, 0.1)
w=zero(Probability)

w1 = x + y
w2 = x * y

P1= Array(Probability, (3,))
P1[1]=1
P1[2]=0.0
P1[3]=0.3

P2=ProbArray([0.1,0.3,0.0])

P1+P2

P1 .* P2

P1.==P2

convert(Float64, x)

p1 = convert(Array{Float64}, P1)
p11 = convert(Array{Probability}, p1)

x * 0.1
x + 0.1
0.1 + y


#x < 0.1
y == 1.0
x == 1.0

isclose(x,y)
isclose(x,x)

isclose(P1, P2)
isclose(P1, P1)

print("test printing x = ", x, "\n")

println(y)

show(x)

println(P1)


println("x = ", x, ", log(x)=", log(x))


p1 = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
#p1 = convert(Array{Float64}, p1)
#show(p1)

p2 = convert(Array{Probability,1},p1)
show(p2)

complement(p2)
complement(y)
