function pow(a,b)
    k = b
    t = 1
    p = a
    while k>0
        if k%2==0
            k ÷= 2
            p *= p
        else
            k -= 1
            t *= p
        end
    end
    return t
end

# Задача 2

function fibonacci(n)
    answer = pow(n-1)
    return answer
end

function pow(b)
    k = b
    t = [1 1
        1 1]
    p = [1 1
         1 0]
    while k>0
        if k%2==0
            k ÷= 2
            p *= p
        else
            k -= 1
            t *= p
        end
    end
    return t[2,2]
end

# Задача 3

function log(a::Real,x::Real,ε::Real)
    z = x
    t = 1
    y = 0
    while z > a || z < 1/a || t > ε
        if z > a
            z /= a
            y += t
        elseif z < 1/a
            z *= a
            y -= t
        else
            t /= 2
            z *= z
        end
    end
    return y
end

# Задача 4

function isprime(n)
    if n==1
        return false
    end
    if n==2 || n==3
        return true
    end

    for i in 2:isqrt(n)
        if n%i==0
            return false
        else
            if i ==2
                i+=1
            else
                i+=2
            end
        end
    end
    return true
end

# Задача 5

function eratosphen(n)
    ser=fill(true,n)
    ser[1]=false
    k=2
    while k !== nothing && k<n
        ser[k^2:k:end] .= false
        k=findnext(ser, k+1)
    end
    return findall(ser)
end

# Задача 6

function factor(n)
    answer=[]
    hw = []
    for i in eratosphen(n)
        if n%i==0
            push!(answer,i)
            push!(hw,1)
            n=n/i
            while n%i==0
                hw[end]+=1
                n=n/i
            end
        end
    end
    return answer,hw
end

function eratosphen(n)
    ser=fill(true,n)
    ser[1]=false
    k=2
    while k !== nothing && k<n
        ser[k^2:k:end] .= false
        k=findnext(ser, k+1)
    end
    return findall(ser)
end

# Задача 7

function eller(n)
    result = 1
    answer,hw  = factor(n)
    for i in 1:length(answer)
        if hw[i]==1
            result *= answer[i]-1
        else
            result *=(answer[i]^hw[i]-answer[i]^(hw[i]-1))
        end
    end
    return result
end

function factor(n)
    answer=[]
    hw = []
    for i in eratosphen(n)
        if n%i==0
            push!(answer,i)
            push!(hw,1)
            n=n/i
            while n%i==0
                hw[end]+=1
                n=n/i
            end
        end
    end
    return answer,hw
end

function eratosphen(n)
    ser=fill(true,n)
    ser[1]=false
    k=2
    while k !== nothing && k<n
        ser[k^2:k:end] .= false
        k=findnext(ser, k+1)
    end
    return findall(ser)
end

# Задача 8

function NOD(a,b)
    m = a
    n = b
    while n != 0
        m, n = n, m % n
    end
    return m
end

# Задача 9

function  inv(m,n)
    a = m
    b = n
    u_a = 1
    v_b = 1
    u_b = 0
    v_a = 0

    if NOD(a,b)!=1
        return Nothing
    end

    while b != 0
        k, r = divrem(a,b)
        a, b = b, r
        u, v = u_a, v_a
        u_a, v_a = u_b, u_a
        u_b, v_b = u-k*u_b, v-k*v_b
    end
    while u_a<0
        u_a+=n
    end
    return u_a
end

Base.inv(a::ResidueRing{m}) where m = ResidueRing{m}.inv(a,m)

# Задача 10

function zerodivisors(m)
    answer=Vector{Int}[]
    for i in 2:m-1
        if NOD(i,m)!=1
            push!(answer,i)
        end
    end
    return answer
end

zerodivisors(::ResidueRing{m}) where m = ResidueRing{m}.zerodivisors(m)

# Задача 11

function nilpotents(n)
    divs, _ = factor_m(n)
    multip = 1
    for x in divs
        multip *= x
    end
    return multip:multip:(n-1)
end

# Задача 12

function ord(a, p)
    orders = factor(p - 1)
    for x in orders
        if pow(a, x)%p == 1
            return x
        end
    end
end

# Задача 13

function bisection(f::Function, a, b; atol = 0.001, rtol = 0.001)
    x = (a+b) / 2
    while (b-a) > atol || (b - a)/x > rtol
        if f(a)*f(x) < 0
            b = x
            x = (a+b)/2
        elseif f(x)*f(b) < 0
            a = x
            x = (a+b)/2
        elseif f(x) == 0
            return x
        end
    end
    return x
end