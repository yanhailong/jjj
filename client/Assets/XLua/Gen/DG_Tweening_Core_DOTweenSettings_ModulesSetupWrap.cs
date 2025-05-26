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
    public class DGTweeningCoreDOTweenSettingsModulesSetupWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Core.DOTweenSettings.ModulesSetup);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 11, 11);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "showPanel", _g_get_showPanel);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "audioEnabled", _g_get_audioEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "physicsEnabled", _g_get_physicsEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "physics2DEnabled", _g_get_physics2DEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "spriteEnabled", _g_get_spriteEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "uiEnabled", _g_get_uiEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "textMeshProEnabled", _g_get_textMeshProEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "tk2DEnabled", _g_get_tk2DEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "deAudioEnabled", _g_get_deAudioEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "deUnityExtendedEnabled", _g_get_deUnityExtendedEnabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "epoOutlineEnabled", _g_get_epoOutlineEnabled);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "showPanel", _s_set_showPanel);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "audioEnabled", _s_set_audioEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "physicsEnabled", _s_set_physicsEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "physics2DEnabled", _s_set_physics2DEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "spriteEnabled", _s_set_spriteEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "uiEnabled", _s_set_uiEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "textMeshProEnabled", _s_set_textMeshProEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "tk2DEnabled", _s_set_tk2DEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "deAudioEnabled", _s_set_deAudioEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "deUnityExtendedEnabled", _s_set_deUnityExtendedEnabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "epoOutlineEnabled", _s_set_epoOutlineEnabled);
            
			
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
					
					var gen_ret = new DG.Tweening.Core.DOTweenSettings.ModulesSetup();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.DOTweenSettings.ModulesSetup constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_showPanel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.showPanel);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_audioEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.audioEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_physicsEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.physicsEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_physics2DEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.physics2DEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_spriteEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.spriteEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_uiEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.uiEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_textMeshProEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.textMeshProEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_tk2DEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.tk2DEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_deAudioEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.deAudioEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_deUnityExtendedEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.deUnityExtendedEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_epoOutlineEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.epoOutlineEnabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_showPanel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.showPanel = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_audioEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.audioEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_physicsEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.physicsEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_physics2DEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.physics2DEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_spriteEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.spriteEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_uiEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.uiEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_textMeshProEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.textMeshProEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_tk2DEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.tk2DEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_deAudioEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.deAudioEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_deUnityExtendedEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.deUnityExtendedEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_epoOutlineEnabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.ModulesSetup gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.ModulesSetup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.epoOutlineEnabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
