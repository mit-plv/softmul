(* Prints hex to stdout, intended to be redirected to a .hex file *)
Require Import compiler.SeparationLogic.
Require Import softmul.SoftmulTop.
Require Import bedrock2.Hexdump.
Open Scope hexdump_scope.
Set Printing Width 100.
Goal True. let r := eval cbv in softmul_binary in idtac r. Abort.
