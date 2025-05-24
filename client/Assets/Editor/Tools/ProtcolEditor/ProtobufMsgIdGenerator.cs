using System.Collections.Generic;

public class ValueItem
{
    /// <summary>
    /// 数值，表示枚举项的整型值。
    /// </summary>
    public int number { get; set; }

    /// <summary>
    /// 名称，表示枚举项的字符串标识。
    /// </summary>
    public string name { get; set; }
}

public class Enum_typeItem
{
    /// <summary>
    /// 枚举值列表，包含一系列枚举项。
    /// </summary>
    public List<ValueItem> value { get; set; }

    /// <summary>
    /// 枚举名称，用于标识枚举类型。
    /// </summary>
    public string name { get; set; }
}

public class FieldItem
{
    /// <summary>
    /// 类型名称，表示字段的数据类型。
    /// </summary>
    public string type_name { get; set; }

    /// <summary>
    /// 标签，表示字段的标签类型（如 required, optional, repeated）。
    /// </summary>
    public int label { get; set; }

    /// <summary>
    /// 数据类型，表示字段的具体数据类型（如 int32, string等）。
    /// </summary>
    public int type { get; set; }

    /// <summary>
    /// 字段编号，用于序列化和反序列化时标识字段。
    /// </summary>
    public int number { get; set; }

    /// <summary>
    /// 字段名称，用于标识字段。
    /// </summary>
    public string name { get; set; }
}

public class Message_typeItem
{
    /// <summary>
    /// 枚举类型列表，包含消息类型中的所有枚举类型。
    /// </summary>
    public List<Enum_typeItem> enum_type { get; set; }

    /// <summary>
    /// 字段列表，包含消息类型中的所有字段。
    /// </summary>
    public List<FieldItem> field { get; set; }

    /// <summary>
    /// 消息类型名称，用于标识消息类型。
    /// </summary>
    public string name { get; set; }
}

public class Options
{
    /// <summary>
    /// Java包名，用于指定生成的Java代码的包名。
    /// </summary>
    public string java_package { get; set; }

    /// <summary>
    /// Java外部类名，用于指定生成的Java代码的外部类名。
    /// </summary>
    public string java_outer_classname { get; set; }
}

public class Root
{
    /// <summary>
    /// 公共依赖列表，表示此文件依赖的公共文件的索引。
    /// </summary>
    public List<int> public_dependency { get; set; }

    /// <summary>
    /// 消息类型列表，包含文件中定义的所有消息类型。
    /// </summary>
    public List<Message_typeItem> message_type { get; set; }

    /// <summary>
    /// 选项，用于配置编译器行为。
    /// </summary>
    public Options options { get; set; }

    /// <summary>
    /// 语法版本，表示使用的协议缓冲区版本。
    /// </summary>
    public string syntax { get; set; }

    /// <summary>
    /// 依赖列表，表示此文件依赖的其他文件的路径。
    /// </summary>
    public List<string> dependency { get; set; }

    /// <summary>
    /// 文件名，表示协议缓冲区文件的名称。
    /// </summary>
    public string name { get; set; }
}
