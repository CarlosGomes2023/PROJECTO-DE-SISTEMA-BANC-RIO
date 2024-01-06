registo CONTA
	inteiro numero_conta
	real saldo
	literal estado
	inteiro codigo_cliente
fim registo

registo PESSOA
	inteiro codigo
	literal nome
	literal morada
	literal documento
	literal telefone
fim registo

CONTA contas[3000]
PESSOA clientes[3000]
literal ficheirologico <- "C:\\Users\\lenovo\\Documents\\backproj\\backup2.text"

inteiro qtdClientes, qtdContas

procedimento Menu ()
	escreva "лллллллллллллллллллллллллллллллллллллллллллл \n"
	escreva " 1 - Cadastrar cliente \n"
	escreva " 2 - Listar clientes \n"
	escreva " 3 - Abertura de conta \n"
	escreva " 4 - Depositar dinheiro \n"
	escreva " 5 - Levantar dinheiro \n"
	escreva " 6 - Consultar saldo \n"
	escreva " 7 - Transferir dinheiro \n"
	escreva " 8 - Atualizar dados \n"
	escreva " 9 - Terminar  \n"
	escreva "лллллллллллллллллллллллллллллллллллллллллллл \n"
	
fim procedimento

funcao logico cadastrar_cliente(PESSOA p)
	p.codigo <- qtdClientes + 1
	clientes[qtdClientes] <- p
	qtdClientes <- qtdClientes + 1
	
	retorne verdadeiro
fim funcao

funcao inteiro procurar_conta_codigo (inteiro codigo)
	inteiro i
	para i de 0 ate qtdContas - 1
		CONTA c <- contas[i]
		se c.codigo_cliente = codigo entao
			retorne i
		fimse
	fimpara

	retorne -1
fimfuncao

procedimento listar_clientes ()
	inteiro i
	para i de 0 ate qtdClientes - 1
		PESSOA cliente <- clientes[i]
		escreva "DADOS PESSOAIS\n"
		escreva "Cєdigo: ", cliente.codigo, "\n"
		escreva "Nome: ", cliente.nome, "\n"
		escreva "Telefone: ", cliente.telefone, "\n"
		escreva "Documento: ", cliente.documento, "\n"
		escreva "Morada: ", cliente.morada, "\n\n"

		inteiro posicao <- procurar_conta_codigo (cliente.codigo)

		se posicao = -1 entao
			continue
		fimse

		CONTA c <- contas[posicao]
		escreva "DADOS DA CONTA: \n"
		escreva "Numero: ", c.numero_conta, "\n"
		escreva "Saldo: ", c.saldo, "\n"
		escreva "Estado: ", c.estado, "\n"
		escreva "Codigo cliente; ", c.codigo_cliente, "\n"
	fimpara
fim procedimento

funcao inteiro procurar_cliente (inteiro codigo)
	inteiro i
	para i de 0 ate qtdClientes - 1
		PESSOA c <- clientes[i]
		se c.codigo = codigo entao
			retorne i
		fimse
	fimpara

	retorne -1
fimfuncao

funcao logico abertura_de_conta (PESSOA p, inteiro tipo_conta)
	CONTA c
	c.numero_conta <- qtdContas + 1
	c.saldo <-20000
	c.estado <- "Inactivo"
	c.codigo_cliente <- p.codigo
	contas[qtdContas] <- c

	qtdContas <- qtdContas + 1
	
	retorne verdadeiro
fimfuncao

funcao inteiro procurar_conta (inteiro numero_conta)
	inteiro i
	para i de 0 ate qtdContas - 1
		CONTA c <- contas[i]
		se c.numero_conta = numero_conta entao
			retorne i
		fim se
	fimpara
	
	retorne -1
fimfuncao

funcao logico depositar_dinheiro (inteiro numero_conta, real valor)
	inteiro posicao <- procurar_conta (numero_conta)

	se posicao = -1 entao
		retorne falso
	fimse

	CONTA c <- contas[posicao]
	c.saldo <- c.saldo + valor
	c.estado <- "Activo"

	retorne verdadeiro
fimfuncao

funcao logico levantar_dinheiro (inteiro numero_conta, real valor)
	inteiro posicao <-procurar_conta (numero_conta)

	se posicao = -1 entao
		retorne falso
	fimse

	CONTA c <- contas[posicao]
	
	se c.saldo < valor entao
		retorne falso
	fimse
	
	c.saldo <- c.saldo - valor
	c.estado <- "Activo"

	retorne verdadeiro
fim funcao

funcao real consultar_saldo (inteiro numero_conta)
	inteiro posicao <- procurar_conta (numero_conta)

	se posicao = -1 entao
		retorne -1
	fim se

	retorne contas[posicao].saldo
fim funcao

funcao logico transferir_dinheiro (inteiro numero_conta_enviar, inteiro numero_conta_receber, real valor)
	inteiro posicao_enviar <- procurar_conta (numero_conta_enviar)

	se posicao_enviar = -1 entao
		retorne falso
	fim se

	inteiro posicao_receber <- procurar_conta (numero_conta_receber)

	se posicao_receber = -1 entao
		retorne falso
	fimse

	CONTA c_enviar <- contas[posicao_enviar]

	se c_enviar.saldo < valor entao
		retorne falso
	fimse

	CONTA c_receber <- contas[posicao_receber]

	c_enviar.saldo <- c_enviar.saldo - valor
	c_receber.saldo <- c_receber.saldo + valor

	retorne verdadeiro
