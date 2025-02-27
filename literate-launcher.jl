using Literate

cd(@__DIR__)

Literate.markdown("HoughTransform.jl";
    credit=false,
    execute=true,
    flavor=Literate.CommonMarkFlavor(),
    mdstrings=true)