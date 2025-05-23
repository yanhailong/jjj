using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using Excel;
using Newtonsoft.Json;
using UnityEngine;

public class ExcelUtility
{

    /// <summary>
    /// 表格数据集合
    /// </summary>
    private DataSet mResultSet;
    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="excelFile">Excel file.</param>
    public ExcelUtility(string excelFile)
    {
        FileStream mStream = File.Open(excelFile, FileMode.Open, FileAccess.Read);
        IExcelDataReader mExcelReader = ExcelReaderFactory.CreateOpenXmlReader(mStream);
        mResultSet = mExcelReader.AsDataSet();
    }
    
    /// <summary>
    /// 转换为Json
    /// </summary>
    /// <param name="Header">表头行数</param>
    public void ConvertToJson()
    {
        //判断Excel文件中是否存在数据表
        if (mResultSet.Tables.Count < 1)
            return;
        for (int i = 0; i < mResultSet.Tables.Count; i++)
        {
            DataTable sheet = mResultSet.Tables[i];
            //检查表中是否有数据
            if (sheet.Rows.Count < 1)
                return;
            
            //读取数据表行数和列数
            int rowCount = sheet.Rows.Count;
            int colCount = sheet.Columns.Count;

            //准备一个列表存储整个表的数据
            Dictionary<string, string> table = new Dictionary<string, string>();
            for (int j = 1; j < rowCount; j++){
                //读取第1行数据作为表头字段
                string field = sheet.Rows[j][0].ToString();
                table[field]=sheet.Rows[j][1].ToString();
            }

            string outPath = Application.dataPath + ExcelDir.lanJsonPath;
            if (!Directory.Exists(outPath))
            {
                Directory.CreateDirectory(outPath);
            }
            string fileOutPath= outPath + sheet.TableName.ToLower()+".json";
            if (File.Exists(fileOutPath))
                File.Delete(fileOutPath);
            string json = JsonConvert.SerializeObject(table, Newtonsoft.Json.Formatting.Indented);
            //写入文件
            //判断编码类型
            Encoding encoding=Encoding.GetEncoding("utf-8");
            StreamWriter writer = new StreamWriter(fileOutPath, false, encoding);
            writer.Write(json);
            writer.Close();

        }
    }
}

