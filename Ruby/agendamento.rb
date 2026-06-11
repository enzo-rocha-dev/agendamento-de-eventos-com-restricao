# Enzo Rocha, Giovana Leite e Murilo Amaral

class Agendamento
    attr_reader :aluno, :professor, :disciplina, :dia, :horario #cria os metodos publicos
    
    def initialize(aluno, professor, disciplina, dia, horario) #construtor
        @aluno = aluno #o @ na frente diz que elas pertencem a um objeto especifico, nesse caso o Evento.new
        @professor = professor
        @disciplina = disciplina
        @dia = dia
        @horario = horario
    end
    
    def to_s
    "#{dia} às #{horario} | #{aluno} -> #{professor} (#{disciplina})"
    end
end