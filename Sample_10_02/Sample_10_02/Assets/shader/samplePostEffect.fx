cbuffer cb : register(b0)
{
    float4x4 mvp;       // MVP行列
    float4 mulColor;    // 乗算カラー
};

struct VSInput
{
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PSInput
{
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
};

Texture2D<float4> sceneTexture : register(t0);  // シーンテクスチャ
sampler Sampler : register(s0);

PSInput VSMain(VSInput In)
{
    PSInput psIn;
    psIn.pos = mul(mvp, In.pos);
    psIn.uv = In.uv;
    return psIn;
}

float4 PSMain(PSInput In) : SV_Target0
{
    float4 color = sceneTexture.Sample(Sampler, In.uv);

    // step-7 ピクセルカラーをモノクロ化する
		//モノクロ
	/*
	float Y = 0.299f * color.r + 0.587f * color.b + 0.114f * color.b;
	color.r = Y;
	color.g = Y;
	color.b = Y;
	*/

	//赤のみ
	/*
	* float Y = 0.299f * color.r + 0.587f * color.b + 0.114f * color.b;
	 color.r = Y;
	 color.g = 0;
	 color.b = 0;
	 */

	 //反転
	/*
	 color.r = 1 - color.r;
	 color.g = 1 - color.g;
	 color.b = 1 - color.b;
	 */


	 //ソラリゼーション
	/*
	color.r = 4 * ((color.r - 0.5) * (color.r - 0.5));
	color.g = 4 * ((color.g - 0.5) * (color.g - 0.5));
	color.b = 4 * ((color.b - 0.5) * (color.b - 0.5));
	*/

	//ポスタリゼーション

	for (int i = 0; i < 5; i++)
	{
		if (color.r > 0.25 * i && color.r <= 0.25 * (i + 1))
		{
			color.r = 0.25 * i;
		}
		if (color.g > 0.25 * i && color.g <= 0.25 * (i + 1))
		{
			color.g = 0.25 * i;
		}
		if (color.b > 0.25 * i && color.b <= 0.25 * (i + 1))
		{
			color.b = 0.25 * i;
		}

	}

    return color;
}
