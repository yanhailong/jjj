using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class XFImageFontMaker
{
    //MenuItem可以让我们在asset下的物体右键执行指定方法
    [MenuItem("Assets/CreateImageFontByOne")]
    static void XFCreateImageFont()
    {
        if (Selection.objects == null) return;
        for(int i=0;i<Selection.objects.Length;i++)
        {
            //如果右键对象是图片才执行
            if(Selection.objects[i].GetType()==typeof(Texture2D))
            {
                CreateImageFont(Selection.objects[i] as Texture2D);
            }
        }
    }

    public static void CreateImageFont(Texture2D texture)
    {
        if (texture == null) return;
        //获取贴图路径
        string texturePath = AssetDatabase.GetAssetPath(texture);
        //获取路径后缀
        string textureExtension = Path.GetExtension(texturePath);
        //得到存图片的那个文件路径
        string filePath = texturePath.Remove(texturePath.Length - textureExtension.Length);
        //要创建材质和字体的路径后缀（自定）
        string matPath = filePath + ".mat";
        string fontPath = filePath + ".fontsettings";
        //如果字体已经创建加载路径即可
        Font font = AssetDatabase.LoadAssetAtPath<Font>(fontPath);
        if(font==null)
        {
            font = new Font();
            //创建材质修改shader
            Material mat = new Material(Shader.Find("GUI/Text Shader"));
            //_MainTex为设置游戏对象的主纹理
            mat.SetTexture("_MainTex", texture);
            //在文件夹里创建材质
            AssetDatabase.CreateAsset(mat, matPath);
            font.material = mat;
            //在文件夹里创建字体
            AssetDatabase.CreateAsset(font, fontPath);
        }
       
        //设置字符
        Sprite[] sprites = LoadSpriteByPath(texturePath);
        if(sprites.Length==0)
        {
            Debug.LogError("没有发现创建的字符，请分割一下字符");
            return;
        }
        CharacterInfo[] characterInfos = new CharacterInfo[sprites.Length];

        for(int i=0;i<characterInfos.Length;i++)
        {
            characterInfos[i] = new CharacterInfo();
            //获取字符名字最后一个字符
            characterInfos[i].index = sprites[i].name[sprites[i].name.Length - 1];

            //设置字符uv
            Rect rect = sprites[i].rect;
            characterInfos[i].uvBottomLeft = new Vector2(rect.x / texture.width, rect.y / texture.height);
            characterInfos[i].uvBottomRight = new Vector2((rect.x+ rect.width) / texture.width, rect.y / texture.height);
            characterInfos[i].uvTopLeft = new Vector2(rect.x / texture.width, (rect.y + rect.height )/ texture.height);
            characterInfos[i].uvTopRight = new Vector2((rect.x + rect.width) / texture.width, (rect.y + rect.height) / texture.height);
            //设置字符偏移和宽高
            characterInfos[i].minX = 0;
            characterInfos[i].maxX = (int)rect.width;
            //sprites[i].pivot为每个字符的中心点坐标
            //方便对特定字符修改中心点来定位
            characterInfos[i].minY = 0 - (int)sprites[i].pivot.y ;
            characterInfos[i].maxY = (int)rect.height - (int)sprites[i].pivot.y ;
            characterInfos[i].advance = (int)rect.width;
        }
        font.characterInfo = characterInfos;

        EditorUtility.SetDirty(font);
        //保存资源
        AssetDatabase.SaveAssets();
        //更新asset修改的资源
        AssetDatabase.Refresh();
    }

    public static Sprite[] LoadSpriteByPath(string path)
    {
        List<Sprite> sprites = new List<Sprite>();
        //加载该路径下的所有资源
        Object[] objects = AssetDatabase.LoadAllAssetsAtPath(path);
        for(int i=0;i<objects.Length;i++)
        {
            if(objects[i].GetType()==typeof(Sprite))
            {
                sprites.Add(objects[i] as Sprite);
            }
        }
        return sprites.ToArray();

    }
}