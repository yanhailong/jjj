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
    public class DGTweeningPluginsCorePathCorePathWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.Plugins.Core.PathCore.Path);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 2, 2);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "wpLengths", _g_get_wpLengths);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "wps", _g_get_wps);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "wpLengths", _s_set_wpLengths);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "wps", _s_set_wps);
            
			
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
				if(LuaAPI.lua_gettop(L) == 5 && translator.Assignable<DG.Tweening.PathType>(L, 2) && translator.Assignable<UnityEngine.Vector3[]>(L, 3) && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) && translator.Assignable<System.Nullable<UnityEngine.Color>>(L, 5))
				{
					DG.Tweening.PathType _type;translator.Get(L, 2, out _type);
					UnityEngine.Vector3[] _waypoints = (UnityEngine.Vector3[])translator.GetObject(L, 3, typeof(UnityEngine.Vector3[]));
					int _subdivisionsXSegment = LuaAPI.xlua_tointeger(L, 4);
					System.Nullable<UnityEngine.Color> _gizmoColor;translator.Get(L, 5, out _gizmoColor);
					
					var gen_ret = new DG.Tweening.Plugins.Core.PathCore.Path(_type, _waypoints, _subdivisionsXSegment, _gizmoColor);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				if(LuaAPI.lua_gettop(L) == 4 && translator.Assignable<DG.Tweening.PathType>(L, 2) && translator.Assignable<UnityEngine.Vector3[]>(L, 3) && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4))
				{
					DG.Tweening.PathType _type;translator.Get(L, 2, out _type);
					UnityEngine.Vector3[] _waypoints = (UnityEngine.Vector3[])translator.GetObject(L, 3, typeof(UnityEngine.Vector3[]));
					int _subdivisionsXSegment = LuaAPI.xlua_tointeger(L, 4);
					
					var gen_ret = new DG.Tweening.Plugins.Core.PathCore.Path(_type, _waypoints, _subdivisionsXSegment);
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.Plugins.Core.PathCore.Path constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_wpLengths(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Plugins.Core.PathCore.Path gen_to_be_invoked = (DG.Tweening.Plugins.Core.PathCore.Path)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.wpLengths);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_wps(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Plugins.Core.PathCore.Path gen_to_be_invoked = (DG.Tweening.Plugins.Core.PathCore.Path)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.wps);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_wpLengths(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Plugins.Core.PathCore.Path gen_to_be_invoked = (DG.Tweening.Plugins.Core.PathCore.Path)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.wpLengths = (float[])translator.GetObject(L, 2, typeof(float[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_wps(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.Plugins.Core.PathCore.Path gen_to_be_invoked = (DG.Tweening.Plugins.Core.PathCore.Path)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.wps = (UnityEngine.Vector3[])translator.GetObject(L, 2, typeof(UnityEngine.Vector3[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
