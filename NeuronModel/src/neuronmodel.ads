
package NeuronModel is
   Nmax        : constant Integer := 8;
   numSynapses : constant Integer := Nmax;
   SPEED       : constant Float   := 0.1;
   MOMENTUM    : constant Float   := 0.1;
   type Object;
   type Float_Array is array(Integer range<>) of Float;
   type Neuron_Access is access NeuronModel.Object'Class;
   type Neuron_Access_Array is array (Integer range <>) of Neuron_Access;
   type Object is tagged
      record
         output      : Float ;
         beta        : Float ;
         inNodeCount : Integer;
   
         synWeight: Float_Array(0..numSynapses):=(others => 1.0);
         prevDeltaWeight:Float_Array(0..numSynapses);
         inputs: Float_Array(0..numSynapses);
         inNodes: Neuron_Access_Array(0..numSynapses);
      end record;

   
   function sigmoid(input:in FLoat) return Float;
   function sigmoidDerivative(input:in FLoat) return Float;             
   function activationFn (input:in Float; isDerivativeFn: in Boolean) return Float;
   function getOutput(myNeuron: Neuron_Access) return Float;
   function setDesiredOutput(myNeuron:Neuron_Access; desiredOutput :Float) return Boolean;
   
   
   procedure printOutput(myNeuron: Neuron_Access);
   procedure setInput(myNeuron: Neuron_Access; inputVals: Float_Array);
   procedure connectInput(myNeuron:Neuron_Access; connectingNeuron:Neuron_Access);


end NeuronModel;
