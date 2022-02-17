Shader "Tutorial/005_surface" {
    Properties {
		_Color ("Tint", Color) = (0, 0, 0, 1)
		_MainTex ("Texture", 2D) = "white" {}
    	_Smoothness ("Smoothness", float) = 0
    	_Metallic ("Metallic", float) = 0
	}
    
    Subshader{
    	Tags {"RenderType" = "Opaque" "Queue" = "Geometry"}
    	
    	CGPROGRAM

    	#pragma surface surf Standard fullforwardshadows

    	// Define the struct for Input
    	struct Input
    	{
    		float2 uv_MainTex;
    	};

    	// Main texture and Color declaration.
    	sampler2D _MainTex;
    	fixed4 _Color;
    	half _Smoothness;
    	half _Metallic;

    	void surf(Input i, inout SurfaceOutputStandard o)
    	{
    		fixed4 col = tex2D(_MainTex, i.uv_MainTex);
    		col *= _Color;
    		// Set the albedo to color.
    		o.Albedo = col;
    		o.Smoothness = _Smoothness;
    		o.Metallic = _Metallic;
    	}
    	
    	ENDCG
    }
	
    FallBack "Standard"
}