﻿Shader "Projector/Tattoo" {
    Properties {
        _Color ("Tint Color", Color) = (1,1,1,1)
        _ShadowTex("Cookie", 2D) = "white" {}
    }

    Subshader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent+100"
        }
        Pass {
            ZWrite Off
            Offset -1, -1

            Fog{ Mode Off }

            ColorMask RGB
            Blend OneMinusSrcAlpha SrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_fog_exp2
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            sampler2D _ShadowTex;
            float4x4 unity_Projector;
            float4 _Color;

            v2f vert(appdata_tan v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = mul(unity_Projector, v.vertex);
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                half4 tex = tex2Dproj(_ShadowTex, i.uv);
                tex.a = 1 - tex.a;
                if (i.uv.w < 0)
                {
                    tex = _Color;
                }
                return tex;
            }
            ENDCG
        }
    }
}