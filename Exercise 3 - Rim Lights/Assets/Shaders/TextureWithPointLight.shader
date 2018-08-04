Shader "2D Shaders/TextureWithPointLight"
{
    Properties
    {
        _MainTex ( "Main Texture", 2D ) = "white" {}
        _LightColor ( "Light Color", Color ) = (1,1,1,1)
        _ShadowColor ( "Shadow Color", Color ) = (0,0,0,1)
        _Angle ("Rotation Angle", Range(0,360)) = 0
        _Smoothness ("Distance", float) = 0
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
            float _Smoothness;

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.position);
                float2x2 rot = { cos(_Angle), -sin(_Angle), sin(_Angle), cos(_Angle) };
                o.uv = v.uv;
                o.direction = mul(rot, v.uv - float2(0.5f, 0.5f)) + float2(0.5f, 0.5f);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * lerp(_ShadowColor, _LightColor, smoothstep(0, _Smoothness, i.direction.y));
            }

            ENDCG
        }
    }
}
