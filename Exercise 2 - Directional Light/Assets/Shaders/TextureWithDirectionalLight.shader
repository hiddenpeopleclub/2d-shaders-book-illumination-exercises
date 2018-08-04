Shader "2D Shaders/TextureWithDirectionalLight"
{
    Properties
    {
        _MainTex ( "Main Texture", 2D ) = "white" {}
        _LightColor ( "Light Color", Color ) = (1,1,1,1)
        _ShadowColor ( "Shadow Color", Color ) = (0,0,0,1)
        _Angle ("Angle", Float) = 0
    }

    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 direction : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _LightColor;
            float4 _ShadowColor;
            float _Angle;

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.position);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * lerp(_ShadowColor, _LightColor, i.uv.y);
            }

            ENDCG
        }
    }
}
