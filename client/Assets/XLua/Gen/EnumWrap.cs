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
    
    public class TutorialTestEnumWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(Tutorial.TestEnum), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(Tutorial.TestEnum), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(Tutorial.TestEnum), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E1", Tutorial.TestEnum.E1);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E2", Tutorial.TestEnum.E2);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(Tutorial.TestEnum), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushTutorialTestEnum(L, (Tutorial.TestEnum)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "E1"))
                {
                    translator.PushTutorialTestEnum(L, Tutorial.TestEnum.E1);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E2"))
                {
                    translator.PushTutorialTestEnum(L, Tutorial.TestEnum.E2);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for Tutorial.TestEnum!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for Tutorial.TestEnum! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class TutorialDerivedClassTestEnumInnerWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(Tutorial.DerivedClass.TestEnumInner), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(Tutorial.DerivedClass.TestEnumInner), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(Tutorial.DerivedClass.TestEnumInner), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E3", Tutorial.DerivedClass.TestEnumInner.E3);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "E4", Tutorial.DerivedClass.TestEnumInner.E4);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(Tutorial.DerivedClass.TestEnumInner), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushTutorialDerivedClassTestEnumInner(L, (Tutorial.DerivedClass.TestEnumInner)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "E3"))
                {
                    translator.PushTutorialDerivedClassTestEnumInner(L, Tutorial.DerivedClass.TestEnumInner.E3);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "E4"))
                {
                    translator.PushTutorialDerivedClassTestEnumInner(L, Tutorial.DerivedClass.TestEnumInner.E4);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for Tutorial.DerivedClass.TestEnumInner!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for Tutorial.DerivedClass.TestEnumInner! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineTouchPhaseWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.TouchPhase), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.TouchPhase), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.TouchPhase), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Began", UnityEngine.TouchPhase.Began);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Moved", UnityEngine.TouchPhase.Moved);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Stationary", UnityEngine.TouchPhase.Stationary);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Ended", UnityEngine.TouchPhase.Ended);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Canceled", UnityEngine.TouchPhase.Canceled);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.TouchPhase), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineTouchPhase(L, (UnityEngine.TouchPhase)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Began"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Began);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Moved"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Moved);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Stationary"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Stationary);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Ended"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Ended);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Canceled"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Canceled);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.TouchPhase!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.TouchPhase! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineRenderModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.RenderMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.RenderMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.RenderMode), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ScreenSpaceOverlay", UnityEngine.RenderMode.ScreenSpaceOverlay);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ScreenSpaceCamera", UnityEngine.RenderMode.ScreenSpaceCamera);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldSpace", UnityEngine.RenderMode.WorldSpace);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.RenderMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineRenderMode(L, (UnityEngine.RenderMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "ScreenSpaceOverlay"))
                {
                    translator.PushUnityEngineRenderMode(L, UnityEngine.RenderMode.ScreenSpaceOverlay);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ScreenSpaceCamera"))
                {
                    translator.PushUnityEngineRenderMode(L, UnityEngine.RenderMode.ScreenSpaceCamera);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "WorldSpace"))
                {
                    translator.PushUnityEngineRenderMode(L, UnityEngine.RenderMode.WorldSpace);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.RenderMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.RenderMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUICanvasScalerScaleModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.CanvasScaler.ScaleMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.CanvasScaler.ScaleMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.CanvasScaler.ScaleMode), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ConstantPixelSize", UnityEngine.UI.CanvasScaler.ScaleMode.ConstantPixelSize);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ScaleWithScreenSize", UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ConstantPhysicalSize", UnityEngine.UI.CanvasScaler.ScaleMode.ConstantPhysicalSize);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.CanvasScaler.ScaleMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUICanvasScalerScaleMode(L, (UnityEngine.UI.CanvasScaler.ScaleMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "ConstantPixelSize"))
                {
                    translator.PushUnityEngineUICanvasScalerScaleMode(L, UnityEngine.UI.CanvasScaler.ScaleMode.ConstantPixelSize);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ScaleWithScreenSize"))
                {
                    translator.PushUnityEngineUICanvasScalerScaleMode(L, UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ConstantPhysicalSize"))
                {
                    translator.PushUnityEngineUICanvasScalerScaleMode(L, UnityEngine.UI.CanvasScaler.ScaleMode.ConstantPhysicalSize);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.CanvasScaler.ScaleMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.CanvasScaler.ScaleMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUICanvasScalerScreenMatchModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.CanvasScaler.ScreenMatchMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.CanvasScaler.ScreenMatchMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.CanvasScaler.ScreenMatchMode), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MatchWidthOrHeight", UnityEngine.UI.CanvasScaler.ScreenMatchMode.MatchWidthOrHeight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Expand", UnityEngine.UI.CanvasScaler.ScreenMatchMode.Expand);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Shrink", UnityEngine.UI.CanvasScaler.ScreenMatchMode.Shrink);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.CanvasScaler.ScreenMatchMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUICanvasScalerScreenMatchMode(L, (UnityEngine.UI.CanvasScaler.ScreenMatchMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "MatchWidthOrHeight"))
                {
                    translator.PushUnityEngineUICanvasScalerScreenMatchMode(L, UnityEngine.UI.CanvasScaler.ScreenMatchMode.MatchWidthOrHeight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Expand"))
                {
                    translator.PushUnityEngineUICanvasScalerScreenMatchMode(L, UnityEngine.UI.CanvasScaler.ScreenMatchMode.Expand);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Shrink"))
                {
                    translator.PushUnityEngineUICanvasScalerScreenMatchMode(L, UnityEngine.UI.CanvasScaler.ScreenMatchMode.Shrink);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.CanvasScaler.ScreenMatchMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.CanvasScaler.ScreenMatchMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningAutoPlayWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.AutoPlay), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.AutoPlay), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.AutoPlay), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.AutoPlay.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoPlaySequences", DG.Tweening.AutoPlay.AutoPlaySequences);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoPlayTweeners", DG.Tweening.AutoPlay.AutoPlayTweeners);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "All", DG.Tweening.AutoPlay.All);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.AutoPlay), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningAutoPlay(L, (DG.Tweening.AutoPlay)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoPlaySequences"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.AutoPlaySequences);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoPlayTweeners"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.AutoPlayTweeners);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "All"))
                {
                    translator.PushDGTweeningAutoPlay(L, DG.Tweening.AutoPlay.All);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.AutoPlay!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.AutoPlay! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningAxisConstraintWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.AxisConstraint), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.AxisConstraint), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.AxisConstraint), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.AxisConstraint.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "X", DG.Tweening.AxisConstraint.X);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Y", DG.Tweening.AxisConstraint.Y);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Z", DG.Tweening.AxisConstraint.Z);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "W", DG.Tweening.AxisConstraint.W);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.AxisConstraint), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningAxisConstraint(L, (DG.Tweening.AxisConstraint)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "X"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.X);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Y"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.Y);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Z"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.Z);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "W"))
                {
                    translator.PushDGTweeningAxisConstraint(L, DG.Tweening.AxisConstraint.W);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.AxisConstraint!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.AxisConstraint! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningEaseWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Ease), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Ease), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Ease), L, null, 39, 0, 0);

            Utils.RegisterEnumType(L, typeof(DG.Tweening.Ease));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Ease), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningEase(L, (DG.Tweening.Ease)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(DG.Tweening.Ease), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(DG.Tweening.Ease) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Ease! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningLinkBehaviourWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.LinkBehaviour), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.LinkBehaviour), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.LinkBehaviour), L, null, 12, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PauseOnDisable", DG.Tweening.LinkBehaviour.PauseOnDisable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PauseOnDisablePlayOnEnable", DG.Tweening.LinkBehaviour.PauseOnDisablePlayOnEnable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PauseOnDisableRestartOnEnable", DG.Tweening.LinkBehaviour.PauseOnDisableRestartOnEnable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PlayOnEnable", DG.Tweening.LinkBehaviour.PlayOnEnable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RestartOnEnable", DG.Tweening.LinkBehaviour.RestartOnEnable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "KillOnDisable", DG.Tweening.LinkBehaviour.KillOnDisable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "KillOnDestroy", DG.Tweening.LinkBehaviour.KillOnDestroy);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CompleteOnDisable", DG.Tweening.LinkBehaviour.CompleteOnDisable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CompleteAndKillOnDisable", DG.Tweening.LinkBehaviour.CompleteAndKillOnDisable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RewindOnDisable", DG.Tweening.LinkBehaviour.RewindOnDisable);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RewindAndKillOnDisable", DG.Tweening.LinkBehaviour.RewindAndKillOnDisable);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.LinkBehaviour), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningLinkBehaviour(L, (DG.Tweening.LinkBehaviour)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "PauseOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.PauseOnDisable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PauseOnDisablePlayOnEnable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.PauseOnDisablePlayOnEnable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PauseOnDisableRestartOnEnable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.PauseOnDisableRestartOnEnable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PlayOnEnable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.PlayOnEnable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RestartOnEnable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.RestartOnEnable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "KillOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.KillOnDisable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "KillOnDestroy"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.KillOnDestroy);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CompleteOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.CompleteOnDisable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CompleteAndKillOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.CompleteAndKillOnDisable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RewindOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.RewindOnDisable);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RewindAndKillOnDisable"))
                {
                    translator.PushDGTweeningLinkBehaviour(L, DG.Tweening.LinkBehaviour.RewindAndKillOnDisable);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.LinkBehaviour!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.LinkBehaviour! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningPathModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.PathMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.PathMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.PathMode), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Ignore", DG.Tweening.PathMode.Ignore);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Full3D", DG.Tweening.PathMode.Full3D);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopDown2D", DG.Tweening.PathMode.TopDown2D);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Sidescroller2D", DG.Tweening.PathMode.Sidescroller2D);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.PathMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningPathMode(L, (DG.Tweening.PathMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Ignore"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Ignore);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Full3D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Full3D);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopDown2D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.TopDown2D);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Sidescroller2D"))
                {
                    translator.PushDGTweeningPathMode(L, DG.Tweening.PathMode.Sidescroller2D);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.PathMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.PathMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningPathTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.PathType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.PathType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.PathType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Linear", DG.Tweening.PathType.Linear);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CatmullRom", DG.Tweening.PathType.CatmullRom);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CubicBezier", DG.Tweening.PathType.CubicBezier);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.PathType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningPathType(L, (DG.Tweening.PathType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Linear"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.Linear);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CatmullRom"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.CatmullRom);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CubicBezier"))
                {
                    translator.PushDGTweeningPathType(L, DG.Tweening.PathType.CubicBezier);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.PathType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.PathType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningRotateModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.RotateMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.RotateMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.RotateMode), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fast", DG.Tweening.RotateMode.Fast);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FastBeyond360", DG.Tweening.RotateMode.FastBeyond360);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldAxisAdd", DG.Tweening.RotateMode.WorldAxisAdd);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LocalAxisAdd", DG.Tweening.RotateMode.LocalAxisAdd);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.RotateMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningRotateMode(L, (DG.Tweening.RotateMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Fast"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.Fast);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "FastBeyond360"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.FastBeyond360);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "WorldAxisAdd"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.WorldAxisAdd);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LocalAxisAdd"))
                {
                    translator.PushDGTweeningRotateMode(L, DG.Tweening.RotateMode.LocalAxisAdd);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.RotateMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.RotateMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningScrambleModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.ScrambleMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.ScrambleMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.ScrambleMode), L, null, 7, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.ScrambleMode.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "All", DG.Tweening.ScrambleMode.All);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Uppercase", DG.Tweening.ScrambleMode.Uppercase);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Lowercase", DG.Tweening.ScrambleMode.Lowercase);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Numerals", DG.Tweening.ScrambleMode.Numerals);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Custom", DG.Tweening.ScrambleMode.Custom);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.ScrambleMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningScrambleMode(L, (DG.Tweening.ScrambleMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "All"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.All);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Uppercase"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Uppercase);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Lowercase"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Lowercase);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Numerals"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Numerals);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Custom"))
                {
                    translator.PushDGTweeningScrambleMode(L, DG.Tweening.ScrambleMode.Custom);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.ScrambleMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.ScrambleMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningLoopTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.LoopType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.LoopType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.LoopType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Restart", DG.Tweening.LoopType.Restart);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Yoyo", DG.Tweening.LoopType.Yoyo);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Incremental", DG.Tweening.LoopType.Incremental);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.LoopType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningLoopType(L, (DG.Tweening.LoopType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Restart"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Restart);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Yoyo"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Yoyo);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Incremental"))
                {
                    translator.PushDGTweeningLoopType(L, DG.Tweening.LoopType.Incremental);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.LoopType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.LoopType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningLogBehaviourWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.LogBehaviour), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.LogBehaviour), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.LogBehaviour), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Default", DG.Tweening.LogBehaviour.Default);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Verbose", DG.Tweening.LogBehaviour.Verbose);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ErrorsOnly", DG.Tweening.LogBehaviour.ErrorsOnly);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.LogBehaviour), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningLogBehaviour(L, (DG.Tweening.LogBehaviour)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Default"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.Default);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Verbose"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.Verbose);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ErrorsOnly"))
                {
                    translator.PushDGTweeningLogBehaviour(L, DG.Tweening.LogBehaviour.ErrorsOnly);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.LogBehaviour!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.LogBehaviour! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningTweenTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.TweenType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.TweenType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.TweenType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Tweener", DG.Tweening.TweenType.Tweener);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Sequence", DG.Tweening.TweenType.Sequence);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Callback", DG.Tweening.TweenType.Callback);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.TweenType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningTweenType(L, (DG.Tweening.TweenType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Tweener"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Tweener);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Sequence"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Sequence);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Callback"))
                {
                    translator.PushDGTweeningTweenType(L, DG.Tweening.TweenType.Callback);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.TweenType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.TweenType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningUpdateTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.UpdateType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.UpdateType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.UpdateType), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Normal", DG.Tweening.UpdateType.Normal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Late", DG.Tweening.UpdateType.Late);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fixed", DG.Tweening.UpdateType.Fixed);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Manual", DG.Tweening.UpdateType.Manual);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.UpdateType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningUpdateType(L, (DG.Tweening.UpdateType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Normal"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Normal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Late"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Late);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Fixed"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Fixed);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Manual"))
                {
                    translator.PushDGTweeningUpdateType(L, DG.Tweening.UpdateType.Manual);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.UpdateType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.UpdateType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningPluginsOptionsOrientTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Plugins.Options.OrientType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Plugins.Options.OrientType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Plugins.Options.OrientType), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.Plugins.Options.OrientType.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ToPath", DG.Tweening.Plugins.Options.OrientType.ToPath);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LookAtTransform", DG.Tweening.Plugins.Options.OrientType.LookAtTransform);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LookAtPosition", DG.Tweening.Plugins.Options.OrientType.LookAtPosition);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Plugins.Options.OrientType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningPluginsOptionsOrientType(L, (DG.Tweening.Plugins.Options.OrientType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningPluginsOptionsOrientType(L, DG.Tweening.Plugins.Options.OrientType.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ToPath"))
                {
                    translator.PushDGTweeningPluginsOptionsOrientType(L, DG.Tweening.Plugins.Options.OrientType.ToPath);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LookAtTransform"))
                {
                    translator.PushDGTweeningPluginsOptionsOrientType(L, DG.Tweening.Plugins.Options.OrientType.LookAtTransform);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "LookAtPosition"))
                {
                    translator.PushDGTweeningPluginsOptionsOrientType(L, DG.Tweening.Plugins.Options.OrientType.LookAtPosition);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Plugins.Options.OrientType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Plugins.Options.OrientType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreEnumsNestedTweenFailureBehaviourWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.Enums.NestedTweenFailureBehaviour), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.Enums.NestedTweenFailureBehaviour), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.Enums.NestedTweenFailureBehaviour), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TryToPreserveSequence", DG.Tweening.Core.Enums.NestedTweenFailureBehaviour.TryToPreserveSequence);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "KillWholeSequence", DG.Tweening.Core.Enums.NestedTweenFailureBehaviour.KillWholeSequence);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.Enums.NestedTweenFailureBehaviour), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreEnumsNestedTweenFailureBehaviour(L, (DG.Tweening.Core.Enums.NestedTweenFailureBehaviour)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "TryToPreserveSequence"))
                {
                    translator.PushDGTweeningCoreEnumsNestedTweenFailureBehaviour(L, DG.Tweening.Core.Enums.NestedTweenFailureBehaviour.TryToPreserveSequence);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "KillWholeSequence"))
                {
                    translator.PushDGTweeningCoreEnumsNestedTweenFailureBehaviour(L, DG.Tweening.Core.Enums.NestedTweenFailureBehaviour.KillWholeSequence);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.Enums.NestedTweenFailureBehaviour!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.Enums.NestedTweenFailureBehaviour! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreEnumsSafeModeLogBehaviourWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.Enums.SafeModeLogBehaviour), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.Enums.SafeModeLogBehaviour), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.Enums.SafeModeLogBehaviour), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.Core.Enums.SafeModeLogBehaviour.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Normal", DG.Tweening.Core.Enums.SafeModeLogBehaviour.Normal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Warning", DG.Tweening.Core.Enums.SafeModeLogBehaviour.Warning);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Error", DG.Tweening.Core.Enums.SafeModeLogBehaviour.Error);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.Enums.SafeModeLogBehaviour), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, (DG.Tweening.Core.Enums.SafeModeLogBehaviour)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, DG.Tweening.Core.Enums.SafeModeLogBehaviour.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Normal"))
                {
                    translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, DG.Tweening.Core.Enums.SafeModeLogBehaviour.Normal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Warning"))
                {
                    translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, DG.Tweening.Core.Enums.SafeModeLogBehaviour.Warning);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Error"))
                {
                    translator.PushDGTweeningCoreEnumsSafeModeLogBehaviour(L, DG.Tweening.Core.Enums.SafeModeLogBehaviour.Error);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.Enums.SafeModeLogBehaviour!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.Enums.SafeModeLogBehaviour! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreEnumsSpecialStartupModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.Enums.SpecialStartupMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.Enums.SpecialStartupMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.Enums.SpecialStartupMode), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.Core.Enums.SpecialStartupMode.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SetLookAt", DG.Tweening.Core.Enums.SpecialStartupMode.SetLookAt);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SetShake", DG.Tweening.Core.Enums.SpecialStartupMode.SetShake);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SetPunch", DG.Tweening.Core.Enums.SpecialStartupMode.SetPunch);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SetCameraShakePosition", DG.Tweening.Core.Enums.SpecialStartupMode.SetCameraShakePosition);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.Enums.SpecialStartupMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, (DG.Tweening.Core.Enums.SpecialStartupMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, DG.Tweening.Core.Enums.SpecialStartupMode.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SetLookAt"))
                {
                    translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, DG.Tweening.Core.Enums.SpecialStartupMode.SetLookAt);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SetShake"))
                {
                    translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, DG.Tweening.Core.Enums.SpecialStartupMode.SetShake);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SetPunch"))
                {
                    translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, DG.Tweening.Core.Enums.SpecialStartupMode.SetPunch);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SetCameraShakePosition"))
                {
                    translator.PushDGTweeningCoreEnumsSpecialStartupMode(L, DG.Tweening.Core.Enums.SpecialStartupMode.SetCameraShakePosition);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.Enums.SpecialStartupMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.Enums.SpecialStartupMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreEnumsUpdateNoticeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.Enums.UpdateNotice), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.Enums.UpdateNotice), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.Enums.UpdateNotice), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", DG.Tweening.Core.Enums.UpdateNotice.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RewindStep", DG.Tweening.Core.Enums.UpdateNotice.RewindStep);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.Enums.UpdateNotice), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreEnumsUpdateNotice(L, (DG.Tweening.Core.Enums.UpdateNotice)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushDGTweeningCoreEnumsUpdateNotice(L, DG.Tweening.Core.Enums.UpdateNotice.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RewindStep"))
                {
                    translator.PushDGTweeningCoreEnumsUpdateNotice(L, DG.Tweening.Core.Enums.UpdateNotice.RewindStep);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.Enums.UpdateNotice!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.Enums.UpdateNotice! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreEnumsRewindCallbackModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.Enums.RewindCallbackMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.Enums.RewindCallbackMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.Enums.RewindCallbackMode), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FireIfPositionChanged", DG.Tweening.Core.Enums.RewindCallbackMode.FireIfPositionChanged);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FireAlwaysWithRewind", DG.Tweening.Core.Enums.RewindCallbackMode.FireAlwaysWithRewind);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FireAlways", DG.Tweening.Core.Enums.RewindCallbackMode.FireAlways);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.Enums.RewindCallbackMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreEnumsRewindCallbackMode(L, (DG.Tweening.Core.Enums.RewindCallbackMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "FireIfPositionChanged"))
                {
                    translator.PushDGTweeningCoreEnumsRewindCallbackMode(L, DG.Tweening.Core.Enums.RewindCallbackMode.FireIfPositionChanged);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "FireAlwaysWithRewind"))
                {
                    translator.PushDGTweeningCoreEnumsRewindCallbackMode(L, DG.Tweening.Core.Enums.RewindCallbackMode.FireAlwaysWithRewind);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "FireAlways"))
                {
                    translator.PushDGTweeningCoreEnumsRewindCallbackMode(L, DG.Tweening.Core.Enums.RewindCallbackMode.FireAlways);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.Enums.RewindCallbackMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.Enums.RewindCallbackMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningCoreDOTweenSettingsSettingsLocationWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.Core.DOTweenSettings.SettingsLocation), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.Core.DOTweenSettings.SettingsLocation), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.Core.DOTweenSettings.SettingsLocation), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AssetsDirectory", DG.Tweening.Core.DOTweenSettings.SettingsLocation.AssetsDirectory);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DOTweenDirectory", DG.Tweening.Core.DOTweenSettings.SettingsLocation.DOTweenDirectory);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DemigiantDirectory", DG.Tweening.Core.DOTweenSettings.SettingsLocation.DemigiantDirectory);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.Core.DOTweenSettings.SettingsLocation), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningCoreDOTweenSettingsSettingsLocation(L, (DG.Tweening.Core.DOTweenSettings.SettingsLocation)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "AssetsDirectory"))
                {
                    translator.PushDGTweeningCoreDOTweenSettingsSettingsLocation(L, DG.Tweening.Core.DOTweenSettings.SettingsLocation.AssetsDirectory);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "DOTweenDirectory"))
                {
                    translator.PushDGTweeningCoreDOTweenSettingsSettingsLocation(L, DG.Tweening.Core.DOTweenSettings.SettingsLocation.DOTweenDirectory);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "DemigiantDirectory"))
                {
                    translator.PushDGTweeningCoreDOTweenSettingsSettingsLocation(L, DG.Tweening.Core.DOTweenSettings.SettingsLocation.DemigiantDirectory);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.Core.DOTweenSettings.SettingsLocation!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.Core.DOTweenSettings.SettingsLocation! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
}