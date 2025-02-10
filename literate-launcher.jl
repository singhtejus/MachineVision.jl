using Literate

cd(@__DIR__)

Literate.markdown("EdgeDetection.jl";
    credit=false,
    execute=true,
    flavor=Literate.CommonMarkFlavor(),
    mdstrings=true)