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
    public class DGTweeningCoreDebuggerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Core.Debugger);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 16, 1, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Log", _m_Log_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogWarning", _m_LogWarning_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogError", _m_LogError_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogSafeModeCapturedError", _m_LogSafeModeCapturedError_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogReport", _m_LogReport_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogSafeModeReport", _m_LogSafeModeReport_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogInvalidTween", _m_LogInvalidTween_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogNestedTween", _m_LogNestedTween_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogNullTween", _m_LogNullTween_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogNonPathTween", _m_LogNonPathTween_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogMissingMaterialProperty", _m_LogMissingMaterialProperty_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogRemoveActiveTweenError", _m_LogRemoveActiveTweenError_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LogAddActiveTweenError", _m_LogAddActiveTweenError_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetLogPriority", _m_SetLogPriority_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShouldLogSafeModeCapturedError", _m_ShouldLogSafeModeCapturedError_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "logPriority", _g_get_logPriority);
            
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "DG.Tweening.Core.Debugger does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Log_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.Log( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogWarning_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<object>(L, 1)&& translator.Assignable<DG.Tweening.Tween>(L, 2)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 2, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogWarning( _message, _t );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& translator.Assignable<object>(L, 1)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.LogWarning( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.Debugger.LogWarning!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogError_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<object>(L, 1)&& translator.Assignable<DG.Tweening.Tween>(L, 2)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 2, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogError( _message, _t );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& translator.Assignable<object>(L, 1)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.LogError( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.Debugger.LogError!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogSafeModeCapturedError_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<object>(L, 1)&& translator.Assignable<DG.Tweening.Tween>(L, 2)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 2, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogSafeModeCapturedError( _message, _t );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& translator.Assignable<object>(L, 1)) 
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.LogSafeModeCapturedError( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.Debugger.LogSafeModeCapturedError!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogReport_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.LogReport( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogSafeModeReport_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    object _message = translator.GetObject(L, 1, typeof(object));
                    
                    DG.Tweening.Core.Debugger.LogSafeModeReport( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogInvalidTween_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 1, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogInvalidTween( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogNestedTween_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 1, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogNestedTween( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogNullTween_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 1, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogNullTween( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogNonPathTween_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 1, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogNonPathTween( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogMissingMaterialProperty_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)) 
                {
                    int _propertyId = LuaAPI.xlua_tointeger(L, 1);
                    
                    DG.Tweening.Core.Debugger.LogMissingMaterialProperty( _propertyId );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _propertyName = LuaAPI.lua_tostring(L, 1);
                    
                    DG.Tweening.Core.Debugger.LogMissingMaterialProperty( _propertyName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.Debugger.LogMissingMaterialProperty!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogRemoveActiveTweenError_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _errorInfo = LuaAPI.lua_tostring(L, 1);
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 2, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogRemoveActiveTweenError( _errorInfo, _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LogAddActiveTweenError_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _errorInfo = LuaAPI.lua_tostring(L, 1);
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 2, typeof(DG.Tweening.Tween));
                    
                    DG.Tweening.Core.Debugger.LogAddActiveTweenError( _errorInfo, _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLogPriority_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    DG.Tweening.LogBehaviour _logBehaviour;translator.Get(L, 1, out _logBehaviour);
                    
                    DG.Tweening.Core.Debugger.SetLogPriority( _logBehaviour );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShouldLogSafeModeCapturedError_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = DG.Tweening.Core.Debugger.ShouldLogSafeModeCapturedError(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_logPriority(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, DG.Tweening.Core.Debugger.logPriority);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
