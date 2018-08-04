Shader "2D Shaders/ToNormal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
		    };

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
            float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float x0 = tex2D(_MainTex, i.uv + float2(_MainTex_TexelSize.x, 0)).r;
                float x1 = tex2D(_MainTex, i.uv - float2(_MainTex_TexelSize.x, 0)).r;
                float y0 = tex2D(_MainTex, i.uv + float2(0, _MainTex_TexelSize.y)).r;
                float y1 = tex2D(_MainTex, i.uv - float2(0, _MainTex_TexelSize.y)).r;
                
                float dx = x0 - x1;
                float dy = y0 - y1;

				return fixed4(0.5 - dx, 0.5 - dy, 1, 1);
			}
			ENDCG
		}
	}
}
