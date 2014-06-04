#lang racket

(provide define+doc-string)

(define-syntax (define+doc-string stx)
  (syntax-case stx ()
    [(_ (name . params) doc-str value)
     (begin
       (when (not (symbol? (syntax-e #'name)))
         (raise "not a symbol"))
       (when (not (string? (syntax-e #'doc-str)))
         (raise "not a string"))
       #`(begin (define #,(cons #'name #'params) value)
                (module+ doc-string (define name doc-str) (provide name))))]
    [(_ name doc-str value)
     (begin
       (when (not (symbol? (syntax-e #'name)))
         (raise "not a symbol"))
       (when (not (string? (syntax-e #'doc-str)))
         (raise "not a string"))
       #'(begin (define name value)
                (module+ doc-string (define name doc-str) (provide name))))]))
