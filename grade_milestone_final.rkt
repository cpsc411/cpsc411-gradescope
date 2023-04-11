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
    #;[(dynamic-require '(file "/autograder/submission/compiler.rkt") 'expand-macros (thunk #f))
     '10]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'convert-closures (thunk #f))
     '9]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'expose-allocation-pointer (thunk #f))
     '8]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'specify-representation (thunk #f))
     '7]
    [(dynamic-require '(file "/autograder/submission/compiler.rkt") 'allocate-frames (thunk #f))
     '6]
    [else #f]))

(cond
  [(detect-final-milestone)
   =>
   (lambda (m)
     (produce-report/exit
      (let* ([h1 (dynamic-require `(file ,(format "/autograder/source/grade_milestone_~a.rkt" m))
                                  'test-suite-hash)]
             [grade (number->string
                      (exact->inexact
                       ;; Final implementation score is 60/60
                       (* 60
                          (/ (string->number (hash-ref h1 'score "0"))
                             100))))])
        (hash-set
         h1
         'score grade
         'output (string-join
                  (list
                   (hash-ref h1 'output "")
                   (format
                    "I see that you're submitting milestone ~a; if this is not correct, please contact the instructor.\n"
                    m)
                   (format
                    "Your current implementation grade is: ~a out of 60\n" grade))
                  "\n")))))]
  [else
   (produce-report/exit
    `#hasheq((score . "0")
             (output . "You have not submitted at least milestone 6.")))])
