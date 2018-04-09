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
        if length(f)==length(Fields)
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
    L=length(L)

    for k=1:L
        R=rand()
        if R<p[k]
            epsilon=rand(1,2)
            if epsilon==1
                r.FieldValues[k] = r.fieldvalues[k]-1
                if r.FieldValues[k] < minimum(FieldValues[k].dist)
                    r.FieldValues[k] = r.fieldvalues[k]+2
            else
                r.FieldValues[k] = r.fieldvalues[k]+1
                if r.FieldValues[k] > maximum(Fields[k].dist)
                    r.FieldValues[k] = r.fieldvalues[k]-2
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
