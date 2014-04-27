#lang racket

(provide router-ns)

(define-namespace-anchor anchor)
(define router-ns (namespace-anchor->namespace anchor))

;; Return which controller function to run.
(define (router req)
  'maison)
