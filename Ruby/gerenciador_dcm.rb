# Enzo Rocha, Giovana Leite e Murilo Amaral

require_relative 'agendamento'

class GerenciadorDCM
  def initialize
    @disciplinas = {
      "Tinós" => "Estruturas de Dados",
      "Baranauskas" => "Paradigmas de Programação",
      "Joaquim" => "Banco de Dados"
    }
    
    @horarios_permitidos = {
      "Tinós" => ["Segunda 14h", "Segunda 15h", "Quarta 14h", "Quarta 15h"],
      "Baranauskas" => ["Terça 14h", "Terça 15h", "Quinta 12h", "Quinta 16h"],
      "Joaquim" => ["Segunda 16h", "Quarta 16h", "Sexta 14h", "Sexta 15h"]
    }
    
    @agendamentos = []
    @alunos = {}
    
    carregar_dados_iniciais
  end
  
  def cadastrar_professor(nome, disciplina)
    if @disciplinas.key?(nome)
      puts "Erro: O professor '#{nome}' já está cadastrado no sistema!"
      return false
    end
    
    @disciplinas[nome] = disciplina
    @horarios_permitidos[nome] = []
    
    puts "Sucesso: professor '#{nome}' cadastrado para a disciplina '#{disciplina}'"
    true
  end

  def agendar(aluno, professor, disciplina, dia, horario)
    if @disciplinas[professor] != disciplina
      puts "Inválido: disciplina incompatível."
      return false
    end

    # REGRA 1: Disponibilidade do professor
    horario_completo = "#{dia} #{horario}"
    horarios_prof = @horarios_permitidos[professor]
    
    if horarios_prof.nil? || !horarios_prof.include?(horario_completo)
      puts "Inválido: professor indisponível."
      return false
    end

    # REGRA 2: Conflito de agenda do professor
    conflito_prof = @agendamentos.find do |a| 
      a.professor == professor && a.dia == dia && a.horario == horario 
    end
    
    if conflito_prof
      puts "Inválido: horário já ocupado."
      return false
    end

    # REGRA 3: Conflito de agenda do aluno
    conflito_aluno = @agendamentos.find do |a| 
      a.aluno == aluno && a.dia == dia && a.horario == horario 
    end
    
    if conflito_aluno
      puts "Inválido: aluno já possui atendimento."
      return false
    end

    # REGRA 4: Limite semanal
    qtd_agendamentos = @agendamentos.count { |a| a.aluno == aluno }
    
    if qtd_agendamentos >= 2
      puts "Inválido: limite semanal atingido."
      return false
    end

    novo_agendamento = Agendamento.new(aluno, professor, disciplina, dia, horario)
    @agendamentos << novo_agendamento
    puts "Agendamento aprovado."
    true
  end

  def listar_agendamentos
    if @agendamentos.empty?
      puts "\n Nenhum agendamento realizado até o momento."
    else
      puts "\n=== AGENDAMENTOS DO DCM ==="
      @agendamentos.each { |a| puts a }
    end
  end
  
  def consultar_horarios(professor)
    horarios = @horarios_permitidos[professor]
    if horarios.nil?
      puts "Professor não encontrado no sistema."
    elsif horarios.empty?
      puts "O professor '#{professor}' ainda não possui horários cadastrados."
    else
      puts "\nHorários de #{professor}:"
      horarios.each { |h| puts "  - #{h}" }
    end
  end
  
  def cadastrar_aluno(nome, curso, periodo)
    if @alunos.key?(nome)
      puts "Erro: O aluno '#{nome}' já está cadastrado no sistema!"
      return false
    end

    @alunos[nome] = { curso: curso, periodo: periodo }
    puts "Sucesso: Aluno '#{nome}' (#{curso} - #{periodo}) cadastrado."
    true
  end
  
  def adicionar_horario(professor, novo_horario)
    if !@horarios_permitidos.key?(professor)
      puts "Erro: Professor '#{professor}' não encontrado."
      return false
    end

    if @horarios_permitidos[professor].include?(novo_horario)
      puts "Erro: O horário '#{novo_horario}' já existe para este professor."
      return false
    end

    @horarios_permitidos[professor] << novo_horario
    puts "Sucesso: Horário '#{novo_horario}' adicionado à agenda de '#{professor}'."
    true
  end
  
  def aluno_existe?(nome)
    @alunos.key?(nome)
  end
    
  private 
  
  def carregar_dados_iniciais
    @agendamentos << Agendamento.new("Ana", "Tinós", "Estruturas de Dados", "Segunda", "14h")
    @agendamentos << Agendamento.new("Pedro", "Baranauskas", "Paradigmas de Programação", "Terça", "14h")
    @agendamentos << Agendamento.new("Lucas", "Joaquim", "Banco de Dados", "Sexta", "14h")
    @agendamentos << Agendamento.new("Ana", "Joaquim", "Banco de Dados", "Quarta", "16h")
  end
end