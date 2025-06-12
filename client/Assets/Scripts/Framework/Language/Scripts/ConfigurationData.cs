using System.Collections.Generic;

namespace Language
{
    public class LangCfgData
    {
        public ConfigurationData ConfigurationData;
    }
    public class Pathcfg
    {
        /// <summary>
        /// 
        /// </summary>
        public string json { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string texture { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string spine { get; set; }
    }

    public class ConfigurationData
    {
        /// <summary>
        /// 
        /// </summary>
        public string defaultLanguage { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public List <string > languages { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public Pathcfg pathcfg { get; set; }
    }
    
}