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

* Contiene el `Dockerfile`, `docker-compose.yml`, `nginx.conf`, y los certificados SSL autofirmados (`app.crt`, `app.key`).
* Contiene `prometheus.yml`, `alert.rules.yml` y las definiciones de los dashboards de Grafana (archivos `.json`).
* Archivos de configuración de servicios (`node-exporter.service`, etc.).
* Capturas de pantalla del despliegue (acceso HTTPS, Grafana).

---
### 1.2. Despliegue en la Nube (AWS EC2)

* [cite_start]Se lanzó una instancia EC2 y se configuró un **Security Group** para permitir tráfico SSH (22), HTTP (80), HTTPS (443) y Grafana (3000). [cite: 15]
* [cite_start]Se instaló Docker y se ejecutó la aplicación usando Docker Compose[cite: 16].
---
## 2. Archivos del Repositorio

| Directorio / Archivo | Descripción | |
| :--- | :--- | :--- | |
| Configuración de Nginx y orquestación. | Parte 1 y 2 | |
| `Dockerfile` | Instrucciones para construir la imagen. | |
| `docker-compose.yml` | Define el servicio `webapp` y mapea los puertos. | |
| `nginx.conf (docker)` | Configuración de Nginx (SSL, redirección 80->443). | |
| Configuración de métricas y visualización. | Parte 3 y 4 | |
| `prometheus.yml` | Configuración de los jobs de Node Exporter y Prometheus. | |
| `alert.rules.yml` | Definición de alertas (ej. CPU > 80%). | 
| `dashboard_cpu_disk.json` | Exportación del dashboard custom (CPU/Memoria/Disco). | |
| **`README.md`** | Este archivo, documentación y conclusiones. | |
---

## 3. Conclusión Técnica (Respuesta a Preguntas)

### • ¿Qué aprendió al integrar Docker, AWS y Prometheus?

Aprendí a construir un **ciclo de vida de despliegue inmutable**. Docker garantiza que el entorno de la aplicación es idéntico tanto localmente como en la nube (AWS), eliminando la dependencia de la infraestructura subyacente. La integración de Prometheus me enseñó la importancia de la **recolección de métricas** desde el inicio para garantizar la salud del servicio y planificar la capacidad.

### • ¿Qué fue lo más desafiante y cómo lo resolvería en un entorno real?

Lo más desafiante fue la gestión de la **configuración de red y seguridad (SSL/TLS)** entre Docker, Nginx y las Reglas de Seguridad de AWS (Security Groups). En un entorno real, esto se resolvería utilizando un **Load Balancer (ELB/ALB)** de AWS para manejar la terminación SSL/TLS y delegar el tráfico seguro a los contenedores internos. También se usaría **Terraform** para gestionar la infraestructura de AWS como código (IaC), asegurando que las reglas de seguridad sean siempre correctas.

### • ¿Qué beneficio aporta la observabilidad en el ciclo DevOps?

La observabilidad (a través de Prometheus y Grafana) permite a los equipos **DevOps** pasar de la simple monitorización reactiva a un enfoque proactivo. Al centralizar métricas, *logs* y *traces*, se reduce drásticamente el **Tiempo Medio de Resolución (MTTR)** de los incidentes. Permite a los desarrolladores y operadores entender rápidamente qué está fallando (el por qué) y no solo cuándo falló (el qué), acelerando la entrega de valor de forma segura y fiable.

---

## 4. Evidencias de Despliegue
* https://www.notion.so/final-servicios-telematicos-2af686ab5be58022a6b1d0030f59d755?source=copy_link
