Shader "Unlit/TextureBlend"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondaryTex ("Secondary Texture", 2D) = "black" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        // _Threshold ("Threshold", Range(0, 1)) = 0
        _Range ("Range", Range(0, 1)) = 0
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
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SecondaryTex;
            float4 _SecondaryTex_ST;
            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            // float _Threshold;
            float _Range;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _SecondaryTex);
                o.uv3 = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col1 = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_SecondaryTex, i.uv2);
                fixed blend = tex2D(_NoiseTex, i.uv3);
                fixed realBlend;

                float threshold =(sin(_Time.y) + 1)/2;

                if (blend < threshold - _Range)
                    realBlend = 0;
                else if (blend > threshold + _Range)
                    realBlend = 1;
                else
                {
                    realBlend = (blend + _Range - threshold) / _Range * 2;
                }
                
                fixed4 col = lerp(col1, col2, realBlend);
                return col;
            }
            ENDCG
        }
    }
}
