---
title: Instalacion del entorno de desarrollo
tags: [prueba, concepto, markdown, entorno de desarrollo]
categories: instalacion
---


###Preparación del entorno de desarrollo
El objetivo de este documento es permitir que los desarrolles puedan crear **un entorno de test** en una maquina local o virtual lo mas parecida posible a la que en un futuro se va a utilizar en el entorno de producción.
Esta guía está pensada para el sistema operativo **Ubuntu Server 14.04.1 LTS**.

####Instalación del sistema operativo
Para la instalación de Ubuntu Server tan solo hay que utilizar la imagen de disco que se puede descargar desde su página oficial desde [este enlace](http://www.ubuntu.com/download/server).

Una vez arrancada la máquina desde la imagen de disco tan solo hay que seguir las instrucciones de instalación. Durante este proceso se le preguntará si desea preinstalar ciertos paquetes. Es recomendable instalar los siguientes paquetes:

- OpenSSH
- LAMP Stack  

####Configuración básica del servidor
#####Dar permisos de administrador a la nueva cuenta creada
Para evitar salir de la cuenta del usuario *normal* y volver a entrar con la cuenta *root* hay que darle *privilegios* `sudo` a nuestra cuenta de usuario.

Para dar este tipo de privilegios hay que ejecutar el comando 
	
	visudo
Este comando abrirá un archivo de configuración. Encuentre una sección similar a esta:

	# User privilege specification
	root    ALL=(ALL:ALL) ALL

Tan solo hay que añadir otra linea al fichero con el mismo formato que la anterior, sustituyendo "icca" por el nombre de la cuenta de usuario que corresponda:

	# User privilege specification
	root    ALL=(ALL:ALL) ALL
	icca    ALL=(ALL:ALL) ALL

Después guarde el fichero.

#####Configurar la interfaz de red con una IP estática
Hay que modificar el archivo de configuración de red 
	
	/etc/network/interfaces

Y utilizamos la siguiente configuración:

	# Configuración de dirección IP fija para el interfaz eth0
	auto eth0
	iface eth0 inet static
	address 192.168.100.228
	netmask 255.255.255.0
	network 192.168.100.0
	broadcast 192.168.100.255
	gateway 192.168.100.1

y reiniciamos el servicio con:

	sudo /etc/init.d/networking restart

####Instalación y configuración de Apache
Para instalar apache es recomendable hacerlo a través del gestor de paquetes de Ubuntu `apt`.
Para comenzar la instalación ejecutamos los siguientes comandos:

	sudo apt-get update
	sudo apt-get install apache2
	
Dado que se ha utilizado el comando `sudo` para realizar la instalación con privilegios `root` se le preguntará por la contraseña de usuario.

Después de ejecutar estos comandos el servidor apache estará instalado, para comprobar si funciona correctamente intenta acceder al servidor mediando un navegador

	http://direccion_IP_del_servidor

Si no sabes cual es la dirección pública del servidor puedes utilizar el siguiente comando:

	ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
	
Una vez instalado Apache se puede personalizar la configuración modificando el archivo de configuración situado en la carpeta

	/etc/apache2/con

La carpeta por defecto, donde Apache buscará para servir los archivos es

	/var/www
	
####Instalación y configuración de MySQL
Para instalarlo ejecutamos el siguiente comando

	sudo apt-get install mysql-server php5-mysql

Durante el proceso de instalación se le pedirá que introduzca y confirme la contraseña para el usuario `root` de MySQL.

Cuando termine el proceso de instalación es necesario ejecutar algunos comandos para tener un entorno MySQL seguro.

Primero hay que crear la estructura de directorios de bases de datos, donde MySQL almacenará su información

	sudo mysql_install_db

A continuación es necesario ejecutar un script de seguridad que elimina algunos comportamientos peligrosos por defecto

	sudo mysql_secure_installation

Durante el proceso de instalación se pedirá la contraseña del usuario `root` y se preguntará si es necesario cambiar dicha contraseña. Para el resto de opciones tan solo hay que pulsar `ENTER` para aceptar los valores por defecto.

Por último si queremos modificar los parámetros de configuración de MySQL es necesario modificar el archivo de configuración. Para ello, primero se realiza una copia de seguridad del archivo original
	
	sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf_original

Se modifica el archivo con cualquier editor de texto
	
	sudo nano /etc/mysql/my.cnf

Y se reinicia el servidor MySQL

	sudo service mysql start

Los parámetros que se han modificado en este caso son los siguientes:

	bind-address		= 0.0.0.0
	innodb_buffer_pool_size = 512M


####Configuración del servidor SSH
Para instalar la aplicación servidor de OpenSSH, y los archivos de soporte relacionados, use en una línea de comandos la siguiente instrucción:
	
	sudo apt-get install openssh-server

El paquete `openssh-server` se puede seleccionar para instalar durante el proceso de Instalación de la Edición Servidor.

Puede configurar el comportamiento predeterminado del servidor OpenSSH, sshd, editando el archivo `/etc/ssh/sshd_config`.

Antes de cambiar e archivo de configuración es recomendable hacer una copia de seguridad del archivo protegerlo contra escritura.

	sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
	sudo chmod a-w /etc/ssh/sshd_config.original

Es recomendable restringir el acceso al usuario `root` por motivos de seguridad. Para ello busque la linea

	PermitRootLogin yes

Puede modificar esta linea a *no* si quiere deshabitar el acceso remoto a `root`

	PermitRootLogin no
	
Después de hacer los cambios en el archivo `/etc/ssh/sshd_config`, guarde este, y reinicie el servidor `sshd` para que los cambios tengan efecto usando la siguiente orden en una terminal:

	sudo service ssh restart
	
####Instalación y configuración de openLDAP
Para instalar el servidor LDAP utilizamos los siguientes comandos:

	sudo apt-get install slapd ldap-utils
	sudo dpkg-reconfigure slapd

En el proceso de instalación se pedirá el usuario, contraseña de usuario, y dominio

	usuario:admin
	pass:icca
	dominio: relationalmessages.com
	login: cn=admin,dc=relationalmessages,dc=com
	Base de datos: HDB




