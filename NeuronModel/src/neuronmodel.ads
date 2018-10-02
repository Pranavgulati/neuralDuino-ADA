
package NeuronModel is
   Nmax        : constant Integer := 3;
   numSynapses : constant Integer := Nmax;
   SPEED       : constant Float   := 0.4;
   MOMENTUM    : constant Float   := 0.4;
   type Object;
   type Neuron;
   type Neuron_Access is access all Neuron;
   type Neuron_Access_Array is array (Natural range <>) of aliased Neuron_Access;
   type Float_Array is array(Integer range<>) of Float;
   type Object is 
      record
         output      : Float ;
         beta        : Float ;
         inNodeCount : Integer;
   
         synWeight: Float_Array(0..numSynapses):=(others => 1.0);
         prevDeltaWeight:Float_Array(0..numSynapses);
         inputs: Float_Array(0..numSynapses);
         inNodes: Neuron_Access_Array(0..numSynapses);
      end record;
   type Neuron is new NeuronModel.Object;
   type Neuron_Array is array (Natural range<>) of aliased Neuron;

   
   function sigmoid(input:in FLoat) return Float;
   function sigmoidDerivative(input:in FLoat) return Float;             
   function activationFn (input:in Float; isDerivativeFn: in Boolean) return Float;
   
   procedure getOutput(myNeuron: Neuron_Access ;Result: out Float);
   procedure setDesiredOutput(myNeuron:Neuron_Access; desiredOutput :Float;Result:out Boolean); 
   
   procedure printOutput(myNeuron: Neuron_Access);
   procedure setInput(myNeuron: Neuron_Access; inputVals: Float_Array);
   procedure connectInput(myNeuron:Neuron_Access; connectingNeuron:Neuron_Access);
   procedure adjustWeights(myNeuron:Neuron_Access) ;
   procedure backpropogate(myNeuron:Neuron_Access);
   procedure setOutput(myNeuron:Neuron_Access; value: Float) ;
   procedure initialize(myNeuron:Neuron_Access);
   procedure printWeights(myNeuron :Neuron_Access);
   
   procedure makeOutput(myNeuron:Neuron_Access);
end NeuronModel;
