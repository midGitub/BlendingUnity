﻿Shader "Custom/Mask" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
	}
	SubShader {
		Tags { "RenderType"="Overlay" }
		ZTest Always ZWrite Off Cull Off Fog { Mode Off }
		
		Pass {
			CGPROGRAM
			#define NUM_RECTS 4
			#pragma debug
			#pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Rects[NUM_RECTS];

			struct Input {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			Input vert(Input IN) {
				Input OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.uv = IN.uv;
				return OUT;
			}
			float4 frag(Input IN) : COLOR {
				for (uint i = 0; i < NUM_RECTS; i++) {
					float4 rect = _Rects[i];
					if (all(float4(IN.uv - rect.xy, rect.xy + rect.zw - IN.uv) > 0))
						discard;
				}				
				return tex2D(_MainTex, IN.uv);
			}
			ENDCG
		}
	} 
}
