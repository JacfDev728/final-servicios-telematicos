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
### 1.3. Estado Final y Estrategia de Despliegue
La solución implementada cumple con todos los requisitos del examen, superando el principal desafío de saturación de recursos de la instancia t3.micro.

Validación Funcional (Staging): Para garantizar la estabilidad de la validación, se utilizó una estrategia de Estacionamiento (Staging), ejecutando la aplicación (Partes I/II) y el Monitoreo (Partes III/IV) por separado, ya que la capacidad de la t3.micro no permite correr los seis servicios principales simultáneamente de forma estable.

** IP Pública de la EC2 (Lab Actual): 35.172.184.223
**IP Privada de la EC2 (Conexión de Monitoreo): 172.31.26.79

🎯 Parte I y II: Empaquetado y Despliegue en AWS EC2 (HTTPS y Funcionalidad)

El despliegue consistió en una arquitectura de 3 contenedores (Nginx, Flask App, MySQL DB) orquestados por Docker Compose.
| Requisito | Descripción y solución | Archivo / Comando Clave |
| :--- | :--- | :--- |
| HTTPS y Redirección | Nginx se configuró como reverse proxy en el puerto 443 con certificados auto-firmados (en ssl/). Se implementó una regla de redirección para forzar HTTP (80) -> HTTPS (443). | nginx.conf |
| Conexión DB | Problema: La aplicación Flask no encontraba la DB, devolviendo un error 500 (Can't connect to local server through socket...). Solución 1: Se cambió el host de DB de 'localhost' al nombre del servicio Docker 'db'. Solución 2 (Final): Se agregó explícitamente el puerto :3306 en la cadena de conexión para forzar el protocolo TCP/IP y evitar que Python buscara el archivo de socket. | webapp/config.py |
| Inicialización de Tablas | Problema: El script init.sql fallaba al inicio de MySQL, dejando la tabla users vacía (Empty set). Solución: Se forzó la creación manual de la tabla users para que la aplicación Flask pudiera realizar el POST y db.session.commit(). | exec... < init.sql |
| Comando Final de Despliegue | Se utilizó docker compose (sintaxis moderna) para construir la imagen con la corrección de config.py y desplegar los servicios. | docker compose up --build -d  |

🎯 Parte III: Monitoreo con Prometheus y Node Exporter

Los servicios de monitoreo se instalaron y se ejecutaron directamente en el host EC2 como servicios de systemd para reducir la complejidad de la red Docker.
| Requisito | Descripción y solución | Archivo / Comando Clave |
| :--- | :--- | :--- |
| Instalación | Instalación de binarios y configuración de usuarios (prometheus, node_exporter). Se crearon los archivos .service y se habilitaron con sudo systemctl enable. | prometheus.service & node_exporter.service |
| Configuración | Se configuró prometheus.yml para recolectar métricas del propio Prometheus y del Node Exporter en el host. | prometheus.yml (Targets: localhost:9090 y localhost:9100) |
| Validación | Se verificó que ambas metas estén en estado UP accediendo a la UI de Prometheus. | http://35.172.184.223:9090/targets |

🎯 Parte IV: Visualización con Grafana
| Requisito | Descripción y solución | Archivo / Comando Clave |
| :--- | :--- | :--- |
| Instalación | Grafana se desplegó en un contenedor Docker separado. | docker run -d --name=grafana -p 3000:3000 grafana/grafana:latest |
| Conexión a Prometheus | Problema: Al usar localhost o 127.0.0.1, Grafana no podía ver a Prometheus (error connection refused). Solución: Se configuró la fuente de datos para apuntar a la IP privada del host EC2 para que el contenedor pueda acceder al servicio systemd en la red de AWS. | http://172.31.26.79:9090 |
| Dashboards | Se importó el panel preconfigurado ID 1860 (Node Exporter Full) y se crearon paneles adicionales para validar el requisito. | Dashboards creados y ID 1860 importado. |
---
## 2. Archivos del Repositorio

| Directorio / Archivo | Descripción | a |
| :--- | :--- | :--- |
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

Aprendí a crear un **Pipeline DevOps** modular donde **la portabilidad de Docker** y la **escalabilidad de AWS** se combinan con la observabilidad en tiempo real de Prometheus y Grafana. El principal aprendizaje fue que el diseño de la arquitectura (monitoreo como servicio sidecar en contenedores o como servicio de host) es fundamental para gestionar los recursos en entornos de infraestructura limitada.

### • ¿Qué fue lo más desafiante y cómo lo resolvería en un entorno real?

El mayor desafío fue la **saturación constante de la instancia t3.micro** al intentar correr la aplicación web y el monitoreo juntos, lo que obligó a usar una estrategia de Estacionamiento (Staging). En un entorno real, esto se resuelve con un **diseño de microservicios distribuido**, donde Prometheus y Grafana correrían en una **instancia separada** (o un servicio gestionado de AWS como ECS/EKS y CloudWatch) para aislar la carga y garantizar la estabilidad de la aplicación crítica.

### • ¿Qué beneficio aporta la observabilidad en el ciclo DevOps?

La observabilidad, facilitada por Prometheus y Grafana, aporta el beneficio de la detección proactiva de fallas y la **reducción del tiempo de resolución (MTTR)**. Permite obtener métricas en tiempo real sobre el rendimiento (CPU, RAM, latencia de la aplicación), guiando las decisiones de **escalabilidad, optimización de código y la validación automática de nuevos despliegues**.

---

## 4. Evidencias de Despliegue
* https://www.notion.so/final-servicios-telematicos-2af686ab5be58022a6b1d0030f59d755?source=copy_link
