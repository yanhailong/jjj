
namespace Language
{
    /// <summary>
    /// 语言数据类型
    /// </summary>
    public enum LanguageDataType
    {
        /// <summary>
        /// 文字
        /// </summary>
        Word = 0,
        /// <summary>
        /// 图片
        /// </summary>
        Picture = 1,
        /// <summary>
        /// 预制体
        /// </summary>
        Prefab = 2,
    }

    public class LanguageData
    {
        // public int dataType;
        /// <summary>
        /// 值
        /// </summary>
        public string value;
        // public int fontSize = -1;
        // /// <summary>
        // /// 字体库的下标
        // /// </summary>
        // public int fontIndex = -1;
    }
}

