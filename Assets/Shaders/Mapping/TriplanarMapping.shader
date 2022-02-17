Shader "Unlit/TriplanarMapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Sharpness ("Sharpness", float) = 1
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD0;
                float2 uvFront : TEXCOORD1;
                float2 uvSide : TEXCOORD2;
                float2 uvUp : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Get the world position.
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                // Calculate the world normal.
                o.normal = UnityObjectToWorldNormal(v.normal);

                // Transform the world space coordinate to the texture uv.
                o.uvFront = TRANSFORM_TEX(o.worldPos.xy, _MainTex);
                o.uvSide = TRANSFORM_TEX(o.worldPos.yz, _MainTex);
                o.uvUp = TRANSFORM_TEX(o.worldPos.xz, _MainTex);
                
                return o;
            }

            float _Sharpness;
            
            fixed4 frag (v2f i) : SV_Target
            {
                // Sample the color from the texture.
                float4 colFront = tex2D(_MainTex, i.uvFront);
                float4 colSide = tex2D(_MainTex, i.uvSide);
                float4 colUp = tex2D(_MainTex, i.uvUp);

                // The weight for each side.
                float3 weight = i.normal;
                // Make all the weights positive.
                weight = abs(weight);
                // Sharpen the weight.
                weight = pow(weight, _Sharpness);
                // Make the sum of all the weight = 1.
                weight = weight / (weight.x + weight.y + weight.z);

                // Calculate the final color.
                float4 col = colFront * weight.z + colSide * weight.x + colUp * weight.y;

                return col;
            }
            ENDCG
        }
    }
}