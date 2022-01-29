////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_ObjHeader.fxh : HgShadow オブジェクト影描画に必要な基本パラメータ定義ヘッダファイル
//  ここのパラメータをシェーダエフェクトファイルで #include して使用します。
//  作成: 針金P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// パラメータ宣言

// 制御パラメータ
#define HgShadow_CTRLFILENAME  "HgShadow.x"
bool HgShadow_Valid  : CONTROLOBJECT < string name = HgShadow_CTRLFILENAME; >;

float HgShadow_DensityUp   : CONTROLOBJECT < string name = "(self)"; string item = "ShadowDen+"; >;
float HgShadow_DensityDown : CONTROLOBJECT < string name = "(self)"; string item = "ShadowDen-"; >;

#ifndef MIKUMIKUMOVING

float HgShadow_AcsRx : CONTROLOBJECT < string name = HgShadow_CTRLFILENAME; string item = "Rx"; >;
float HgShadow_ObjTr : CONTROLOBJECT < string name = "(self)"; string item = "Tr"; >;
static float HgShadow_Density = max((degrees(HgShadow_AcsRx) + 5.0f*HgShadow_DensityUp + 1.0f)*(1.0f - HgShadow_DensityDown), 0.0f);

#else

shared float HgShadow_MMM_Density;
static float HgShadow_Density = max((HgShadow_MMM_Density + 5.0f*HgShadow_DensityUp)*(1.0f - HgShadow_DensityDown), 0.0f);

#endif


// 影生成描画結果を記録するためのレンダーターゲット
shared texture2D HgShadow_ViewportMap2 : RENDERCOLORTARGET;
sampler2D HgShadow_ViewportMapSamp = sampler_state {
    texture = <HgShadow_ViewportMap2>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};


// スクリーンサイズ
float2 HgShadow_ViewportSize : VIEWPORTPIXELSIZE;
static float2 HgShadow_ViewportOffset = (float2(0.5,0.5)/HgShadow_ViewportSize);


// セルフシャドウの遮蔽率を求める
float HgShadow_GetSelfShadowRate(float4 PPos)
{
    // スクリーンの座標
    float2 texCoord = float2( ( PPos.x/PPos.w + 1.0f ) * 0.5f,
                              1.0f - ( PPos.y/PPos.w + 1.0f ) * 0.5f ) + HgShadow_ViewportOffset;

    // 遮蔽率
    float comp = 1.0f - tex2Dlod( HgShadow_ViewportMapSamp, float4(texCoord, 0, 0) ).r;

    return (1.0f-(1.0f-comp) * min(HgShadow_Density, 1.0f));
}


struct HgShadow_COLOR {
    float4 Color;        // オブジェクト色
    float4 ShadowColor;  // 影色
};


// 影色に濃度を加味する
HgShadow_COLOR HgShadow_GetShadowDensity(float4 Color, float4 ShadowColor, bool useToon, float LightNormal)
{
    HgShadow_COLOR Out;
    Out.Color = Color;
    Out.ShadowColor = ShadowColor;

    if( !useToon || length(Color.rgb-ShadowColor.rgb) > 0.01f ){
        float e = max(HgShadow_Density, 1.0f);
        float a = 1.0f / e;
        float b = 1.0f - smoothstep(3.0f, 6.0f, e);
        float3 color = lerp(ShadowColor.rgb*a, ShadowColor.rgb*b, pow(ShadowColor.rgb, e));
        Out.ShadowColor = float4(saturate(color), ShadowColor.a);
    }
    if( !useToon ){
        float e = lerp( max(HgShadow_Density, 1.0f), 1.0f, smoothstep(0.0f, 0.4f, LightNormal) );
        float a = 1.0f / e;
        float b = 1.0f - smoothstep(3.0f, 6.0f, e);
        float3 color = lerp(Color.rgb*a, Color.rgb*b, pow(Color.rgb, e));
        Out.Color = float4(saturate(color), Color.a);
        #ifndef MIKUMIKUMOVING
        Out.Color.a *= HgShadow_ObjTr;
        Out.ShadowColor.a *= HgShadow_ObjTr;
        #endif
    }

    return Out;
}


