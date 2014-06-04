#lang racket

(require "define-docstring.rkt")

(define+doc-string maison "ma belle maison" 1)

(define+doc-string (voiture horn)
  "The other docstring"
  horn)

;; in the repl
;; racket@> (require (submod "example.rkt" doc-string))
;; racket@> voiture
;; "The other docstring"
