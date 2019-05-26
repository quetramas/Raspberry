booleana=0
while [[ $boleana -eq 0 ]]; do
  clear
  echo "1.- Persistencia de conexion ssh"
  echo
  echo "2.- Instalar PiHole"
  echo
  echo "3.- Instalar Ntop y Suricata"
  echo
  echo "4.- Reiniciar"
  echo
  echo "5.- Bastionar Raspberry Pi"
  echo
  echo "6.- Instalar Samba y Apache con Php"
  echo
  echo "7.- Salir"
  echo
  echo -e -n "Elige una opcion: "
  read opcion
  case opcion in
    1) clear
       sleep 1.5
       echo "Realizando persistencia de SSH"
       sudo -k systemctl enable ssh >> errores.txt
       if [ $? -eq 0 ]; then
         sudo -k systemctl start ssh >> errores.txt
       else
         echo "Ha ocurrido algún error, comprobar errores.txt"
         echo
         read -p "Enter para continuar..."
       fi
       #Comprobar
      continue;;

    2) clear
       sleep 1.5
       echo "Instalando PiHole..."
       sleep 1.5
       git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole >> errores.txt
       if [ $? -eq 0 ]; then
         clear
         echo "El primer paso se ha completado correctamente"
         sleep 1.5
         clear
         cd "Pi-hole/automated install/"
         sudo bash basic-install.sh >> errores.txt
       else
         clear
         echo "Puede que la herramienta git no esté instalada correctamente, comprobarla"
         sleep 1.5
       fi
      continue;;

    3) clear
       sleep 1.5
       echo "Instalando ntop..."
       sudo -k apt-get install ntop >> errores.txt
       clear
       if [ $? -eq 0 ]; then
         sleep 1.5
         echo "Ntop se ha instalado correctamente"
         clear
         sudo /etc/init.d/ntop start >> errores.txt
         if [ $? -eq 0 ]; then
           echo "El servicio se ha iniciado correctamente"
           sleep 1.5
           clear
           echo "Comprobando el servicio..."
           sudo netstat -tulpn | grep :3000 >> errores.txt
           sleep 2
         else
           clear
           echo "Ha ocurrido algún error, comprobar errores.txt"
           echo
           read -p "Enter para continuar..."
         fi
       else
         clear
         echo "Ha ocurrido algún error, comprobar errores.txt"
         echo
         read -p "Enter para continuar..."
         sleep 1.5
       fi
       clear
       echo "Instalando Suricata..."
       sleep 1.5
       clear
       echo "Instalando dependencias y paquetes..."
       sudo apt-get install wget build-essential libpcre3-dev libpcre3-dbg automake autoconf libtool libpcap-dev libnet1-dev libyaml-dev zlib1g-dev libcap-ng-dev libjansson-dev >> errores.txt
       if [ $? -eq 0 ]; then
         clear
         echo "Las dependencias se han instalado correctamente"
         wget http://www.openinfosecfoundation.org/download/suricata-4.1.4.tar.gz >> errores.txt
         if [ $? -eq 0 ]; then
           clear
           echo "El comando wget se ha ejecutado correctamente"
           sleep 1.5
           clear
           echo "Desccomrpimiento y desempaquetando el paquete"
           tar -xvf suricata-4.1.4.tar.gz >>
           if [ $? -eq 0 ]; then
             clear
             echo "Se ha descomprimido y desempaquetado correctamente"
             sleep 1.5
             clear
             echo "Configurando..."
             sleep 1.5
             ./configure --sysconfdir=/etc --localstatedir=/var >> errores.txt
             if [ $? -eq 0 ]; then
               clear
               echo "Se ha configurado correctamente"
               sleep 1.5
               clear
               echo "Compilando..."
               make
               if [ $? -eq 0 ]; then
                 clear
                 echo "Se ha completado correctamente"
                 sleep 1.5
                 clear
                 sudo make install >> errores.txt
                 if [ $? -eq 0 ]; then
                   echo "Se ha completado todo correctamente"
                   clear
                   echo "instalando archivos de configuracion..."
                   sudo make install-conf >> errores.txt
                   if [ $? -eq 0 ]; then
                     clear "Instalando reglas..."
                     sleep 1.5
                     sudo make install-rules >> errores.txt
                     if [ $? -eq 0 ]; then
                       echo "Se ha instalado todo correctamente"
                       sleep 1.5
                     else
                       clear
                       echo "Ha ocurrido algun error, comprobar errores.txt"ç
                       echo
                       read -p "Enter para continuar..."
                     fi
                   else
                     clear
                     echo "Ha ocurrido algun error, comprobar errores.txt"
                     echo
                     read -p "Enter para continuar..."
                   fi
                 else
                   clear
                   echo "Ha ocurrido algun error, comprobar errores.txt"
                   echo
                   read -p "Enter para continuar..."
                 fi
               else
                 clear
                 echo "No se ha completado correctamente, comprobar errores.txt"
                 echo
                 read -p "Enter para continuar..."
               fi
             else
               clear
               echo "No se ha configurado correctamente, comprobar errores.txt"
               echo
               read -p "Enter para continuar..."
             fi
           else
             clear
             echo "El comando (tar -xvf) no se ha realizado correctamente, comprobar errores.txt"
             echo
             read -p "Enter para continuar..."
           fi
         else
           clear
           echo "El comando wget NO se ha realizado correctamente, comprobar errores.txt"
           echo
           read -p "Enter para continuar..."
         fi
       fi
      ;;

    4)  clear
        sleep 1.5
        echo "Reiniciando..."
        sleep 1.5
        reboot
      ;;

    5)  clear
        sleep 1.5
        bool=0
        while [[ $bool -eq 0 ]]; do
          clear
          echo "1.- Cambiar contraseña de pi"
          echo
          echo "2.- Securizar servidor ssh"
          echo
          echo "3.- Instalar y configurar fail2ban y sendmail"
          echo
          echo "4.- Salir"
          echo
          read option
          case option in
              1)clear
                echo "cambiando contraseña del usuario pi..."
                sleep 1.5
                sudo passwd pi >>
                if [ $? -eq 0 ]; then
                  echo "La contraseña ha sido cambiada correctamente"
                else
                  echo "Ha ocurido algún error, revisar el archivo errores.txt"
                  echo
                  read -p "Enter para continuar..."
                fi
                continue;;

              2)clear
                echo "El archivo sshd_config se cambiará por el que hemos creado..."
                sleep 1.5
                mv sshd_config /etc/ssh/sshd_config
                continue;;

              3)clear
                echo "Instalando fail2ban..."
                sleep 1.5
                sudo -k apt-get install fail2ban >> errores.txt
                if [ $? -eq 0 ]; then
                  clear
                  echo "Fail2Ban se ha instalado correctamente"
                  clear
                  sudo -k apt-get install sendmail >> errores.txt
                  if [ $? -eq 0 ]; then
                    clear
                    echo "Sendmail se ha instalado correctamente"
                    sleep 1.5
                    clear
                    echo "¿A que email quiere recibir los avisos?: "
                    read email
                    $email
                    sed 's/root@localhost/'$email'/g' auxiliar.txt > jail.conf
                    mv jail.conf /etc/fail2ban/
                  else
                    echo "Ha ocurido algún error, revisar el archivo errores.txt"
                    echo
                    read -p "Enter para continuar..."
                  fi
                else
                  echo "Ha ocurido algún error, revisar el archivo errores.txt"
                  echo
                  read -p "Enter para continuar..."
                fi
              ;;

              4)clear
                echo "Saliendo..."
                bool=1
          esac
        done
       continue;;

    6)clear
      echo "Instalando Samba..."
      sleep 1.5
      sudo -k apt-get install samba samba-common python-glade2 system-config-samba >> errores.txt
      if [ $? -eq 0 ]; then
        echo "Samba se ha instalado correctamente"
        sleep 1.5
        echo "Instalando Apache..."
        sleep 1.5
        sudo -k apt-get install apache2 >> errores.txt
        if [ $? -eq 0 ]; then
          clear
          echo "Apache se ha instalado correctamente"
          read -p "Enter para continuar..."
          clear
          echo "Instalando php..."
          sudo -k apt-get install php5-common libapache2-mod-php5 php5-cli >> errores.txt
          if [ $? -eq 0 ]; then
            clear
            echo "Php se ha instalado correctamente"
            sleep 1.5
            clear
            echo "Ya se pueden iniciar los servicios"
            sleep 1.5
          else
            echo "Ha ocurido algún error, revisar el archivo errores.txt"
            read -p "Enter para continuar..."
          fi
        else
          echo "Ha ocurido algún error, revisar el archivo errores.txt"
          read -p "Enter para continuar..."
        fi
        clear
      else
        echo "Ha ocurido algún error, revisar el archivo errores.txt"
        read -p "Enter para continuar..."
      fi
      continue;;

    7) clear
       sleep 1.5
       echo "Saliendo..."
       sleep 1.5
      booleana=1
  esac
  #
  if [ $? -eq 0 ]; then
  fi
  #
done
