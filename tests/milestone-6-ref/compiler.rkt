#lang racket

(require cpsc411/reference/a6-solution)

(provide
 check-values-lang
 uniquify
 sequentialize-let
 normalize-bind
 impose-calling-conventions
 select-instructions
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
 generate-x64)
