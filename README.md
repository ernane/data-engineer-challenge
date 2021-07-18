## Organização do Projeto
------------
    ├── assets
    │   └── images               <- Imagens para documentação
    ├── config
    │   └── types_mapping.json   <- Arquivo disponibilizado no desafio
    ├── data
    │   ├── input                
    │   │   └── users            <- Arquivo disponibilizado no desafio
    │   └── output
    │       └── users            <- Arquivos de output do spark
    ├── jobs                     
    │   └── users_job.py         <- Job para execução no Glue Job
    ├── notebooks                
    │   └── users_job.json       <- Notebook para execução do spark via Jupyter Notebook
    ├── requirements             
    │   └── requirements.txt     <- Documentação do Desafio
    ├── terraform                
    │   ├── glue.tf              <- Configuração de criação do Job no Glue
    │   ├── iam.tf               <- Configurações de grupos e roles
    │   ├── main.tf              <- Arquivo de configuração
    │   ├── s3.tf                <- Criação e arquivos dos buckets
    │   └── variables.tf         <- Variáveis globais
    ├── .envrc                   <- Arquivo de configuração unix
    ├── .gitignore               <- Arquivo git
    ├── .python-version          <- Versão do python via pyenv
    ├── .terraform-version       <- Versão do terraform via tfenv
    ├── Dockerfile               <- Arquivo das imagens docker
    ├── LICENSE                  <- Licença do projeto
    ├── README.md                <- Arquivo principal de Documentação
    ├── docker-compose.yml       <- Arquivo que cria a stack para execução local
    ├── requirements-dev.txt     <- Depências para desenvolvimento Python
    └── requirements.txt         <- Depências Python

--------

## Componentes

### Glue [Execução em Cloud] 

O `AWS Glue` é um serviço de ETL - Extração, transformação e carga totalmente gerenciado que facilita a preparação e o carregamento de dados para análise. Com ele é possível executar scripts spark sem a necessidade de se preocupar com o provisionamento da infraestrura de um cluster spark.

### Pontos Positivos

- É integrado com uma grande variedade de serviços da `AWS`
- Oferece suporte nativo a dados armazenados no `Amazon Aurora` e em todos os outros mecanismos do `Amazon RDS`, no `Amazon Redshift` e no `Amazon S3`
- Não tem servidor. Não é necessário provisionar ou gerenciar a infraestrutura.
- Executa tarefas de ETL em um ambiente `Apache Spark` gerenciado com aumento de escala horizontal.
- Executa o `crawling` de suas fontes de dados, identifica os formatos de dados e sugere esquemas e transformações.

![glue](https://github.com/ernane/data-engineer-challenge/blob/main/assets/images/glue-job.png?raw=true)

### Terraform

Para esse desafio foi utilizado o `terraform` com o objetivo de prover `infrastructure as code(IaC)`. Todos os arquivos necessários para configuração e criação do Job Glue na `AWS`, podem ser encontrados no diretório **terraform**.

### Apache Parquet [Armazenamento Colunar]

É um formato de armazenamento colunar disponível em todos os projetos que pertencem ao ecossistema Hadoop, independente do modelo de processamento, framework ou linguagem usada. Outros pontos considerados para adoção do parquet, foram:

* Compressão por colunas é mais eficiente
* Algoritmo de compressão pode ser especificado por coluna
* otimizado para trabalhar com estruturas de dados complexas em massa

### Docker [Execução Local]

Para a execução do script spark de forma local foi escolhido utilizar o docker junto com o docker-compose
onde foi provisionado o spark em `mode standalone`. Para subir o cluster local baster executar o comando:

```bash
docker-compose up -d
```

Serviços provisionados

| host      | port | name           |
|-----------|------|----------------|
| localhost | 8080 | spark-master   |
| localhost | 8081 | spark-worker-1 |
| localhost | 8082 | spark-worker-2 |
| localhost | 8083 | spark-worker-3 |
| localhost | 8084 | spark-worker-4 |

![spark](https://github.com/ernane/data-engineer-challenge/blob/main/assets/images/spark-master.png?raw=true)