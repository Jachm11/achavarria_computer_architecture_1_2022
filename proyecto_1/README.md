# Proyecto Individual
## The Imitation Game: Diseño e Implementación de un ASIP de desencriptación mediante RSA

Se realiza un framework que consiste en dos programas:
- Una interfaz gráfica escrita en Python que permite la sección del archivo .txt con la información de la imagen encriptada. Así mismo convierte dicho .txt a una imagen png y despliega en la pantalla. Esta interfaz permite llamar al programa de desencriptación con una llave específica, esta es guardada en un archivo .txt. La interfaz luego el .txt de salida y lo despliega al lado de la imagen original.
- Programa de desencriptación escrito en el ISA x86_64. Este se encarga de tomar el .txt original y cargarlo a memoria, así como el .txt con la llave. Luego lo desencripta cada pixel y genera un .txt de salida.

_Notas_:
- Todos los .txt deben consistir de números enteros separados por un espacio.
- Es necesario realizar cambios al código fuente en caso de querer procesar imágenes encriptadas de un tamaño distinto a 640x960 píxeles de entrada y 640x480 píxeles de salida.

## Herramientas

Se utilizó:
```
   - GUI
       - Python 3.10.9
           - Biblioteca de gráficos: TKinter 8.6
           - Procesamiento de imágenes: Pillow 9.4.0
   - Desencriptador
       - X86
           - Compilador: nasm 2.16.01
           - Debugger: gdb 13.1
```

## Uso

### Estructura de archivos

```
proyecto_1
│   README.md
│   Proyectos_Arqui1_Proyecto_Individual_v7.pdf    
│
└───The Imitation Game
    │   makefile
    │
    └───src       
    |   |  
    |   └────asm
    │         rsa_decrypt.asm       (desenciptación)
    │
    └───────pyhton
            |  main.py              (script del GUI)
            |
            └──build                (Este directorio es autogenerado)
            |     rsa_decrypt.o
            |     rsa_decrypt
            |     input.txt
            |     input.png
            |     output.txt
            |     output.png
            |     key.txt
            |
            └─assets                (Elementos de GUI)
              | equation.png   
```

### Comandos de uso

Dentro del directorio "The Imitation Game"

Compilado y ejecución:
```
    make exec
```

Compilado y debuggeo de x86
```
    make debug
```