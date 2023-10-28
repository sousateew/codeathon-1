Codeathon = {};

addEventHandler("onResourceStart", resourceRoot, 
    function()
        API = Api:new(API_URL);
        API:get()
    end
)

addEventHandler("onPlayerResourceStart", root, 
    function(res)
        if (res == resource) then
            triggerClientEvent(source, "onClientReceiveCodeathonData", source, API.data)
        end
    end
)

function Codeathon.readyData(data)
    triggerClientEvent("onClientReceiveCodeathonData", root, data)
end