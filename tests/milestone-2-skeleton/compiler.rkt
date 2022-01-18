#lang racket

(require
 cpsc411/compiler-lib
 cpsc411/2c-run-time)

(provide
 check-values-lang
 uniquify
 sequentialize-let
 normalize-bind
 select-instructions
 uncover-locals
 assign-fvars
 replace-locations
 assign-homes
 flatten-begins
 patch-instructions
 implement-fvars
 check-paren-x64
 generate-x64

 interp-values-lang

 interp-paren-x64)

;; STUBS; delete when you've begun to implement the passes or replaced them with
;; your own stubs.
(define-values (check-values-lang
                interp-values-lang
                uniquify
                sequentialize-let
                normalize-bind
                ;select-instructions
                assign-homes
                uncover-locals
                assign-fvars
                replace-locations
                flatten-begins
                patch-instructions
                implement-fvars
                check-paren-x64
                ;generate-x64
                )
  (values
   values
   values
   values
   values
   ; values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   ;values
   ))

;; TODO: Fill in.
;; You might want to reuse check-paren-x64 and generate-x64 from milestone-1

(define (select-instructions p)

  ; (Imp-cmf-lang-v3 value) -> (List-of (Asm-lang-v2 effect)) and (Asm-lang-v2 aloc)
  ; Assigns the value v to a fresh temporary, returning two values: the list of
  ; statements the implement the assignment in Loc-lang, and the aloc that the
  ; value is stored in.
  (define (assign-tmp v)
    (TODO "Consider implementing assign-tmp."))

  (define (select-tail e)
    (TODO "Implement select-tail"))

  (define (select-value e)
    (TODO "Implement select-value"))

  (define (select-effect e)
    (TODO "Implement select-value"))

  (match p
    [`(module ,tail)
     `(module () ,(select-tail tail))]))

(define (interp-paren-x64 p)
  ; Environment (List-of (paren-x64-v2 Statements)) -> Integer
  (define (eval-instruction-sequence env sls)
    (if (empty? sls)
        (dict-ref env 'rax)
        (TODO "Implement the fold over a sequence of Paren-x64-v2 /s/.")))

  ; Environment Statement -> Environment
  (define (eval-statement env s)
    (TODO "Implement the transition function evaluating a Paren-x64-v2 /s/."))

  ; (Paren-x64-v2 binop) -> procedure?
  (define (eval-binop b)
    (TODO "Implement the interpreter for Paren-x64-v2 /binop/."))

  ; Environment (Paren-x64-v2 triv) -> Integer
  (define (eval-triv regfile t)
    (TODO "Implement the interpreter for Paren-x64-v2 /triv/."))

  (TODO "Implement the interpreter for Paren-x64-v2 /p/."))

(define (generate-x64 p)
  (define (program->x64 p)
    (match p
      [`(begin ,s ...)
       (TODO "generate-x64")]))

  (define (statement->x64 s)
    (TODO "generate-x64"))

  (define (loc->x64 loc)
    (TODO "generate-x64"))

  (define (binop->ins b)
    (TODO "generate-x64"))

  (program->x64 p))

(current-pass-list
 (list
  check-values-lang
  uniquify
  sequentialize-let
  normalize-bind
  select-instructions
  assign-homes
  flatten-begins
  patch-instructions
  implement-fvars
  generate-x64
  wrap-x64-run-time
  wrap-x64-boilerplate))

(module+ test
  (require
   rackunit
   rackunit/text-ui
   cpsc411/test-suite/public/v3
   ;; NB: Workaround typo in shipped version of cpsc411-lib
   (except-in cpsc411/langs/v3 values-lang-v3)
   cpsc411/langs/v2)

  (run-tests
   (v3-public-test-sutie
    (current-pass-list)
    (list
     interp-values-lang-v3
     interp-values-lang-v3
     interp-values-unique-lang-v3
     interp-imp-mf-lang-v3
     interp-imp-cmf-lang-v3
     interp-asm-lang-v2
     interp-nested-asm-lang-v2
     interp-para-asm-lang-v2
     interp-paren-x64-fvars-v2
     interp-paren-x64-v2
     #f #f))))
