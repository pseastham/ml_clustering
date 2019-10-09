using Clustering, Plots
# Clustering docs: http://juliastats.github.io/Clustering.jl/stable/algorithms.html

#fsize=20
#gr(label="",xlim=(0,1),ylim=(0,1),ratio=:equal,
#        ms=10,msw = 0,size=(1600,800),xtickfont=font(fsize),
#        ytickfont=font(fsize),guidefont=font(fsize),
#        legendfont=font(fsize),titlefont=font(fsize))
gr(label="",ratio=:equal)

function generateData(c1,c2,M)
        d=2             # dimension of data
        Md2 = Int(M/2)
        data = rand(d,M)
        data[:,1:Md2] = c1*ones(d,Md2) .+ 0.25*(2*rand(d,Md2) .- 1)
        data[:,Md2+1:M] = c2*ones(d,Md2) .+ 0.25*(2*rand(d,Md2) .- 1)

        return data
end

function plot_kmeans(data,k)
        _,M=size(data)

        # perform k-means clustering
        K=kmeans(data, k)
        μ=K.centers
        c = counts(K)
        a = assignments(K)

        # visualize
        k<=5 || error("need $(k) colors, only 5 defined")
        cArr=[:blue,:red,:purple,:pink,:cyan]
        p1 = plot(title="k-means")
        # plot data
        for i=1:M
                scatter!(p1,[data[1,i]],[data[2,i]],color=cArr[a[i]])
        end

        # plot means
        for i=1:k
                scatter!(p1,[μ[1,i]],[μ[2,i]],color=cArr[i],
                        label=string("mu ",i," (",c[i],")"),
                        ms=10,legend=:topleft,msw = 3)
        end
        plot(p1)
end

function plot_hierarchy(data,K)
        _,M=size(data)

        # find hierarchical clustering
        D = zeros(M,M)
        for i=1:M, j=(i+1):M
                D[i,j] = sqrt((data[1,i]-data[1,j])^2+(data[2,i]-data[2,j])^2)
                D[j,i] = D[i,j]
        end
        H=hclust(D, linkage=:single)
        a=cutree(H; k=K)
        
        # visualize
        K<=5 || error("need $(K) colors, only 5 defined")
        cArr=[:blue,:red,:purple,:pink,:cyan]

        # plot hierarchical clustering
        p2 = plot(title="hierarchical")
        # plot data
        for i=1:M
                scatter!(p2,[data[1,i]],[data[2,i]],color=cArr[a[i]])
        end
        plot(p2)
end

function plot_comparison(data,k)
        _,M=size(data)

        # perform k-means clustering
        K=kmeans(data, k)
        μ=K.centers
        c = counts(K)
        a = assignments(K)

        # visualize
        k<=5 || error("need $(k) colors, only 5 defined")
        cArr=[:blue,:red,:purple,:pink,:cyan]
        p1 = plot(title="k-means")
        # plot data
        for i=1:M
                scatter!(p1,[data[1,i]],[data[2,i]],color=cArr[a[i]])
        end

        # plot means
        for i=1:k
                scatter!(p1,[μ[1,i]],[μ[2,i]],color=cArr[i],
                        label=string("mu ",i," (",c[i],")"),
                        ms=10,legend=:topleft,msw = 3)
        end

        # find hierarchical clustering
        D = zeros(M,M)
        for i=1:M, j=(i+1):M
                D[i,j] = sqrt((data[1,i]-data[1,j])^2+(data[2,i]-data[2,j])^2)
                D[j,i] = D[i,j]
        end
        H=hclust(D, linkage=:single)
        a=cutree(H; k=k)

        # plot hierarchical clustering
        p2 = plot(title="hierarchical")
        # plot data
        for i=1:M
                scatter!(p2,[data[1,i]],[data[2,i]],color=cArr[a[i]])
        end

        plot(p1,p2,layout=(1,2))
end