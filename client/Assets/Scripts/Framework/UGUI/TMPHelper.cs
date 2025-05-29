using System.Reflection;
using TMPro;

public class TMPHelper
{
    public static void LoadSettings()
    {
        TMP_Settings settings = AssetsManager.Instance.LoadAsset<TMP_Settings>("Common/Fonts","TMPSettings");
        var settingsType = settings.GetType();
        var settingsInstanceInfo = settingsType.GetField("s_Instance", BindingFlags.Static | BindingFlags.NonPublic);
        settingsInstanceInfo.SetValue(null, settings);
    }
}