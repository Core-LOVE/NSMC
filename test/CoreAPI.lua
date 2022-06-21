local CoreAPI = {}
CoreAPI.path = "CoreAPI/"

function CoreAPI.require(p)
	return require(CoreAPI.path .. p)
end

CoreAPI.require("utils.class")

function CoreAPI.onInitAPI()

end

return CoreAPI