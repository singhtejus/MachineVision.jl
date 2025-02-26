# # Imports
using Pkg
Pkg.activate(".")
using Statistics
using CairoMakie
using CairoMakie.GeometryBasics
using GLMakie
using Plots
using LinearAlgebra

# # Perspective and Orthoginal Projection functions
# Perspective Projection: x' = x * (z'/z), y' = y * (z'/z)
# Orthogonal Projection: x' = x, y' = y

function PerspectiveProj(A::Matrix, z_prime::Float64)
    A = vcat(A, ones(1, size(A, 2)))
    P = zeros(3, size(A, 1))
    P[1,1], P[2,2], P[3,3] = z_prime, z_prime, 1
    
    A_prime = P * A
    A_prime[1, :] .= A_prime[1, :] ./ A_prime[3,:]
    A_prime[2, :] .= A_prime[2, :] ./ A_prime[3,:]
    return A_prime[1:2, :]
end 

function OrthogonalProj(A::Matrix)
    A = vcat(A, ones(1, size(A, 2)))

    P = zeros(3, size(A, 1))
    P[1,1], P[2,2] = 1.0, 1.0  

    A_prime = P * A
    return A_prime[1:2, :]
end

# # Other useful functions
# PlotPolygon: Plots a polygon given its vertices
    # Compute the centroid, Calculates angles of each point relative to the centroid, Sort indices based on angles in descending order for clockwise, Reorder points based on sorted indices.

# ReorderPointsClockwise: Reorders the points of a polygon in clockwise order (required for ShoelaceArea())
    # Compute the centroid, Calculates angles of each point relative to the centroid, Sort indices based on angles in descending order for clockwise.

    # ShoelaceArea: Calculates the area of a polygon using the shoelace formula

function PlotPolygon(points::Matrix{T}) where T <: Real
    
    center = mean(points, dims=2)
    angles = atan.(points[2, :] .- center[2], points[1, :] .- center[1])
    
    sorted_indices = sortperm(angles, rev=true)
    reorderedpoints = points[:, sorted_indices]
    x, y = reorderedpoints[1, :], reordered_points[2, :]
    poly(x, y)
end

function ReorderPointsClockwise(points::Matrix{T}) where T <: Real
    
    center = mean(points, dims=2)
    angles = atan.(points[2, :] .- center[2], points[1, :] .- center[1])
    
    sorted_indices = sortperm(angles, rev=true)
    return points[:, sorted_indices]
end

function ShoelaceArea(points::Matrix)

    center = mean(points, dims=2)
    angles = atan.(points[2, :] .- center[2], points[1, :] .- center[1])

    sorted_indices = sortperm(angles, rev=true)
    reorderedpoints = points[:, sorted_indices]

    n = size(reorderedpoints, 2)
    area = 0.0
    for i in 1:n
        j = rem(i, n) + 1
        area += reorderedpoints[1, i] * reorderedpoints[2, j] - reorderedpoints[1, j] * reorderedpoints[2, i]
    end
    area = abs(area) / 2
    return area
end
    
# # Example
points = [3 3 3 3; 1 4 1 4; -1 -1 -2 -2]
z_prime = 1.0

points_pers_proj = PerspectiveProj(points, z_prime)
space_points_pers = vcat(points_pers_proj, z_prime * ones(1, size(points_pers_proj, 2)))
points_orth_proj = OrthogonalProj(points)
reordered_points = ReorderPointsClockwise(points_pers_proj)
x_pers, y_pers = reordered_points[1, :], reordered_points[2, :]
x_orth, y_orth = points_orth_proj[1, :], points_orth_proj[2, :]
area = ShoelaceArea(points_pers_proj)

PlotPolygon(points_pers_proj)
using Plots
Plots.plot(x_pers, y_pers)

Makie.scatter(x_orth, y_orth)

