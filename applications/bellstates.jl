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

# In this document we will discuss a few applications of qubits & quantum circuits


#1)Bell States - made with bell circuits
begin 
    bellcircuit = chain(2,put(1=>H),control(1, 2=>X))
    Yao.plot(bellcircuit)
end

# As you can see, the circuit takes in two qubits as input, and operates on them to give the bell states.

# 1.1)Feeding qubits to a circuit in Yao

##creating the system of two qubits with state |00>.
q1 = ArrayReg(bit"00")

#state of a qubit in vector form
state(q1)


#Let's try feeding the qubits to the Bell circuit we made!

a = (q1 |> bellcircuit) # passing the q1 through bellcircuit.
state(a)


#2) Reverse Bell Circuit
begin
	reversebellcircuit = chain(2, control(1,2=>X), put(1=>H))
	Yao.plot(reversebellcircuit)
end

res = (a|> reversebellcircuit)
state(res)

#What do you think is the effect of single qubit gates on a qubit?

begin
    singlequbitcircuit = chain(2, put(1=>X))
    Yao.plot(singlequbitcircuit)
end

begin
    bellstate = ArrayReg(bit"00") + ArrayReg(bit"11") |> normalize!
    re = (bellstate |> singlequbitcircuit)
    state(re)
end