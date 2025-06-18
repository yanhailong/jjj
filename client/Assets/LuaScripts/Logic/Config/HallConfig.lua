---@class HallConfig
HallConfig=Class("HallConfig")
local this=HallConfig

-- 游戏的配置
-- 子游戏的名字
GameNames = {
	USDollarExpress="USDollarExpress",--美元快递
}

-- 游戏的配置
GameConfig = {
	[GameNames.USDollarExpress] = {
		gameType = 100100,
		Manager = "SingleGames/USDollarExpress/MVCHead",
		EnterCtrlName = CtrlNames.UIHall, --游戏入口界面
	},
}

