begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.Registry.update()
	Pkg.add("Yao")
	Pkg.add("YaoPlots")
	Pkg.add("StatsBase")
	Pkg.add("Plots")
	Pkg.add("BitBasis")
end

using Yao, YaoPlots

begin
	singlequbitcircuit = chain(2, put(1=>X))
	Yao.plot(singlequbitcircuit)
end
begin
	bellstate = ArrayReg(bit"00") + ArrayReg(bit"11") |> normalize!
	re = bellstate |> singlequbitcircuit
	state(re)
end

#Measuring qubits in Yao can be done by using the measure function.
#syntax for Measuring: q |> r->measure(r, nshots=number_of_runs)

measuredqubits = (re |> r->measure(r,nshots=1024))


# You don't need to know this:
begin
	using StatsBase: Histogram, fit
	using Plots: bar, scatter!, gr; gr()
	using BitBasis
	function plotmeasure(x::Array{BitStr{n,Int},1}) where n
		hist = fit(Histogram, Int.(x), 0:2^n)
		x = 0
		if(n<=3)
			s=8
		elseif(n>3 && n<=6)
			s=5
		elseif(n>6 && n<=10)
			s=3.2
		elseif(n>10 && n<=15)
			s=2
		elseif(n>15)
			s=1
		end
		bar(hist.edges[1] .- 0.5, hist.weights, legend=:none, size=(600*(2^n)/s,400), ylims=(0:maximum(hist.weights)), xlims=(0:2^n), grid=:false, ticks=false, border=:none, color=:lightblue, lc=:lightblue)
		scatter!(0:2^n-1, ones(2^n,1), markersize=0,
         series_annotations="|" .* string.(hist.edges[1]; base=2, pad=n) .* "⟩")
		scatter!(0:2^n-1, zeros(2^n,1) .+ maximum(hist.weights), markersize=0,
         series_annotations=string.(hist.weights))
	end
end

plotmeasure(measuredqubits)

#Implementing superdense coding

begin 
    Alice_and_Bobs_entangled_qubits = ArrayReg(bit"00") + ArrayReg(bit"11") |> normalize!
    input = ["00","01","10","11"][rand(1:4)]
end

state(Alice_and_Bobs_entangled_qubits)


begin
    if(input == "00")
        Alices_circuit = chain(2)
	elseif(input == "01")
		Alices_circuit = chain(2, put(1=>X))
	elseif(input == "10")
		Alices_circuit = chain(2, put(1=>Z))
	elseif(input == "11") 
		Alices_circuit = chain(2, put(1=>Y))
	end
	Yao.plot(Alices_circuit)
end
reversebellcircuit = chain(2, control(1,2=>X), put(1=>H))
Bobs_part = ((Alice_and_Bobs_entangled_qubits |> Alices_circuit) |> reversebellcircuit) |> r->measure(r, nshots=1024)