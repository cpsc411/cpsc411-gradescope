#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt")

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var FACT_S from "fact.rkt")
(define-var compile from "fact.rkt")
(define-var execute from "fact.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html

(define-test-suite a0-test-suite
  (test-case ""
    (check-regexp-match
     #rx"2\\.(13|14|15)"
     (with-output-to-string (thunk (system "nasm --version")))))

  (test-case ""
    (check-regexp-match
     #rx"\\.exe"
     (compile FACT_S)))

  (test-equal? "" (execute FACT_S) 120))

;; Naturally, use the same suite name here.

(generate-results a0-test-suite)
