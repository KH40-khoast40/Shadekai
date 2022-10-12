
//Shadekai (Project Sekai shader for MMD)

#define SekaiMap_Texture "_H.png" //The texture that ends with "_H"
#define ShadowColorMap_Texture "_S.png" //The texture that ends with "_S"

#define Character 20
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//	0.Ichika	4.Minori	8.Kohane	12.Tsukasa	16.Kanade	20.Vocaloids
//	1.Saki		5.Haruka	9.An		13.Emu		17.Mafuyu
//	2.Honami	6.Airi		10.Akito	14.Nene		18.Ena
//	3.Shiho		7.Shizuku	11.Touya	15.Rui		19.Mizuki
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#define Self_LightDirection 0 //Light direction per character, set to 0 for the model to use global light instead

#define Self_Ambient 0 //The ambient color on the model. If enable, the Self_Lighting_Model must have "Ambient_R/G/B +" facials
#define Self_Rim 0 //The color of the rim to be exact. If enable, the Self_Lighting_Model must have "Rim_R/G/B +" facials

//Note that if Self_Ambient and Self_Rim are turned off, those of the model will be globally controlled by the RGB facials in Shadekai_Controller.pmx
//Turn off the 3 things above if you just want to control all aspects of the lighting globally, like a sane person

//The options below are to define the controller of LightDirection, Ambient, Rim

	#define Self_Lighting_Model "Shadekai_Light.pmx" 
		//Choose the model that contains the bone used to control the lighting
		//Type "(self)" if you want to use the character model itself as the controller
	
	#define Self_Lighting_Bone_Toon "Toon_Direction" //Choose the bone used to control the toon
	#define Self_Lighting_Bone_Rim "Rim_Direction" //Choose the bone used to control the rim

//////////////////////////////////////////////////////////////////////////////////////////////////////////

#define Shadow 1
	//0 to disable, 1 to enable
	//If you choose 1, you have to load HgShadow.x for the model to have real-time shadow
	//Choose 0 if you don't want the model to have real-time shadow even when HgShadow.x is loaded
	//The model won't have real-time shadow regardless of the options if HgShadow.x is not loaded
	
#define Shadow_Sharp 1
	//0 to choose soft shadow , 1 to choose sharp shadow
	//For Sekai's artstyle, sharp shadow is recommended. HgShadow is still required for sharp shadow

//////////////////////////////////////////////////////////////////////////////////////////////////////////

#define Front_Object 1 //Enable to make eyebrows and some other parts always appear in front of other objects, even if they're physically behind something

//////////////////////////////////////////////////////////////////////////////////////////////////////////

float Rim_Intensity = 0.35;
float Rim_Length = 0.25; //SMALLER number means LONGER rim
float Rim_Thickness = 0.65; //SMALLER number means THICKER rim

float Edge_Thickness = 0.01;

//////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "Shadekai_Sync.fxsub"