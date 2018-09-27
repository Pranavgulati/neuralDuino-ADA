with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Neuron;
package body Neuron is
   package NumericFunctions is new Ada.Numerics.Generic_Elementary_Functions(Float_Type => Float);

   function sigmoid(input:in FLoat)
                    return Float is
               begin
                  return (1.0 / (1.0 + NumericFunctions.Exp((-1.0)*input)));
               end sigmoid;

   function sigmoidDerivative(input:in FLoat)
                    return Float is
               begin
                  return (input)*(1.0-input);
               end sigmoidDerivative;
   function activationFn (input:in Float; isDerivativeFn: in Boolean)
                          return Float is
               begin
                  if isDerivativeFn = True then
                     return sigmoid(input);
                  else return sigmoidDerivative(input);
                  end if ;
               end activationFn;


   procedure setInput(myNeuron: Neuron_Access ;inputVals: Float_Array) is
   sum : Float :=0.0;
  -- set inCOunt =0
   begin
      for i in Integer range 0..numSynapses loop
         myNeuron.inputs(i) := inputVals(i);
         sum := sum + myNeuron.synWeight(i) * inputVals(i);
      end loop;
         myNeuron.output := activationFn(sum , False);
   end setInput;

   procedure printOutput(myNeuron: Neuron_Access) is
   begin
      Put("output: ");
      Put(myNeuron.output,Aft => 2,Exp => 0);
      Put_Line("");
   end printOutput;

end Neuron;
