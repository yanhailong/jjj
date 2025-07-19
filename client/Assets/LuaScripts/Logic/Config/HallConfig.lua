---@class HallConfig
HallConfig=Class("HallConfig")
local this=HallConfig

---服务器配置
local serverConfig;
---本地配置
local localConfig;
---获取服务器配置
function this.GetServerConfig()
	if CommonConfigManager.configContent==nil then return nil end
	if serverConfig==nil then
		local jsonStr=CommonConfigManager.configContent;
		serverConfig=jsonDecode(jsonStr);
	end
	return serverConfig;
end
---获取本地配置
function this.GetLocalConfig()
	if localConfig==nil then
		localConfig=jsonDecode(CommonConfigManager.localConfigContent);
	end
	return localConfig;
end
---保存本地配置
function this.SaveLocalConfig()
	if localConfig==nil then return end
	local content=jsonEncode(localConfig);
	CommonConfigManager:SaveLocalConfig(content);
end
---保存游戏配置
function this.SaveGameConfig(gameName)
	local serverGameConfig=serverConfig.gameConfig[gameName];
	if serverGameConfig==nil then
		logError("获取游戏配置错误:"..tostring(gameName))
		return''
	end
	if localConfig.gameConfig==nil then
		localConfig.gameConfig={}
	end
	localConfig.gameConfig[gameName]=serverGameConfig;
	this.SaveLocalConfig();
end


-- 游戏的配置
-- 子游戏的名字
GameNames = {
	USDollarExpress="USDollarExpress",--美元快递
	BaccaratSessionSelect="BaccaratGame",--百家乐
	DragonTigerFight="DragonTigerFight",--龙虎斗
}

---游戏选择场景配置
GameSortID={
	[1]=GameNames.USDollarExpress,--美元快递
	[2]=GameNames.BaccaratSessionSelect,--百家乐
	[3]=GameNames.DragonTigerFight,--龙虎斗
}

-- 游戏的配置
GameConfig = {
	[GameNames.USDollarExpress] = {
		gameType = 100100,
		Manager = "SingleGames/USDollarExpress/USDollarExpress",
		EnterCtrlName = CtrlNames.UIHall, --游戏入口界面
	},
	[GameNames.BaccaratSessionSelect] = {
		gameType = 200500,
		Manager = "SingleGames/Baccarat/Baccarat",
		EnterCtrlName = CtrlNames.BaccaratMain, --游戏入口界面
	},[GameNames.DragonTigerFight] = {
		gameType = 200100,
		Manager = "SingleGames/DragonTigerFight/MVCHead",
		EnterCtrlName = CtrlNames.DragonTigerFight, --游戏入口界面
	},
}

