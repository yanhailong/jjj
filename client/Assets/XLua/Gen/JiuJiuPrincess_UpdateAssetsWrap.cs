#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class JiuJiuPrincessUpdateAssetsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(JiuJiuPrincess.UpdateAssets);
			Utils.BeginObjectRegister(type, L, translator, 0, 4, 4, 4);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUpdateSizeWaitTime", _m_SetUpdateSizeWaitTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartUpdate", _m_StartUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DownLoadAssets", _m_DownLoadAssets);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "HTTPTIMEOUT", _g_get_HTTPTIMEOUT);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "MAXUPDATECOUNT", _g_get_MAXUPDATECOUNT);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "DOWNLOADERRORCOUNT", _g_get_DOWNLOADERRORCOUNT);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "updateUrl", _g_get_updateUrl);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "HTTPTIMEOUT", _s_set_HTTPTIMEOUT);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "MAXUPDATECOUNT", _s_set_MAXUPDATECOUNT);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "DOWNLOADERRORCOUNT", _s_set_DOWNLOADERRORCOUNT);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "updateUrl", _s_set_updateUrl);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 8, 1, 1);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NETWORKERROR", JiuJiuPrincess.UpdateAssets.NETWORKERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "HTTPERROR", JiuJiuPrincess.UpdateAssets.HTTPERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LOCALLISTERROR", JiuJiuPrincess.UpdateAssets.LOCALLISTERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LOCALSIZEERROR", JiuJiuPrincess.UpdateAssets.LOCALSIZEERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SERVERFILELISTERROR", JiuJiuPrincess.UpdateAssets.SERVERFILELISTERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SERVERSIZEERROR", JiuJiuPrincess.UpdateAssets.SERVERSIZEERROR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FILEDOWNLOADERROR", JiuJiuPrincess.UpdateAssets.FILEDOWNLOADERROR);
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "updateSizeTime", _g_get_updateSizeTime);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "updateSizeTime", _s_set_updateSizeTime);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 5 && (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING) && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5))
				{
					string _localPath = LuaAPI.lua_tostring(L, 2);
					string _url = LuaAPI.lua_tostring(L, 3);
					string _gameName = LuaAPI.lua_tostring(L, 4);
					int _version = LuaAPI.xlua_tointeger(L, 5);
					
					var gen_ret = new JiuJiuPrincess.UpdateAssets(_localPath, _url, _gameName, _version);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				if(LuaAPI.lua_gettop(L) == 4 && (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING))
				{
					string _localPath = LuaAPI.lua_tostring(L, 2);
					string _url = LuaAPI.lua_tostring(L, 3);
					string _gameName = LuaAPI.lua_tostring(L, 4);
					
					var gen_ret = new JiuJiuPrincess.UpdateAssets(_localPath, _url, _gameName);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				if(LuaAPI.lua_gettop(L) == 3 && (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING))
				{
					string _localPath = LuaAPI.lua_tostring(L, 2);
					string _url = LuaAPI.lua_tostring(L, 3);
					
					var gen_ret = new JiuJiuPrincess.UpdateAssets(_localPath, _url);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.UpdateAssets constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUpdateSizeWaitTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetUpdateSizeWaitTime( _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<System.Action<int, string>>(L, 2)&& translator.Assignable<System.Action<int, int>>(L, 3)&& translator.Assignable<System.Action>(L, 4)&& translator.Assignable<System.Action<int>>(L, 5)) 
                {
                    System.Action<int, string> _updateError = translator.GetDelegate<System.Action<int, string>>(L, 2);
                    System.Action<int, int> _updateProgress = translator.GetDelegate<System.Action<int, int>>(L, 3);
                    System.Action _updateFinished = translator.GetDelegate<System.Action>(L, 4);
                    System.Action<int> _checkFinished = translator.GetDelegate<System.Action<int>>(L, 5);
                    
                    gen_to_be_invoked.StartUpdate( _updateError, _updateProgress, _updateFinished, _checkFinished );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<System.Action<int, string>>(L, 2)&& translator.Assignable<System.Action<int, int>>(L, 3)&& translator.Assignable<System.Action>(L, 4)) 
                {
                    System.Action<int, string> _updateError = translator.GetDelegate<System.Action<int, string>>(L, 2);
                    System.Action<int, int> _updateProgress = translator.GetDelegate<System.Action<int, int>>(L, 3);
                    System.Action _updateFinished = translator.GetDelegate<System.Action>(L, 4);
                    
                    gen_to_be_invoked.StartUpdate( _updateError, _updateProgress, _updateFinished );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.UpdateAssets.StartUpdate!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DownLoadAssets(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DownLoadAssets(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Clear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_HTTPTIMEOUT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.HTTPTIMEOUT);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_MAXUPDATECOUNT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.MAXUPDATECOUNT);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DOWNLOADERRORCOUNT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.DOWNLOADERRORCOUNT);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_updateUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.updateUrl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_updateSizeTime(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, JiuJiuPrincess.UpdateAssets.updateSizeTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_HTTPTIMEOUT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.HTTPTIMEOUT = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_MAXUPDATECOUNT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.MAXUPDATECOUNT = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DOWNLOADERRORCOUNT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.DOWNLOADERRORCOUNT = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_updateUrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                JiuJiuPrincess.UpdateAssets gen_to_be_invoked = (JiuJiuPrincess.UpdateAssets)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.updateUrl = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_updateSizeTime(RealStatePtr L)
        {
		    try {
                
			    JiuJiuPrincess.UpdateAssets.updateSizeTime = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
