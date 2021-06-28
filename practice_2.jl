function sortkey(key_values, a)
    indperm=sortperm(key_values)
    return a[indperm]
end

# Задача 2

function calcsort!(A,values::UnitRange{Int})
    store = zeros(Int, size(values))
    for i in 1:length(A)
        for j in 1:length(values)
            if A[i]==values[j]
                store[j]+=1
            end
        end
    end
    k=1
    for i in 1:length(values)
        while store[i]>0
            A[k]=values[i]
            k+=1
            store[i]-=1
        end
    end
    return A
end

function calcsort!(A,values::Vector{Int})
    store = zeros(Int, size(values))
    for i in 1:length(A)
        for j in 1:length(values)
            if A[i]==values[j]
                store[j]+=1
            end
        end
    end
    k=1
    for i in 1:length(values)
        while store[i]>0
            A[k]=values[i]
            k+=1
            store[i]-=1
        end
    end
    return A
end

# Задача 3

function insertsort!(A)
    for i in 2:length(A)
        key = A[i]
        j = i - 1
        while j >= 1 && A[j] > key
            A[j + 1] = A[j]
            j -= 1
        end
        A[j + 1] = key
    end
    return A
end

function insertsort(A)
    insertsort!(deepcopy(A))
end

function insertsortperm!(A)
    numbers = collect(1:length(A))
    for i in 2:length(A)
        key = A[i]
        j = i - 1
        while j >= 1 && A[j] > key
            A[j + 1] = A[j]
            numbers[j + 1],numbers[j] =numbers[j],numbers[j + 1]
            j -= 1
        end
        A[j + 1] = key
        numbers[j + 1],numbers[i] = numbers[i],numbers[j + 1]
    end
    return numbers
end

function insertsortperm(A)
    insertsortperm!(deepcopy(A))
end

# Задача 4

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
            j=j-1
        end
    end
    return A
end