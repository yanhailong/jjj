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
    public class JiuJiuPrincessUIEventListenerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(JiuJiuPrincess.UIEventListener);
			Utils.BeginObjectRegister(type, L, translator, 0, 27, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddClick", _m_AddClick);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddToggle", _m_AddToggle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddSlider", _m_AddSlider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddScrollRect", _m_AddScrollRect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddLongPress", _m_AddLongPress);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddPressDown", _m_AddPressDown);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddPressUp", _m_AddPressUp);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddInputChange", _m_AddInputChange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddDropdownSelect", _m_AddDropdownSelect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddInputEndEdit", _m_AddInputEndEdit);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddBeginDrag", _m_AddBeginDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddDrag", _m_AddDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddEndDrag", _m_AddEndDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveClick", _m_RemoveClick);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveToggle", _m_RemoveToggle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveSlider", _m_RemoveSlider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveScrollRect", _m_RemoveScrollRect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedLongPress", _m_RemovedLongPress);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedPressDown", _m_RemovedPressDown);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedPressUp", _m_RemovedPressUp);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedInputChange", _m_RemovedInputChange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedDropdownSelect", _m_RemovedDropdownSelect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedInputEndEdit", _m_RemovedInputEndEdit);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedBeginDrag", _m_RemovedBeginDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedDrag", _m_RemovedDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemovedEndDrag", _m_RemovedEndDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 2, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Get", _m_Get_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new JiuJiuPrincess.UIEventListener();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to JiuJiuPrincess.UIEventListener constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Get_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = JiuJiuPrincess.UIEventListener.Get(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddClick(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<UnityEngine.GameObject> _callback = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 3);
                    
                    gen_to_be_invoked.AddClick( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddToggle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<bool> _callback = translator.GetDelegate<System.Action<bool>>(L, 3);
                    
                    gen_to_be_invoked.AddToggle( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddSlider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<float> _callback = translator.GetDelegate<System.Action<float>>(L, 3);
                    
                    gen_to_be_invoked.AddSlider( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddScrollRect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<UnityEngine.Vector2> _callback = translator.GetDelegate<System.Action<UnityEngine.Vector2>>(L, 3);
                    
                    gen_to_be_invoked.AddScrollRect( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddLongPress(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 3);
                    
                    gen_to_be_invoked.AddLongPress( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddPressDown(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 3);
                    
                    gen_to_be_invoked.AddPressDown( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddPressUp(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 3);
                    
                    gen_to_be_invoked.AddPressUp( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddInputChange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<string> _callback = translator.GetDelegate<System.Action<string>>(L, 3);
                    
                    gen_to_be_invoked.AddInputChange( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddDropdownSelect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<int> _callback = translator.GetDelegate<System.Action<int>>(L, 3);
                    
                    gen_to_be_invoked.AddDropdownSelect( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddInputEndEdit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<string> _callback = translator.GetDelegate<System.Action<string>>(L, 3);
                    
                    gen_to_be_invoked.AddInputEndEdit( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddBeginDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<UnityEngine.EventSystems.PointerEventData> _callback = translator.GetDelegate<System.Action<UnityEngine.EventSystems.PointerEventData>>(L, 3);
                    
                    gen_to_be_invoked.AddBeginDrag( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<UnityEngine.EventSystems.PointerEventData> _callback = translator.GetDelegate<System.Action<UnityEngine.EventSystems.PointerEventData>>(L, 3);
                    
                    gen_to_be_invoked.AddDrag( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddEndDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    System.Action<UnityEngine.EventSystems.PointerEventData> _callback = translator.GetDelegate<System.Action<UnityEngine.EventSystems.PointerEventData>>(L, 3);
                    
                    gen_to_be_invoked.AddEndDrag( _go, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveClick(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemoveClick( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveToggle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemoveToggle( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveSlider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemoveSlider( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveScrollRect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemoveScrollRect( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedLongPress(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedLongPress( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedPressDown(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedPressDown( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedPressUp(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedPressUp( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedInputChange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedInputChange( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedDropdownSelect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedDropdownSelect( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedInputEndEdit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedInputEndEdit( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedBeginDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedBeginDrag( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedDrag( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemovedEndDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.RemovedEndDrag( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                JiuJiuPrincess.UIEventListener gen_to_be_invoked = (JiuJiuPrincess.UIEventListener)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Clear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
