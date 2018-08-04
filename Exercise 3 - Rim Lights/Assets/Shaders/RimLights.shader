Shader "2D Shaders/RimLights"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Normals ("Texture", 2D) = "white" {}
        _LightColor("LightColor", Color) = (0,0,0,0)
        _LightPosition("LightPosition", Vector) = (0,0,0,0)
	}
    
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
          Cull Off
          ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
		    };

			struct v2f
			{
				float2 uv : TEXCOORD0;
                float4 position : SV_POSITION; 
			};

			sampler2D _MainTex;
			sampler2D _Normals;
            float3 _LightPosition;
            float4 _LightColor;

			v2f vert (appdata v)
			{
				v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // Go ahead and find L
                float3 l = 0;

                // This is N as stored in the texture, careful with the range
                fixed4 n = tex2D(_Normals, i.position.xy / _ScreenParams.xy);

                // NdotL will give you the intensity of the light in this pixel
                float NdotL = saturate(dot(normalize(n), normalize(l)));

                // Set the right light color here
                float4 col = n;

                return col; 
            }
			ENDCG
		}
	}
}
