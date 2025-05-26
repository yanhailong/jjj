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
    public class DGTweeningPluginsUlongPluginWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Plugins.UlongPlugin);
			Utils.BeginObjectRegister(type, L, translator, 0, 7, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Reset", _m_Reset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetFrom", _m_SetFrom);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ConvertToStartValue", _m_ConvertToStartValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRelativeEndValue", _m_SetRelativeEndValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetChangeValue", _m_SetChangeValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSpeedBasedDuration", _m_GetSpeedBasedDuration);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EvaluateAndApply", _m_EvaluateAndApply);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new DG.Tweening.Plugins.UlongPlugin();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Plugins.UlongPlugin constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Reset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    
                    gen_to_be_invoked.Reset( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetFrom(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    bool _isRelative = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.SetFrom( _t, _isRelative );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>>(L, 2)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isuint64(L, 3))&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    ulong _fromValue = LuaAPI.lua_touint64(L, 3);
                    bool _setImmediately = LuaAPI.lua_toboolean(L, 4);
                    bool _isRelative = LuaAPI.lua_toboolean(L, 5);
                    
                    gen_to_be_invoked.SetFrom( _t, _fromValue, _setImmediately, _isRelative );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Plugins.UlongPlugin.SetFrom!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ConvertToStartValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    ulong _value = LuaAPI.lua_touint64(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.ConvertToStartValue( _t, _value );
                        LuaAPI.lua_pushuint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetRelativeEndValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    
                    gen_to_be_invoked.SetRelativeEndValue( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetChangeValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions> _t = (DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<ulong, ulong, DG.Tweening.Plugins.Options.NoOptions>));
                    
                    gen_to_be_invoked.SetChangeValue( _t );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSpeedBasedDuration(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Plugins.Options.NoOptions _options;translator.Get(L, 2, out _options);
                    float _unitsXSecond = (float)LuaAPI.lua_tonumber(L, 3);
                    ulong _changeValue = LuaAPI.lua_touint64(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.GetSpeedBasedDuration( _options, _unitsXSecond, _changeValue );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EvaluateAndApply(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.UlongPlugin gen_to_be_invoked = (DG.Tweening.Plugins.UlongPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Plugins.Options.NoOptions _options;translator.Get(L, 2, out _options);
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 3, typeof(DG.Tweening.Tween));
                    bool _isRelative = LuaAPI.lua_toboolean(L, 4);
                    DG.Tweening.Core.DOGetter<ulong> _getter = translator.GetDelegate<DG.Tweening.Core.DOGetter<ulong>>(L, 5);
                    DG.Tweening.Core.DOSetter<ulong> _setter = translator.GetDelegate<DG.Tweening.Core.DOSetter<ulong>>(L, 6);
                    float _elapsed = (float)LuaAPI.lua_tonumber(L, 7);
                    ulong _startValue = LuaAPI.lua_touint64(L, 8);
                    ulong _changeValue = LuaAPI.lua_touint64(L, 9);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 10);
                    bool _usingInversePosition = LuaAPI.lua_toboolean(L, 11);
                    DG.Tweening.Core.Enums.UpdateNotice _updateNotice;translator.Get(L, 12, out _updateNotice);
                    
                    gen_to_be_invoked.EvaluateAndApply( _options, _t, _isRelative, _getter, _setter, _elapsed, _startValue, _changeValue, _duration, _usingInversePosition, _updateNotice );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
