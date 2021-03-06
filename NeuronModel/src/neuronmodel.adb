with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with NeuronModel;
with Ada.Numerics.Float_Random;

package body NeuronModel is
   package NumericFunctions is new Ada.Numerics.Generic_Elementary_Functions(Float_Type => Float);

   function sigmoid(input:in FLoat) return Float is
   begin
      return (1.0 / (1.0 + NumericFunctions.Exp((-1.0)*input)));
   end sigmoid;
   function sigmoidDerivative(input:in FLoat) return Float is
   begin
      return (input)*(1.0-input);
   end sigmoidDerivative;
   function activationFn (activationFnValue:ActivationFnType ;input:in Float; isDerivativeFn: in Boolean) return Float is
   begin
      if isDerivativeFn = True then
         case activationFnValue is
            when Linear => return 1.0;
            when Sigmoid => return sigmoidDerivative(input);
         end case;
      else
         case activationFnValue is
            when Linear => return input;
            when Sigmoid => return sigmoidDerivative(input);
         end case;
      end if ;
   end activationFn;
   procedure setActivationFn(myNeuron: Neuron_Access ;activationFnValue:ActivationFnType ) is
   begin
      myNeuron.activationFnValue := activationFnValue;
   end;
   procedure getOutput(myNeuron: Neuron_Access;Result: out Float) is
   sum: Float := 0.0;
   begin
      if myNeuron.inNodeCount /= 0 then
         for i in Integer range 0..myNeuron.inNodeCount-1 loop
            getOutput(myNeuron.inNodes(i),Result);
            sum:= sum+ myNeuron.synWeight(i)*Result;
         end loop;
         myNeuron.output:= activationFn(activationFnValue =>myNeuron.activationFnValue,
                                        input          => sum,
                                        isDerivativeFn => False);
         Result:= myNeuron.output;
      else Result:= myNeuron.output;
      end if;
   end getOutput;
   procedure setDesiredOutput(myNeuron:Neuron_Access; desiredOutput :Float; Result : out Boolean) is
   begin
      myNeuron.beta := desiredOutput - myNeuron.output;
      if (myNeuron.beta * 100.0) < 1.0 and (myNeuron.beta *100.0) > -1.0 then Result := True;
      else Result := False;
      end if;
      Put(myNeuron.beta,Exp => 0,Aft => 1);Put("= desiredOut");New_Line;
   end setDesiredOutput;

   procedure printOutput(myNeuron: Neuron_Access) is
   begin
      Put("output: ");
      Put(myNeuron.output,Aft => 2,Exp => 0);
      Put_Line("");
   end printOutput;
   procedure setInput(myNeuron: Neuron_Access ;inputVals: Float_Array) is
   sum : Float :=0.0;
   begin
      -- because one neuron can either have an input vector or inNodes. Reset inNodeCount
      myNeuron.inNodeCount :=0;
      for i in Integer range 0..numSynapses loop
         myNeuron.inputs(i) := inputVals(i);
         sum := sum + myNeuron.synWeight(i) * inputVals(i);
      end loop;
         myNeuron.output := activationFn(myNeuron.activationFnValue,sum , False);
   end setInput;
   procedure connectInput(myNeuron:Neuron_Access; connectingNeuron:Neuron_Access) is
   begin
      myNeuron.inNodes(myNeuron.inNodeCount) := connectingNeuron;
      myNeuron.inNodeCount:= myNeuron.inNodeCount + 1;
   end connectInput;
   procedure adjustWeights(myNeuron:Neuron_Access) is
   myDelta :Float := myNeuron.beta * activationFn(myNeuron.activationFnValue,myNeuron.output,True);
   begin
      if myNeuron.inNodeCount /= 0 then
         for i in Integer range 0..myNeuron.inNodeCount-1 loop
            declare
               delWeight:Float:= NeuronModel.SPEED * myNeuron.inNodes(i).output * myDelta;
            begin
               myNeuron.synWeight(i) := myNeuron.synWeight(i) + delWeight + ( MOMENTUM * myNeuron.prevDeltaWeight(i));
               myNeuron.prevDeltaWeight(i):= delWeight;
            end;
         end loop;
      else
         for i in Integer range 0..NeuronModel.numSynapses loop
            declare
               delWeight:Float:= (NeuronModel.SPEED * myNeuron.inputs(i) * myDelta);
            begin
               myNeuron.synWeight(i) := myNeuron.synWeight(i) + delWeight + ( MOMENTUM * myNeuron.prevDeltaWeight(i));
               myNeuron.prevDeltaWeight(i):= delWeight;
            end;
         end loop;
      end if;
      myNeuron.beta:=0.0;
   end adjustWeights;
   procedure backpropogate(myNeuron:Neuron_Access) is
   myDelta: Float:= myNeuron.beta * activationFn(myNeuron.activationFnValue,myNeuron.output,True);
   begin
      if myNeuron.inNodeCount /=0 then
         for i in Integer range 0..myNeuron.inNodeCount-1 loop
            --The following backpropogates myDelta to the previous layer neurons
            myNeuron.inNodes(i).beta := myNeuron.inNodes(i).beta + (myNeuron.synWeight(i) * myDelta);
         end loop;
      end if;
   end backpropogate;
   --The following must only be used for neurons that act as a bias neuron and
   --are required to give a fixed output
   procedure setOutput(myNeuron:Neuron_Access; value: Float) is
   begin
      myNeuron.output:= value;
      myNeuron.inNodeCount:=0;
   end setOutput;
   procedure initialize(myNeuron:Neuron_Access) is
      RNG : Ada.Numerics.Float_Random.Generator;
   begin
      myNeuron.inNodeCount:=0;
      myNeuron.output:=0.0;
      myNeuron.beta:=0.0;

      for i in Integer range 0..NeuronModel.numSynapses loop
         myNeuron.synWeight(i):= Ada.Numerics.Float_Random.Random(Gen => RNG)*2.0;
         myNeuron.prevDeltaWeight(i):= 0.0;
         myNeuron.inputs(i) := 0.0;
      end loop;
   end initialize;
   procedure printWeights(myNeuron:Neuron_Access) is
   begin
      for i in Integer range 0..numSynapses loop
         Put(myNeuron.synWeight(i),Exp => 0,Aft => 2);Put(",");
      end loop;
      Put_Line(" = Weights ");
   end printWeights;
   procedure makeOutput(myNeuron:Neuron_Access) is
   sum : Float := 0.0;
   Result : Float :=0.0;
   begin
      if myNeuron.inNodeCount /= 0 then
         for i in Integer range 0..myNeuron.inNodeCount-1 loop
            getOutput(myNeuron.inNodes(i),Result);
            sum:= sum + myNeuron.synWeight(i)*Result;
         end loop;
         myNeuron.output:= activationFn(activationFnValue =>myNeuron.activationFnValue,
                                        input          => sum,
                                        isDerivativeFn => False);
      end if;
      Put(myNeuron.output,Exp => 0,Aft => 2);Put(" = Output ");
   end makeOutput;
end NeuronModel;

