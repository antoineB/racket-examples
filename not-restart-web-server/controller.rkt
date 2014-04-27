#lang racket

(require web-server/http)

(provide controller-ns)

(define-namespace-anchor anchor)
(define controller-ns (namespace-anchor->namespace anchor))

(define (maison req)
  (response/output
   (lambda (out) (display "maison" out))))

(define (voiture req)
  (response/output
   (lambda (out) (display "voiture" out))))
