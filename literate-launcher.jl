using Literate

cd(@__DIR__)

Literate.markdown("KernelFilters.jl";
    credit=false,
    execute=true,
    flavor=Literate.CommonMarkFlavor(),
    mdstrings=true)