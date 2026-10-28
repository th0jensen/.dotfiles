(require "grove/grove.scm")
(require "helix/keymaps.scm")
(require "microscope/microscope.scm")
(require "microscope/previewer.scm")
(require "helix/components.scm")
(require "helix/commands.scm")
(require "run-command/run-command.scm")

;; File picker
(define (microscope-file-picker)
  (define (fetch query state)
    (let* ([dir (or state ".")]
           [result (run-argv "rg" (list "--files" "--hidden" "-g" "!.git" dir))]
           [output (hash-ref result 'stdout "")]
           [entries (split-many output "\n")])
      (sort
        (filter
          (lambda (item)
            (and (> (string-length item) 0)
                 (or (= (string-length query) 0)
                     (string-contains? item query))))
          entries)
        string<?)))

  (define (show path width)
    (Line
      (list (cons path "ui.text"))
      (list "")))

  (define (on-select selected state)
    (open selected)
    (cons event-result/close selected))

  (microscope (Picker fetch show on-select file-previewer)))

(provide microscope-file-picker)

;; "path:line:col:text" -> (list path line col)
(define (parse-match selected)
  (let* ([parts (split-many selected ":")])
    (list (if (> (length parts) 0) (car parts) "")
          (if (> (length parts) 1) (cadr parts) "1")
          (if (> (length parts) 2) (caddr parts) "1"))))

;; Keep lines [target-before, target+after], numbered, with the match marked.
(define (window-lines lines target before after)
  (let loop ([rest lines] [n 1] [acc '()])
    (cond
      [(null? rest) (reverse acc)]
      [(> n (+ target after)) (reverse acc)]
      [(< n (- target before)) (loop (cdr rest) (+ n 1) acc)]
      [else
       (loop (cdr rest)
             (+ n 1)
             (cons (string-append (if (= n target) "> " "  ")
                                  (number->string n)
                                  " | "
                                  (car rest))
                   acc))])))

;; Preview for grep results: file contents around the matching line.
(define (grep-previewer selected)
  (let* ([m (parse-match selected)]
         [path (car m)]
         [target (or (string->number (cadr m)) 1)])
    (if (= (string-length path) 0)
        (list selected)
        (window-lines (file-previewer path) target 5 60))))

;; Search file contents with ripgrep; open the selected match at its line.
(define (microscope-grep-picker)
  (define (fetch query state)
    (if (= (string-length query) 0)
        '()
        (let* ([result
                 (run-argv "rg"
                           (list "--line-number"
                                 "--column"
                                 "--no-heading"
                                 "--color" "never"
                                 "--hidden"
                                 "-g" "!.git"
                                 query
                                 ".")
                           (hash 'timeout-ms 10000))]
               [output (hash-ref result 'stdout "")])
          (sort
            (filter
              (lambda (item) (> (string-length item) 0))
              (split-many output "\n"))
            string<?))))

  (define (show match width)
    (Line
      (list (cons match "ui.text"))
      (list "")))

  (define (on-select selected state)
    (let* ([m (parse-match selected)]
           [path (car m)]
           [line (cadr m)])
      (open path)
      (goto line)
      (cons event-result/close selected)))

  (microscope (Picker fetch show on-select grep-previewer)))

(provide microscope-grep-picker)

;; Grove visibility depends on whether Helix was launched with a workspace.
(define (grove-workspace-launch?)
  (let loop ([args (cdr (command-line))])
    (cond
      [(null? args) #f]
      [(equal? (car args) "--") #f]
      [(or (equal? (car args) "-w")
           (equal? (car args) "--working-dir"))
       #t]
      [else (loop (cdr args))])))

(grove-start!
  #:visibility (if (grove-workspace-launch?) 'always 'focused)
  #:side 'right
  #:width 24
  #:icons #t
  #:guides #t)

(keymap (global)
  (normal
    (space
      (e ":grove-focus!")
      (E ":grove-visibility-toggle!")
      (f ":microscope-file-picker")
      (G ":microscope-grep-picker"))))
