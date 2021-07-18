## Componentes

### Glue [Execução em Cloud] 

O `AWS Glue` é um serviço de ETL - Extração, transformação e carga totalmente gerenciado que facilita a preparação e o carregamento de dados para análise. Com ele é possível executar scripts spark sem a necessidade de se preocupar com o provisionamento da infraestrura de um cluster spark.

### Pontos Positivos

- É integrado com uma grande variedade de serviços da `AWS`
- Oferece suporte nativo a dados armazenados no `Amazon Aurora` e em todos os outros mecanismos do `Amazon RDS`, no `Amazon Redshift` e no `Amazon S3`
- Não tem servidor. Não é necessário provisionar ou gerenciar a infraestrutura.
- Executa tarefas de ETL em um ambiente `Apache Spark` gerenciado com aumento de escala horizontal.
- Executa o `crawling` de suas fontes de dados, identifica os formatos de dados e sugere esquemas e transformações.

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

![arquitetura](https://github.com/ernane/data-engineer-challenge/blob/main/assets/images/spark-master.png?raw=true)