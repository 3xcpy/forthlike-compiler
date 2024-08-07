(defparameter *words* ())

(defun program-header ()
  (format t "format ELF64 executable 3~%")
  (format t "segment readable executable~%"))

;; Compiler intrinsics
(defun int_push (n)
  (format t "    add r15, 8    ; PUSH compiler intrinsic~%")
  (format t "    mov QWORD [r15], ~a~%" n))

(defun int_pop ()
  (format t "    mov rax, [r15]    ; POP compiler intrinsic~%")
  (format t "    sub r15, 8~%"))

(defun int_drop ()
  (format t "    sub r15, 8~%"))

(defun int_add ()
  (int_pop)
  (format t "    add [r15], rax    ; ADD compiler intrinsic~%"))

(defun int_mul ()
  (int_pop)
  (format t "    mov rbx, rax~%")
  (int_pop)
  (format t "    mul rbx    ; MUL compiler intrinsic~%")
  (int_push "rax"))

(defun int_call (word)
  (format t "    call ~a~%" word))

(defun builtin_print_definition ()
  (format t "print:~%")
  (int_pop)
  (format t "    mov rdi, rax~%")
  (format t "    mov     r9, -3689348814741910323~%")
  (format t "    sub     rsp, 40~%")
  (format t "    mov     BYTE [rsp+31], 1~%")
  (format t "    lea     rcx, [rsp+30]~%")
  (format t ".L2:~%")
  (format t "    mov     rax, rdi~%")
  (format t "    lea     r8, [rsp+32]~%")
  (format t "    mul     r9~%")
  (format t "    mov     rax, rdi~%")
  (format t "    sub     r8, rcx~%")
  (format t "    shr     rdx, 3~%")
  (format t "    lea     rsi, [rdx+rdx*4]~%")
  (format t "    add     rsi, rsi~%")
  (format t "    sub     rax, rsi~%")
  (format t "    add     eax, 48~%")
  (format t "    mov     BYTE [rcx], al~%")
  (format t "    mov     rax, rdi~%")
  (format t "    mov     rdi, rdx~%")
  (format t "    mov     rdx, rcx~%")
  (format t "    sub     rcx, 1~%")
  (format t "    cmp     rax, 9~%")
  (format t "    ja      .L2~%")
  (format t "    lea     rax, [rsp+32]~%")
  (format t "    mov     edi, 1~%")
  (format t "    sub     rdx, rax~%")
  (format t "    xor     eax, eax~%")
  (format t "    lea     rsi, [rsp+32+rdx]~%")
  (format t "    mov     rdx, r8~%")
  (format t "    mov     rax, 1~%")
  (format t "    syscall~%")
  (format t "    add     rsp, 40~%")
  (format t "    ret~%"))

(defun builtin_emit_definition ()
  (format t "emit:~%")
  (format t "    mov rax, 1  ~%")
  (format t "    mov rdi, 1  ~%")
  (format t "    mov rsi, r15~%")
  (format t "    mov rdx, 1  ~%")
  (format t "    syscall     ~%")
  (int_drop)
  (format t "    ret         ~%"))

(defun int_exit (exit_code)
  (format t "    mov rax, 60~%")
  (format t "    mov rdi, ~a~%" exit_code)
  (format t "    syscall~%"))

(defun data_segment ()
  (format t "   segment readable writable~%"))

(defun allocate_stack (size)
  (format t "mem:  rb ~a~%" size))

(defun entry_point ()
  (format t "entry start~%")
  (format t "start:~%"))

(defun init_stack ()
  (format t "    mov r15, mem~%"))

(defun codegen (tokens)
  (loop for tok in tokens do
        (cond ((numberp tok) (int_push tok))
              (t (compile-word tok)))))

(defun compile-word (word)
  (cond
    ((string-equal word "+") (int_add))
    ((string-equal word "*") (int_mul))
    ((string-equal word ".") (int_call "print"))
    ((string-equal word "emit") (int_call "emit"))
    (t (with-open-file (l "./log" :direction :output :if-exists :supersede)
         (format l "ERROR: undefined word ~a~%" word)))))

(defun tokenize (text)
  (let ((result ())
        (tokens (my-split text)))
    (loop for tok in tokens do
          (cond ((parse-integer tok :junk-allowed t) (setf result (cons (parse-integer tok) result)))
                (t (setf result (cons tok result)))))
    (reverse result)))

(defun compile-code (code)
  (with-open-file
      (s "./out.asm" :direction :output :if-exists :supersede)
    (let ((*standard-output* s))
      (program-header)
      (builtin_print_definition)
      (builtin_emit_definition)
      (entry_point)
      (init_stack)
      (codegen (tokenize code))
      (int_exit 0)
      (data_segment)
      (allocate_stack 4096))))

;; Utility for tokenizer
(defun delimiterp (c)
  (char= c #\Space))

(defun my-split (string &key (delimiterp #'delimiterp))
  (loop :for beg = (position-if-not delimiterp string)
    :then (position-if-not delimiterp string :start (1+ end))
    :for end = (and beg (position-if delimiterp string :start beg))
    :when beg :collect (subseq string beg end)
    :while end))
