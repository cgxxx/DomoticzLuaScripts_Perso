local hysteresis = 0.5 --Valeur de tolérance (hystérésis)
local sonde = 'Thermomètre de la piece' --Nom de la sonde de température
local thermostat = 'Interrupteur Thermostat' --Nom de l'interrupteur virtuel du thermostat
local radiateur = 'Radiateur' --Nom du radiateur à allumer/éteindre
local deviceconsigne = 'Consigne de la piece'

-- -------------------------------------------------------------------------------------------------

commandArray = {}

--La sonde emet toutes les 40 secondes. Ce sera approximativement la fréquence d'exécution de ce script.

if (devicechanged[sonde]) then
    local consigne = otherdevices[deviceconsigne] -- Récupération de la température de consigne
	local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relevée dans la pièce

    --On n'agit que si le "thermostat" est actif
    if (otherdevices[thermostat]=='On') then
    	if (temperature < (consigne - hysteresis)  and otherdevices[radiateur]=='On') then
            print('Allumage du chauffage dans la pièce')
            commandArray[radiateur]='Off'
	    elseif (temperature > (consigne + hysteresis) and otherdevices[radiateur]=='Off') then
	        print('Extinction du chauffage dans la pièce')
            commandArray[radiateur]='On'
	    end
   -- Extinction immédiate du chauffage si on a arrété le thermostat
    elseif (otherdevices[thermostat]=='Off' and otherdevices[radiateur]=='Off') then
	        print('Thermostat Désactivé : Extinction du chauffage dans la pièce')
            commandArray[radiateur]='On'
    end
end

return commandArray