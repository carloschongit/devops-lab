Week 1 — DevOps Foundations
Setting up environment and understanding CI/CD.

# 21/02/2026 — CI/CD Fundamentals

## Conceptos Observados

CI (Integracion Continuano o Continuous Integration) no es una herramienta es una practica.
Es un evento automático que ocurre cuando hay cambios en el repositorio.
La integracion pasa a ser responsabilidad de los desarrolladores.
se realizan commits regularmente, por lo que debe ser compilado regularmente.
La compilacion se debe activar automaticamente.

Antes todo era manual:

- construir
- probar
- desplegar

Y demoraban muchos los procesos.

Ahora el repositorio dispara procesos automáticamente.

Pipeline = receta definida que siempre ejecuta los mismos pasos, deberia de realizarce en una base de datos dedicada.

CD (Entrega Continua o Continuous Delivery/Deployments) es una practica de desarrollo que se puede lanzar en produccion en cualquier momento.

Anteriormente se recibia el paquete de instalacion con las instrucciones, manual asi que podria tener errores humanos.

Va de la mano con la CI ya que es un requisito.

Anteriormente las instrucciones eran manuales ahora se automatizan en un scrip.

Con la CD, la demora en los pasos pasa a ser minima, ya que casi todos los pasos estan automatizados.

## Traducción al laboratorio actual

Hoy el flujo es manual:

1. editar archivo
2. docker build
3. docker run
4. validar navegador

CI/CD reemplaza estas acciones por ejecución automática definida como pipeline.

El repositorio contiene:

- código
- definición futura del pipeline

## Traducción a Mi Laboratorio

Ayer hice manualmente:
docker build
docker run

Eso en DevOps real no se hace manual.
Se define en un pipeline.

El objetivo será que un git push construya automáticamente la imagen.
