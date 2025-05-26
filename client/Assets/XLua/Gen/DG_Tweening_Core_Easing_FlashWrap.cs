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
    public class DGTweeningCoreEasingFlashWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Core.Easing.Flash);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 5, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Ease", _m_Ease_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EaseIn", _m_EaseIn_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EaseOut", _m_EaseOut_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EaseInOut", _m_EaseInOut_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "DG.Tweening.Core.Easing.Flash does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Ease_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 1);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _overshootOrAmplitude = (float)LuaAPI.lua_tonumber(L, 3);
                    float _period = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = DG.Tweening.Core.Easing.Flash.Ease( _time, _duration, _overshootOrAmplitude, _period );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EaseIn_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 1);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _overshootOrAmplitude = (float)LuaAPI.lua_tonumber(L, 3);
                    float _period = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = DG.Tweening.Core.Easing.Flash.EaseIn( _time, _duration, _overshootOrAmplitude, _period );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EaseOut_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 1);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _overshootOrAmplitude = (float)LuaAPI.lua_tonumber(L, 3);
                    float _period = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = DG.Tweening.Core.Easing.Flash.EaseOut( _time, _duration, _overshootOrAmplitude, _period );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EaseInOut_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 1);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _overshootOrAmplitude = (float)LuaAPI.lua_tonumber(L, 3);
                    float _period = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = DG.Tweening.Core.Easing.Flash.EaseInOut( _time, _duration, _overshootOrAmplitude, _period );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
