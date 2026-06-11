;Enzo Rocha, Giovana Leite e Murilo

(defparameter *aluno* nil)
(defparameter *professor* nil)
(defparameter *agenda* nil)

;função para adicionar aluno
(defun add_aluno (nome curso periodo)
    (setf *aluno* (cons (list nome curso periodo 0) *aluno*)))

;função para adicionar professor
(defun add_prof (nome disciplina)
    (setf *professor* (cons (list nome disciplina) *professor*)))

;função para registrar um horário de atendimento
(defun cadastrar-monitoria (prof disciplina dia hora)
    (setf *agenda* (cons (list prof disciplina dia hora "disponivel") *agenda*)))

;função para agendar um horário
(defun agendar (aluno prof disciplina dia hora)
    (dolist (y *aluno*)
        (if (and (equal (first y) aluno) (< (fourth y) 2))
            (let ((ok 0) (livre 1))
                ;verifica se o aluno está livre nesse horário
                (dolist (x *agenda*)
                    (if (and (equal (fifth x) aluno) (equal (third x) dia) (equal (fourth x) hora))
                        (setf livre 0)
                    )
                )
                (if (= livre 1)
                    (progn
                        (dolist (x *agenda*)
                            (if (equal x (list prof disciplina dia hora "disponivel"))
                                (progn
                                    (setf (fifth x) aluno)
                                    (setf ok 1))))
                        
                        (if (= ok 0)
                            (format t "Não foi possível agendar~%")
                            (progn
                                (format t "Agendamento realizado com sucesso!~%")
                                (setf (fourth y) (+ (fourth y) 1))
                            )
                        )
                    )
                    (format t "Aluno já possui outra monitoria nesse horário~%")
                )
            )
            
                (if (equal (first y) aluno)
                    (format t "Aluno já atingiu o limite de monitorias semanais~%")
                )
        )
    )
)

;mostrar agenda
(defun mostrar-agenda ()
    (let ((ok 0))
        (dolist (x *agenda* ok)
            (format t "~A / ~A / ~A / ~A / ~A~%"
                    (first x)
                    (second x)
                    (third x)
                    (fourth x)
                    (fifth x))
        )
    )
)

;consultar horários de um professor
(defun mostrar-agenda-prof (prof)
    (let ((ok 0))
        (dolist (x *agenda* ok)
            (if (equal (first x) prof)
                (format t "~A / ~A / ~A / ~A~%"
                    (second x)
                    (third x)
                    (fourth x)
                    (fifth x))
            )
        )
    )
)

;consultar agendamentos
(defun mostrar-agendamentos ()
    (let ((ok 0))
        (dolist (x *agenda* ok)
            (if (not (equal (fifth x) "disponivel"))
                (format t "~A / ~A / ~A / ~A~%"
                    (first x)
                    (second x)
                    (third x)
                    (fourth x))
            )
        )
    )
)

;main
(do ((var 0)) ((= var 1) "programa finalizado")

    (format t
            "1. Cadastrar um aluno~%2. Cadastrar um professor~%3. Cadastrar horário de monitoria~%4. Agendar~%5. Mostrar agenda~%6. Consultar horários de um professor~%7. Listar todos os agendamentos~%8. Sair~%Escolha uma opção: ")
    (finish-output)

    (let ((option 0))
        (setf option (read))
        (cond
            ((equal option 1)
                (let ((nome nil) (curso nil) (periodo nil))

                    (format t "Digite o nome do aluno: ")
                    (finish-output)
                    (setf nome (read-line))

                    (format t "Digite o curso do aluno: ")
                    (finish-output)
                    (setf curso (read-line))

                    (format t "Digite o período do aluno: ")
                    (finish-output)
                    (setf periodo (read-line))

                    (add_aluno nome curso periodo)))

            ((equal option 2)
                (let ((nome nil) (disciplina nil))

                    (format t "Digite o nome do professor: ")
                    (finish-output)
                    (setf nome (read-line))

                    (format t "Digite a disciplina ministrada pelo professor: ")
                    (finish-output)
                    (setf disciplina (read-line))

                    (add_prof nome disciplina)))

            ((equal option 3)
                (let ((prof nil) (disciplina nil) (dia nil) (hora nil))

                    (format t "Digite o nome do professor: ")
                    (finish-output)
                    (setf prof (read-line))

                    (format t "Digite a disciplina: ")
                    (finish-output)
                    (setf disciplina (read-line))

                    (format t "Digite o dia: ")
                    (finish-output)
                    (setf dia (read-line))

                    (format t "Digite a hora: ")
                    (finish-output)
                    (setf hora (read-line))

                    (cadastrar-monitoria prof disciplina dia hora)))

            ((equal option 4)
                (let ((aluno nil) (prof nil) (dia nil) (disciplina nil) (hora nil))

                    (format t "Com qual professor deseja agendar? ")
                    (finish-output)
                    (setf prof (read-line))

                    (format t "Digite o nome do aluno: ")
                    (finish-output)
                    (setf aluno (read-line))

                    (format t "Digite a disciplina: ")
                    (finish-output)
                    (setf disciplina (read-line))

                    (format t "Dia: ")
                    (finish-output)
                    (setf dia (read-line))

                    (format t "Hora: ")
                    (finish-output)
                    (setf hora (read-line))

                    (agendar aluno prof disciplina dia hora)))

            ((equal option 5)
                (mostrar-agenda))

            ((equal option 6)
                (let ((prof nil))
                    (format t "Digite o nome do professor: ")
                    (finish-output)
                    (setf prof (read-line))
                    (mostrar-agenda-prof prof))
                )
            
            ((equal option 7)
                (mostrar-agendamentos))

            ((equal option 8)
                (setf var 1))
        )
    )
)