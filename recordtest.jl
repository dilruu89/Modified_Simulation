#using RecordLinkageSim
include("standard_fields.jl")


K=4

N = [20, 10, 10, 10]
T = [0, 1, 2, 3]
Lambda = [0.0, 0.0, 0.0, 3.0]
P = 0.1*ones(Float64, K, L)
Q = 0.1*ones(Float64, K, L)
M = 0.1*ones(Float64, K, L)


DATA = DataBaseArray("test", K, N, T, Lambda, P, Q, M, Fields)
println("\n.....................")
show(DATA)
println(".....................")
