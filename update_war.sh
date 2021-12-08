#########################################################################
#           Developed by Stanislaw Glegola PF/5 DLXP3N0			#
#				V 1.0					#
#       Script for web aplication automated update on tomcat server	#
#          To lunch script type in console command below		#
#       cd /appl/tomcat/apps/app/deploy && bash update_war.sh		#
#########################################################################

#!/bin/bash
war_name=build.war
war_location=/appl/tomcat/apps/app/deploy/new_build/
deploy_folder=/appl/tomcat/apps/app/deploy
arch_dir=/appl/tomcat/apps/app/deploy/archive
process_name=service.service

war_origin=$war_location$war_name

if [ -f $war_origin ]
then
	echo "File $war_origin istnieje"
else
	echo "Plik nie istnieje"
	exit 1
fi

sudo systemctl stop $process_name
echo "Service stopped"
sleep 1

cd $deploy_folder

if [ ! -d $arch_dir ]
then
	echo "Warning: creating a new archive folder"
	mkdir archive
fi

rm -R mdp

mv $war_name "$war_name.$(date +%F_%H:%M:%S)"
sleep 2
mv $war_name.* archive

cd $arch_dir
for i in /appl/tomcat/apps/app/deploy/archive/* 
do
	tmp=$i
	tmp+='.old'
	mv $i $tmp
	if [ -f ./*.old.old.old ]
	then
		rm ./*.old.old.old
		echo "Old version deleted from archive folder"
	fi
done

cd $deploy_folder
mv $war_origin $deploy_folder

sleep 1
sudo systemctl start $process_name
echo "Service started"