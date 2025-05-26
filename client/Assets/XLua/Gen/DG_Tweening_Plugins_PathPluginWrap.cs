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
    public class DGTweeningPluginsPathPluginWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Plugins.PathPlugin);
			Utils.BeginObjectRegister(type, L, translator, 0, 8, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Reset", _m_Reset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetFrom", _m_SetFrom);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ConvertToStartValue", _m_ConvertToStartValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRelativeEndValue", _m_SetRelativeEndValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetChangeValue", _m_SetChangeValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSpeedBasedDuration", _m_GetSpeedBasedDuration);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EvaluateAndApply", _m_EvaluateAndApply);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOrientation", _m_SetOrientation);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Get", _m_Get_xlua_st_);
            
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MinLookAhead", DG.Tweening.Plugins.PathPlugin.MinLookAhead);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new DG.Tweening.Plugins.PathPlugin();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Plugins.PathPlugin constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Reset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    
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
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    bool _isRelative = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.SetFrom( _t, _isRelative );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>>(L, 2)&& translator.Assignable<DG.Tweening.Plugins.Core.PathCore.Path>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    DG.Tweening.Plugins.Core.PathCore.Path _fromValue = (DG.Tweening.Plugins.Core.PathCore.Path)translator.GetObject(L, 3, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
                    bool _setImmediately = LuaAPI.lua_toboolean(L, 4);
                    bool _isRelative = LuaAPI.lua_toboolean(L, 5);
                    
                    gen_to_be_invoked.SetFrom( _t, _fromValue, _setImmediately, _isRelative );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Plugins.PathPlugin.SetFrom!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Get_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = DG.Tweening.Plugins.PathPlugin.Get(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ConvertToStartValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    UnityEngine.Vector3 _value;translator.Get(L, 3, out _value);
                    
                        var gen_ret = gen_to_be_invoked.ConvertToStartValue( _t, _value );
                        translator.Push(L, gen_ret);
                    
                    
                    
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
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    
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
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> _t = (DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>)translator.GetObject(L, 2, typeof(DG.Tweening.Core.TweenerCore<UnityEngine.Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions>));
                    
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
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Plugins.Options.PathOptions _options;translator.Get(L, 2, out _options);
                    float _unitsXSecond = (float)LuaAPI.lua_tonumber(L, 3);
                    DG.Tweening.Plugins.Core.PathCore.Path _changeValue = (DG.Tweening.Plugins.Core.PathCore.Path)translator.GetObject(L, 4, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
                    
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
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Plugins.Options.PathOptions _options;translator.Get(L, 2, out _options);
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 3, typeof(DG.Tweening.Tween));
                    bool _isRelative = LuaAPI.lua_toboolean(L, 4);
                    DG.Tweening.Core.DOGetter<UnityEngine.Vector3> _getter = translator.GetDelegate<DG.Tweening.Core.DOGetter<UnityEngine.Vector3>>(L, 5);
                    DG.Tweening.Core.DOSetter<UnityEngine.Vector3> _setter = translator.GetDelegate<DG.Tweening.Core.DOSetter<UnityEngine.Vector3>>(L, 6);
                    float _elapsed = (float)LuaAPI.lua_tonumber(L, 7);
                    DG.Tweening.Plugins.Core.PathCore.Path _startValue = (DG.Tweening.Plugins.Core.PathCore.Path)translator.GetObject(L, 8, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
                    DG.Tweening.Plugins.Core.PathCore.Path _changeValue = (DG.Tweening.Plugins.Core.PathCore.Path)translator.GetObject(L, 9, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
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
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOrientation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.Plugins.PathPlugin gen_to_be_invoked = (DG.Tweening.Plugins.PathPlugin)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    DG.Tweening.Plugins.Options.PathOptions _options;translator.Get(L, 2, out _options);
                    DG.Tweening.Tween _t = (DG.Tweening.Tween)translator.GetObject(L, 3, typeof(DG.Tweening.Tween));
                    DG.Tweening.Plugins.Core.PathCore.Path _path = (DG.Tweening.Plugins.Core.PathCore.Path)translator.GetObject(L, 4, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
                    float _pathPerc = (float)LuaAPI.lua_tonumber(L, 5);
                    UnityEngine.Vector3 _tPos;translator.Get(L, 6, out _tPos);
                    DG.Tweening.Core.Enums.UpdateNotice _updateNotice;translator.Get(L, 7, out _updateNotice);
                    
                    gen_to_be_invoked.SetOrientation( _options, _t, _path, _pathPerc, _tPos, _updateNotice );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
