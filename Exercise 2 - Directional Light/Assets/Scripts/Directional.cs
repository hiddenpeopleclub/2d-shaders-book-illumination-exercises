using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Lights
{
    public class Directional : MonoBehaviour
    {
        [Range(0,360)]
        public float Angle;
        public Color LightColor;
        public Color ShadowColor;
    }
}
