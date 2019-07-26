#!/bin/zsh
#  ███╗   ███╗ █████╗ ██████╗ ███████╗    ██╗    ██╗██╗████████╗██╗  ██╗      ██╗██████╗         
#  ████╗ ████║██╔══██╗██╔══██╗██╔════╝    ██║    ██║██║╚══██╔══╝██║  ██║     ██╔╝╚════██╗        
#  ██╔████╔██║███████║██║  ██║█████╗      ██║ █╗ ██║██║   ██║   ███████║    ██╔╝  █████╔╝        
#  ██║╚██╔╝██║██╔══██║██║  ██║██╔══╝      ██║███╗██║██║   ██║   ██╔══██║    ╚██╗  ╚═══██╗        
#  ██║ ╚═╝ ██║██║  ██║██████╔╝███████╗    ╚███╔███╔╝██║   ██║   ██║  ██║     ╚██╗██████╔╝        
#  ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝     ╚══╝╚══╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝      ╚═╝╚═════╝         
#  ██████╗ ██╗   ██╗                                                                             
#  ██╔══██╗╚██╗ ██╔╝                                                                             
#  ██████╔╝ ╚████╔╝                                                                              
#  ██╔══██╗  ╚██╔╝                                                                               
#  ██████╔╝   ██║                                                                                
#  ╚═════╝    ╚═╝                                                                                
#  ██╗   ██╗ █████╗ ███╗   ██╗███╗   ██╗██╗███████╗                                              
#  ╚██╗ ██╔╝██╔══██╗████╗  ██║████╗  ██║██║██╔════╝                                              
#   ╚████╔╝ ███████║██╔██╗ ██║██╔██╗ ██║██║███████╗                                              
#    ╚██╔╝  ██╔══██║██║╚██╗██║██║╚██╗██║██║╚════██║                                              
#     ██║   ██║  ██║██║ ╚████║██║ ╚████║██║███████║                                              
#     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝╚══════╝                                              
#  ██╗      █████╗ ███╗   ██╗ ██████╗                                                            
#  ██║     ██╔══██╗████╗  ██║██╔════╝                                                            
#  ██║     ███████║██╔██╗ ██║██║  ███╗                                                           
#  ██║     ██╔══██║██║╚██╗██║██║   ██║                                                           
#  ███████╗██║  ██║██║ ╚████║╚██████╔╝                                                           
#  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝                                                            
#                                                                                                                                                                                                         

input="./ApprenantsList"
mode="g"
project=''
timeWait=3
apprenantForce=""
DISCORD_SCRIPT="./discord.sh"
communicationMode=""
discordWebHook="set your"
urlbase='set your'

while getopts "m:p:u:l:x:" opt; do
  case $opt in
    m)
      mode=$OPTARG
      ;;
    m)
      mode=$OPTARG
      ;;
    p)
      project=$OPTARG
      ;;
    u)
      apprenantForce=$OPTARG
      ;;
    x)
      communicationMode=$OPTARG
      ;;
    *) echo 'error' >&2
       exit 1
  esac
done


messageDiscord()
{
  msg=$1;
  ./discord.sh --webhook-url=$discordWebHook --text "[Project : $project][Mode : #$mode] $msg"
  sleep 1
}

