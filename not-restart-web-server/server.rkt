#lang racket

(require web-server/web-server
         web-server/servlet-dispatch
         racket/rerequire)

(define controller-ns (begin 
                        (dynamic-rerequire "controller.rkt")
                        (dynamic-require "controller.rkt" 'controller-ns)))

(define router-ns (begin
                 (dynamic-rerequire "router.rkt")
                 (dynamic-require "router.rkt" 'router-ns)))

(define (start req)
  (dynamic-rerequire "router.rkt")
  (define sym ((eval 'router router-ns) req))
  (dynamic-rerequire "controller.rkt")
  ((eval sym controller-ns) req))

(define end-server
  (serve
   #:port 8080
   #:dispatch
   (dispatch/servlet start)))

(do-not-return)
