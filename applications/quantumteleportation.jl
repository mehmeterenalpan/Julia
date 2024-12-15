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
	Alices_and_Bobs_entangled_qubits = ArrayReg(bit"00") + ArrayReg(bit"11") |> normalize!
	Alicequbit = rand_state(1) #This function creates a qubit with a random state.
	state(Alicequbit)
end

begin
	teleportationcircuit = chain(3, control(1,2=>X), put(1=>H))
	Yao.plot(teleportationcircuit)
end 
begin
	feeding = join(Alices_and_Bobs_entangled_qubits, Alicequbit) |> teleportationcircuit
	state(feeding)
end


Alices_measuredqubits = measure!(RemoveMeasured(), feeding, 1:2)
if(Alices_measuredqubits == bit"00")
	Bobs_qubit = feeding
elseif(Alices_measuredqubits == bit"01")
	Bobs_qubit = feeding |> chain(1, put(1=>Z))
elseif(Alices_measuredqubits == bit"10")
	Bobs_qubit = feeding |> chain(1, put(1=>X))
else
	Bobs_qubit = feeding |> chain(1, put(1=>Y))
end

state(Bobs_qubit)

[state(Alicequbit) state(Bobs_qubit)]