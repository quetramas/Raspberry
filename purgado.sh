#Algunas variables
mac=`ip link show | awk '/ether/ {print $2}' | head -1`
ip=`hostname -i | cut -d " " -f 1`
booleana=0
while [[ $booleana -eq 0 ]]; do
  clear
  echo "        __^__                                      __^__  "
  echo "       ( ___ )------------------------------------( ___ ) "
  echo -e "        | / |             \e[1;32m¿Qué tramas?\e[0m             | \ |"
  echo "        | / |                                      | \ |  "
  echo -e "        |___|       \e[5m Instalación automática \e[25m       |___|"
  echo "       (_____)------------------------------------(_____) "
  echo
  echo -e "                email: \e[1;32mcontacto@quetramasblog.com\e[0m"
  echo
  echo -e "--------------------------------------------------------"
  echo -e " Mac: \e[1;32m$mac\e[0m             Ip: \e[1;32m$ip\e[0m"
  echo -e "--------------------------------------------------------"
  echo
  echo
  echo -e "1.- Persistencia de conexion ssh"
  echo
  echo -e "2.- Instalar PiHole"
  echo
  echo -e "3.- Instalar Ntop y Suricata"
  echo
  echo -e "4.- Bastionar Raspberry Pi"
  echo
  echo -e "5.- Reiniciar"
  echo
  echo -e "\e[1;31m6.- Salir\e[0m"
  echo
  echo -e -n "Elige una opcion: "
  read opcion
  case $opcion in

    1) #Persistencia ssh
       clear
       sleep 1.5
       echo "Realizando persistencia de SSH"
       sudo -k systemctl enable ssh 2>> errores.txt
       if [ $? -eq 0 ]; then
         echo ""
         echo -e "El comando se ha ejecutado correctamente"
       else
         echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
       fi
       continue;;

    2) #Instalar PiHole
       clear
       sleep 1.5
       echo "Instalando PiHole..."
       sleep 1.5
       git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole 2>> errores.txt
       if [ $? -eq 0 ]; then
         echo ""
         echo -e "\e[1;32mEl comando se ha ejecutado correctamente\e[0m"
         echo
         cd "Pi-hole/automated install/"
         echo
         echo "Instalando PiHole..."
         sleep 1.5
         sudo bash basic-install.sh 2>> errores.txt
         if [ $? -eq 0 ]; then
           echo ""
           echo -e "\e[1;32mPiHole se ha instalado correctamente\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         else
           echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         fi
       else
         echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
       fi
       continue;;

    3) #Instalar Ntop y Suricata
       clear
       sleep 1.5
       echo "Instalando Ntop..."
       sudo -k apt-get install ntop 2>> errores.txt
       if [ $? -eq 0 ]; then
         clear
         sleep 1.5
         echo -n -e "\e[1;32mNtop se ha instalado correctamente\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         sudo /etc/init.d/ntop start 2>> errores.txt
         if [ $? -eq 0 ]; then
           echo ""
           echo -e "\e[1;32mNtop se ha iniciado correctamente\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           clear
           echo "Comprobando el servicio..."
           sleep 1.5
           sudo netstat -tulpn | grep :3000 2>> errores.txt
           if [ $? -eq 0 ]; then
             echo ""
             echo -e "\e[1;32mEl servicio está corriendo correctamente\e[0m"
             echo
             echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           else
             echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
             echo
             echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           fi
         else
           echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         fi
       else
         echo -e "\e[1;31mHa ocurrido un error, comprobar el archivo \"errores.txt\"\e[0m"
         echo
         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
       fi
       clear

       #Instalar suricata
       sleep 2
       echo "Instalando suricata..."
       sleep 1.5
       echo
       echo "Instalando dependencias y paquetes..."
       sudo apt-get install wget build-essential libpcre3-dev libpcre3-dbg automake autoconf libtool libpcap-dev libnet1-dev libyaml-dev zlib1g-dev libcap-ng-dev libjansson-dev 2>> errores.txt
       if [ $? -eq 0 ]; then
         clear
         echo -e "\e[1;32mLas dependencias se han instalado correctamente\e[0m"
         wget http://www.openinfosecfoundation.org/download/suricata-4.1.4.tar.gz 2>> errores.txt
         if [ $? -eq 0 ]; then
           clear
           echo -e "\e[1;32mEl comando wget se ha ejecutado correctamente\e[0m"
           sleep 1.5
           clear
           echo "Instalando el paquete..."
           sleep 1.5
           sudo tar -xvf suricata-4.1.4.tar.gz 2>> errores.txt
           if [ $? -eq 0 ]; then
             clear
             echo -e "\e[1;32mPaquete instalado correctamente\e[0m"
             sleep 1.5
             clear
             echo "Configurando..."
             sleep 2
             ./configure --sysconfdir=/etc --localstatedir=/var 2>> errores.txt
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
                 sudo make install 2>> errores.txt
                 if [ $? -eq 0 ]; then
                   echo -e "\e[1;32mSe ha completado todo correctamente\e[0m"
                   clear
                   echo "instalando archivos de configuracion..."
                   sleep 1.5
                   sudo make install-conf 2>> errores.txt
                   if [ $? -eq 0 ]; then
                     clear "Instalando reglas..."
                     sleep 1.5
                     sudo make install-rules 2>> errores.txt
                     if [ $? -eq 0 ]; then
                       echo -e "\e[1;32mLas reglas se han implementado correctamente\e[0m"
                       sleep 1.5
                     else
                       clear
                       echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                     fi
                   else
                     clear
                     echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                     echo
                     echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                   fi
                 else
                   clear
                   echo -e "\e[1;31mHa ocurrido algun error, comprobar errores.txt\e[0m"
                   echo
                   echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                 fi
               else
                 clear
                 echo -e "\e[1;31mNo se ha completado correctamente, comprobar errores.txt\e[0m"
                 echo
                 echo -n -e "\e[1;34mEnter para continuar...\e[0m"
               fi
             else
               clear
               echo -e "\e[1;31mNo se ha configurado correctamente, comprobar errores.txt\e[0m"
               echo
               echo -n -e "\e[1;34mEnter para continuar...\e[0m"
             fi
           else
             clear
             echo -e "\e[1;31mEl comando (tar -xvf) no se ha realizado correctamente, comprobar errores.txt\e[0m"
             echo
             echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           fi
         else
           clear
           echo -e "\e[1;31mEl comando wget NO se ha realizado correctamente, comprobar errores.txt\e[0m"
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
         fi
       fi
      continue;;

      4) #Bastionar raspberry pi
         clear
         sleep 1
             bool=0
             while [[ $bool -eq 0 ]]; do
               clear
               echo "        __^__                                      __^__  "
               echo "       ( ___ )------------------------------------( ___ ) "
               echo -e "        | / |             \e[1;32m¿Qué tramas?\e[0m             | \ |"
               echo "        | / |                                      | \ |  "
               echo -e "        |___|       \e[5m Bastionar Raspberry Pi \e[25m       |___|"
               echo "       (_____)------------------------------------(_____) "
               echo
               echo -e "                email: \e[1;32mcontacto@quetramasblog.com\e[0m"
               echo
               echo -e "--------------------------------------------------------"
               echo -e " Mac: \e[1;32m$mac\e[0m             Ip: \e[1;32m$ip\e[0m"
               echo -e "--------------------------------------------------------"
               echo
               echo
               echo "1.- Cambiar contraseña del usuario pi"
               echo
               echo "2.- Securizar servidor ssh"
               echo
               echo "3.- Instalar y configurar fail2ban y sendmail"
               echo
               echo -e "\e[1;31m4.- Salir\e[0m"
               echo
               read option
               case $option in

                   1) #Cambiar contraseña del usuario pi
                     clear
                     echo "cambiando contraseña del usuario pi..."
                     sleep 1.5
                     sudo passwd pi 2>> errores.txt
                     if [ $? -eq 0 ]; then
                       echo -e "\e[1;32mLa contraseña ha sido cambiada correctamente\e[0m"
                     else
                       echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                     fi
                     continue;;

                   2)#Cambiar el archivo sshd_config
                     clear
                     echo "El archivo sshd_config se cambiará por el que hemos creado..."
                     sleep 1.5
                     mv sshd_config /etc/ssh/sshd_config 2>> errores.txt
                     if [ $? -eq 0 ]; then
                       echo -e "\e[1;32mEl archivo ha sido cambiado correctamente\e[0m"
                     else
                       echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                     fi
                     continue;;

                   3) #Instalando fail2ban y sendmail
                     clear
                     echo "Instalando fail2ban..."
                     sleep 1.5
                     sudo -k apt-get install fail2ban 2>> errores.txt
                     if [ $? -eq 0 ]; then
                       clear
                       echo -e "\e[1;32mFail2Ban se ha instalado correctamente\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                       clear
                       echo "Instalando sendmail..."
                       sleep 1.5
                       sudo -k apt-get install sendmail 2>> errores.txt
                       if [ $? -eq 0 ]; then
                         clear
                         echo -e "\e[1;32mSendmail se ha instalado correctamente\e[0m"
                         echo
                         echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                         sleep 1.5
                         clear
                         echo -n "¿A que email quiere recibir los avisos?: "
                         read email
                         sed 's/root@localhost/'$email'/g' auxiliar.txt > jail.conf
                         if [ $? -eq 0 ]; then
                          mv jail.conf /etc/fail2ban/
                          if [ $? -eq 0 ]; then
                            echo "Se ha modificado correctamente el email"
                          else
                            echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                            echo
                            echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                          fi
                        else
                          echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                          echo
                          echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                         fi
                       else
                         echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                         echo
                         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                       fi
                     else
                       echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                       echo
                       echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                     fi
                     clear
                     sleep 1
                     echo -n "¿Enviamos un email de prueba? y/n  :"
                     read resp
                     if [ $resp == "y" ]; then
                       clear
                       echo -n "Vuelve a escribir tu cuenta: "
                       read cuenta
                       echo
                       echo -n "Cuenta destino: "
                       read cuentadest
                       echo
                       echo -n "Escribe el asunto: "
                       read asunto
                       echo
                       echo -n "Escribe el cuerpo del mensaje: "
                       read cuerpo
                       echo
                       echo -n "Escribe el usuario de la cuenta(ej:contacto@gmail.com = contacto): "
                       read usuario
                       echo
                       echo -n "Escribe la contraseña de tu cuenta: "
                       read pass
                       clear
                       echo "Mandando email..."
                       sendemail -f $cuenta -t $cuentadest -s smtp.gmail.com:587 -u \ \"$asunto\" -m \"$cuerpo\" -v -xu $usuario -xp $pass -o tls=yes
                       if [ $? -eq 0 ]; then
                         echo -e "\e[1;32mEl email debaría llegar en breve...\e[0m"
                         echo
                         echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                       else
                         echo -e "\e[1;31mHa ocurrido algún error, revisar el archivo errores.txt\e[0m"
                         echo
                         echo -n -e "\e[1;34mEnter para continuar...\e[0m\e[0m"
                       fi
                      else
                        clear
                        echo -e "\e[1;31mSaliendo...\e[0m"
                        sleep 1.5
                     fi
                       continue;;

                      4) #Salir
                         clear
                         echo -e "\e[1;31mSaliendo...\e[0m"
                         sleep 1.5
                         bool=1
                         ;;

                      *) clear
                         echo "$option es una opcion inválida. Por favor inténtelo de nuevo."
                         echo
                         echo -n -e "\e[1;34mEnter para continuar...\e[0m"
                         continue;;
                    esac
                  done
                  continue;;

      5)  #Reiniciar
          clear
          sleep 1.5
          echo "Reiniciando..."
          sleep 1.5
          reboot
        ;;

        6) #Salir
           clear
           echo -e "\e[1;31mSaliendo...\e[0m"
           sleep 1.5
           booleana=1
           ;;

        *) clear
           echo "$opcion es una opcion inválida. Por favor inténtelo de nuevo."
           echo
           echo -n -e "\e[1;34mEnter para continuar...\e[0m"
           continue;;
    esac
  done
