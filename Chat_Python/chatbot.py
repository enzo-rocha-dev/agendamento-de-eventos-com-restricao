import os
import re

from pyswip import Prolog

import spacy

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB


# Carrega o modelo de NLP

nlp = spacy.load("pt_core_news_sm")


# Conecta ao arquivo Prolog

prolog = Prolog()

base_dir = os.path.dirname(
    os.path.abspath(__file__)
)

arquivo_prolog = os.path.join(
    base_dir,
    "agendamento.pl"
)

prolog.consult(arquivo_prolog)


# Exemplos para treinamento do Naive Bayes

dados_treinamento = [

    # Agendar

    ("agendar monitoria", "agendar"),
    ("marcar monitoria", "agendar"),
    ("reservar monitoria", "agendar"),
    ("quero uma monitoria", "agendar"),
    ("preciso de monitoria", "agendar"),
    ("agende para mim", "agendar"),
    ("marque um horário", "agendar"),
    ("quero marcar atendimento", "agendar"),
    ("criar monitoria", "agendar"),
    ("agendar com professor", "agendar"),

    # Consultar aluno

    ("ana tem monitoria", "consultar_aluno"),
    ("quais monitorias da marina", "consultar_aluno"),
    ("pedro possui atendimento", "consultar_aluno"),
    ("consultar aluno", "consultar_aluno"),
    ("mostrar monitorias", "consultar_aluno"),
    ("gabriel tem monitoria", "consultar_aluno"),

    # Consultar professor

    ("horários do tinos", "consultar_professor"),
    ("bara tem horário", "consultar_professor"),
    ("joca está disponível", "consultar_professor"),
    ("consultar professor", "consultar_professor"),
    ("mostrar horários", "consultar_professor"),
    ("horários disponíveis", "consultar_professor"),

    # Listar

    ("listar agendamentos", "listar"),
    ("mostrar tudo", "listar"),
    ("listar monitorias", "listar"),
    ("exibir monitorias", "listar"),
    ("mostrar agendamentos", "listar")
]


# Treina o classificador

frases = [x[0] for x in dados_treinamento]

classes = [x[1] for x in dados_treinamento]

vectorizer = CountVectorizer()

X = vectorizer.fit_transform(frases)

modelo = MultinomialNB()

modelo.fit(X, classes)


# Entidades conhecidas pelo chatbot

ALUNOS = {

    "ana": "ana",
    "pedro": "pedro",
    "lucas": "lucas",
    "marina": "marina",
    "julia": "julia",
    "gabriel": "gabriel"
}

PROFESSORES = {

    "tinos": "tinos",
    "tinós": "tinos",
    "tino": "tinos",

    "baranauskas": "baranauskas",
    "bara": "baranauskas",

    "joaquim": "joaquim",
    "joca": "joaquim"
}

DISCIPLINAS = {

    "aed": "estruturas_de_dados",
    "estrutura de dados": "estruturas_de_dados",
    "estruturas de dados": "estruturas_de_dados",

    "bd": "banco_de_dados",
    "banco de dados": "banco_de_dados",

    "lpp": "paradigmas_de_programacao",
    "paradigmas": "paradigmas_de_programacao",
    "paradigmas de programação":
        "paradigmas_de_programacao"
}

DIAS = {

    "segunda": "segunda",

    "terça": "terca",
    "terca": "terca",

    "quarta": "quarta",

    "quinta": "quinta",

    "sexta": "sexta"
}


# Identifica a intenção da mensagem

def detectar_intencao(texto):

    vetor = vectorizer.transform([texto])

    return modelo.predict(vetor)[0]


# Extrai entidades da frase

def extrair_dados(texto):

    texto = texto.lower()

    doc = nlp(texto)

    dados = {

        "aluno": None,
        "professor": None,
        "disciplina": None,
        "dia": None,
        "hora": None
    }

    for token in doc:

        palavra = token.text

        if palavra in ALUNOS:
            dados["aluno"] = ALUNOS[palavra]

        if palavra in PROFESSORES:
            dados["professor"] = PROFESSORES[palavra]

        if palavra in DIAS:
            dados["dia"] = DIAS[palavra]

    for disciplina in DISCIPLINAS:

        if disciplina in texto:
            dados["disciplina"] = DISCIPLINAS[disciplina]

    horario = re.search(
        r"(\d{1,2})(?:h|:00)?",
        texto
    )

    if horario:

        dados["hora"] = horario.group(1) + "h"

    return dados


# Solicita um agendamento ao Prolog

def realizar_agendamento(dados):

    consulta = f"""
    agendar(
        {dados['aluno']},
        {dados['professor']},
        {dados['disciplina']},
        {dados['dia']},
        '{dados['hora']}'
    )
    """

    try:

        resultado = list(
            prolog.query(consulta)
        )

        return len(resultado) > 0

    except Exception as erro:

        print("\nErro:", erro)

        return False


# Consulta monitorias de um aluno

def consultar_aluno(aluno):

    consulta = f"""
    agendamento(
        {aluno},
        Professor,
        Disciplina,
        Dia,
        Hora
    )
    """

    return list(prolog.query(consulta))


# Consulta horários livres de um professor

