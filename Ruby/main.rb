# Enzo Rocha, Giovana Leite e Murilo Amaral

require_relative 'agendamento'
require_relative 'gerenciador_dcm'

def exibir_menu
  puts "\n========================================="
  puts "   SISTEMA DE MONITORIAS DCM - USP RP    "
  puts "========================================="
  puts "1. Solicitar novo agendamento"
  puts "2. Consultar horários de um professor"
  puts "3. Listar todos os agendamentos"
  puts "4. Cadastrar novo professor"
  puts "5. Adicionar horário à agenda de um professor"
  puts "6. Sair"
  print "Escolha uma opção: "
end

def pedir_dados_agendamento(gerenciador)
  puts "\n--- Novo Agendamento ---"
  print "Nome do Aluno: "
  aluno = gets.chomp

  if !gerenciador.aluno_existe?(aluno)
    puts "\n Aluno '#{aluno}' não encontrado no sistema. Vamos cadastrar rapidinho!"
    print "Curso (ex: BCC, MAN, IBM): "
    curso = gets.chomp
    print "Período atual (ex: 5º): "
    periodo = gets.chomp
    
    gerenciador.cadastrar_aluno(aluno, curso, periodo)
    puts "--- Continuando o agendamento ---"
  end

  print "Nome do Professor: "
  professor = gets.chomp

  print "Disciplina: "
  disciplina = gets.chomp

  print "Dia da semana (ex: Segunda): "
  dia = gets.chomp

  print "Horário (ex: 14h): "
  horario = gets.chomp

  [aluno, professor, disciplina, dia, horario]
end

def main
  gerenciador = GerenciadorDCM.new
  
  loop do
    exibir_menu
    opcao = gets.chomp

    case opcao
    when "1"
      dados = pedir_dados_agendamento(gerenciador)
      puts "\n--- Validando Regras de Negócio ---"
      gerenciador.agendar(*dados)

    when "2"
      print "\nDigite o nome do professor: "
      prof = gets.chomp
      gerenciador.consultar_horarios(prof)

    when "3"
      gerenciador.listar_agendamentos

    when "4"
      puts "\n--- Cadastro de Professor ---"
      print "Nome do Professor: "
      nome = gets.chomp
      print "Disciplina que leciona: "
      disciplina = gets.chomp
      gerenciador.cadastrar_professor(nome, disciplina)

    when "5"
      puts "\n--- Adicionar Horário à Agenda ---"
      print "Nome do Professor: "
      prof = gets.chomp
      print "Novo Horário (ex: Sexta 18h): "
      horario = gets.chomp
      gerenciador.adicionar_horario(prof, horario)

    when "6"
      puts "\nEncerrando o sistema de monitorias do DCM. Até logo!"
      break

    else
      puts "\nOpção inválida! Digite um número de 1 a 6."
    end
  end
end

main if __FILE__ == $0