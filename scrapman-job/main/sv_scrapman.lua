if Config.useESX then 
   ESX = nil
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.useQBCore then
   QBCore = nil
   QBCore = exports['qb-core']:GetCoreObject()
elseif Config.useVRP then
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")

    vRP = Proxy.getInterface("vRP")
    vRPclient = Tunnel.getInterface("vRP","vRP_showroom")
end

RegisterServerEvent('scrapjob:scrap:find')
AddEventHandler('scrapjob:scrap:find', function()
   local _source = source
   if Config.useESX then 
       local xPlayer = ESX.GetPlayerFromId(_source)
       xPlayer.addInventoryItem('scrap', 1)  
   elseif Config.useQBCore then 
       local Player = QBCore.Functions.GetPlayer(_source)
       Player.Functions.AddItem('scrap', 1)
   elseif Config.useVRP then
        vRP.giveInventoryItem(vRP.getUserId({_source}),'scrap',1,true)
   end
end)

RegisterServerEvent('scrapjob:scrap:sell')
AddEventHandler('scrapjob:scrap:sell', function()
   local _source = source

   if Config.useESX then
      local xPlayer = ESX.GetPlayerFromId(source)
      local scrapQuantity = xPlayer.getInventoryItem('scrap').count
      local addmoney = math.random(20, 50) -- change here the price of the scrap sell
      if scrapQuantity >= 1 then
         xPlayer.removeInventoryItem('scrap', 1)
         xPlayer.addMoney(addmoney)
         TriggerClientEvent("pNotify:SendNotification", source, {
           text = "you sold a scrap type for <b style=color:#1588d4>"  .. addmoney .. " <b style=color:#d1d1d1> keep working</b>",
           type = "success",
           queue = "lmao",
           timeout = 7000,
           layout = "Centerleft"
         })
      elseif scrapQuantity then
      	 TriggerClientEvent("pNotify:SendNotification", source, {
           text = "you dont have any scrap type",
           type = "success",
           queue = "lmao",
           timeout = 7000,
           layout = "Centerleft"
          })
      end
   elseif Config.useQBCore then
       local Player = QBCore.Functions.GetPlayer(_source)
       local item = Player.Functions.HasItem('scrap')
       if item == (nil or false) then scrapQuantity = 0 elseif item == true then  scrapQuantity = 1 end
       if scrapQuantity >= 1 then
            str = 'you sold a scrap type for '.. addMoney
            Player.Functions.RemoveItem('scrap', 1)
            TriggerClientEvent('QBCore:Notify', _source, str, 'primary', 10000)
       elseif scrapQuantity then
           TriggerClientEvent('QBCore:Notify', _source, "you dont have any scrap type", 'primary', 10000)            
       end
    elseif Config.useVRP then
        local item = vRP.getIventoryItemAmount({vRP.getUserId({_source}),'scrap'})
        if item == nil then scrapQuantity = 0 elseif item == true then scrapQuantity = 1 end
        if scrapQuantity >= 1 then
            msg = 'you sold a scrap type for'...addMoney
            vRP.tryGetIventoryItem({vRP.getUserId({_source}),'scrap',1.true})
            vRP.giveMoney({vRP.getUserId({_source}),math.random(50, 100)})
            vRPclient.notify(_source,{msg})
   end
end)
