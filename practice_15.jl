ConnectList{T}=Vector{Vector{T}}
function convert(tree::ConnectList{T}, root::T) where T
    b=[]
    for i in firstindex(tree):lastindex(tree)
        for j in firstindex(tree[i]):lastindex(tree[i])
            push!(b,vcat([[a] for a in tree[j+1]],tree[i][j]))
        end
        if length(tree[i])+2>length(tree) || lastindex(tree[length(tree[i])+2])==0
            break
        end
    end
    b=vcat(b,root)
    return b
end

# Задача 2

function convert(tree)
    T=typeof(tree[end])
    connect_tree = Dict{T,Vector{T}}()

    function recurs_trace(tree)
        connect_tree[tree[end]]=[]
        for subtree in tree[1:end-1]
            push!(connect_tree[tree[end]], recurs_trace(subtree))
        end
        return tree[end]
    end

    recurs_trace(tree)
    return connect_tree
end

# Задача 3

function tree_convert(tree::ConnectList{T}, root::T) where T
    tr = copy(tree)
    arr = Array{Tree{Int}}(undef,length(tr))
    for i in 1:length(tr)
        arr[i] = Tree{Int}(i,[])
    end
    list = arr[root]
    a = [root]
    while (!isempty(a))
        cur = first(a)
        deleteat!(a,firstindex(a))
        a = append!(a,tr[cur])
        for tree in tr[cur]
            push!(list_arr[cur].sub,list_arr[tree])
        end
    end
    return list
end
        
# Задача 4
        
function height(tree::Tree) 

    h=0
    for sub in tree.sub
        h = max(h,height(sub))
    end
    return h+1
end

function vernumber(tree::Tree)
    N=1
    for sub in tree.sub
        N += vernumber(sub)
    end
    return N
end

function leavesnumber(tree::Tree)
    if isempty(tree.sum)
        return 1
    end
    N=0
    for sub in tree.sub
        N += leavesnumber(sub)
    end
    return N
end

function maxvalence(tree::Tree) 
    p=length(tree.sub)
    for i in tree.sub
        p = max(p, maxvalence(sub))
    end
    return p
end
function meanpath(tree::Tree)
                    
    function sumpath_numver()
        N=1
        S=0
        for sub in tree.sub
            s, n = sumpath_numver(sub)
            S += s
            N += n
        end
        return S, N
    end

    S, N = sumpath_numver()
    return S/N
end
                
# Задача 6

function find_general(rootindex::T, tree::ConnectList{T}) where T

    number_visited = 0
    general = 0

    function recurstrace(tree, parent=0)  
        is_mutable_general = false

        for subindex in tree[rootindex]
            if number_visited < length(tree)
                toptrace(subindex, tree)
            end
        end

        if tree[end] < length(tree)
            number_visited +=1
            if number_visited == 1
                general = tree[end]
            end                        
        end
                        
        if general==tree[end] 
            is_mutable_general = true 
        end
        if is_mutable_general && number_visited < < length(tree)
            general = parent
        end
