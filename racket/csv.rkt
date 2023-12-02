#lang typed/racket

(provide csv-read)

(: csv-read (-> Input-Port (#:separator Char) (#:quote Char) (Listof (Listof String))))
(define (csv-read csv_input #:separator (seperator-char #\,) #:quote (quote-char #\"))

  (: csv-read-quoted (-> Output-Port String))
  (define (csv-read-quoted acc)
    (match (read-char csv_input)
      ((? eof-object?) (get-output-string acc))
      ((== quote-char) #:when (eqv? quote-char (peek-char csv_input))
                       (write-char quote-char acc)
                       (read-char csv_input)
                       (csv-read-quoted acc))
      ((== quote-char) (get-output-string acc))
      ((? char? ch) (write-char ch acc)
                    (csv-read-quoted acc))))

  (: csv-read-line (-> Output-Port (Listof String)))
  (define (csv-read-line acc)
    (match (read-char csv_input)
      ((or (? eof-object?) #\newline #\return) (cons (get-output-string acc) '()))
      ((== seperator-char) (cons (bytes->string/utf-8 (get-output-bytes acc #t))
                                 (csv-read-line acc)))
      ((== quote-char) (write-string (csv-read-quoted (open-output-string)) acc)
                       (csv-read-line acc))
      ((? char? ch) (write-char ch acc)
                    (csv-read-line acc))))

  (: loop (-> (Listof (Listof String))))
  (define (loop)
    (match (peek-char csv_input)
      ((? eof-object?) '())
      ((or #\newline #\return) (read-char csv_input)
                               (loop))
      (else (cons (csv-read-line (open-output-string))
                  (loop)))))

  (loop))

(call-with-input-file "C:/Users/enoch/Desktop/test.txt"
  (lambda ([infile : Input-Port])
    (csv-read infile)))