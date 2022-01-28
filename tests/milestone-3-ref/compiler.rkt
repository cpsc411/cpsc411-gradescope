#lang racket

(require cpsc411/reference/a3-solution)

(provide
 check-values-lang
 uniquify
 sequentialize-let
 normalize-bind
 select-instructions
 uncover-locals
 undead-analysis
 conflict-analysis
 assign-registers
 replace-locations
 assign-homes-opt
 flatten-begins
 patch-instructions
 implement-fvars
 check-paren-x64
 generate-x64)
