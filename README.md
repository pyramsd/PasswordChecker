# PasswordChecker

Programa que testea que tan segura es tu contraseña con la ayuda de la librería `zxcvbn` y también te indica si la contraseña se ha filtrado en alguna lista de contraseñas

Ejecución
```bash
./passwordChecker.sh pasword123

./passwordChecker.sh pasword123 -wordlist ./usr/share/wordlists/rockyou.txt.gz
```

Uso
```
Usage: ./passwordChecker.sh <password> [-wordlist <ruta_a_wordlist>]

Parameters:
    password        Contraseña a evaluar
    -wordlist       Lista de contraseñas en un archivo
```
> No es necesario descomprimir el archivo, esto es útil se vas testear con archivos pesados
