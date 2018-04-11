using Probabilities

export Record

type Record
    ID::Integer
    FieldValues::Array{Integer,1}

    function Record(ID::Integer,Fields::Array{FieldDefinition,1})
        L=length(Fields)
        f=Array{Integer}(L)

        for i=1:L
            f[i] = rand(Fields[i].dist)
        end
        new(ID,f)
    end

    function Record(ID::Integer,f::Array,Fields::Array{FieldDefinition,1})
        if length(f)!=length(Fields)
            error("f and fields length should match")
        end

        for i=1:length(L)
            if f[i]!= 0 && !insupport(Fields[i].dist, f[i])
            error("f[$i] is not in the support of $(Fields[i].dist)")
            end
        end
        new(ID,f)
    end

end

isequal(r1::Record, r2::Record) = (r1.ID==r2.ID && length(r1.FieldValues)==length(r2.FieldValues) && all(r1.FieldValues.==r2.FieldValues))
==(r1::Record, r2::Record)=isequal(r1,r2)
!=(r1::Record, r2::Record)=!isequal(r1,r2)

function AddError!(Fields,r,p,q,m)
    L=length(Fields)

    for k=1:L
        R=rand()
        if R<p[k]
            epsilon=rand(1,2)
            if epsilon==1
                r.FieldValues[k] = r.FieldValues[k]-1
                if r.FieldValues[k] < minimum(FieldValues[k].dist)
                    r.FieldValues[k] = r.FieldValues[k]+2
                end
            else
                r.FieldValues[k] = r.FieldValues[k]+1
                if r.FieldValues[k] > maximum(Fields[k].dist)
                    r.FieldValues[k] = r.FieldValues[k]-2
                end
            end
        end
    end

    for k=1:L
        R=rand()
        if R<q[k]
            r.FieldValues[k] = rand(Fields[k].dist)
        end
    end

    for k=1:L
        R=rand()
        if R<m[k]
            r.FieldValues[k] = 0
        end
    end

end



type DataBase
    ID::Integer
    n::Integer  #no of record
    t::Integer  #type of db
    lambda::Float64
    p::Array{Probability,1}
    q::Array{Probability,1}
    m::Array{Probability,1}
    Records::Array{Record,1}

    function DataBase(ID::Integer,n::Integer, Fields::Array{FieldDefinition,1})
        if n<1
            error("Error must be generated atleast in one reocrd")
        end
        t=1
        lamda=0
        L=length(Fields)
        p=zero(Array{Probability}(L))
        q=zero(Array{Probability}(L))
        m=zero(Array{Probability}(L))
        r=Array{Record}(n)

        for i=1:n
            r[i]=Record(i,Fields)
        end
        new(ID,n,t,lamda,p,q,m,r)
    end

    function DataBase(ID::Integer,n::Integer,t::Integer,lamda::Float64,p::Array{Probability,1},q::Array{Probability,1},m::Array{Probability,1},Census::DataBase,Fields::Array{FieldDefinition,1})
        if n<1
            error("Error must be generated atleast in one reocrd")
        end

        L=length(Fields)
        r=Array{Record}(n)

        if t==1
            if n>Census.n
            error("do not create errors in Census")
            end
            j=shuffle(collect(1:Census.n))
            for i=1:n
                r[i]=deepcopy(Census.Records[j[i]])
                AddError!(Fields,r[i],p,q,m)
            end
        elseif t==2

            for i=1:n
                j=rand(1:Census.n)
                print("$j,")
                r[i]=deepcopy(Census.Records[j])
                AddError!(Fields,r[i],p,q,m)
            end
        elseif t==3
            i=0
            P=Poisson(lamda)
            while i<n
                j=rand(1:Census.n)
                K=rand(p)
                k=0
                while i<n && k < K
                    i= i+1
                    k= k+1
                    r[i]=deepcopy(Census.Records[j])
                    AddError!(Fields,r[i],p,q,m)
                end
            end
        end
        new(ID,n,t,lamda,p,q,m,r)
        end

    function DataBase(ID::Integer, n::Integer, t::Integer, lamda::Float64, p::Array{Float64,1}, q::Array{Float64,1}, m::Array{Float64,1}, Census::DataBase, Fields::Array{FieldDefinition,1})

        DataBase(ID,n,t,lamda,convert(Array{Probability,1},p), convert(Array{Probability,1},q), convert(Array{Probability,1},m), Census::DataBase, Fields::Array{FieldDefinition,1})
    end

end

function isequal(R1::DataBase, R2::DataBase)
    tmp=(R1.ID==R2.ID &&
    R1.n==R2.n &&
    R1.t==R2.t &&
    abs(R1.lambda -  R2.lambda) < 1.0e-12 &&
    isclose(R1.p, R2.p) &&
    isclose(R1.q, R2.q) &&
    isclose(R1.m, R2.m) &&
    all(R1.Records .== R2.Records)

    )
    return tmp
end
==(R1::DataBase, R2::DataBase) = isequal(R1,R2)
!=(R1::DataBase, R2::DataBase) = !isequal(R1,R2)
length(R1::DataBase)=R1.n

type DataBaseArray
    name::AbstractString
    DBs::Array{DataBase,1}
    Fields::Array{FieldDefinition,1}

    function DataBaseArray(name, K, N, T, Lamda, P,Q, M, Fields::Array{FieldDefinition,1})
        DBs=Array{DataBase}(K)
        DBs[1]=DataBase(1,N[1],Fields)

        for i=2:K
            DBs[i] = DataBase(i, N[i], T[i], Lamda[i], P[i,:], Q[i,:], M[i,:], DBs[1], Fields)
        end
        new(name,DBs,Fields)
    end
    DataBaseArray(name::AbstractString,DBs::Array{DataBase,1},Fields::Array{FieldDefinition,1}) = new(name,DBs,Fields)
end

function isequal(DB1::DataBaseArray,DB2::DataBaseArray)
    tmp=( DB1.name==DB2.name &&
    all(DB1.DBs .== DB2.DBs) &&
    all(DB1.Fields .== DB2.Fields)
    )
    return tmp
end
==(DB1::DataBaseArray,DB2::DataBaseArray)=isequal(DB1,DB2)
!=(DB1::DataBaseArray,DB2::DataBaseArray)=!isequal(DB1,DB2)
length(D::DataBaseArray)=length(D.DBs)
size(D::DataBaseArray)=[length(D.DBs[i]) for i in 1:length(D)]
