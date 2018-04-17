#!/bin/bash 
###################################################################################################
# ESBBB - Eu Sirvo Bacana Bacteria de Bits 							  #
# Autor : Marcos Moraes                                                                           #
# Descricao: Script para direcionamento de arquivos xml e envio de arquivos por email		  #
# Data : 08/03/2018 - Dia da mulher 								  #
# Data Revisao : 22/03/2017 - Abolition Day in Puerto Rico					  #
###################################################################################################

#Arquivos de configuracao 
config="/opt/esbbb/esbbb.conf"
mail1=$(cat $config | grep -e "mail1" | cut -d "=" -f 2)
#mail2=$(cat $config | grep -e "mail2" | cut -d "=" -f 2)
DirBusca=$(cat $config | grep "DirBusca" | cut -d "=" -f 2)
source /opt/esbbb/db.conf 
log="/var/log/esbbb.log"
	#Empresas
ConfigEmp() 
	{
		empresa1=$(cat $config | grep -e "Empresa1" | cut -d "=" -f 2)
		destino[1]=$(cat $config | grep -e "Emp1Destino" | cut -d "=" -f 2)
		# Auto sete 
		empresa2=$(cat $config | grep -e "Empresa2" | cut -d "=" -f 2)
		destino[2]=$(cat $config | grep -e "Emp2Destino" | cut -d "=" -f 2)
		# Cardiesel
		empresa3=$(cat $config | grep -e "Empresa3" | cut -d "=" -f 2)
		destino[3]=$(cat $config | grep -e "Emp3Destino" | cut -d "=" -f 2)
		#Calisto
	        empresa4=$(cat $config | grep -e "Empresa4" | cut -d "=" -f 2)
                destino[4]=$(cat $config | grep -e "Emp4Destino" | cut -d "=" -f 2)
		#Goias
	        empresa5=$(cat $config | grep -e "Empresa5" | cut -d "=" -f 2)
                destino[5]=$(cat $config | grep -e "Emp5Destino" | cut -d "=" -f 2)
		#Goias filial 
                empresa6=$(cat $config | grep -e "Empresa6" | cut -d "=" -f 2)
                destino[6]=$(cat $config | grep -e "Emp6Destino" | cut -d "=" -f 2)
		#Montes Claros
	       empresa7=$(cat $config | grep -e "Empresa7" | cut -d "=" -f 2)
               destino[7]=$(cat $config | grep -e "Emp7Destino" | cut -d "=" -f 2)
		#POsto Imperial
         	empresa8=$(cat $config | grep -e "Empresa8" | cut -d "=" -f 2)
                destino[8]=$(cat $config | grep -e "Emp8Destino" | cut -d "=" -f 2)
		#Posto Imperial Filail
                empresa9=$(cat $config | grep -e "Empresa9" | cut -d "=" -f 2)
                destino[9]=$(cat $config | grep -e "Emp9Destino" | cut -d "=" -f 2)
		#Uberlandia
                empresa10=$(cat $config | grep -e "Empresa10" | cut -d "=" -f 2)
                destino[10]=$(cat $config | grep -e "Emp10Destino" | cut -d "=" -f 2)
		#Uberlandia filial
	   empresa11=$(cat $config | grep -e "Empresa11" | cut -d "=" -f 2)
                destino[11]=$(cat $config | grep -e "Emp11Destino" | cut -d "=" -f 2)
		#Vadiesel
		   empresa12=$(cat $config | grep -e "Empresa12" | cut -d "=" -f 2)
                destino[12]=$(cat $config | grep -e "Emp12Destino" | cut -d "=" -f 2)
		#Valadares
	   empresa13=$(cat $config | grep -e "Empresa13" | cut -d "=" -f 2)
                destino[13]=$(cat $config | grep -e "Emp13Destino" | cut -d "=" -f 2)
	}

