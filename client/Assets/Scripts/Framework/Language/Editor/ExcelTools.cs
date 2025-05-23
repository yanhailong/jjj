using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

public class ExcelTools : EditorWindow
{
	/// <summary>
	/// 当前编辑器窗口实例
	/// </summary>
	private static ExcelTools instance;

	/// <summary>
	/// Excel文件列表
	/// </summary>
	private static List<string> excelList;

	/// <summary>
	/// 项目根路径	
	/// </summary>
	private static string pathRoot;

	/// <summary>
	/// 滚动窗口初始位置
	/// </summary>
	private static Vector2 scrollPos;
	/// <summary>
	/// 显示当前窗口	
	/// </summary>
	[MenuItem("Tools/ExcelTools")]
	static void ShowExcelTools()
	{
		Init();
		//加载Excel文件
		LoadExcel();
		instance.Show();
	}

	void OnGUI()
	{
		DrawOptions();
		DrawExport();
	}

	/// <summary>
	/// 绘制插件界面配置项
	/// </summary>
	private void DrawOptions()
	{
		GUILayout.BeginHorizontal();
		EditorGUILayout.LabelField("请选择格式类型:",GUILayout.Width(85));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		EditorGUILayout.LabelField("请选择编码类型:",GUILayout.Width(85));
		GUILayout.EndHorizontal();


	}
   
    /// <summary>
    /// 绘制插件界面输出项
    /// </summary>
    private void DrawExport()
	{

		if(excelList==null) return;
		if(excelList.Count<1)
		{
			EditorGUILayout.LabelField("目前没有Excel文件被选中哦!");

		}
		else
		{
			GUILayout.BeginVertical();
			scrollPos=GUILayout.BeginScrollView(scrollPos,false,true,GUILayout.Height(150));
			foreach(string s in excelList)
			{
				GUILayout.BeginHorizontal();
				GUILayout.Toggle(true,s);
				GUILayout.EndHorizontal();
			}
			GUILayout.EndScrollView();
			GUILayout.EndVertical();

			//输出
			if(GUILayout.Button("转换"))
			{
				Convert();
			}
		}
	}

	/// <summary>
	/// 转换Excel文件
	/// </summary>
	private static void Convert()
	{
		foreach(string assetsPath in excelList)
		{
			//获取Excel文件的绝对路径
			string excelPath=pathRoot + "/" + assetsPath;
			//构造Excel工具类
			ExcelUtility excel=new ExcelUtility(excelPath);
			excel.ConvertToJson();
			//刷新本地资源
			AssetDatabase.Refresh();
		}

		//转换完后关闭插件
		//这样做是为了解决窗口
		//再次点击时路径错误的Bug
		instance.Close();

	}

	/// <summary>
	/// 加载Excel
	/// </summary>
	private static void LoadExcel()
	{
		if(excelList==null) excelList=new List<string>();
		excelList.Clear();
		//获取选中的对象

		string[] files = GetFiles(ExcelDir.excelPath,".xlsx");
		if (files.Length==0)
			return;
		foreach(string file in files)
		{
			excelList.Add(file);
		}
	}
	
	public static string[] GetFiles(string targetPath,string suffixal="")
	{
		string[] files = Directory.GetFiles(targetPath, "*", SearchOption.AllDirectories);
		List<string> list = new List<string>();
		foreach (var file in files)
		{
			if (file.EndsWith(".DS_Store")||file.EndsWith(".meta"))continue;
			if (file.EndsWith(suffixal))
				list.Add(file);
		}
		return list.ToArray();
	}
	
	

	private static void Init()
	{
	    
		//获取当前实例
		instance=EditorWindow.GetWindow<ExcelTools>();
		//初始化
		pathRoot=Application.dataPath;
		//注意这里需要对路径进行处理
		//目的是去除Assets这部分字符以获取项目目录
		//我表示Windows的/符号一直没有搞懂
		pathRoot=pathRoot.Substring(0,pathRoot.LastIndexOf("/"));
		excelList=new List<string>();
		scrollPos=new Vector2(instance.position.x,instance.position.y+75);
	}

	void OnSelectionChange() 
	{
		//当选择发生变化时重绘窗体
		Show();
		LoadExcel();
		Repaint();
	}
}
