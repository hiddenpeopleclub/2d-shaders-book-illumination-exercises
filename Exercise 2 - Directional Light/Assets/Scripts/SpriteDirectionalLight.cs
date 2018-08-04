using UnityEngine;

public class SpriteDirectionalLight : MonoBehaviour {
    public Shader Shader;
    public Color LightColor = Color.white;
    public Color ShadowColor = Color.black;
    [Range(0,360)]
    public float Angle;

    SpriteRenderer spriteRenderer;
    public Material material;

    private void Start()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        Sprite sprite = spriteRenderer.sprite;

        material = new Material(Shader);
        material.SetTexture("_MainTex", sprite.texture);

        spriteRenderer.material = material;
    }

    private void Update()
    {
        material.SetColor("_LightColor", LightColor);
        material.SetColor("_ShadowColor", ShadowColor);
        material.SetFloat("_Angle", Mathf.Deg2Rad * Angle);
        spriteRenderer.material = material;

    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        Lights.Directional directionalLight = collision.gameObject.GetComponent<Lights.Directional>();
        LightColor = directionalLight.LightColor;
        ShadowColor = directionalLight.ShadowColor;
        Angle = directionalLight.Angle;
    }

}
