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
    public class JiuJiuPrincessCoroutineManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(JiuJiuPrincess.CoroutineManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 6, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartCor", _m_StartCor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StopCor", _m_StopCor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StopAll", _m_StopAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DelayCall", _m_DelayCall);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WebRequest", _m_WebRequest);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Wait", _m_Wait);
			
			
			
			
			
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
					
					var gen_ret = new JiuJiuPrincess.CoroutineManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.CoroutineManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartCor(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<System.Collections.IEnumerator>(L, 2)) 
                {
                    System.Collections.IEnumerator _enumerator = (System.Collections.IEnumerator)translator.GetObject(L, 2, typeof(System.Collections.IEnumerator));
                    
                        var gen_ret = gen_to_be_invoked.StartCor( _enumerator );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& translator.Assignable<object>(L, 2)&& translator.Assignable<System.Collections.IEnumerator>(L, 3)) 
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    System.Collections.IEnumerator _enumerator = (System.Collections.IEnumerator)translator.GetObject(L, 3, typeof(System.Collections.IEnumerator));
                    
                        var gen_ret = gen_to_be_invoked.StartCor( _obj, _enumerator );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.CoroutineManager.StartCor!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StopCor(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    int _cor_id = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.StopCor( _obj, _cor_id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StopAll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    
                    gen_to_be_invoked.StopAll( _obj );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DelayCall(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<object>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<System.Action>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    float _time = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action _func = translator.GetDelegate<System.Action>(L, 4);
                    int _repeat = LuaAPI.xlua_tointeger(L, 5);
                    
                        var gen_ret = gen_to_be_invoked.DelayCall( _obj, _time, _func, _repeat );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& translator.Assignable<object>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<System.Action>(L, 4)) 
                {
                    object _obj = translator.GetObject(L, 2, typeof(object));
                    float _time = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action _func = translator.GetDelegate<System.Action>(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.DelayCall( _obj, _time, _func );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.CoroutineManager.DelayCall!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WebRequest(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Networking.UnityWebRequest _request = (UnityEngine.Networking.UnityWebRequest)translator.GetObject(L, 2, typeof(UnityEngine.Networking.UnityWebRequest));
                    System.Action _func = translator.GetDelegate<System.Action>(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.WebRequest( _request, _func );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Wait(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.CoroutineManager gen_to_be_invoked = (JiuJiuPrincess.CoroutineManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.YieldInstruction>(L, 2)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    UnityEngine.YieldInstruction _wait = (UnityEngine.YieldInstruction)translator.GetObject(L, 2, typeof(UnityEngine.YieldInstruction));
                    System.Action _func = translator.GetDelegate<System.Action>(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.Wait( _wait, _func );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.CustomYieldInstruction>(L, 2)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    UnityEngine.CustomYieldInstruction _wait = (UnityEngine.CustomYieldInstruction)translator.GetObject(L, 2, typeof(UnityEngine.CustomYieldInstruction));
                    System.Action _func = translator.GetDelegate<System.Action>(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.Wait( _wait, _func );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.CoroutineManager.Wait!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
