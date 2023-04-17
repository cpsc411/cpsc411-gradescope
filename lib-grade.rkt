#lang racket

(require lang/prim)
(require rackunit)
(require json)
(require racket/hash)
(require racket/exn)

(provide produce-report/exit define-var generate-results generate-results/hash)

(provide mirror-macro)

(define (produce-report/exit grade-hash)
  (with-output-to-file "/autograder/results/results.json"
    #:exists 'replace
    (lambda ()
      (write-json grade-hash)))
  (exit))

(define-syntax define-var
  (syntax-rules (from)
    [(_ var-name from base-filename)
     (define var-name
       (with-handlers ([exn:fail?
                        (lambda (e)
                          (produce-report/exit
                           `#hasheq((score . 0)
                                    (output . ,(string-append "Run failed with error\n"
                                                              (exn-message e))))))])
         (define bfn base-filename)
         (define filename (string-append "/autograder/submission/" bfn))
         (if (file-exists? filename)
             (with-handlers ([exn:fail?
                              (lambda (e)
                                (produce-report/exit
                                 `#hasheq((score . 0)
                                          (output . ,(string-append "Loading failed with error\n"
                                                                    (exn-message e))))))])
               (dynamic-require `(file ,filename) 'var-name
                                (thunk
                                 (dynamic-require `(file ,filename) #f)
                                 (define ns (module->namespace `(file ,filename)))
                                 (eval `(,#'first-order->higher-order var-name) ns))))
             (produce-report/exit
              `#hasheq((score . 0)
                       (output . ,(string-append "File " bfn " not found: please check your submission")))))))]))

(define-syntax mirror-macro
  (syntax-rules (from)
    [(_ macro-name from base-filename)
     (define-syntax macro-name
       (syntax-rules ()
         [(_ E (... ...))
          (with-handlers ([exn:fail?
                           (lambda (e)
                             (produce-report/exit
                              `#hasheq((score . 0)
                                       (output . ,(string-append "Run failed with error\n"
                                                                 (exn-message e))))))])
            (define bfn base-filename)
            (define filename (string-append "/autograder/submission/" bfn))
            (if (file-exists? filename)
                (with-handlers ([exn:fail?
                                 (lambda (e)
                                   (produce-report/exit
                                    `#hasheq((score . 0)
                                             (output . ,(string-append "Loading failed with error\n"
                                                                       (exn-message e))))))])
                  (eval '(macro-name E (... ...))
                        (module->namespace
                         (begin
                           (dynamic-require `(file , filename) #f)
                           `(file ,filename)))))
                (produce-report/exit
                 `#hasheq((score . 0)
                          (output . ,(string-append "File " bfn " not found: please check your submission"))))))]))]))

(define (generate-results test-suite [score-out-of-f
                                      (lambda (total-tests) total-tests)])
  (produce-report/exit
   (generate-results/hash
    test-suite
    score-out-of-f)))

(define (generate-results/hash test-suite [score-out-of-f
                                           (lambda (total-tests) total-tests)])
  (struct fold-state (success-names
                      ; (Listof test-result?) x (Listof String)
                      error-results error-names
                      ; (Listof test-result?) x (Listof String)
                      failure-results failure-names
                      names) #:transparent)

  (define init-state (fold-state (list) (list) (list) (list) (list) (list)))

  (define (push-suite-name name state)
    (struct-copy fold-state state [names (cons name (fold-state-names state))]))

  (define (pop-suite-name name state)
    (struct-copy fold-state state [names (rest (fold-state-names state))]))

  (define (make-name state result)
    (define new-name
      (string-join
       (filter (lambda (s) (and s (not (equal? s ""))))
               (append (reverse (fold-state-names state)) (list (test-result-test-case-name result))))
       ":"))
    (if (equal? new-name "")
        #f
        new-name))

  (define (add-error state result)
    (struct-copy fold-state
                 state
                 [error-names (cons (make-name state result)
                                    (fold-state-error-names state))]
                 [error-results (cons result (fold-state-error-results state))]))

  (define (add-failure state result)
    (struct-copy fold-state
                 state
                 [failure-names (cons (make-name state result)
                                      (fold-state-failure-names state))]
                 [failure-results (cons result (fold-state-failure-results state))]))

  (define (add-success state result)
    (struct-copy fold-state
                 state
                 [success-names (cons (make-name state result)
                                  (fold-state-success-names state))]))

  (define (add-result result state)
    (cond
      [(test-failure? result)
       (add-failure state result)]
      [(test-error? result)
       (add-error state result)]
      [(test-success? result)
       (add-success state result)]))

  (define (fold-state-total-results state)
    (+
     (length (fold-state-success-names state))
     (length (fold-state-error-names state))
     (length (fold-state-failure-names state))))

  (define ((make-failure-hash type) name the-exn)
    (define short-name
      (if name
          name
          "Unnamed test"))
    (define rendered-output
      (if name
          (format "~a test named «~a»" type name)
          (format "~a unnamed test" type)))
    (list
     `#hasheq((name . ,short-name)
              (status . "failed")
              (output . ,rendered-output))
     `#hasheq((name . ,(format "Debug for ~a" short-name))
              (visibility . "hidden")
              (output . ,(let ([p (open-output-string)])
                           (parameterize ([current-error-port p]
                                          [current-output-port p])
                             ((current-check-handler) the-exn))
                           (get-output-string p))))))

  (let* ([start-memory (current-memory-use 'cumulative)]
         [start-time (current-milliseconds)]
         [test-results (fold-test-results add-result init-state test-suite
                                          #:fdown push-suite-name
                                          #:fup pop-suite-name)]
         [end-time (current-milliseconds)]
         [real-time (- end-time start-time)]
         [end-memory (current-memory-use 'cumulative)]
         [memory-usage (exact->inexact (/ (- end-memory start-memory) (* 1024 1024)))]
         [total-tests-run (fold-state-total-results test-results)]
         [total-tests-possible (score-out-of-f total-tests-run)]
         [raw-score (* 100
                       (/ (length (fold-state-success-names test-results))
                          total-tests-possible))]
         [score-str (number->string (exact->inexact raw-score))])
    (hash-union
     `#hasheq((total-tests-possible . ,total-tests-possible)
              (total-tests-run . ,total-tests-run)
              #;(leaderboard . (#hasheq((name . "Compile Time (real time ms)")
                                        (value . ,real-time))
                                #hasheq((name . "Compile-time Memory Usage (MB)")
                                        (value . ,memory-usage)))))

     (if (= raw-score 100)
         `#hasheq((score . "100")
                  (output . "Looks shipshape, all tests passed, mate!"))
         (hash-union
          (if (or
               (> raw-score 100)
               (> total-tests-run total-tests-possible)
               (eq? 0 (+ (length (fold-state-failure-names test-results))
                         (length (fold-state-error-names test-results)))))
              `#hasheq((output . "Something has gone wrong and your score is likely to be inaccurate; contact an instructor."))
              `#hasheq())
          `#hasheq((score . ,score-str)
                   (tests . ,(append
                              `(
                                #hasheq((name . "Debug info")
                                        (visibility . "hidden")
                                        (output . ,(format "Total tests possible: ~a~nTotal tests run: ~a~n"
                                                           total-tests-possible
                                                           total-tests-run)))
                                )
                              (append-map (make-failure-hash "Execution error in")
                                          (fold-state-error-names test-results)
                                          (map test-error-result (fold-state-error-results test-results)))
                              (append-map (make-failure-hash "Incorrect answer from")
                                          (fold-state-failure-names test-results)
                                          (map test-failure-result (fold-state-failure-results test-results)))))))))))