ConfigEmp
#Inicialização
echo -e "\033[3;31m Iniciando o ESBBB \033[0m"
#sleep 2
echo -e "\033[3;31m DIRETORIO CONFIGURACAO $config \033[0m"
echo -e "\033[3;31m DITETORIO DE LOG $log \033[0m"
#sleep 2
echo -e "\033[3;31m EMAIL PRINCIPAL ENVIO $mail1 \033[0m"
#sleep 2 
echo -e "\033[3;31m EMAIL COPIA ENVIO $mail2 \033[0m"
#sleep 2 
echo -e "\033[3;31m EMPRESAS CONFIGURADAS :
	$empresa1 -- destino ${destino[1]} 
	$empresa2 -- destino ${destino[2]}
	$empresa3 -- detino ${destino[3]}
	$empresa4 -- destino ${destino[4]}
	$empresa5 -- destino ${destino[5]}
	$empresa6 -- destino ${destino[6]}
	$empresa7 -- destino ${destino[7]}
	$empresa8 -- destino ${destino[8]}
	$empresa9 -- destino ${destino[9]}
	$empresa10 -- destino ${destino[10]}
	$empresa11 --destino ${destino[11]}
	$empresa12 --destino ${destino[12]}
	$empresa13 -- destino ${destino[13]}
	 \033[0m"
	
#read a
sleep 10

#funcoes
	monitor()
		{
		ler=$(tail -n 7 $log)
			for (( j=0 ; j <= 100 ; j++)) 
			{
			echo $j
			} | dialog --title "ESBBB" --guage 'PERCENTUAL' 7 65 
			dialog --title "ESSBB" --infobox "$ler" 0 0 
			ConfigEmp
			sleep 5
		}	

	processar()
		{
		data=$(date +'%Y%m%d')
		
			echo "$data - Arquivo $i -- processo $cont" >> $log
			echo "Este email é automatico. Nota fiscal $nf enviada" | mutt -s "Nota Fiscal Eletronica $nf" $mail1 -c $mail2 -a $1
			 Guardar=$(echo ${destino[$j]}${data}'_'${nf}'_'${nome}".xml")
mysql -u $user -p${senha} -e "insert into tbNotas(Cnpj,NumeroNota,DataNota,DataArmazenamento,Email,StatusMail,CnpjRemetente,ConteudoXml,Destino) values ('$cnpj',$nf,$data,$data,'$mail1','V','$CnpjRemetente','$(cat $1)','$Guardar')" $db 
			echo "$cnpj Nota Fiscal numero : $nf sendo processada" >> $log
			echo "Email nota fiscal $nf Enviado" >> $log
			echo "Movendo arquivo $1 - $cnpj" >> $log

		nome=$(echo $1 | cut -d "/" -f 9)
		mv $1 ${destino[$j]}${data}'_'${nf}'_'${nome}".xml"
#		echo 'teste1' >> $log
		Guardar=$(echo "")
		echo ${destino[$j]}${data}'_'${nf}'_'${nome}".xml" >> $log 
#		echo 'teste1' >> $log
			echo "Arquivo movido" >> $log
		echo "+-------------------------------------------------------------------------+" >> $log
		
		}


	searchdestroy()
			{
			for ((loop=1 ; loop > 0 ; loop++))
			{	
			cont=0
			search=$(find $DirBusca -type f -name "*.xml")
				for i in $search 
				do 
				nf=$(cat $i | grep -e "<nNF>"  | awk -F "<nNF>" '{print $2}' | awk -F "</nNF>" '{print $1}')
				cnpj=$(cat $i | awk -F "<dest>" '{print $2}' | awk -F "</dest>" '{print $1}' | awk -F "<CNPJ>" '{print $2}' | awk -F "</CNPJ>" '{print $1}')
				CnpjRemetente=$(cat $i | awk -F "<emit>" '{print $2}' | awk -F "</emit>" '{print $1}' | awk -F "<CNPJ>" '{print $2}' | awk -F "</CNPJ>" '{print $1}')

				cont=$(expr 1 + $cont)

					case $cnpj in 
						$empresa1)
							j=1
							processar $i
							
							;;
						$empresa2) 
							j=2
							processar $i	
							;;
						$empresa3) 
							j=3
							processar $i
							;;
                                                $empresa4)
                                                        j=4
                                                        processar $i
                                                        ;;
						$empresa5)
                                                        j=5
                                                        processar $i
                                                        ;;
						$empresa6)
                                                        j=6
                                                        processar $i
                                                        ;;
						$empresa7)
                                                        j=7
                                                        processar $i
                                                        ;;
						$empresa8)
                                                        j=8
                                                        processar $i
                                                        ;;
						$empresa9)
                                                        j=9
                                                        processar $i
                                                        ;;
						$empresa10)
                                                        j=10
                                                        processar $i
                                                        ;;
						$empresa11)
                                                        j=11
                                                        processar $i
                                                        ;;
						$empresa12)
							j=12
							processar $i
							;;
						$empresa13)
							j=13
							processar $i
							;;
						esac	
				monitor			
			done  
			
			} 
					
		}  



	menu_i(){
		opc=$(dialog --stdout --title "ESBBB" --backtitle "$empresa" --menu "MENU INICIAL" 0 0 0 \
			1 "Iniciar o servico" \
			2 "Configurar" \
			3 "Sair" )
		case $opc in 
			1) 
			dialog --stdout --title "ESBBB" --backtitle "$empresa" --infobox "ESSBB" 0 0  
			searchdestroy
				
			;;
			2)
			ler=$(tailf $log)	
			dialog --stdout --title "ESSBB" --backtitle "$empresa" --msgbox "${ler}" 0 0 
			;;
			3)	
			exit 0 
		esac
	

	}

#inicio 
start=$(cat $config | grep "Instalado" | cut -d "=" -f 2)  
echo $start

#echo $start
	if [ $start -eq 1 ]
		then
			menu_i
		else 
			echo "2"
	fi







