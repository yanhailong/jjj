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
    public class DGTweeningCoreDOTweenSettingsSafeModeOptionsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Core.DOTweenSettings.SafeModeOptions);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 2, 2);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "logBehaviour", _g_get_logBehaviour);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "nestedTweenFailureBehaviour", _g_get_nestedTweenFailureBehaviour);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "logBehaviour", _s_set_logBehaviour);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "nestedTweenFailureBehaviour", _s_set_nestedTweenFailureBehaviour);
            
			
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
					
					var gen_ret = new DG.Tweening.Core.DOTweenSettings.SafeModeOptions();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Core.DOTweenSettings.SafeModeOptions constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_logBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.SafeModeOptions gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.SafeModeOptions)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, gen_to_be_invoked.logBehaviour);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_nestedTweenFailureBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.SafeModeOptions gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.SafeModeOptions)translator.FastGetCSObj(L, 1);
                translator.PushDGTweeningCoreEnumsNestedTweenFailureBehaviour(L, gen_to_be_invoked.nestedTweenFailureBehaviour);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_logBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.SafeModeOptions gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.SafeModeOptions)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.Enums.SafeModeLogBehaviour gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.logBehaviour = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_nestedTweenFailureBehaviour(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Core.DOTweenSettings.SafeModeOptions gen_to_be_invoked = (DG.Tweening.Core.DOTweenSettings.SafeModeOptions)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.Enums.NestedTweenFailureBehaviour gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.nestedTweenFailureBehaviour = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