def consultar_professor(professor):

    consulta = f"""
    disponivel(
        {professor},
        Dia,
        Hora
    ),
    \\+ agendamento(
        _,
        {professor},
        _,
        Dia,
        Hora
    )
    """

    return list(
        prolog.query(
            consulta
        )
    )


# Lista todos os agendamentos

def listar_agendamentos():

    consulta = """
    agendamento(
        Aluno,
        Professor,
        Disciplina,
        Dia,
        Hora
    )
    """

    return list(
        prolog.query(
            consulta
        )
    )


# Lê dados de agendamento do usuário

def ler_agendamento():

    print("\n" + "=" * 60)
    print("🗓️  AGENDAMENTO VIA NLP")
    print("=" * 60)
    print("(Digite 'voltar' ou 'sair' para retornar ao menu)")

    entrada = input(
        "\nDescreva o agendamento de forma natural:\n"
        "(Ex: 'Enzo quer marcar banco de dados com Tinos sexta as 14h')\n\n> "
    ).lower().strip()

    # Verifica se usuario quer voltar
    if entrada in ["voltar", "sair"]:
        print("\n← Voltando ao menu...")
        return None

    dados = extrair_dados(entrada)
    tentativa = 1

    while True:
        # Identifica campos faltantes
        faltantes = []
        for campo in ["aluno", "professor", "disciplina", "dia", "hora"]:
            if dados[campo] is None:
                faltantes.append(campo)

        # Se todos os campos foram preenchidos, retorna
        if not faltantes:
            return dados

        print(f"\n⚠️  Informacao incompleta (tentativa {tentativa})")
        print(f"Faltam: {', '.join(faltantes)}")

        # Solicita reformulacao
        entrada_refinada = input(
            "\nReformule a frase de forma mais completa (ou digite 'voltar'/'sair'):\n> "
        ).lower().strip()

        # Verifica se usuario quer voltar
        if entrada_refinada in ["voltar", "sair"]:
            print("\n← Voltando ao menu...")
            return None

        dados_refinados = extrair_dados(entrada_refinada)

        # Merge inteligente (nao sobrescreve dados ja preenchidos)
        for chave in dados:
            if dados[chave] is None and dados_refinados[chave] is not None:
                dados[chave] = dados_refinados[chave]

        tentativa += 1


def mostrar_menu():

    print("\n" + "=" * 60)
    print("📋 SISTEMA DE AGENDAMENTO DE MONITORIAS")
    print("=" * 60)
    print("1 - Agendar monitoria (via NLP)")
    print("2 - Consultar monitorias de um aluno")
    print("3 - Consultar horarios livres de um professor")
    print("4 - Listar todos os agendamentos")
    print("0 - Sair")
    print("=" * 60)

# Interface principal

while True:

    mostrar_menu()

    opcao = input(
        "\nEscolha uma opção: "
    )

    if opcao == "0":
        print("\nEncerrando sistema...")
        break

    # Opcao 1: Agendar monitoria
    elif opcao == "1":

        dados = ler_agendamento()

        # Se usuario digitou voltar/sair
        if dados is None:
            continue

        if None in [

            dados["aluno"],
            dados["professor"],
            dados["disciplina"],
            dados["dia"]

        ]:

            print(
                "\n❌ Dados invalidos."
            )

            continue

        print(
            "\n[Prolog] Validando regras..."
        )

        sucesso = realizar_agendamento(
            dados
        )

        if sucesso:

            print(
                "\n✅ Agendamento aprovado."
            )

        else:

            print(
                "\n❌ Agendamento recusado."
            )

    # Opcao 2: Consultar monitorias de um aluno
    elif opcao == "2":

        aluno = input(
            "\nNome do aluno: "
        ).lower()

        aluno = ALUNOS.get(aluno)

        if not aluno:

            print(
                "\nAluno nao encontrado."
            )

            continue

        resultado = consultar_aluno(
            aluno
        )

        if not resultado:

            print(
                "\nNenhuma monitoria encontrada."
            )

        else:

            print(
                "\nMonitorias encontradas:"
            )

            for r in resultado:

                print(
                    f"- {r['Disciplina']} | "
                    f"{r['Professor']} | "
                    f"{r['Dia']} | "
                    f"{r['Hora']}"
                )

    # Opcao 3: Consultar horarios de um professor
    elif opcao == "3":

        professor = input(
            "\nProfessor: "
        ).lower()

        professor = PROFESSORES.get(
            professor
        )

        if not professor:

            print(
                "\nProfessor nao encontrado."
            )

            continue

        resultado = consultar_professor(
            professor
        )

        if not resultado:

            print(
                "\nNenhum horario livre."
            )

        else:

            print(
                "\nHorarios livres:"
            )

            for r in resultado:

                print(
                    f"- {r['Dia']} | "
                    f"{r['Hora']}"
                )

    # Opcao 4: Listar agendamentos
    elif opcao == "4":

        resultado = listar_agendamentos()

        print(
            "\nAgendamentos cadastrados:"
        )

        for r in resultado:

            print(
                f"- {r['Aluno']} | "
                f"{r['Professor']} | "
                f"{r['Disciplina']} | "
                f"{r['Dia']} | "
                f"{r['Hora']}"
            )

    else:

        print(
            "\n❌ Opcao invalida. Tente novamente."
        )