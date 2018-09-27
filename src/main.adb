
with Ada.Text_IO; use Ada.Text_IO;
with Neuron; use Neuron;

procedure Main is
   type Neurons is array(Integer range <>) of Neuron_Access;
   numNeurons: Integer := Neuron.numSynapses;
   neuronArray :Neurons(0..numNeurons):= (others => new Neuron.Object);
   inputVector: Float_Array(0..Neuron.numSynapses):= (2|3=>4.0 ,others=>1.0);
begin
   for i in Integer range 0..numNeurons loop
      Neuron.setInput(myNeuron  => neuronArray(i),
                      inputVals => inputVector);
      Neuron.printOutput(myNeuron => neuronArray(i));

      inputVector(i mod Neuron.numSynapses) := Float(i);
   end loop;

end Main;
