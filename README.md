# To Run application

## Start and SSH into Vagrant VM 

```
vagrant up
vagrant ssh servidorWeb
```

## Run the webApp

```
cd /home/vagrant/webapp
export FLASK_APP=run.py
/usr/local/bin/flask run --host=0.0.0.0
```
# 🚀 EXAMEN FINAL: SERVICIOS TELEMÁTICOS - PROYECTO CLOUDNOVA

Este repositorio contiene la configuración y evidencias del despliegue seguro y la implementación de observabilidad para la aplicación web de CloudNova en AWS EC2, utilizando Docker, Prometheus y Grafana.

---

## 1. Estructura del Proyecto

* **`docker/`**: Contiene el `Dockerfile`, `docker-compose.yml`, `nginx.conf`, y los certificados SSL autofirmados (`app.crt`, `app.key`).
* **`monitoring/`**: Contiene `prometheus.yml`, `alert.rules.yml` y las definiciones de los dashboards de Grafana (archivos `.json`).
* **`scripts/`**: Archivos de configuración de servicios (`node-exporter.service`, etc.).
* **`EVIDENCIAS.md`**: Capturas de pantalla del despliegue (acceso HTTPS, Grafana).

---

## 2. Conclusión Técnica (Respuesta a Preguntas)

### • ¿Qué aprendió al integrar Docker, AWS y Prometheus?

Aprendí a construir un **ciclo de vida de despliegue inmutable**. Docker garantiza que el entorno de la aplicación es idéntico tanto localmente como en la nube (AWS), eliminando la dependencia de la infraestructura subyacente. La integración de Prometheus me enseñó la importancia de la **recolección de métricas** desde el inicio para garantizar la salud del servicio y planificar la capacidad.

### • ¿Qué fue lo más desafiante y cómo lo resolvería en un entorno real?

Lo más desafiante fue la gestión de la **configuración de red y seguridad (SSL/TLS)** entre Docker, Nginx y las Reglas de Seguridad de AWS (Security Groups). En un entorno real, esto se resolvería utilizando un **Load Balancer (ELB/ALB)** de AWS para manejar la terminación SSL/TLS y delegar el tráfico seguro a los contenedores internos. También se usaría **Terraform** para gestionar la infraestructura de AWS como código (IaC), asegurando que las reglas de seguridad sean siempre correctas.

### • ¿Qué beneficio aporta la observabilidad en el ciclo DevOps?

La observabilidad (a través de Prometheus y Grafana) permite a los equipos **DevOps** pasar de la simple monitorización reactiva a un enfoque proactivo. Al centralizar métricas, *logs* y *traces*, se reduce drásticamente el **Tiempo Medio de Resolución (MTTR)** de los incidentes. Permite a los desarrolladores y operadores entender rápidamente qué está fallando (el por qué) y no solo cuándo falló (el qué), acelerando la entrega de valor de forma segura y fiable.

---

## 3. Evidencias de Despliegue

