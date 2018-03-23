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
mail2=$(cat $config | grep -e "mail2" | cut -d "=" -f 2)
DirBusca=$(cat $config | grep "DirBusca" | cut -d "=" -f 2)
source /opt/esbbb/db.conf 
log="/var/log/esbbb.log"
	#Empresas
		# Rede Mineira 
		empresa1=$(cat $config | grep -e "Empresa1" | cut -d "=" -f 2)
		destino1=$(cat $config | grep -e "Emp1Destino" | cut -d "=" -f 2)

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
	$empresa1 -- destino $destino1 
	$empresa2 -- destino $destino2 \033[0m"
echo $db
echo $table
echo $user
read a 

#funcoes
	monitor()
		{
		ler=$(tail -n 7 $log)
			for (( j=0 ; j <= 100 ; j++)) 
			{
			echo $j
			} | dialog --title "ESBBB" --guage 'PERCENTUAL' 7 65 
			dialog --title "ESSBB" --infobox "$ler" 0 0 
			sleep 5
		}	

	searchdestroy()
			{
			for ((loop=1 ; loop > 0 ; loop++))
			{	
			cont=0
			search=$(find $DirBusca -type f -name "*.xml")
				for i in $search 
				do 
				echo "Arquivo $i -- processo $cont" >> $log
				nf=$(cat $i | grep -e "<nNF>"  | awk -F "<nNF>" '{print $2-$3}')
				cnpj=$(cat $i | awk -F "<dest>" '{print $2}' | awk -F "</dest>" '{print $1}' | awk -F "<CNPJ>" '{print $2}' | awk -F "</CNPJ>" '{print $1}')
				echo "$cnpj Nota Fiscal numero : $nf sendo processada" >> $log
				cont=$(expr 1 + $cont)
				echo "Este email é automatico. Nota fiscal $nf enviada" | mutt -s "Nota Fiscal Eletronica $nf" $mail1 -c $mail2 -a $i 
				echo "Email nota fiscal $nf Enviado" >> $log
				data=$(date +'%d%m%y')
					case $cnpj in 
						$empresa1)
						echo "Movendo arquivo $i - $cnpj" >> $log
						nome=$(echo $i | cut -d "/" -f 9)
						mv $i ${destino1}${data}'_'${nf}'_'${nome}".xml"
						echo "Arquivo movido" >> $log
						echo "+-------------------------------------------------------------------------+" >> $log
						mysql -u $user -pbankai -e "insert into tbNotas(cnpj,numero_nota) values ('$cnpj',$nf)" $db
						
							;;
								$empresa2) 
							echo "Movendo arquivo $i - $cnpj" >> $log
							mv $i /home/mk/Documentos/DESENVOLVIMENTO/shell/xml/empresa2
							echo "Arquivo movido" >> $log
							
							;;
							3333) 
							echo "Movendo arquivo $i - $cnpj" >> $log
							mv $i /home/mk/Documentos/DESENVOLVIMENTO/shell/xml/empresa3
							echo "Arquivo movido" >> $log 
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







