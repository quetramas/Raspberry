booleana=0
while [[ $boleana -eq 0 ]]; do
  clear
  echo "        __^__                                      __^__  "
  echo "       ( ___ )------------------------------------( ___ ) "
  echo -e "        | / |             \e[1;32m\e[5m¿Qué tramas?\e[25m\e[0m             | \ |"
  echo "        | / |                                      | \ |  "
  echo -e "        |___|       \e[5m Instalación automática \e[25m       |___|"
  echo "       (_____)------------------------------------(_____) "
  echo
  echo -e "1.- Persistencia de conexion ssh"
  echo
  echo -e "2.- Instalar PiHole"
  echo
  echo -e "3.- Instalar Ntop y Suricata"
  echo
  echo -e "4.- Reiniciar"
  echo
  echo -e "5.- Bastionar Raspberry Pi"
  echo
  echo -e "6.- Instalar Samba y Apache con Php"
  echo
  echo -e "\e[1;31m7.- Salir\e[0m"
  echo
  echo -e -n "Elige una opcion: "
  read opcion
  case $opcion in
    1) clear
       sleep 1.5
       echo "Realizando persistencia de SSH"
       sudo -k systemctl enable ssh >> errores.txt
       if [ $? -eq 0 ]; then
         sudo -k systemctl start ssh >> errores.txt
       else
         echo -e "\e[1;31mHa ocurrido algún error, comprobar el archivo errores.txt\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         read -p ""
       fi
      continue;;

    2) clear
       sleep 1.5
       echo "Instalando PiHole..."
       sleep 1.5
       git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole >> errores.txt
       if [ $? -eq 0 ]; then
         clear
         echo -e "\e[1;32mEl primer paso se ha completado correctamente\e[0m"
         sleep 1.5
         clear
         cd "Pi-hole/automated install/"
         sudo bash basic-install.sh >> errores.txt
       else
         clear
         echo -e "\e[1;31mPuede que la herramienta git no esté instalada correctamente, comprobarla\e[0m"
         sleep 1.5
       fi
      continue;;

    3) clear
       sleep 1.5
       echo "Instalando ntop..."
       sudo -k apt-get install ntop >> errores.txt
       if [ $? -eq 0 ]; then
         clear
         sleep 1.5
         echo -e "\e[1;32mNtop se ha instalado correctamente\e[0m"
         clear
         sudo /etc/init.d/ntop start >> errores.txt
         if [ $? -eq 0 ]; then
           echo -e "\e[1;32mEl servicio se ha iniciado correctamente\e[0m"
           sleep 1.5
           clear
           echo "Comprobando el servicio..."
           sudo netstat -tulpn | grep :3000 >> errores.txt
           sleep 1.5
         else
           clear
           echo -e "\e[1;31mHa ocurrido algún error, comprobar errores.txt\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           read -p ""
         fi
       else
         clear
         echo -e "\e[1;31mHa ocurrido algún error, comprobar errores.txt\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         read -p ""
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
         echo -e "\e[1;32mLas dependencias se han instalado correctamente\e[0m"
         wget http://www.openinfosecfoundation.org/download/suricata-4.1.4.tar.gz >> errores.txt
         if [ $? -eq 0 ]; then
           clear
           echo -e "\e[1;32mEl comando wget se ha ejecutado correctamente\e[0m"
           sleep 1.5
           clear
           echo "Desccomrpimiento y desempaquetando el paquete"
           sudo tar -xvf suricata-4.1.4.tar.gz >> errores.txt
           if [ $? -eq 0 ]; then
             clear
             echo -e "\e[1;32mSe ha descomprimido y desempaquetado correctamente\e[0m"
             sleep 1.5
             clear
             echo "Configurando..."
             sleep 1.5
             ./configure --sysconfdir=/etc --localstatedir=/var >> errores.txt
             if [ $? -eq 0 ]; then
               clear
               echo -e "\e[1;32mSe ha configurado correctamente\e[0m"
               sleep 1.5
               clear
               echo "Compilando..."
               make
               if [ $? -eq 0 ]; then
                 clear
                 echo -e "\e[1;32mSe ha completado correctamente\e[0m"
                 sleep 1.5
                 clear
                 sudo make install >> errores.txt
                 if [ $? -eq 0 ]; then
                   echo -e "\e[1;32mSe ha completado todo correctamente\e[0m"
                   clear
                   echo "instalando archivos de configuracion..."
                   sudo make install-conf >> errores.txt
                   if [ $? -eq 0 ]; then
                     clear "Instalando reglas..."
                     sleep 1.5
                     sudo make install-rules >> errores.txt
                     if [ $? -eq 0 ]; then
                       echo -e "\e[1;32mSe ha instalado todo correctamente\e[0m"
                       sleep 1.5
                     else
                       clear
                       echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                       read -p ""
                     fi
                   else
                     clear
                     echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                     echo
                     echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                     read -p ""
                   fi
                 else
                   clear
                   echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                   echo
                   echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                   read -p ""
                 fi
               else
                 clear
                 echo -e "\e[1;31mNo se ha completado correctamente, comprobar errores.txt\e[0m"
                 echo
                 echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                 read -p ""
               fi
             else
               clear
               echo -e "\e[1;31mNo se ha configurado correctamente, comprobar errores.txt\e[0m"
               echo
               echo -n -e "\e[1;34mEnter para continuar...\e[0m"
               read -p ""
             fi
           else
             clear
             echo -e "\e[1;31mEl comando (tar -xvf) no se ha realizado correctamente, comprobar errores.txt\e[0m"
             echo
             echo -n -e "\e[1;34mEnter para continuar...\e[0m"
             read -p ""
           fi
         else
           clear
           echo -e "\e[1;31mEl comando wget NO se ha realizado correctamente, comprobar errores.txt\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           read -p ""
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
          echo -n "Elige una opcion: "
          read option
          case $option in
              1)clear
                echo "cambiando contraseña del usuario pi..."
                sleep 1.5
                sudo passwd pi >> errores.txt
                if [ $? -eq 0 ]; then
                  echo -e "\e[1;32mLa contraseña ha sido cambiada correctamente\e[0m"
                else
                  echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                  echo
                  echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                  read -p ""
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
                  echo -e "\e[1;32mFail2Ban se ha instalado correctamente\e[0m"
                  clear
                  sudo -k apt-get install sendmail >> errores.txt
                  if [ $? -eq 0 ]; then
                    clear
                    echo -e "\e[1;32mSendmail se ha instalado correctamente\e[0m"
                    sleep 1.5
                    clear
                    echo -n "¿A que email quiere recibir los avisos?: "
                    read email
                    $email
                    sed 's/root@localhost/'$email'/g' auxiliar.txt > jail.conf
                    mv jail.conf /etc/fail2ban/
                  else
                    echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                    echo
                    echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                    read -p ""
                  fi
                else
                  echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                  echo
                  echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                  read -p ""
                fi
                  continue;;

              4)clear
                echo -e "\e[1;31mSaliendo...\e[0m"
                bool=1
          esac
        done
       continue;;

    6)clear
      echo "Instalando Samba..."
      sleep 1.5
      sudo -k apt-get install samba samba-common python-glade2 system-config-samba >> errores.txt
      if [ $? -eq 0 ]; then
        clear
        echo -e "\e[1;32mSamba se ha instalado correctamente\e[0m"
        sleep 1.5
        echo "Instalando Apache..."
        sleep 1.5
        sudo -k apt-get install apache2 >> errores.txt
        if [ $? -eq 0 ]; then
          clear
          echo -e "\e[1;32mApache se ha instalado correctamente\e[0m"
          echo
          echo -n -e "\e[1;34mEnter para continuar...\e[0m"
          read -p ""
          clear
          echo "Instalando php..."
          sudo -k apt-get install php5-common libapache2-mod-php5 php5-cli >> errores.txt
          if [ $? -eq 0 ]; then
            clear
            echo -e "\e[1;32mPhp se ha instalado correctamente\e[0m"
            sleep 1.5
            clear
            echo -e "\e[1;32mYa se pueden iniciar los servicios\e[0m"
            sleep 1.5
          else
            clear
            echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
            echo
            echo -n -e "\e[1;34mEnter para continuar...\e[0m"
            read -p ""
          fi
        else
          clear
          echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
          echo
          echo -n -e "\e[1;34mEnter para continuar...\e[0m"
          read -p ""
        fi
        clear
      else
        clear
        echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
        echo
        echo -n -e "\e[1;34mEnter para continuar...\e[0m"
        read -p ""
      fi
      continue;;

    7) clear
       sleep 1.5
       echo -e "\e[1;31mSaliendo...\e[0m"
       sleep 1.5
      booleana=1
  esac
done
