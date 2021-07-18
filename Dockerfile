#===============================================================================================================================================#
#                                                                   base                                                                        #
#===============================================================================================================================================#
ARG debian_buster_image_tag=8-jre-slim

FROM openjdk:${debian_buster_image_tag} as base

ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace} \
    && apt-get update -y \
    && apt-get install -y python3 python3-pip \
    && pip3 install -U pip setuptools  \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${shared_workspace}

VOLUME ${shared_workspace}


#===============================================================================================================================================#
#                                                                   spark_base                                                                  #
#===============================================================================================================================================#
FROM base AS spark_base

ARG spark_version=3.1.1
ARG hadoop_version=2.7

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

WORKDIR ${SPARK_HOME}


#===============================================================================================================================================#
#                                                                   spark_master                                                                #
#===============================================================================================================================================#
FROM spark_base AS spark_master

ARG spark_master_web_ui=8080

EXPOSE ${spark_master_web_ui} ${SPARK_MASTER_PORT}

CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out


#===============================================================================================================================================#
#                                                                   spark_worker                                                                #
#===============================================================================================================================================#
FROM spark_base AS spark_worker

ARG spark_worker_web_ui=8081

EXPOSE ${spark_worker_web_ui}

CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out


#===============================================================================================================================================#
#                                                                   jupyterlab                                                                  #
#===============================================================================================================================================#
FROM base AS jupyterlab

ARG spark_version=3.1.1
ARG jupyterlab_version=3.0.14

RUN pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version}

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=