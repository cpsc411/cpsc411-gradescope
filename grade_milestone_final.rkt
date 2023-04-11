#lang racket

(require
 racket/hash
 "lib-grade.rkt")

;; Valid final project:
;; - '10
;; - '9
;; - '8
;; - '7

(define (detect-final-milestone)
  (cond
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'expand-macros (thunk #f))
     '10]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'convert-closures (thunk #f))
     '9]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'expose-allocation-pointer (thunk #f))
     '8]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'specify-representation (thunk #f))
     '7]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'assign-frames (thunk #f))
     '6]
    [else #f]))

(cond
  [(detect-final-milestone)
   =>
   (lambda (m)
     (produce-report/exit
      (hash-union
       ;; TODO
       (dynamic-require `(file ,(format "/autograder/source/grade_milestone_~a.rkt" m))
                        'test-suite-hash)
       `#hasheq((score . "0")
                (output .
                        ,(format "I see that you're submitting milestone ~a; if this is not correct, please contact the instructor.\n"
                                 m)))
       #:combine/key (lambda (k a b)
                       (cond
                         [(eq? k 'score)
                          ;; Final implementation score is 60/60
                          (number->string
                           (exact->inexact
                            (* 60
                               (/ (max (string->number a) (string->number b))
                                  100))))]
                         [(eq? k 'output)
                          (string-append a b)])))))]
  [else
   (produce-report/exit
    `#hasheq((score . "0")
             (output . "You have not submitted at least milestone 6.")))])
