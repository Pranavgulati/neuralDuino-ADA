
package Neuron is
   Nmax        : constant Integer := 8;
   numSynapses : constant Integer := Nmax;

   type Float_Array is array(Integer range<>) of Float;
   type Object is tagged
      record
         output      : Float ;
         beta        : Float ;
   
         synWeight: Float_Array(0..numSynapses):=(others => 1.0);
         prevDeltaWeight:Float_Array(0..numSynapses);
         inputs:Float_Array(0..numSynapses);
         inNodes: Float_Array(0..numSynapses);
      end record;
   type Neuron_Access is access Neuron.Object'Class;
   
   function sigmoid(input:in FLoat) return Float;
   function sigmoidDerivative(input:in FLoat) return Float;             
   function activationFn (input:in Float; isDerivativeFn: in Boolean) return Float;
   procedure setInput(myNeuron: Neuron_Access; inputVals: Float_Array);
   procedure printOutput(myNeuron: Neuron_Access);

end Neuron;
