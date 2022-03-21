#lang racket

(require cpsc411/reference/a8-solution)

(provide
 uniquify
 implement-safe-primops
 specify-representation
 remove-complex-opera*
 sequentialize-let
 normalize-bind
 impose-calling-conventions
 select-instructions
 expose-allocation-pointer
 uncover-locals
 undead-analysis
 conflict-analysis
 assign-call-undead-variables
 allocate-frames
 assign-registers
 replace-locations
 assign-frame-variables
 implement-fvars
 optimize-predicates
 expose-basic-blocks
 resolve-predicates
 flatten-program
 patch-instructions
 implement-mops
 generate-x64)
