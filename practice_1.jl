# Author: Artem Althin KMBO-04-20

# Задача 1

function reverse_user!(V::Vector{Int})
    size_V = size(V, 1)
    for i in 1:div(size_V, 2)
        V[i], V[size_V - i + 1] = V[size_V - i + 1], V[i]
    end
    return V
end

function reverse_user!(M::Array{Int,2}, dim::Int)
    for i in 1:dim
        M[i,:] = reverse!(M[i,:])
    end
    return M
end

# Задача 2

function copy_user(X::Array{Int})
    x=Array{Int}(1:(size(X, 1)*size(X, 2)))
    for i in 1:(size(X, 1)*size(X, 2))
        x[i]=X[i];
    end
    return reshape(x, (size(X, 2), size(X, 1)))
end

# Задача 3

function bubblesort(A::Array{Int})
    X=deepcopy(A)
    for i in 1:size(A, 1)
        for j in 1:size(A, 1)-i
            if(X[j]>X[j+1])
                X[j],X[j+1]=X[j+1],X[j]
            end
        end
    end
    return X
end

function bubblesort!(A::Array{Int})
    for i in 1:size(A, 1)
        for j in 1:size(A, 1)-i
            if(A[j]>A[j+1])
                A[j],A[j+1]=A[j+1],A[j]
            end
        end
    end
    return A
end

function bubblesortperm(A::Array{Int})
    indexes=collect(1:size(A, 1))
    for i in 1:size(A, 1)
        for j in 1:size(A, 1)-i
            if(A[j]>A[j+1])
                indexes[j],indexes[j+1]=indexes[j+1],indexes[j]
            end
        end
    end
    return indexes
end

function bubblesortperm!(A::Array{Int}, B::Array{Int})
    if(size(A, 1)==size(B, 1))
        B=collect(1:size(A, 1))
        for i in 1:size(A, 1)
            for j in 1:size(A, 1)-i
                if(A[j]>A[j+1])
                    B[j],B[j+1]=B[j+1],B[j]
                end
            end
        end
        return B
    end
end

# Задача 4

function sort(A::Matrix)
    X=deepcopy(A)
    for i in 1:size(A, 2)
        for k in 1:size(A, 1)
            for j in 1:(size(A, 1)-1)
                if(X[j, i]>X[j+1, i])
                    X[j, i],X[j+1, i]=X[j+1, i],X[j, i]
                end
            end
        end
    end
    return X
end

function sort!(X::Matrix)
    for i in 1:size(X, 2)
        for k in 1:size(X, 1)
            for j in 1:(size(X, 1)-1)
                if(X[j, i]>X[j+1, i])
                    X[j, i],X[j+1, i]=X[j+1, i],X[j, i]
                end
            end
        end
    end
    return X
end

# Задача 5

function sortkey(key_values, a)
    indperm=sortperm(key_values)
    return a[indperm]
end

# Задача 6

function calcsortkey(a, key_series, key_values)
    vector_vector_indexes = calcsortindexes(key_series, key_values)
    b=similar(a)
    j=1
    for vector_indexes in vector_vector_indexes
        for i in vector_indexes
            b[j] = a[i]
            j+=1
        end
    end
    return b
end

function calcsortindexes(key_series, key_values)
    vector_vector_indexes=[Int[] for _ in key_values]

    for i in eachindex(key_series)
        k=indexvalue(key_series[i], key_values)
        push!(vector_vector_indexes[k], i)
    end

    return vector_vector_indexes
end

function indexvalue(v, values::Vector)
    findfirst(x->x==v, values)
end

function calcsort_numzeros(a)
    b=[@view a[:,j] for j in 1:size(a,2)]
    k_s=[length(findall(b[j].== 0)) for j in 1:length(b)]
    b = calcsortkey(b, k_s, collect(0:size(a,1)))
    return  hcat(b...)
end

# Задача 7

function insertsort!(A)
    for k in eachindex(A)
        while k>1 && A[k-1] > A[k]
            A[k-1], A[k] = A[k], A[k-1]
            k -= 1
        end
    end
    return A
end

function insertsortperm!(A)
    ind=collect(1:length(A))
    for k in eachindex(A)
        while k>1 && A[k-1] > A[k]
            A[k-1], A[k] = A[k], A[k-1]
            ind[k-1], ind[k] = ind[k], ind[k-1]
            k -= 1
        end
    end
    return ind
end


# Задача 8

insertsort!(A)=reduce(1:length(A))do _, k
    while k>1 && A[k-1] > A[k]
        A[k-1], A[k] = A[k], A[k-1]
        k-=1
    end
    return A
end

# задача 9

function quicsearch(A,b)
    first = firstindex(A)
    last = lastindex(A)
    index = -1
    bool= false
    while (first+1 < last) &&(index == -1)
        mid = (first+last)÷2
        if A[mid] == b
            index = mid
            bool=true
        else
            if b<A[mid]
                last = mid -1
            else
                first = mid +1
            end
        end
    end
    if A[first]>b
        index=first
        bool=false
    elseif A[last]>b
        index=last
        bool=false
    elseif A[last]<b
        index=last+1
        bool=false
    end
    return bool,index
end

function insertsort!(A)
    for i in 2:length(A)
        key = A[i]
        j = i
        c,d=quicsearch(A[1:i-1],key)
        while d!=j
            A[j],A[j-1]=A[j-1],A[j]
            j-=1
        end
    end
    return A
end

# задача 10

function nummax(A)
    max = A[firstindex(A)]
    count = 1
    for i in (firstindex(A):lastindex(A))
        if A[i] > max
            max = A[i]
            count = 0
        end
        if A[i] == max
            count += 1
        end
    end
    return count
end

# задача 11

function findallmax(A)
    max = A[firstindex(A)]
    max_num = []
    for i in (firstindex(A):lastindex(A))
        if A[i] > max
            max = A[i]
            max_num = []
        end
        if A[i] == max
            append!(max_num, i)
        end
    end
    return max_num
end

# задача 12

function findallmax(A)
    max = A[firstindex(A)]
    max_num = []
    for i in (firstindex(A):lastindex(A))
        if A[i] > max
            max = A[i]
            max_num = []
        end
        if A[i] == max
            append!(max_num, i)
        end
    end
    return max_num
end
