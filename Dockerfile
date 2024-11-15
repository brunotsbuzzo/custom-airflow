FROM apache/airflow:2.10.3

ENV ORACLE_HOME=/opt/oracle
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_15
ENV PATH=/opt/oracle/instantclient_21_15:$PATH

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget=1.21.3-1+b2 \
        unzip=6.0-28 \
        libaio1=0.3.113-4 && \
    mkdir -p /opt/oracle && \
    usermod -aG sudo airflow && \
    usermod -aG root airflow && \
    groupadd airflow && chown -R airflow:airflow /opt /var /tmp /etc/ld.so.conf.d && \
    wget -q https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-basic-linux-21.15.0.0.0dbru.zip -P /tmp && \
    unzip /tmp/instantclient-basic-linux-21.15.0.0.0dbru.zip -d $ORACLE_HOME && \
    echo $LD_LIBRARY_PATH > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig && \
    rm -rf /tmp/instantclient* && rm -rf /var/lib/apt/lists/*

USER airflow

COPY ./requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt