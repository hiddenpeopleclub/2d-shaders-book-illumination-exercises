using UnityEngine;

public class SpritePointLight : MonoBehaviour
{
    public Shader Shader;
    public Color LightColor = Color.white;
    public Color ShadowColor = Color.black;
    public float Distance;
    public float Range = 0;
    public Vector3 Direction;

    [Range(0, 360)]
    public float Angle = 0;

    Lights.Point currentLight;


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
        if(currentLight != null)
        {
            material.SetColor("_LightColor", LightColor);
            material.SetColor("_ShadowColor", ShadowColor);

            // We calculate the angle of the direction to the y axis
            Direction = transform.position - currentLight.transform.position;
            Distance = Direction.magnitude;
            Direction.Normalize();
            Angle = Mathf.Acos(Vector3.Dot(Direction, Vector3.down));
            Vector3 cross = Vector3.Cross(Direction, Vector3.down);
            if (Vector3.Dot(Vector3.forward, cross) < 0)
            {
                Angle = -Angle;
            }

            material.SetFloat("_Smoothness", Distance / Range);
            material.SetFloat("_Angle", Angle);

            spriteRenderer.material = material;
        }

    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        currentLight = collision.gameObject.GetComponent<Lights.Point>();
        Debug.Log(collision);
        LightColor = currentLight.LightColor;
        ShadowColor = currentLight.ShadowColor;
        Range = currentLight.Range;
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        currentLight = null;
    }

}