fimfuncao

funcao logico atualizar_dados (PESSOA p, inteiro codigo_cliente)
	inteiro posicao <- procurar_cliente(codigo_cliente)

	se posicao = -1 entao
		retorne falso
	fimse

	p.codigo <- codigo_cliente
	clientes[posicao] <- p

	retorne verdadeiro
fimfuncao

procedimento backup ()
	fficheiro ficheirologico

	fAbrir(ficheirologico, caminho, verdadeiro)
	
	inteiro i
	para i de 0 ate qtdClientes - 1
		PESSOA p <- clientes[i]
		literal linha <- strIntParaStr(p.codigo) + "-" + p.nome + "-" + p.bi_ou_nif + "-" + p.telefone + "-" + p.morada
		
        inteiro posicao <- procurar(p.codigo)
		se posicao <> -1 entao
			CONTA c <- contas[posicao]
			linha <- linha + "-" + strIntParaStr(c.numero_conta) + "-" + strRealParaStr(c.saldo) + "-" + c.estado + "-" + strIntParaStr(c.codigo_cliente)
		fim se

		fEscrever(ficheirologico, linha + "\n")
	fim para

	fFechar(ficheirologico)
fim procedimento

funcao literal limpar (literal texto_com_virgula)
	retorne strTrocar(texto_com_virgula, ",", "")
fim funcao

procedimento restaurar_ficheiro ()
	fficheiro ficheirologico

	fAbrir(ficheirologico, caminho, falso)

	enquanto fTemLinha(ficheirologico) faca
		literal linha <- fLerLinha(ficheirologico)
		literal quebrada[] <- strRepartir(linha, "-")

		PESSOA p
		p.codigo <- strValorInt(quebrada[0])
		p.nome <- quebrada[1]
		p.bi_ou_nif <- quebrada[2]
		p.telefone <- quebrada[3]
		p.morada <- quebrada[4]

		clientes[totalClientes] <- p
		totalClientes <- totalClientes + 1

		se aTamanho(quebrada, 0) = 5 entao
			continue
		fim se

		CONTA c
		c.numero_conta <- strValorInt(quebrada[5])
		c.saldo <- strValorReal(limparVirgula(quebrada[6]))
		c.estado <- quebrada[7]
		c.codigo_cliente <- strValorInt(quebrada[8])

		contas[totalContas] <- c
		totalContas <- totalContas + 1
	fim enquanto

	fFechar(ficheiro)
fim procedimento

inicio
	
	restaurar_ficheiro()

	inteiro opcao

	enquanto opcao <> 9 faca
		Menu()
		leia opcao
		
		logico resposta
		
		escolha opcao

		caso 1:
			PESSOA p
			escreva "Digite o seu nome: "
			leia p.nome
			escreva "Digite o seu telefone: "
			leia p.telefone
			escreva "Digite o seu bilhete: "
			leia p.bi_ou_nif
			escreva "Digite a sua morada: "
			leia p.morada

			resposta <- cadastrar_cliente(p)
		caso 2:
			listar_clientes()
		caso 3:
			inteiro codigo

			escreva "Digite o seu codigo pessoal: "
			leia codigo

			inteiro posicao <- buscar_cliente(codigo)

			se posicao <> -1 entao
				inteiro tipo_conta
				escreva "Insira o tipo de conta (0 para particular ou 1 para empresarial: "
				leia tipo_conta
				
				resposta <- abertura_de_conta(clientes[posicao], tipo_conta)
			fim se
		caso 4:
			inteiro numero_conta
			real valor

			escreva "Digite o numero da conta: "
			leia numero_conta

			escreva "Digite o valor a depositar: "
			leia valor

			resposta <- depositar_dinheiro (numero_conta, valor)
		caso 5:
			inteiro numero_conta
			real valor

			escreva "Digite o numero da conta: "
			leia numero_conta

			escreva "Digite o valor a levantar: "
			leia valor

			resposta <- levantar_dinheiro (numero_conta, valor)
		caso 6:
			inteiro numero_conta

			escreva "Digite o numero da conta: "
			leia numero_conta

			real saldo <- consultar_saldo(numero_conta)
			se saldo <> - 1 entao
		
				escreva " Saldo da conta: ", saldo, "\n"
			
			fim se
		caso 7:
			inteiro numero_conta_enviar, numero_conta_receber
			real valor

			escreva "Digite o numero da conta a enviar: "
			leia numero_conta_enviar

			escreva "Digite o numero da conta a receber: "
			leia numero_conta_receber

			escreva "Digite o valor a transferir: "
			leia valor

			resposta <- transferir_dinheiro (numero_conta_enviar, numero_conta_receber, valor)
		caso 8:
			inteiro codigo

			escreva "Insira o seu codigo pessoal: "
			leia codigo

			inteiro posicao <- procurar_cliente(codigo)

			PESSOA p

			escreva "Digite o seu nome: "
			leia p.nome
			escreva "Digite o seu telefone: "
			leia p.telefone
			escreva "Digite o seu bilhete: "
			leia p.bi_ou_nif
			escreva "Digite a sua morada: "
			leia p.morada

			resposta <- atualizar_dados(p, codigo)
		fim escolha

		se resposta entao
			escreva "Operaчуo feita com sucesso!\n"
			backup()
		fim se
	fim enquanto

fim algoritmo