# Day 28 Reflection
## ¿Qué aprendiste al introducir el fallo intencional en el pipeline?
Que un pipeline falla de forma controlada y predecible cuando se introduce
un `exit 1` explícito. GitHub Actions detiene la ejecución en el step que
falla y marca todos los steps siguientes como skipped. Esto confirma que el
pipeline respeta el orden de ejecución y que un fallo temprano protege los
steps posteriores de ejecutarse con un estado inválido.
## ¿Cómo identificaste en los logs el step exacto donde falló el pipeline?
Usando `gh run view $FAILED_RUN_ID --log` para descargar el log completo y
luego filtrando con `grep -i "error"`, `grep -i "failed"` y `grep -i "exit"`.
El log muestra cada step con su nombre y estado, lo que permite identificar
exactamente en qué punto del pipeline ocurrió el fallo.
## ¿Por qué `gh run view` falla en modo no interactivo sin un ID explícito?
Porque en modo interactivo `gh` puede presentar un menú para seleccionar el
run. Cuando la salida se redirige a un archivo con `>`, ya no hay terminal
interactiva disponible, por lo que `gh` no puede mostrar ese menú y falla.
La solución es extraer el ID explícitamente con
`gh run list --json databaseId --jq '.[0].databaseId'`
y almacenarlo en una variable.
## ¿Qué diferencia hay entre validación de contenido y validación funcional?
La validación de contenido confirma que el archivo está bien escrito — usa
`grep`, `diff` y validación de sintaxis YAML para verificar que los cambios
correctos están presentes en el archivo antes de commitear. La validación
funcional confirma que el código realmente hace lo que se espera cuando se
ejecuta — corre el script, el build o el comando y verifica el resultado.
En el caso de workflows de GitHub Actions la validación funcional no puede
hacerse localmente y se sustituye por observar el resultado del run en
GitHub Actions con `gh run list`.
## ¿Para qué sirve Trivy y qué diferencia hay entre `trivy fs` y `trivy image`?
Trivy es un escáner de vulnerabilidades de seguridad. `trivy fs` escanea el
sistema de archivos local del repositorio buscando dependencias con CVEs
conocidos y configuraciones inseguras en archivos como el Dockerfile.
`trivy image` escanea una imagen Docker ya construida, incluyendo todas las
capas del sistema operativo base y los paquetes instalados dentro del
contenedor. La diferencia clave es que `trivy image` puede encontrar
vulnerabilidades en el sistema operativo base que `trivy fs` no detectaría
porque solo analiza los archivos del proyecto.