if [ $project ]; then

  if [[ "$mode" == "l" ]] then

  else
    echo "#Let run engine" $project

    echo "#Create Folder Project"
    mkdir -p $project

    echo "#Create File Missed for project"
    touch $project/Missed
    echo "====" > $project/Missed
  fi

    echo "#Mode == $mode"

 
  if [[ "$communicationMode" == "d" ]] then
        timeWait=2
        ./discord.sh --webhook-url=$discordWebHook --text "[Project : $project][Mode : #$mode] Début de la récupération des projets $project !"
        
        n=3
        while [ $n != 0 ]
        do
          messageDiscord "$n ..."
          n=$(( n-1 ))
          sleep 1
        done

  fi

  

     routineTask() {
      apprenant=$1
      projet=$2
      discordName=$3
      if [ -d "$project/$apprenant" ]; then

        if [[ "$mode" == "u" ]] then
          echo "#Try update $apprenant!"

          if [[ "$communicationMode" == "d" ]] then
            messageDiscord "Try update <@!$discordName>!";
          fi
          
          if ! (git -C $project/$apprenant pull origin master) then
            echo "#Fck! Just failed update where is the project ?!"
            
            if [[ "$communicationMode" == "d" ]] then
              messageDiscord "Je ne trouve pas ton projet <@!$discordName>!";
            fi

            echo $apprenant >> $project/Missed
            rm -rf $project/$apprenant
          else
            echo "#Good Boy! Project Updated !"

            if [[ "$communicationMode" == "d" ]] then
              messageDiscord "J'ai mis à jour ton projet <@!$discordName> ! Good Job :)";
            fi
            sleep $timeWait;

          fi
          echo "==END==";
        else
          echo "--$apprenant project's already in the game<3--"
          if [[ "$communicationMode" == "d" ]] then
            messageDiscord "J'ai déjà ton projet <@!$discordName> ! Good Job :)";
          fi
        fi

      else
        echo "--Try cloning $apprenant project's <3--"

        if [[ "$communicationMode" == "d" ]] then
          messageDiscord "J'essaye de cloner ton projet <@!$discordName> !";
        fi
        echo "#Create folder project for a apprenant"
        mkdir -p $project/$apprenant
	
           ##Try clone project if failed ad it too Missed
         if ! (git clone "$urlbase/$apprenant/$project" $project/$apprenant) then
           echo "#Fck! Just failed where is the project ?!"

          if [[ "$communicationMode" == "d" ]] then
            messageDiscord "Je ne trouve pas ton projet <@!$discordName> ! Qu'est ce qui s'est passé?";
          fi
           echo $apprenant >> $project/Missed
           rm -rf $project/$apprenant
         else
          if [[ "$communicationMode" == "d" ]] then
           messageDiscord "J ai trouvé ton projet <@!$discordName> ! GoodJob!";
          fi
           echo "#Good Boy! I find the project"
         fi
         echo "==END==";
         sleep $timeWait
      fi
    }

    if [ $apprenantForce ]; then
      routineTask $apprenantForce $project
    else
      ##loop over ApprenantsList
      echo "#Start Looping"
      apprenantLoopFullArray=();
      while IFS= read -r apprenantLoopFull
      do
        apprenantLoopFullArray+=$apprenantLoopFull;
      done < "$input"
    fi

    for i in "${apprenantLoopFullArray[@]}"
    do
      : 
      IFS=':' read -A oneApprennantFull <<< "${i}"
      apprenantName=${oneApprennantFull[1]}
      apprenantDiscord=${oneApprennantFull[2]}
      if [[ "$mode" == "l" ]] then
          echo "$urlbase/$apprenantName/$project"
        else
          routineTask $apprenantName $project $apprenantDiscord
        fi
    done

    if [[ "$communicationMode" == "d" ]] then
        missedIds=$(<$project/Missed | tr '\n' ' ')
        messageDiscord "Fin du clone ! Good job all! "
        sleep 1
        messageDiscord "Il me manque votre projet : "
        sleep 1
        messageDiscord $missedIds
      fi

else
    echo "FckOff usages : ./CloneProj.sh -p {nomDuProj} -m {Mode : u:update g:get l:links} -u {apprenantName}"
    echo "-x {d:discord}"
fi

#   ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗               
#  ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗              
#  ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝              
#  ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗              
#  ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝              
#   ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝               
#   ██████╗ ██╗      █████╗ ███╗   ██╗ ██████╗██╗   ██╗██╗  ██╗
#  ██╔═══██╗██║     ██╔══██╗████╗  ██║██╔════╝╚██╗ ██╔╝╚██╗██╔╝
#  ██║██╗██║██║     ███████║██╔██╗ ██║██║  ███╗╚████╔╝  ╚███╔╝ 
#  ██║██║██║██║     ██╔══██║██║╚██╗██║██║   ██║ ╚██╔╝   ██╔██╗ 
#  ╚█║████╔╝███████╗██║  ██║██║ ╚████║╚██████╔╝  ██║   ██╔╝ ██╗
#   ╚╝╚═══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝
#                                                              
