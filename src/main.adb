
with Ada.Text_IO; use Ada.Text_IO;
with NeuronModel; use NeuronModel;

procedure Main is
   type Neurons is array(Integer range <>) of NeuronModel.Neuron_Access;
   numNeurons: Integer := NeuronModel.numSynapses;
   neuronArray :Neurons(0..numNeurons):= (others => new NeuronModel.Object);
   inputVector: Float_Array(0..NeuronModel.numSynapses):= (2|3=>4.0 ,others=>1.0);
begin
   for i in Integer range 0..numNeurons loop
      NeuronModel.setInput(myNeuron  => neuronArray(i),
                      inputVals => inputVector);
      NeuronModel.printOutput(myNeuron => neuronArray(i));

      inputVector(i mod NeuronModel.numSynapses) := Float(i);
   end loop;

end Main;
