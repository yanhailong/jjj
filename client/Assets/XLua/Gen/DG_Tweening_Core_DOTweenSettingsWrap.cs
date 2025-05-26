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
    public class DGTweeningCoreDOTweenSettingsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Core.DOTweenSettings);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 26, 26);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "useSafeMode", _g_get_useSafeMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "safeModeOptions", _g_get_safeModeOptions);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "timeScale", _g_get_timeScale);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "useSmoothDeltaTime", _g_get_useSmoothDeltaTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "maxSmoothUnscaledTime", _g_get_maxSmoothUnscaledTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "rewindCallbackMode", _g_get_rewindCallbackMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "showUnityEditorReport", _g_get_showUnityEditorReport);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "logBehaviour", _g_get_logBehaviour);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "drawGizmos", _g_get_drawGizmos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultRecyclable", _g_get_defaultRecyclable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultAutoPlay", _g_get_defaultAutoPlay);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultUpdateType", _g_get_defaultUpdateType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultTimeScaleIndependent", _g_get_defaultTimeScaleIndependent);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultEaseType", _g_get_defaultEaseType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultEaseOvershootOrAmplitude", _g_get_defaultEaseOvershootOrAmplitude);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultEasePeriod", _g_get_defaultEasePeriod);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultAutoKill", _g_get_defaultAutoKill);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "defaultLoopType", _g_get_defaultLoopType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "debugMode", _g_get_debugMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "debugStoreTargetId", _g_get_debugStoreTargetId);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "showPreviewPanel", _g_get_showPreviewPanel);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "storeSettingsLocation", _g_get_storeSettingsLocation);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "modules", _g_get_modules);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "createASMDEF", _g_get_createASMDEF);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "showPlayingTweens", _g_get_showPlayingTweens);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "showPausedTweens", _g_get_showPausedTweens);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "useSafeMode", _s_set_useSafeMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "safeModeOptions", _s_set_safeModeOptions);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "timeScale", _s_set_timeScale);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "useSmoothDeltaTime", _s_set_useSmoothDeltaTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "maxSmoothUnscaledTime", _s_set_maxSmoothUnscaledTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "rewindCallbackMode", _s_set_rewindCallbackMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "showUnityEditorReport", _s_set_showUnityEditorReport);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "logBehaviour", _s_set_logBehaviour);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "drawGizmos", _s_set_drawGizmos);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultRecyclable", _s_set_defaultRecyclable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultAutoPlay", _s_set_defaultAutoPlay);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultUpdateType", _s_set_defaultUpdateType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultTimeScaleIndependent", _s_set_defaultTimeScaleIndependent);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultEaseType", _s_set_defaultEaseType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultEaseOvershootOrAmplitude", _s_set_defaultEaseOvershootOrAmplitude);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultEasePeriod", _s_set_defaultEasePeriod);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultAutoKill", _s_set_defaultAutoKill);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "defaultLoopType", _s_set_defaultLoopType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "debugMode", _s_set_debugMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "debugStoreTargetId", _s_set_debugStoreTargetId);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "showPreviewPanel", _s_set_showPreviewPanel);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "storeSettingsLocation", _s_set_storeSettingsLocation);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "modules", _s_set_modules);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "createASMDEF", _s_set_createASMDEF);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "showPlayingTweens", _s_set_showPlayingTweens);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "showPausedTweens", _s_set_showPausedTweens);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AssetName", DG.Tweening.Core.DOTweenSettings.AssetName);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AssetFullFilename", DG.Tweening.Core.DOTweenSettings.AssetFullFilename);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new DG.Tweening.Core.DOTweenSettings();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.DOTweenSettings constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useSafeMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useSafeMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_safeModeOptions(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.safeModeOptions);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_timeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.timeScale);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useSmoothDeltaTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useSmoothDeltaTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_maxSmoothUnscaledTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.maxSmoothUnscaledTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_rewindCallbackMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningCoreEnumsRewindCallbackMode(L, gen_to_be_invoked.rewindCallbackMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_showUnityEditorReport(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.showUnityEditorReport);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_logBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningLogBehaviour(L, gen_to_be_invoked.logBehaviour);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_drawGizmos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.drawGizmos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultRecyclable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.defaultRecyclable);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultAutoPlay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningAutoPlay(L, gen_to_be_invoked.defaultAutoPlay);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultUpdateType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningUpdateType(L, gen_to_be_invoked.defaultUpdateType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultTimeScaleIndependent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.defaultTimeScaleIndependent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultEaseType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningEase(L, gen_to_be_invoked.defaultEaseType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultEaseOvershootOrAmplitude(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.defaultEaseOvershootOrAmplitude);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultEasePeriod(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.defaultEasePeriod);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultAutoKill(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.defaultAutoKill);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_defaultLoopType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningLoopType(L, gen_to_be_invoked.defaultLoopType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_debugMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.debugMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_debugStoreTargetId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.debugStoreTargetId);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_showPreviewPanel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.showPreviewPanel);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_storeSettingsLocation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningCoreDOTweenSettingsSettingsLocation(L, gen_to_be_invoked.storeSettingsLocation);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_modules(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.modules);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_createASMDEF(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.createASMDEF);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_showPlayingTweens(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.showPlayingTweens);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_showPausedTweens(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.showPausedTweens);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useSafeMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useSafeMode = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_safeModeOptions(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.safeModeOptions = (DG.Tweening.Core.DOTweenSettings.SafeModeOptions)translator.GetObject(L, 2, typeof(DG.Tweening.Core.DOTweenSettings.SafeModeOptions));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_timeScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.timeScale = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useSmoothDeltaTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useSmoothDeltaTime = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_maxSmoothUnscaledTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.maxSmoothUnscaledTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_rewindCallbackMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.Enums.RewindCallbackMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.rewindCallbackMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_showUnityEditorReport(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.showUnityEditorReport = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_logBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.LogBehaviour gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.logBehaviour = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_drawGizmos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.drawGizmos = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultRecyclable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.defaultRecyclable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultAutoPlay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.AutoPlay gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.defaultAutoPlay = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultUpdateType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.UpdateType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.defaultUpdateType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultTimeScaleIndependent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.defaultTimeScaleIndependent = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultEaseType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.Ease gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.defaultEaseType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultEaseOvershootOrAmplitude(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.defaultEaseOvershootOrAmplitude = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultEasePeriod(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.defaultEasePeriod = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultAutoKill(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.defaultAutoKill = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_defaultLoopType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.LoopType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.defaultLoopType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_debugMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.debugMode = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_debugStoreTargetId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.debugStoreTargetId = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_showPreviewPanel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.showPreviewPanel = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_storeSettingsLocation(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.DOTweenSettings.SettingsLocation gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.storeSettingsLocation = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_modules(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.modules = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.GetObject(L, 2, typeof(DG.Tweening.Core.DOTweenSettings.ModulesSetup));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_createASMDEF(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.createASMDEF = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_showPlayingTweens(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.showPlayingTweens = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_showPausedTweens(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.showPausedTweens = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