##################################
function generate_sphere_points(n_theta=30, n_phi=30; r=1.0)
    # Generate spherical coordinates
    theta = range(0, π, length=n_theta)
    phi = range(0, 2π, length=n_phi)
    
    # Convert to Cartesian coordinates
    x = r * sin.(theta) * cos.(phi)'
    y = r * sin.(theta) * sin.(phi)'
    z = r * cos.(theta) * ones(1, n_phi) .+0.5
    
    # Combine into 3×N matrix
    return vcat(vec(x)', vec(y)', vec(z)')
end
points = generate_sphere_points(80, 80; r=0.3)
points_proj = copy(points)
points_proj[3, :] .= 0  # Set z-coordinates to zero

p = scatter3d(
    points[1, :], points[2, :], points[3, :],
    markersize=1.5,
    markerstrokewidth=0,
    label="Original Sphere",
    aspect_ratio= :,
    xlims=(-1.1, 1.1),
    ylims=(-1.1, 1.1),
    zlims=(-0.5, 1.1),
    camera=(30, 20),
    title="Sphere and XY-Projection",
    xlabel="X", ylabel="Y", zlabel="Z",
    color=:blue,
    size=(1200, 800)
)

scatter3d!(
    p,  # Explicitly specify we're adding to plot 'p'
    points_proj[1, :], points_proj[2, :], points_proj[3, :],
    markersize=1.5,
    markerstrokewidth=0,
    label="XY-Projection",
    color=:red
)

display(p)





for i in 10:2:90
    p = scatter3d(
    points[1, :], points[2, :], points[3, :],
    markersize=1.5,
    markerstrokewidth=0,
    label="Original Sphere",
    aspect_ratio=:equal,
    xlims=(-2.1, 2.1),
    ylims=(-2.1, 2.1),
    zlims=(-2.1, 2.1),
    camera=(40, i),
    title="Sphere and XY-Projection",
    xlabel="X", ylabel="Y", zlabel="Z",
    color=:blue,
    size=(1200, 800)
)
scatter3d!(
    p,  # Explicitly specify we're adding to plot 'p'
    points_proj[1, :], points_proj[2, :], points_proj[3, :],
    markersize=1.5,
    markerstrokewidth=0,
    label="XY-Projection",
    color=:red
)
display(p)
sleep(0.05)
end

fig = Figure()
ax = Axis3(fig[1, 1], title="3D Projection to Image Plane", xlabel="X", ylabel="Y", zlabel="Z")

# Plot the original points
scatter!(ax, points[1, :], points[2, :], points[3, :], color=:blue, markersize=10, label="Original Points")
scatter!(ax, space_points_pers[1, :], space_points_pers[2, :], space_points_pers[3, :], color=:red, markersize=10, label="Projected Points")

for i in 1:size(points, 2)
    lines!(ax,
        [points[1, i], space_points_pers[1, i]],  # X-coordinates
        [points[2, i], space_points_pers[2, i]],  # Y-coordinates
        [points[3, i], space_points_pers[3, i]],  # Z-coordinates
        color=:black, linewidth=1, linestyle=:dash)
end

fig
# Plot original 3D points

x = Vec3(1,1,1)






x = 0:0.05:3;
y = 0:0.05:3;
z = @. sin(x) * exp(-(x+y))

fig = Figure(; size=(600, 400))
ax = Axis3(fig[1,1]; limits=((-5,5), (-5,5), (-5,5)),
    perspectiveness = 0.5,
    azimuth = -4.0,
    elevation = 0.3,
    halign = 5)
lines!(Point3f.(x, 0, z), transparency=true)
lines!(Point3f.(0, y, z), transparency=true)
band!(Point3f.(x, y, 0), Point3f.(x, y, z);
    color=(:orangered, 0.25), transparency=true)
lines!(Point3f.(x, y, z); color=(:orangered, 0.9), transparency=true)
fig

p = Polygon(Point2f[(0, 0), (1, 0), (1, 2), (0, 2)])
poly!(p)



original_points = [3 3 3 3; 1 4 1 4; -1 -1 -2 -2]  # (3 x N matrix)

# Transformed points lying on a specific Z-plane
transformed_points = space_points_pers  # (3 x N matrix)

# Close the polygons by repeating the first point at the end
x_orig, y_orig, z_orig = original_points[1, :], original_points[2, :], original_points[3, :]
x_orig = vcat(x_orig, x_orig[1])
y_orig = vcat(y_orig, y_orig[1])
z_orig = vcat(z_orig, z_orig[1])

x_trans, y_trans, z_trans = transformed_points[1, :], transformed_points[2, :], transformed_points[3, :]
x_trans = vcat(x_trans, x_trans[1])
y_trans = vcat(y_trans, y_trans[1])
z_trans = vcat(z_trans, z_trans[1])

# Create the figure and axis
fig = Figure()
ax = Axis3(fig[1, 1], title = "Original and Transformed Polygons", xlabel = "X", ylabel = "Y", zlabel = "Z")

# Plot the original polygon
lines!(ax, x_orig, y_orig, z_orig, color = :blue, linewidth = 2, label = "Original Polygon")

# Plot the transformed polygon
lines!(ax, x_trans, y_trans, z_trans, color = :red, linewidth = 2, label = "Transformed Polygon")

# Add a legend
Legend(fig[1, 2], ax)
fig
