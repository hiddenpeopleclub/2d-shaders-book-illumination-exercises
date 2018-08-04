using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CreateNormal : Editor {

    [MenuItem("2D Shaders/Create Normals")]
    public static void CreateNormals()
    {
        Texture2D top = null;
        Texture2D bottom = null;
        Texture2D left = null;
        Texture2D right = null;

        foreach( Object obj in Selection.objects)
        {
            if (obj.name.IndexOf("top") > 0) { top = (Texture2D)obj; }
            if (obj.name.IndexOf("bottom") > 0) { bottom = (Texture2D)obj; }
            if (obj.name.IndexOf("left") > 0) { left = (Texture2D)obj; }
            if (obj.name.IndexOf("right") > 0) { right = (Texture2D)obj; }
        }

        if (top == null || bottom == null || left == null || right == null ) 
        {
            Debug.LogError("Missing directional images.");
            return; 
        }

        Texture2D normals = new Texture2D(top.width, top.height);

        for (int x = 0; x < top.width; ++x)
        {
            for (int y = 0; y < top.height; ++y)
            {
                float t = top.GetPixel(x, y).r;
                float b = bottom.GetPixel(x, y).r;
                float l = left.GetPixel(x, y).r;
                float r = right.GetPixel(x, y).r;


                Vector3 n = new Vector3(0, 0, 0);

                // Calculate the normal here

                normals.SetPixel(x, y, new Color((n.x + 1) / 2, (n.y + 1) / 2, (n.z + 1) / 2, 1.0f));
            }
        }

        // Save file
        string normal_file_name = top.name.Split('-')[0] + "-normals";
        string path = System.IO.Path.GetDirectoryName(AssetDatabase.GetAssetPath(top));
        string filename = Application.dataPath + "/../" + path + "/" + normal_file_name + ".png";
        System.IO.File.WriteAllBytes(filename, normals.EncodeToPNG());
        Debug.Log("Created normal map at path: " + filename);
    }
}
