#lang racket

(require web-server/web-server
         web-server/http
         net/url
         (prefix-in seq:
                    web-server/dispatchers/dispatch-sequencer)
         (prefix-in filter:
                    web-server/dispatchers/dispatch-filter)
         web-server/servlet-dispatch)

(define (quick-response title message)
  (response/xexpr
   `(html (head (title ,title))
          (body ,message))))

(define poll-hash (make-hash))

(define (poll req)
  (define params (map path/param-path (url-path (request-uri req))))
  (define id (second params))
  (define message (third params))
  (with-handlers ([(lambda _ #t) (quick-response "fail" (format "There is no ~a" id))])
      (let ([sem (hash-ref poll-hash id)])
        (hash-set! poll-hash id message)  
        (semaphore-post sem))           
      (quick-response "ok" "message transmitted")))

(define (push req)
  (define params (map path/param-path (url-path (request-uri req))))
  (define id (first params))
  (define sem (make-semaphore 0))
  (hash-set! poll-hash id sem)
  (semaphore-wait sem)
  (begin0
    (quick-response
     "ok"
     (hash-ref poll-hash id))
    (hash-remove! poll-hash id)))


(serve
 #:port 8080
 #:dispatch
 (seq:make
  (filter:make
   #rx"/poll"
   (dispatch/servlet poll))
  (dispatch/servlet push)))

(do-not-return)
