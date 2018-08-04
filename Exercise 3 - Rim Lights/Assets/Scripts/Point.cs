using UnityEngine;

namespace Lights
{
    public class Point : MonoBehaviour
    {
        public Color LightColor;
        public Color ShadowColor;

        [Header("Range (In Units)")]
        [Range(0,100)]
        public float Range;

        private void Start()
        {
            CircleCollider2D c = GetComponent<CircleCollider2D>();
            c.radius = Range;
        }
    }
}
