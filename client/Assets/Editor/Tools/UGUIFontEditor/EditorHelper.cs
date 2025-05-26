using UnityEngine;
using UnityEditor;

public class EditorHelper : MonoBehaviour {

	[MenuItem("Assets/BatchCreateArtistFont")]
	static public void BatchCreateArtistFont()
	{
		ArtistFont.BatchCreateArtistFont();
	}
}
