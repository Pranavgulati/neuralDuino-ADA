with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;use Ada.Integer_Text_IO;
with NeuronModel; use NeuronModel;
procedure main is
   numNeurons: Integer := 7;
   neuronArray :Neuron_Access_Array(0..numNeurons):= (others => new NeuronModel.Object);
   inputVector: Float_Array(0..NeuronModel.numSynapses):= (2|3=>4.0 ,others=>1.0);

   procedure learn is
      output : Float_Array(0..3) := (0.0,0.0,0.0,1.0);
      input1 : Float_Array(0..3) := (0.0,0.0,1.0,1.0);
      input2 : Float_Array(0..3) := (0.0,1.0,0.0,1.0);
      Result : Boolean;
   begin
      for i in Integer range 0..3000 loop
         for k in Integer range 0..3 loop
            NeuronModel.setOutput(neuronArray(1),input1(k));
            NeuronModel.setOutput(neuronArray(2),input2(k));

            NeuronModel.makeOutput(myNeuron => neuronArray(5));
            NeuronModel.setDesiredOutput(myNeuron      => neuronArray(5),
                                         desiredOutput => output(k),
                                         Result => Result);

            NeuronModel.backpropogate(neuronArray(5));
            NeuronModel.adjustWeights(neuronArray(5));
            NeuronModel.adjustWeights(neuronArray(4));
            NeuronModel.adjustWeights(neuronArray(3));

         end loop;
      end loop;

   end learn;

begin
   for i in Integer range 0..5 loop
      initialize(neuronArray(i));
   end loop;
   --Make the connections between neurons
   NeuronModel.connectInput(myNeuron         => neuronArray(5),
                            connectingNeuron => neuronArray(3));
   NeuronModel.connectInput(myNeuron         => neuronArray(5),
                            connectingNeuron => neuronArray(4));
   NeuronModel.connectInput(myNeuron         => neuronArray(5),
                            connectingNeuron => neuronArray(6));
   NeuronModel.connectInput(myNeuron         => neuronArray(4),
                            connectingNeuron => neuronArray(1));
   NeuronModel.connectInput(myNeuron         => neuronArray(4),
                            connectingNeuron => neuronArray(2));
   NeuronModel.connectInput(myNeuron         => neuronArray(4),
                            connectingNeuron => neuronArray(6));
   NeuronModel.connectInput(myNeuron         => neuronArray(3),
                            connectingNeuron => neuronArray(1));
   NeuronModel.connectInput(myNeuron         => neuronArray(3),
                            connectingNeuron => neuronArray(2));
   NeuronModel.connectInput(myNeuron         => neuronArray(3),
                            connectingNeuron => neuronArray(6));
   NeuronModel.setOutput(myNeuron => neuronArray(6),
                         value    => 1.0);
   Put_Line("Setup done");

   Put(neuronArray(5).inNodeCount);
   Put(neuronArray(5).inNodes(0).synWeight(0));
   Put(neuronArray(3).synWeight(0));
      learn;
end main;

