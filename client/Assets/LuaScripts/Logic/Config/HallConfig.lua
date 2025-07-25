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
	Baccarat="Baccarat",--百家乐
	DragonTigerFight="DragonTigerFight",--龙虎斗
	VietnamChess="VietnamChess",--越南色碟
	CarLogo="CarLogo",--豪车俱乐部
	BirdsAnimals="BirdsAnimals",--飞禽走兽
	RoyalWar="RoyalWar",--红黑大战
}

---游戏选择场景配置
GameSortID={
	[1]=GameNames.USDollarExpress,--美元快递
	[2]=GameNames.Baccarat,--百家乐
	[3]=GameNames.DragonTigerFight,--龙虎斗
	[4]=GameNames.VietnamChess,--越南色碟
	[5]=GameNames.CarLogo,--豪车俱乐部
	[6]=GameNames.BirdsAnimals,--飞禽走兽
	[7]=GameNames.RoyalWar,--红黑大战
}

-- 游戏的配置
GameConfig = {
	[GameNames.USDollarExpress] = {
		gameType = 100100,
		Manager = "SingleGames/USDollarExpress/USDollarExpress",
		EnterCtrlName = CtrlNames.UIHall, --游戏入口界面
	},
	[GameNames.Baccarat] = {
		gameType = 200500,
		Manager = "SingleGames/Baccarat/Baccarat",
		EnterCtrlName = CtrlNames.UIHall, --游戏入口界面
	},[GameNames.DragonTigerFight] = {
		gameType = 200101,
		Manager = "SingleGames/DragonTigerFight/DragonTigerFight",
		EnterCtrlName = CtrlNames.DragonTigerFight, --游戏入口界面
	},[GameNames.VietnamChess] = {
		gameType = 200700,
		Manager = "SingleGames/VietnamChess/VietnamChess",
		EnterCtrlName = CtrlNames.VietnamChessGame, --游戏入口界面
	},[GameNames.CarLogo] = {
		gameType = 200400,
		Manager = "SingleGames/CarLogo/CarLogo",
		EnterCtrlName = CtrlNames.CarLogoGame, --游戏入口界面
	},[GameNames.BirdsAnimals] = {
		gameType = 200300,
		Manager = "SingleGames/BirdsAnimals/BirdsAnimals",
		EnterCtrlName = CtrlNames.BirdsAnimalsGame, --游戏入口界面
	},[GameNames.RoyalWar] = {
		gameType = 200100,
		Manager = "SingleGames/RoyalWar/RoyalWar",
		EnterCtrlName = CtrlNames.UIHall, --游戏入口界面
	},
	
}

