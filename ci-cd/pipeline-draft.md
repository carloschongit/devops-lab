# Pipeline Draft — Diseño Inicial

Fecha: 22/02/2026
Estado: Definición manual antes de automatizar

## Flujo actual (manual)

1. Se modifica el código.
2. Se construye imagen manualmente.
3. Se ejecuta contenedor manualmente.
4. Se valida en navegador.
5. Se hace commit.

## Flujo esperado en CI/CD (conceptual)

Evento de inicio:
git push

El sistema debería ejecutar automáticamente:

Paso 1 — Validar repositorio recibido.
Paso 2 — Ejecutar proceso de build reproducible.
Paso 3 — Verificar que el build termina sin errores.
Paso 4 — Preparar artefacto listo para despliegue.

Todavía no se ejecuta nada.
Solo se describe el comportamiento esperado.

## Relación con este repositorio

notes/ → documentación del proceso
ci-cd/ → definición futura del pipeline
docker/ → lugar donde vivirá el build más adelante

## Secuencia que una máquina debería ejecutar

Estas instrucciones están escritas como pasos determinísticos:

1. Obtener código del repositorio.
2. Posicionarse en la raíz del proyecto.
3. Ejecutar proceso de construcción definido por el proyecto.
4. Confirmar resultado exitoso.
5. Marcar versión como válida.

## Equivalente en comandos (referencia)

git clone <repo>
cd devops-lab

# build (actualmente manual)

# docker build ...

Estos comandos aún no serán automatizados.
Solo se documentan.

## Por qué el pipeline también debe versionarse

El proceso de build debe vivir en el repositorio.
No debe depender de memoria humana.
Debe poder reconstruirse desde cero solo con el repo.

## Estado del proyecto hoy

Fase: previa a CI real.

Ya existe:

- repositorio estructurado
- aplicación funcional
- documentación base

Aún no existe:

- ejecución automática
- validaciones automáticas

### Fase 4 — Registro de Ejecución

Objetivo:
Dejar evidencia verificable de que el proceso fue ejecutado.

Todo pipeline necesita generar trazabilidad.
En esta fase se documenta cuándo se ejecutó y cuál fue el resultado.

Datos mínimos a registrar:

- Fecha de ejecución
- Versión del repositorio utilizada
- Resultado del proceso (éxito o fallo)
- Observaciones relevantes

La evidencia de ejecución se registrará en: ci-cd/execution-log.md
