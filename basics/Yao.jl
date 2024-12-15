begin
    using Pkg
    Pkg.activate(tempdir())
    Pkg.add("Yao")
    Pkg.add("YaoPlots")
end

using Yao, YaoPlots
let 
    # Basic Usage of 'X' circuit for 2 Qubits
    circuit = chain(2, put(1=>X), put(2=>X))
    Yao.plot(circuit)
    #assume that we have 5 qubits who are going to enter 'X' circuit:
    circuit_2 = chain(5,repeat(X,1:5))
    Yao.plot(circuit_2)
    # But What about 'Y' and 'Z' circuits?
    circuit_3 = chain(3, put(1=>Y), put(2=>Z), put(3=>H), repeat(Y, 1:2), repeat(Z, 1:2), repeat(H, [1 3]))
	Yao.plot(circuit_3)
    #What about multiqubit gates...
    Yao.plot(chain(2,control(1, 2=>X)))

end