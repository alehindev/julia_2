function merge(A,B)
    C = promote_type(eltype(A), eltype(B))[]
    i, j = 1, 1
    n, m = 1, 1
    while i <= length(A)  || j <= length(B)
        while i <= length(A) && ( A[i] <= B[m] || j > length(B))
            push!(C, A[i])
            i += 1
            n += 1
        end
        if n > length(A)
            n -= 1
        end
        while j <= length(B) && (B[j] <= A[n] || i > length(A))
            push!(C,B[j])
            j += 1
            m += 1
        end
        if m > length(B)
            m -= 1
        end
    end

    return C
end

function mergesort!(a)
    if length(a) == 1
        return a
    end
    a1 = mergesort!(a[1:end ÷ 2])
    a2 = mergesort!(a[end ÷ 2 + 1:end])
    merge(a1, a2)
end

# Задача 2

function mergesort_iter!(a)
    k = 1
    while k < length(a)
        for i in 1:2k:length(a)
            if (i + k - 1 < length(a) < i + 2k -1)
                b = merge(a[i:i+k-1], a[i+k : lastindex(a)])
                a[i:lastindex(a)] = b
            elseif ( i + 2k -1 <= length(a))
                b = merge(a[i:i+k-1], a[i+k : i+2k - 1])
                a[i:i+2k-1] = b
            end
        end
        k *= 2
    end

    return a
end

function merge1!(a, b, c)
    d = merge(a,b)
    for i in 1:length(c)
        c[i] = d[i]
    end
    return c
end

function mergesort_iter2!(a)
    k = 1
    b = similar(a)
    while k < length(a)
        for i in 1:2k:length(a)
            if (i + k - 1 < length(a) < i + 2k -1)
                b = merge(a[i:i+k-1], a[i+k : lastindex(a)])
                a[i:lastindex(a)] = b
            elseif ( i + 2k -1 <= length(a))
                b = merge(a[i:i+k-1], a[i+k : i+2k - 1])
                a[i:i+2k-1] = b
            end
        end
        k *= 2
    end

    a = b
    return a
end

# Задача 3

using Random
using BenchmarkTools
function comprassion()
    array = []
    for i in 1:999999
        push!(array, rand())
    end
    array2 = array
    @btime sort!(array)
    @btime mergesort!(array2)
end

# Задача 4

function partsort!(A, b)
    A1 = []
    A2 = []
    A3 = []
    for x in A
        if x < b
            push!(A1, x)
        elseif x == b
            push!(A2, x)
        else
            push!(A3, x)
        end
    end
    i = length(A1)
    j = length(A1) + length(A2)
    A = append!(A1, A2)
    A = append!(A, A3)
    return A, i, j
end

function partsort2!(A, b)
    A1 = Vector{eltype(A)}(undef, length(A))
    A2 = Vector{eltype(A)}(undef, length(A))
    A3 = Vector{eltype(A)}(undef, length(A))
    i, j, k = 1, 1, 1
    for x in A
        if x < b
            A1[i] = x
            i+=1
        elseif x == b
            A2[j] = x
            j+=1
        else
            A3[k] = x
            k += 1
        end
    end
    i -= 1
    j -= 1
    k -= 1
    for count in 1:i
        A[count] = A1[count]
    end
    for count in i+1:i+j
        A[count] = A2[count - i]
    end
    for count in i+j+1:i+j+k
        A[count] = A3[count - i - j]
    end
    return A, i, i+j
end

function quicksort!(a)
    if length(a) < 2
        return a
    end
    a, i, j = partsort!(a, a[(1+length(a)) ÷ 2])
    a[1:i] = quicksort!(a[1:i])
    a[j+1 : end] = quicksort!(a[j+1:end])
    return a
end

function quicksort_!(a)
    if length(a) < 2
        return a
    end
    a, i, j = partsort2!(a, a[(1+length(a)) ÷ 2])
    a[1:i] = quicksort_!(a[1:i])
    a[j+1 : end] = quicksort_!(a[j+1:end])
    return a
end

# Задача 5

function k_statistics(a, k::Int)
    if length(a) < 2
        return a[1]
    end
    a, i, j = partsort!(a, a[(1+length(a)) ÷ 2])
    if k <= i
        return k_statistics(a[1:i], k)
    elseif i < k < j+1
        return a[k]
    else
        return k_statistics(a[j+1:end], k - j)
    end
end

function median(a)
    if length(a) % 2 == 0
        return k_statistics(a, length(a) ÷ 2)
    else
        return k_statistics(a, (length(a) ÷ 2 + 1))
    end
end