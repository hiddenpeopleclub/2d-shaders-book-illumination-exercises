Shader "2D Shaders/Blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

        // Vertical Blur
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 sum = fixed4(0,0,0,0);
                
                #define convolute(weight,offset) tex2D( _MainTex, float2(i.uv.x, i.uv.y + _MainTex_TexelSize.y * offset)) * weight

                sum += convolute(0.000229, -4.0);
                sum += convolute(0.005977, -3.0);
                sum += convolute(0.060598, -2.0);
                sum += convolute(0.241732, -1.0);
                sum += convolute(0.382928,  0.0);
                sum += convolute(0.241732, +1.0);
                sum += convolute(0.060598, +2.0);
                sum += convolute(0.005977, +3.0);
                sum += convolute(0.000229, +4.0);

				return sum;
			}
			ENDCG
		}
        
        // Horizontal Blur
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 sum = float4(0,0,0,0);

                #define convolute(weight,offset) tex2D( _MainTex, float2(i.uv.x + _MainTex_TexelSize.x * offset, i.uv.y)) * weight

                sum += convolute(0.05, -4.0);
                sum += convolute(0.09, -3.0);
                sum += convolute(0.12, -2.0);
                sum += convolute(0.15, -1.0);
                sum += convolute(0.18,  0.0);
                sum += convolute(0.15, +1.0);
                sum += convolute(0.12, +2.0);
                sum += convolute(0.09, +3.0);
                sum += convolute(0.05, +4.0);

                return sum;
            }
            ENDCG
        }

	}
}
