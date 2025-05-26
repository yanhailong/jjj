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
    public class AssetsManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(AssetsManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 24, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Initialized", _m_Initialized);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAllAssets", _m_LoadAllAssets);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateGameObject", _m_CreateGameObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadTextAssetStr", _m_LoadTextAssetStr);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadGameObject", _m_LoadGameObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadSprite", _m_LoadSprite);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadTexture2D", _m_LoadTexture2D);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadFont", _m_LoadFont);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAudioClip", _m_LoadAudioClip);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAnimationClip", _m_LoadAnimationClip);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAnimatorController", _m_LoadAnimatorController);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadMaterial", _m_LoadMaterial);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadSkeletonDataAsset", _m_LoadSkeletonDataAsset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAllAssetAsync", _m_LoadAllAssetAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateGameObjectAsync", _m_CreateGameObjectAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadGameObjectAsync", _m_LoadGameObjectAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadSpriteAsync", _m_LoadSpriteAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadTexture2DAsync", _m_LoadTexture2DAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadFontAsync", _m_LoadFontAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAudioClipAsync", _m_LoadAudioClipAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAnimationClipAsync", _m_LoadAnimationClipAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAnimatorControllerAsync", _m_LoadAnimatorControllerAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadMaterialAsync", _m_LoadMaterialAsync);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadSkeletonDataAssetAsync", _m_LoadSkeletonDataAssetAsync);
			
			
			
			
			
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
					
					var gen_ret = new AssetsManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Initialized(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Initialized(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAllAssets(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Type _t = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    
                        var gen_ret = gen_to_be_invoked.LoadAllAssets( _abName, _t );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateGameObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Transform>(L, 4)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    UnityEngine.Transform _parent = (UnityEngine.Transform)translator.GetObject(L, 4, typeof(UnityEngine.Transform));
                    
                        var gen_ret = gen_to_be_invoked.CreateGameObject( _abName, _assetName, _parent );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.CreateGameObject( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.CreateGameObject!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadTextAssetStr(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadTextAssetStr( _abName, _assetName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadTextAssetStr( _abName );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadTextAssetStr!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadGameObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadGameObject( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadGameObject( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadGameObject!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadSprite(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadSprite( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadSprite( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadSprite!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadTexture2D(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadTexture2D( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadTexture2D( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadTexture2D!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadFont(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadFont( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadFont( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadFont!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAudioClip(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadAudioClip( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadAudioClip( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAudioClip!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAnimationClip(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadAnimationClip( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadAnimationClip( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAnimationClip!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAnimatorController(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadAnimatorController( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.LoadAnimatorController( _abName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAnimatorController!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadMaterial(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadMaterial( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadSkeletonDataAsset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.LoadSkeletonDataAsset( _abName, _assetName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAllAssetAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Type _t = (System.Type)translator.GetObject(L, 3, typeof(System.Type));
                    System.Action<UnityEngine.Object[]> _action = translator.GetDelegate<System.Action<UnityEngine.Object[]>>(L, 4);
                    
                    gen_to_be_invoked.LoadAllAssetAsync( _abName, _t, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateGameObjectAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.GameObject>>(L, 4)&& translator.Assignable<UnityEngine.Transform>(L, 5)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    System.Action<UnityEngine.GameObject> _action = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 4);
                    UnityEngine.Transform _parent = (UnityEngine.Transform)translator.GetObject(L, 5, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.CreateGameObjectAsync( _abName, _assetName, _action, _parent );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.GameObject>>(L, 4)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    System.Action<UnityEngine.GameObject> _action = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 4);
                    
                    gen_to_be_invoked.CreateGameObjectAsync( _abName, _assetName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.CreateGameObjectAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadGameObjectAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.GameObject>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.GameObject> _action = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadGameObjectAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.GameObject>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.GameObject> _action = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 3);
                    
                    gen_to_be_invoked.LoadGameObjectAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadGameObjectAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadSpriteAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Sprite>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Sprite> _action = translator.GetDelegate<System.Action<UnityEngine.Sprite>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadSpriteAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Sprite>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Sprite> _action = translator.GetDelegate<System.Action<UnityEngine.Sprite>>(L, 3);
                    
                    gen_to_be_invoked.LoadSpriteAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadSpriteAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadTexture2DAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Texture2D>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Texture2D> _action = translator.GetDelegate<System.Action<UnityEngine.Texture2D>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadTexture2DAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Texture2D>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Texture2D> _action = translator.GetDelegate<System.Action<UnityEngine.Texture2D>>(L, 3);
                    
                    gen_to_be_invoked.LoadTexture2DAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadTexture2DAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadFontAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Font>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Font> _action = translator.GetDelegate<System.Action<UnityEngine.Font>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadFontAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.Font>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Font> _action = translator.GetDelegate<System.Action<UnityEngine.Font>>(L, 3);
                    
                    gen_to_be_invoked.LoadFontAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadFontAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAudioClipAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.AudioClip>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.AudioClip> _action = translator.GetDelegate<System.Action<UnityEngine.AudioClip>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadAudioClipAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.AudioClip>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.AudioClip> _action = translator.GetDelegate<System.Action<UnityEngine.AudioClip>>(L, 3);
                    
                    gen_to_be_invoked.LoadAudioClipAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAudioClipAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAnimationClipAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.AnimationClip>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.AnimationClip> _action = translator.GetDelegate<System.Action<UnityEngine.AnimationClip>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadAnimationClipAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.AnimationClip>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.AnimationClip> _action = translator.GetDelegate<System.Action<UnityEngine.AnimationClip>>(L, 3);
                    
                    gen_to_be_invoked.LoadAnimationClipAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAnimationClipAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAnimatorControllerAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.RuntimeAnimatorController>>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.RuntimeAnimatorController> _action = translator.GetDelegate<System.Action<UnityEngine.RuntimeAnimatorController>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadAnimatorControllerAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<UnityEngine.RuntimeAnimatorController>>(L, 3)) 
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.RuntimeAnimatorController> _action = translator.GetDelegate<System.Action<UnityEngine.RuntimeAnimatorController>>(L, 3);
                    
                    gen_to_be_invoked.LoadAnimatorControllerAsync( _abName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to AssetsManager.LoadAnimatorControllerAsync!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadMaterialAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    System.Action<UnityEngine.Material> _action = translator.GetDelegate<System.Action<UnityEngine.Material>>(L, 3);
                    string _assetName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.LoadMaterialAsync( _abName, _action, _assetName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadSkeletonDataAssetAsync(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                AssetsManager gen_to_be_invoked = (AssetsManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _abName = LuaAPI.lua_tostring(L, 2);
                    string _assetName = LuaAPI.lua_tostring(L, 3);
                    System.Action<Spine.Unity.SkeletonDataAsset> _action = translator.GetDelegate<System.Action<Spine.Unity.SkeletonDataAsset>>(L, 4);
                    
                    gen_to_be_invoked.LoadSkeletonDataAssetAsync( _abName, _assetName, _action );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
