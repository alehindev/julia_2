function find_all_max(a)
    i_max=Vector{Int}(undef,size(a))
    i_max[begin]=firstindex(a)
    n = firstindex(i_max)
    for i in firstindex(a)+1:lastindex(a)
        if A[i]>A[i_max[end]]
            i_max[begin]=i
            n = firstindex(i_max)
        elseif A[i]==A[i_max[end]]
            n+=1
            i_max[n]=i
        end
    end
    return resize!(i_max,n)
end

# Задача 2 и 3

function betterbubblesort!(A)
    n = length(A)
    v=0
    j=1
    for i in 1:n-1
        for j in 1:n-i
            if A[j]>A[j+1]
                A[j], A[j+1] = A[j+1], A[j]
                v=j+1
            end
        end
        j=v
    end
    return A
end

function shanker!(A)
    a=firstindex(A)
    b=length(A)
    while (a<=b)
        for i in b:a+1
            if A[i-1]>A[i]
                A[i-1],A[i]=A[i],A[i-1]
            end
        end
        a=a+1
        for j in a:b+
            if A[j-1]>A[j]
                A[j-1],A[j]=A[j],A[j-1]
            end
        end
        b=b-1
    end
    return A
end

# Задача 4

function shell(a)
    len = length(a)
    pol = len / 2
    while len >= 1
        for i in pol:len
            x = a[i]
            j = i
        end
        while j >= pol & a[j - pol] > x
            a[j] = a[j - pol]
            j -= pol
        end
        a[j] = pol
        pol /= 2
    end
    return a
end

# Задача 5

function slice(A::Vector{T},p::Vector{Int}) ::Vector{T} where T
    srez = Vector{Int}(undef,size(p))
    for i in 1:size(p)
        srez[i]=A[i]
    end
    return srez
end

function slice(A::Vector{T},p::Vector{Int}) ::Vector{T} where T
    return A[p]
end

# Задача 6

function permute_!(a::Vector{T}, perm::Vector{Int}) :: Vector{T} where T
    count = 0
    for i in 1:length(a)
        if i != p[i]
            count += 1
        end
    end
    i = 1
    k = p[i]
    x = a[k]
    y = a[i]
    a[i] = a[k]
    count -= 1
    while count!= 0
        k = y
        x = p.index(k)
        y = a[x]
        a[x] = a[k]
        count -= 1
    end
    return a
end

# Задача 7

function mydeleteat!(A,a)
    for i in a:length(A)-1
        A[i]=A[i+1]
    end
    A[length(A)]=Nothing
end

function myinsert!(A,a,c)
    b=A[end]
    for i in length(A)-1:a
        A[i+1]=A[i]
    end
    A[a]=c
    A=vcat(A,b)
    return A
end

# Задача 8

function allunique(A)
    for i in 1:length(A)
        for j in i+1:length(A)
            if A[i]==A[j]
                return false
            end
        end
    end
    return true
end

# Задача 9

function myreverse!(A)
    a=firstindex(A)
    b=lastindex(A)
    count=0
    while (a<b)
        A[a+count],A[b+count]=A[b+count],A[a+count]
        count+=1
    end
end

# Задача 10

function nextindex(k,m,A)
    return (k+m)%length(A)
end

function sdvig(A,m)
    for i in 1:length(A)
        A[i],A[nextindex(i,m,A)]=A[nextindex(i,m,A)],A[i]
    end
    return A
end

# Задача 11 и 12

function transpose11!(A)
    n,m = size(A)
    B=Matrix{eltype(A)}(undef,m,n)
    for j in 1:n
        for i in 1:m
            B[i,j] = A[j,i]
        end
    end
    A=B
    return A
end

function transpose12!(A)
    n,m = size(A)
    for j in 1:n
        for i in j:m
            temp = A[i,j]
            A[i,j] = A[j,i]
            A[j,i] = temp
        end
    end
    return A
end