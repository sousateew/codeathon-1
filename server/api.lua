Api = {};
Api.__index = Api;

function Api:new(...)
    local instance = {};
    setmetatable(instance, Api)
    
    if instance:constructor(...) then
        return instance
    end
    return false
end

function Api:constructor(url)
    self.url = url;
    return true
end

function Api:get()
    fetchRemote(self.url, function(responseData, errorCode)
        if (errorCode == 0) then
            self.data = fromJSON(responseData);
            Codeathon.readyData(self.data)

            print("Success, Mockoon data loaded.")
        else
            print("Error " .. errorCode .. ", check Mockoon.")
            return false
        end
    end)
end