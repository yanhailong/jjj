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
    public class DGTweeningDOCurveCubicBezierWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.DOCurve.CubicBezier);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPointOnSegment", _m_GetPointOnSegment_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetSegmentPointCloud", _m_GetSegmentPointCloud_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "DG.Tweening.DOCurve.CubicBezier does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPointOnSegment_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector3 _startPoint;translator.Get(L, 1, out _startPoint);
                    UnityEngine.Vector3 _startControlPoint;translator.Get(L, 2, out _startControlPoint);
                    UnityEngine.Vector3 _endPoint;translator.Get(L, 3, out _endPoint);
                    UnityEngine.Vector3 _endControlPoint;translator.Get(L, 4, out _endControlPoint);
                    float _factor = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        var gen_ret = DG.Tweening.DOCurve.CubicBezier.GetPointOnSegment( _startPoint, _startControlPoint, _endPoint, _endControlPoint, _factor );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSegmentPointCloud_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 1)&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    UnityEngine.Vector3 _startPoint;translator.Get(L, 1, out _startPoint);
                    UnityEngine.Vector3 _startControlPoint;translator.Get(L, 2, out _startControlPoint);
                    UnityEngine.Vector3 _endPoint;translator.Get(L, 3, out _endPoint);
                    UnityEngine.Vector3 _endControlPoint;translator.Get(L, 4, out _endControlPoint);
                    int _resolution = LuaAPI.xlua_tointeger(L, 5);
                    
                        var gen_ret = DG.Tweening.DOCurve.CubicBezier.GetSegmentPointCloud( _startPoint, _startControlPoint, _endPoint, _endControlPoint, _resolution );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 1)&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)) 
                {
                    UnityEngine.Vector3 _startPoint;translator.Get(L, 1, out _startPoint);
                    UnityEngine.Vector3 _startControlPoint;translator.Get(L, 2, out _startControlPoint);
                    UnityEngine.Vector3 _endPoint;translator.Get(L, 3, out _endPoint);
                    UnityEngine.Vector3 _endControlPoint;translator.Get(L, 4, out _endControlPoint);
                    
                        var gen_ret = DG.Tweening.DOCurve.CubicBezier.GetSegmentPointCloud( _startPoint, _startControlPoint, _endPoint, _endControlPoint );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 6&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Vector3>>(L, 1)&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    System.Collections.Generic.List<UnityEngine.Vector3> _addToList = (System.Collections.Generic.List<UnityEngine.Vector3>)translator.GetObject(L, 1, typeof(System.Collections.Generic.List<UnityEngine.Vector3>));
                    UnityEngine.Vector3 _startPoint;translator.Get(L, 2, out _startPoint);
                    UnityEngine.Vector3 _startControlPoint;translator.Get(L, 3, out _startControlPoint);
                    UnityEngine.Vector3 _endPoint;translator.Get(L, 4, out _endPoint);
                    UnityEngine.Vector3 _endControlPoint;translator.Get(L, 5, out _endControlPoint);
                    int _resolution = LuaAPI.xlua_tointeger(L, 6);
                    
                    DG.Tweening.DOCurve.CubicBezier.GetSegmentPointCloud( _addToList, _startPoint, _startControlPoint, _endPoint, _endControlPoint, _resolution );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Vector3>>(L, 1)&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)) 
                {
                    System.Collections.Generic.List<UnityEngine.Vector3> _addToList = (System.Collections.Generic.List<UnityEngine.Vector3>)translator.GetObject(L, 1, typeof(System.Collections.Generic.List<UnityEngine.Vector3>));
                    UnityEngine.Vector3 _startPoint;translator.Get(L, 2, out _startPoint);
                    UnityEngine.Vector3 _startControlPoint;translator.Get(L, 3, out _startControlPoint);
                    UnityEngine.Vector3 _endPoint;translator.Get(L, 4, out _endPoint);
                    UnityEngine.Vector3 _endControlPoint;translator.Get(L, 5, out _endControlPoint);
                    
                    DG.Tweening.DOCurve.CubicBezier.GetSegmentPointCloud( _addToList, _startPoint, _startControlPoint, _endPoint, _endControlPoint );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.DOCurve.CubicBezier.GetSegmentPointCloud!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
