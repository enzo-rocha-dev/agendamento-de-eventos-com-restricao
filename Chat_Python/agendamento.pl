% Enzo Rocha, Giovana Leite e Murilo Amaral

:- dynamic agendamento/5.

% Definindo informações para a BC

professor(tinos, estruturas_de_dados).
professor(baranauskas, paradigmas_de_programacao).
professor(joaquim, banco_de_dados).

aluno(ana, man, 3).
aluno(pedro, bcc, 5).
aluno(lucas, ibm, 2).
aluno(marina, man, 4).
aluno(julia, bcc, 1).
aluno(gabriel, ibm, 6).

% Tinós
disponivel(tinos, segunda, '14h').
disponivel(tinos, segunda, '15h').
disponivel(tinos, quarta, '14h').
disponivel(tinos, quarta, '15h').

% Baranauskas
disponivel(baranauskas, terca, '14h').
disponivel(baranauskas, terca, '15h').
disponivel(baranauskas, quinta, '12h').
disponivel(baranauskas, quinta, '16h').

% Joaquim
disponivel(joaquim, segunda, '16h').
disponivel(joaquim, quarta, '16h').
disponivel(joaquim, sexta, '14h').
disponivel(joaquim, sexta, '15h').

agendamento(ana, tinos, estruturas_de_dados, segunda, '14h').
agendamento(pedro, baranauskas, paradigmas_de_programacao, terca, '14h').
agendamento(lucas, joaquim, banco_de_dados, sexta, '14h').
agendamento(ana, joaquim, banco_de_dados, quarta, '16h').

% Implementação das funcionalidades

horarios_disponiveis(Professor) :-
    writeln('Horarios livres:'),
    forall(
        (
            disponivel(Professor, Dia, Hora),
            \+ agendamento(_, Professor, _, Dia, Hora)
        ),
        format('- ~w ~w~n', [Dia, Hora])
    ).

% Regra 1 - Disponibilidade do professor

validar_disponibilidade(Professor, Dia, Hora) :-
    disponivel(Professor, Dia, Hora), !.

validar_disponibilidade(_, _, _) :-
    writeln('Invalido: professor indisponivel.'),
    fail.

% Regra 2 - Professor ocupado

validar_professor_livre(Professor, Dia, Hora) :-
    \+ agendamento(_, Professor, _, Dia, Hora), !.

validar_professor_livre(_, _, _) :-
    writeln('Invalido: horario ja ocupado.'),
    fail.

% Regra 3 - Aluno ocupado

validar_aluno_livre(Aluno, Dia, Hora) :-
    \+ agendamento(Aluno, _, _, Dia, Hora), !.

validar_aluno_livre(_, _, _) :-
    writeln('Invalido: aluno ja possui atendimento.'),
    fail.

% Regra 4 - Limite de 2 monitorias

validar_limite_semanal(Aluno) :-
    findall(
        X,
        agendamento(Aluno, _, _, _, _),
        Lista
    ),
    length(Lista, N),
    N < 2, !.

validar_limite_semanal(_) :-
    writeln('Invalido: limite semanal atingido.'),
    fail.

% Regra 5 - Compatibilidade da disciplina

validar_disciplina(Professor, Disciplina) :-
    professor(Professor, Disciplina), !.

validar_disciplina(_, _) :-
    writeln('Invalido: disciplina incompativel.'),
    fail.

% Agendamento

agendar(Aluno, Professor, Disciplina, Dia, Hora) :-

    validar_disciplina(Professor, Disciplina),

    validar_disponibilidade(
        Professor,
        Dia,
        Hora
    ),

    validar_professor_livre(
        Professor,
        Dia,
        Hora
    ),

    validar_aluno_livre(
        Aluno,
        Dia,
        Hora
    ),

    validar_limite_semanal(
        Aluno
    ),

    assertz(
        agendamento(
            Aluno,
            Professor,
            Disciplina,
            Dia,
            Hora
        )
    ),

    writeln('Agendamento aprovado.').

listar_agendamentos :-
    forall(
        agendamento(
            Aluno,
            Professor,
            Disciplina,
            Dia,
            Hora
        ),
        format(
            '~w | ~w | ~w | ~w | ~w~n',
            [Aluno, Professor, Disciplina, Dia, Hora]
        )
    ).