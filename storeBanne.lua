--Variables de condition

local temperature_min = 17
local nebulosite_max = 30
local vent_max = 30

-- -------------------------------------------------------------------------------------------------
commandArray = {}

--Sonde déclencheuse
local sonde_temperature = 'Météo' --Nom de la sonde de température extérieure

--La sonde est mise à jour toutes les 5 minutes (voir cron). Ce sera la fréquence d'exécution de ce script.
if (devicechanged[sonde_temperature]) then

    local temperature_exterieure=tonumber(otherdevices_temperature[sonde_temperature]) -- Sonde de température extérieure
    local nebulosite = tonumber(otherdevices['Nuages'])  --Sonde de nébulosité
    local vent = tonumber(otherdevices_windspeed['Vent']) --Sonde de vent
    local soleil = otherdevices['Soleil face au balcon'] --Le soleil est face au balcon ?

    local etatActuel=uservariables["position-store"];

    -- Si le soleil est en face du balcon, qu'il n'y a pas trop de nuages, que la température est assez chaude, et qu'il n'y a pas trop de vent...
    if ( soleil=='On' and (temperature_exterieure>=temperature_min) and (nebulosite<=nebulosite_max) and (vent<=vent_max)) then
        etatDesire="On"
    else
        etatDesire="Off"
    end

    if (etatDesire ~= etatActuel) then
        if (etatDesire=='On') then
            print("Les conditions sont réunies pour déployer le store");
        elseif (soleil=='Off') then
            print("Les conditions ne sont plus réunies : Le soleil n'est plus visible -> On rétracte le store");
        elseif (temperature_exterieure<temperature_min) then
            print("Les conditions ne sont plus réunies : Il fait trop froid -> On rétracte le store");
        elseif (nebulosite>nebulosite_max) then
            print("Les conditions ne sont plus réunies : Trop de nuages -> On rétracte le store");
        elseif (vent>vent_max) then
            print("Les conditions ne sont plus réunies : Trop de vent -> On rétracte le store");
        end
        
        commandArray['Variable:position-store']=etatDesire
    end

end

return commandArray