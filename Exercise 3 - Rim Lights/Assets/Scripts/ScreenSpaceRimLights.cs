using UnityEngine;

public class ScreenSpaceRimLights : MonoBehaviour {
    enum Pass
    {
        Normals,
        Lights,
    }

    [Header("Normal Generation")]
    public Shader TextureWithAlphaOnly;
    public Material Blur;

    [Range(1,5)]
    public int BlurPasses = 3;
    public Material ToNormal;

    [Header("Rim Lights")]
    public Shader RimLights;
    public Lights.Point PointLight;


    new Camera camera;
    RenderTexture Mask;
    RenderTexture Normals;
    RenderTexture Lights;
    RenderTexture tmp;
    RenderTexture tmp2;

    Vector4 tmpVector = Vector4.zero;

    Pass CurrentPass;

	private void Awake()
	{
        camera = GetComponent<Camera>();

        Mask = new RenderTexture(camera.pixelWidth, camera.pixelHeight, 24);
        Normals = new RenderTexture(camera.pixelWidth, camera.pixelHeight, 24);
        Lights = new RenderTexture(camera.pixelWidth, camera.pixelHeight, 24);

        tmp = new RenderTexture(camera.pixelWidth, camera.pixelHeight, 24);
        tmp2 = new RenderTexture(camera.pixelWidth, camera.pixelHeight, 24);
	}

    private void Update()
    {
        camera.SetReplacementShader(TextureWithAlphaOnly, null);
        camera.targetTexture = Normals;
        CurrentPass = Pass.Normals;
        camera.Render();

        CurrentPass = Pass.Lights;
        camera.SetReplacementShader(RimLights, null);
        Vector3 lightPos = PointLight.transform.position;
        tmpVector.Set(lightPos.x, lightPos.y, lightPos.z, 0);
        Shader.SetGlobalVector("_LightPosition", tmpVector);
        Shader.SetGlobalVector("_LightColor", PointLight.LightColor);
        Shader.SetGlobalTexture("_Normals", Normals);
        camera.targetTexture = null;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        switch (CurrentPass)
        {
            case Pass.Normals:
                Graphics.Blit(source, Mask);
                Graphics.Blit(source, tmp);

                for (int i = 0; i < BlurPasses; i++)
                {
                    Graphics.Blit(tmp, tmp2, Blur, 0);
                    Graphics.Blit(tmp2, tmp, Blur, 1);
                }

                Graphics.Blit(tmp, destination, ToNormal);
                break;
            case Pass.Lights:
                Graphics.Blit(source, destination);
                break;
        }
    }
}
