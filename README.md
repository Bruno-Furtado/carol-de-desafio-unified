# 1. Configurar ambiente

Neste tutorial, vamos utilizar o banco de dados MySQL, a ferramenta de visualização de dados MySQL Workbench e uma máquina virtual VirtualBox com Windows 10. Todos esses softwares são gratuitos.

## 1.1. Máquina virtual

O primeiro é baixar e instalar a máquina virtual em seu computador. Para baixar basta entrar [neste link](https://www.virtualbox.org/wiki/Downloads) e selecionar o seu sistema operacional. A instalação é simples e segue um fluxo padrão.

> Atenção: caso esteja utilizando MacOS, certifique-se de ir até as configurações do sistema e permitir o uso deste app em "Segurança e privacidade".

O segundo passo é baixar a imagem do sistema operacional Windows 10. A imagem está disponível gratuitamente [neste link](https://www.microsoft.com/en-us/software-download/windows10ISO).

Com o VirtualBox instalado e a imagem do Windows em mãos, é possível criar a máquina virtual. Para tanto, clique em `Novo` e forneça um nome a mesma. Depois disso selecione o tipo como `Microsoft Windows` e a versão como `Windows 10`, certificando-se de que a versão é compatível com a da imagem (32 ou 64-bit). Quanto as demais etapas, siga as recomendações.

A máquina virtual já está criada. Agora precisamos apontar para imagem do Windows. Vá em configurações da máquina virtual (botão invertido em cima dela) e depois em `Armazenamento`. Em `Controller: SATA` haverá um ícone de DVD: clique em cima dele. Uma nova tela abrirá e vc deverá clicar em `Adicionar`. Selecione a imagem do Windows e confirme. Haverão dois icones de DVDs e o primeiro tem o nome `Empty`. Certifique-se de apagar o `Empty` e manter apenas a imagem do Windows 10.

Tudo pronto, agora inicie a máquina virtual e siga os passos para concluir a instalação do Windows 10.

## 1.2. Banco de dados

Todos os passos descritos nesta etapa serão realizados dentro da máquina virtual recém instalada.

Inicialmente entre [neste link](https://dev.mysql.com/downloads/installer/) para baixar o MySQL para Windows. Selecione a primeira opção.

> Atenção: é possível realizar o download sem login clicando em um link discreto, localizado um pouco mais abaixo dos botões em destaque.

Com o instalador em mãos, siga as etapas sugeridas. Caso hajam dúvidas, existem diversos links na internet que explicam como realizar esse procedimento, como por exemplo [este](https://www.devmedia.com.br/instalando-e-configurando-a-nova-versao-do-mysql/25813).

Para visualizar o banco de dados utilizaremos o MySQL Workbench que pode ser obtido [neste link](https://dev.mysql.com/downloads/workbench/). Siga o fluxo padrão para realizar a instalação desta ferramenta.

Concluída ambas as instalações, abra o MySQL Workbench e uma instância já estará disponível para uso. Entre nela utilizando a senha configurada na etapa de instalação do banco de dados MySQL.

## 1.3. Carol

Serão utilizados 3 ambientes:

- [**furtadodev**](https://mobile.carol.ai/furtadodev): Ambiente de desenvolvimento, dev tenant, que possui o BQ habilitado e o Carol App **OpenFlights**.
- [**furtadounif**](https://mobile.carol.ai/furtadounif): Ambiente de produção, unified tenant, big, que centralizará todos os dados dos clientes do app **OpenFlights**.
- [**furtadocustomer**](https://mobile.carol.ai/furtadocustomer): Ambiente de produção que simula um cliente qualquer do aplicativo **OpenFlights**.

O aplicativo OpenFlights foi criado no ambiente **furtadodev**. O tipo de processamento selecionado foi o SQL (não é Hybrid) e a unified tenant selecionada foi a **furtadounif**.

Também no ambiente **furtadodev** foi criado o Data Model `Routes`. Mais detalhes podem ser obtidos [neste link](https://mobile.carol.ai/furtadodev/carol-ui/datamodels/routes).


# 2. Configurar base de dados

Todos os dados utilizados neste tutorial estão disponíveis [neste link](https://openflights.org/data.html).

## 2.1. Criação de esquema e tabelas

Dentro da máquina virtual, utilize o MySQL Workbench para executar o script `01-create.sql`. Ele irá criar o schema `openflights` e suas respectivas tabelas:

- `airlines`: Lista de todas as companhias aéreas.
	- `airline_id`: chave primária
- `airports`: Lista de todas os aeroportos.
	- `airport_id`: chave primária
- `routes`: Lista de todas as rotas utilizadas pelas companhias aéreas para trafegar entre os aeroportos.
	- `airline_id`: ID da companhia aérea.
	- `source_airport_id`: ID do aeroporto de saída.
	- `destination_airport_id`: ID do aeroporto de chegada.

## 2.2. Ingestão de dados

Depois disso, execute os scripts `02-insert-airports.sql`, `03-insert-airlines.sql` e `04-insert-routes.sql`. Ao final, as 3 tabelas criadas anteriormente estarão populadas com dados.


# 3. Configurar o 2C

Dentro da máquina virtual, siga os passos [deste link](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4405010022167-TOTVS-CAROL-Carol-Connect-2C-Como-instalar-a-Carol-Connect-2C-) paa realizar a instalação do 2C.

Com o 2C instalado, é possível criar uma conexão com o banco de dados seguinte [essas etapas](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4405004985623).