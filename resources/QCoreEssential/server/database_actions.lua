--Quarantine Core Server Essentials Do not edit without permission from KevQSweet.--
require "resources/QCoreEssential/lib/MySQL"


--Recieve Push data and sort to correct channels
  
--Manage channels and determine data length

--either Push specific information
AddEventHandler("UpdateDB", function(dbname, target)
  --compare database fields and insert missing fields, assigned with correct variable types
  if target == nil then
    print("target in push not set or passed incorectly!")
  else
    if target.id == nil then
      print("identifier not set")
    else

      local counter = 0
      for key, value in pairs(target) do
        if value == nil then
          print("ERROR: "..key.." has no value")
        else
          MySQL.Async.fetchAll("SELECT * FROM "..dbname, {}, function(test) 
            if test[key] == nil then                                      --check against existing values of other accounts and create any missing fields
              MySQL.Async.execute("INSERT INTO "..dbname.." (`"..key.."`) VALUES ('"..value.."')")
            end
          end)
          counter = counter + 1 
          if counter == 1 then                                              -- start building input data
            assign_1 = "'"..key.."'='"..value.."'"
          else
            assign_1 = assign_1..", '"..key.."'='"..value.."'" 
          end
        end
      end
    end
  end
  --finallize query
  print("UPDATE "..dbname.." SET ("..assign_1..") WHERE id_ingame = '"..target.id.."'")
  MySQL.Async.execute("UPDATE "..dbname.." SET ("..assign_1..") WHERE id_ingame = '"..target.id.."'")
end
--debug callback