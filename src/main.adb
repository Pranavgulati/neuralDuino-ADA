with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;use Ada.Integer_Text_IO;
with NeuronModel; use NeuronModel;
procedure main is
   numNeurons: Integer := 7;
   neuronArray: Neuron_Array(0..numNeurons);
   neuronAccessArray : Neuron_Access_Array(0..numNeurons);
   output : Float_Array(0..3) := (0.0,0.0,0.0,1.0);
   input1 : Float_Array(0..3) := (0.0,0.0,1.0,1.0);
   input2 : Float_Array(0..3) := (0.0,1.0,0.0,1.0);
   procedure test is
   begin
      for i in Natural range 0..3 loop
      NeuronModel.setOutput(neuronAccessArray(1),input1(i));
      NeuronModel.setOutput(neuronAccessArray(2),input2(i));
      declare
         Result : Float;
      begin
         NeuronModel.getOutput(neuronAccessArray(1),Result => Result);
         Put(Result,Exp => 0,Aft => 1); Put(" ");
         NeuronModel.getOutput(neuronAccessArray(2),Result => Result);
         Put(Result,Exp => 0,Aft => 1); Put(" ");
         NeuronModel.getOutput(neuronAccessArray(5),Result => Result);
         Put(Result,Exp => 0,Aft => 1);New_Line;
      end;
   end loop;
   New_Line;
   end test;
   procedure learn is
      output : Float_Array(0..3) := (0.0,0.0,0.0,1.0);
      input1 : Float_Array(0..3) := (0.0,0.0,1.0,1.0);
      input2 : Float_Array(0..3) := (0.0,1.0,0.0,1.0);
      Result : Boolean;
   begin
      for i in Integer range 0..10 loop
            Put(i);Put(" iter ");
         for k in Integer range 0..3 loop
            NeuronModel.setOutput(neuronAccessArray(1),input1(k));
            NeuronModel.setOutput(neuronAccessArray(2),input2(k));

            NeuronModel.makeOutput(myNeuron => neuronAccessArray(5));
            NeuronModel.setDesiredOutput(myNeuron      => neuronAccessArray(5),
                                         desiredOutput => output(k),
                                         Result => Result);

            NeuronModel.backpropogate(neuronAccessArray(5));
            NeuronModel.adjustWeights(neuronAccessArray(5));
            NeuronModel.adjustWeights(neuronAccessArray(4));
            NeuronModel.adjustWeights(neuronAccessArray(3));
         end loop;
--         NeuronModel.printWeights(neuronAccessArray(4));
      end loop;
   end learn;

begin

   for i in Integer range 0..numNeurons loop
      neuronAccessArray(i) := neuronArray(i)'Unchecked_Access;
      initialize(neuronAccessArray(i));
   end loop;
   NeuronModel.setActivationFn(neuronAccessArray(6),Sigmoid);
   NeuronModel.setActivationFn(neuronAccessArray(5),Sigmoid);
   NeuronModel.setActivationFn(neuronAccessArray(4),Sigmoid);
   NeuronModel.setActivationFn(neuronAccessArray(3),Sigmoid);
   NeuronModel.setActivationFn(neuronAccessArray(2),Linear);
   NeuronModel.setActivationFn(neuronAccessArray(1),Linear);
   --Make the connections between neurons
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(5),
                            connectingNeuron => neuronAccessArray(3));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(5),
                            connectingNeuron => neuronAccessArray(4));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(5),
                            connectingNeuron => neuronAccessArray(6));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(4),
                            connectingNeuron => neuronAccessArray(1));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(4),
                            connectingNeuron => neuronAccessArray(2));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(4),
                            connectingNeuron => neuronAccessArray(6));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(3),
                            connectingNeuron => neuronAccessArray(1));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(3),
                            connectingNeuron => neuronAccessArray(2));
   NeuronModel.connectInput(myNeuron         => neuronAccessArray(3),
                            connectingNeuron => neuronAccessArray(6));
   NeuronModel.setOutput(myNeuron => neuronAccessArray(6),
                         value    => 1.0);
   Put_Line("Setup done");

   test;
   test;
   learn;


end main;

