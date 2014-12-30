<h1>Preparación del entorno de desarrollo</h1>

<p>El objetivo de este documento es permitir que los desarrolles puedan crear <strong>un entorno de test</strong> en una maquina local o virtual lo mas parecida posible a la que en un futuro se va a utilizar en el entorno de producción.
Esta guía está pensada para el sistema operativo <strong>Ubuntu Server 10.04.1 LTS</strong>.</p>

<h2>Instalación del sistema operativo</h2>

<p>Para la instalación de Ubuntu Server tan solo hay que utilizar la imagen de disco que se puede descargar desde su página oficial desde <a href="http://www.ubuntu.com/download/server">este enlace</a>.</p>

<p>Una vez arrancada la máquina desde la imagen de disco tan solo hay que seguir las instrucciones de instalación. Durante este proceso se le preguntará si desea preinstalar ciertos paquetes. Es recomendable instalar los siguientes paquetes:</p>

<ul>
<li>OpenSSH</li>
<li>LAMP Stack  </li>
</ul>

<h2>Configuración básica del servidor</h2>

<h3>Dar permisos de administrador a la nueva cuenta creada</h3>

<p>Para evitar salir de la cuenta del usuario <em>normal</em> y volver a entrar con la cuenta <em>root</em> hay que darle <em>privilegios</em> <code>sudo</code> a nuestra cuenta de usuario.</p>

<p>Para dar este tipo de privilegios hay que ejecutar el comando</p>

<pre><code>visudo
</code></pre>

<p>Este comando abrirá un archivo de configuración. Encuentre una sección similar a esta:</p>

<pre><code># User privilege specification
root    ALL=(ALL:ALL) ALL
</code></pre>

<p>Tan solo hay que añadir otra linea al fichero con el mismo formato que la anterior, sustituyendo "icca" por el nombre de la cuenta de usuario que corresponda:</p>

<pre><code># User privilege specification
root    ALL=(ALL:ALL) ALL
icca    ALL=(ALL:ALL) ALL
</code></pre>

<p>Después guarde el fichero.</p>

<h3>Configurar la interfaz de red con una IP estática</h3>

<p>Hay que modificar el archivo de configuración de red</p>

<pre><code>/etc/network/interfaces
</code></pre>

<p>Y utilizamos la siguiente configuración:</p>

<pre><code># Configuración de dirección IP fija para el interfaz eth0
auto eth0
iface eth0 inet static
address 192.168.100.228
netmask 255.255.255.0
network 192.168.100.0
broadcast 192.168.100.255
gateway 192.168.100.1
</code></pre>

<p>y reiniciamos el servicio con:</p>

<pre><code>sudo /etc/init.d/networking restart
</code></pre>

<h2>Instalación y configuración de Apache</h2>

<p>Para instalar apache es recomendable hacerlo a través del gestor de paquetes de Ubuntu <code>apt</code>.
Para comenzar la instalación ejecutamos los siguientes comandos:</p>

<pre><code>sudo apt-get update
sudo apt-get install apache2
</code></pre>

<p>Dado que se ha utilizado el comando <code>sudo</code> para realizar la instalación con privilegios <code>root</code> se le preguntará por la contraseña de usuario.</p>

<p>Después de ejecutar estos comandos el servidor apache estará instalado, para comprobar si funciona correctamente intenta acceder al servidor mediando un navegador</p>

<pre><code>http://direccion_IP_del_servidor
</code></pre>

<p>Si no sabes cual es la dirección pública del servidor puedes utilizar el siguiente comando:</p>

<pre><code>ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
</code></pre>

<p>Una vez instalado Apache se puede personalizar la configuración modificando el archivo de configuración situado en la carpeta</p>

<pre><code>/etc/apache2/con
</code></pre>

<p>La carpeta por defecto, donde Apache buscará para servir los archivos es</p>

<pre><code>/var/www
</code></pre>

<h2>Instalación y configuración de MySQL</h2>

<p>Para instalarlo ejecutamos el siguiente comando</p>

<pre><code>sudo apt-get install mysql-server php5-mysql
</code></pre>

<p>Durante el proceso de instalación se le pedirá que introduzca y confirme la contraseña para el usuario <code>root</code> de MySQL.</p>

<p>Cuando termine el proceso de instalación es necesario ejecutar algunos comandos para tener un entorno MySQL seguro.</p>

<p>Primero hay que crear la estructura de directorios de bases de datos, donde MySQL almacenará su información</p>

<pre><code>sudo mysql_install_db
</code></pre>

<p>A continuación es necesario ejecutar un script de seguridad que elimina algunos comportamientos peligrosos por defecto</p>

<pre><code>sudo mysql_secure_installation
</code></pre>

<p>Durante el proceso de instalación se pedirá la contraseña del usuario <code>root</code> y se preguntará si es necesario cambiar dicha contraseña. Para el resto de opciones tan solo hay que pulsar <code>ENTER</code> para aceptar los valores por defecto.</p>

<p>Por último si queremos modificar los parámetros de configuración de MySQL es necesario modificar el archivo de configuración. Para ello, primero se realiza una copia de seguridad del archivo original</p>

<pre><code>sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf_original
</code></pre>

<p>Se modifica el archivo con cualquier editor de texto</p>

<pre><code>sudo nano /etc/mysql/my.cnf
</code></pre>

<p>Y se reinicia el servidor MySQL</p>

<pre><code>sudo service mysql start
</code></pre>

<p>Los parámetros que se han modificado en este caso son los siguientes:</p>

<pre><code>bind-address        = 0.0.0.0
innodb_buffer_pool_size = 512M
</code></pre>

<h2>Configuración del servidor SSH</h2>

<p>Para instalar la aplicación servidor de OpenSSH, y los archivos de soporte relacionados, use en una línea de comandos la siguiente instrucción:</p>

<pre><code>sudo apt-get install openssh-server
</code></pre>

<p>El paquete <code>openssh-server</code> se puede seleccionar para instalar durante el proceso de Instalación de la Edición Servidor.</p>

<p>Puede configurar el comportamiento predeterminado del servidor OpenSSH, sshd, editando el archivo <code>/etc/ssh/sshd_config</code>.</p>

<p>Antes de cambiar e archivo de configuración es recomendable hacer una copia de seguridad del archivo protegerlo contra escritura.</p>

<pre><code>sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
sudo chmod a-w /etc/ssh/sshd_config.original
</code></pre>

<p>Es recomendable restringir el acceso al usuario <code>root</code> por motivos de seguridad. Para ello busque la linea</p>

<pre><code>PermitRootLogin yes
</code></pre>

<p>Puede modificar esta linea a <em>no</em> si quiere deshabitar el acceso remoto a <code>root</code></p>

<pre><code>PermitRootLogin no
</code></pre>

<p>Después de hacer los cambios en el archivo <code>/etc/ssh/sshd_config</code>, guarde este, y reinicie el servidor <code>sshd</code> para que los cambios tengan efecto usando la siguiente orden en una terminal:</p>

<pre><code>sudo service ssh restart
</code></pre>

<h2>Instalación y configuración de openLDAP</h2>

<p>Para instalar el servidor LDAP utilizamos los siguientes comandos:</p>

<pre><code>sudo apt-get install slapd ldap-utils
sudo dpkg-reconfigure slapd
</code></pre>

<p>En el proceso de instalación se pedirá el usuario, contraseña de usuario, y dominio</p>

<pre><code>usuario:admin
pass:icca
dominio: relationalmessages.com
login: cn=admin,dc=relationalmessages,dc=com
Base de datos HDB
</code></pre>
