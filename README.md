# Carol - Data Engineering - Challenge: Unified

Este repositório tem por objetivo apresentar como utilizar o processamento de dados SQL unificado na plataforma Carol.

## 1. Configurar ambiente

Vamos utilizar o banco de dados MySQL, a ferramenta de visualização de dados MySQL Workbench e uma máquina virtual VirtualBox com Windows 10. Todos esses softwares são gratuitos.

### 1.1. Máquina virtual

O primeiro passo é baixar e instalar a máquina virtual em seu computador. Para baixar basta entrar [neste link](https://www.virtualbox.org/wiki/Downloads) e selecionar o seu sistema operacional. A instalação é simples e segue um fluxo padrão.

> Caso esteja utilizando MacOS, certifique-se de ir até as configurações do sistema e permitir o uso do software em "Segurança e privacidade".

O segundo passo é baixar a imagem do sistema operacional Windows 10. A imagem está disponível gratuitamente [neste link](https://www.microsoft.com/en-us/software-download/windows10ISO).

Com o VirtualBox instalado e a imagem do Windows em mãos, é possível criar a máquina virtual. Para tanto, clique em `Novo` e forneça um nome a mesma. Depois disso selecione o tipo como `Microsoft Windows` e a versão como `Windows 10`, certificando-se de que a versão é compatível com a da imagem (32 ou 64-bit). Quanto as demais etapas, siga as recomendações.

Feito, a máquina virtual já está criada! Agora precisamos apontar para imagem do Windows. Vá em configurações da máquina virtual (botão invertido em cima dela) e depois em `Armazenamento`. Em `Controller: SATA` haverá um ícone de DVD: clique em cima dele. Uma nova tela abrirá e vc deverá clicar em `Adicionar`. Selecione a imagem do Windows e confirme. Haverão dois icones de DVDs e o primeiro tem o nome `Empty`. Certifique-se de apagar o `Empty` e manter apenas a imagem do Windows 10.

Agora inicie a máquina virtual e siga os passos para concluir a instalação do Windows 10. Tudo pronto!

## 1.2. Banco de dados

Todos os passos descritos nesta etapa serão realizados dentro da máquina virtual recém instalada.

Inicialmente entre [neste link](https://dev.mysql.com/downloads/installer/) para baixar o MySQL para Windows. Selecione a primeira opção. Com o instalador em mãos, siga as etapas sugeridas (caso hajam dúvidas, existem diversos links na internet que explicam como realizar esse procedimento).

> É possível realizar o download sem login clicando em um link discreto, localizado um pouco mais abaixo dos botões em destaque.

Para visualizar o banco de dados utilizaremos o MySQL Workbench que pode ser obtido [neste link](https://dev.mysql.com/downloads/workbench/). Siga o fluxo padrão para realizar a instalação desta ferramenta.

Concluída ambas as instalações, abra o MySQL Workbench e uma instância já estará disponível para uso. Entre nela utilizando a senha configurada na etapa de instalação do banco de dados MySQL. Por enquanto paramos por aqui.

## 1.3. Carol

### Tenants

O próximo passo consiste na criação dos seguintes ambientes:

| Nome | Tamanho | Tipo | Informações |
| --- | --- | --- | --- |
| [furtadodev](https://mobile.carol.ai/furtadodev) | Small | Dev | Este é o ambiente que será utilizado para desenvolvimento do aplicativo OpenFlights. |
| [furtadounif](https://mobile.carol.ai/furtadounif) | Big | Unified | Este é o ambiente que será o responsável por processar os dados de todos os customers que possuem o aplicativo OpenFlights. |
| [furtadocustomer](https://mobile.carol.ai/furtadocustomer) | Small | Customer | Este é um ambiente que simula um customer que faz uso do aplicativo OpenFlights. |

> Todos os ambientes criados são SQL Processing Only e não possuem a camada RT habilitada (seguindo as orientações mais atuais da plataforma).

### App OpenFlights

Com o ambiente **furtadodev** pronto para uso, vamos criar o aplicativo **OpenFlights**, neste ambiente, com a seguinte estrutura:

| Tipo entidade | Nome entidade | Informações |
| --- | --- | --- |
| STG | airlines | Responsável por armazenas os dados das companhias aéreas. |
| STG | airports | Responsável por armazenas os dados dos aeroportos. |
| STG | routes | Responsável por armazenar dados de companias aéreas e aeroportos de origem e destino. |
| DM | Routes | Responsável por unir os dados das staging tables e fornecer informações relacionadas as rotas aéreas. |

> As snapshots das staging tables e do Data Model podem ser encontradas [nesta pasta](https://github.com/Bruno-Furtado/carol-de-desafio-unified/tree/main/carol).

O aplicativo possui as seguintes configurações:

| Nome | Valor | Informações |
| --- | --- | --- |
| Processing Strategy | SQL | Não é um aplicativo hibrído, ou seja, processa dados apenas por meio de pipelines. |
| Unified tenant | furtadounif | Responsável por executar as pipelines e processar dados de todos os ambientes que possuem o app. |
| Git | Este repositório | Aponta para este repositório utilizando o arquivo [pipelines.json](https://github.com/Bruno-Furtado/carol-de-desafio-unified/blob/main/pipeline/pipelines.json) localizado dentro da pasta `pipeline`. |

> Como este app não híbrido, ao instala-lo em um ambiente do tipo customer, este ambiente já é linkado automaticamente com o ambiente unified. Portanto não há a necessidade de linkar via API.

## 2. Configurar base de dados

Todos os dados utilizados neste tutorial estão disponíveis [neste link](https://openflights.org/data.html).

### 2.1. Esquema e tabelas

Dentro da máquina virtual, utilize o MySQL Workbench para executar o script [01-create.sql](https://github.com/Bruno-Furtado/carol-de-desafio-unified/blob/main/mysql/01-create.sql). Ele irá criar o schema `openflights` e suas respectivas tabelas (estrutura espelho das staging tables criadas no ambiente de desenvolvimento).

Abaixo, segue uma explicação básica sobre os IDs que serão úteis para criação da pipeline.

- `airlines`: Lista de todas as companhias aéreas.
	- `airline_id`: chave primária
- `airports`: Lista de todas os aeroportos.
	- `airport_id`: chave primária
- `routes`: Lista de todas as rotas utilizadas pelas companhias aéreas para trafegar entre os aeroportos.
	- `airline_id`: ID da companhia aérea.
	- `source_airport_id`: ID do aeroporto de saída.
	- `destination_airport_id`: ID do aeroporto de chegada.

### 2.2. Ingestão de dados

Depois disso, execute os scripts abaixo para popular cada uma das tabelas recém criadas.

- [02-insert-airports.sql](https://github.com/Bruno-Furtado/carol-de-desafio-unified/blob/main/mysql/02-insert-airports.sql): Popula a tabela `airports` com os dados dos aeroportos.
- [03-insert-airlines.sql](https://github.com/Bruno-Furtado/carol-de-desafio-unified/blob/main/mysql/03-insert-airlines.sql): Popula a tabela `airlines` com os dados das companhias aéreas.
- [04-insert-routes.sql](https://github.com/Bruno-Furtado/carol-de-desafio-unified/blob/main/mysql/04-insert-routes.sql): Popula a tabela `routes` com os dados das rotas.


## 3. Configurar 2C e enviar dados do MySQL para Carol

Dentro da máquina virtual, siga os passos [deste link](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4405010022167-TOTVS-CAROL-Carol-Connect-2C-Como-instalar-a-Carol-Connect-2C-) paa realizar a instalação do 2C.

Com ele instalado, vamos configura-lo para que o mesmo envie os dados do MySQL para o ambiente **furtadocustomer**, que simula um ambiente de cliente [Este documento](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4405004985623) explica como realizar o procedimento.


## 4. Configurar processamento SQL unificado

O primeiro passo é instalar o aplicativo **OpenFlights** no ambiente unificado (**furtadounif**).

Depois disso, tendo a certeza de que todos os dados do 2C foram enviados ao ambiente do cliente, temos de instalar o aplicativo no ambiente do mesmo (**furtadocustomer**).

Uma vez terminada a instalação no ambiente do cliente, a própria Carol iniciará o envio dos dados da **furtadocustomer** para **furtadounif**. Com os dados no ambiente unificado, o processamento da pipeline é executado e a DM `Routes` é populada e os dados são direcionados para o ambiente do customer. Esta etapa encerra o fluxo de processamento SQL unificado.
