// Разработчик: vk.com/id326659555

#include <amxmodx>
#include <reapi>

#define MULTIPLIER 5.0 // Мультипликатор повышения прочности бронежилета. 
// Пример: При значении 5.0 - бронежилет сможет принять ~ 500 урона. 1.0 - сможет принять ~ 100 урона. 0.5 - сможет принять ~ 50 урона.

public plugin_init(){
	register_plugin("Body armor", "0.3 Beta", "vk.com/id326659555");
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "takedamage", false);
}

public takedamage(id, weapon, pid, Float:damage, damagebits){
	if(!is_user_alive(id)) // Если жив до попадания пули, - продолжаем.
		return HC_CONTINUE;

	//if(is_user_bot(id)) 	// Если не бот, продолжаем.
	//	return HC_CONTINUE;

	//if(random_num(0, 5) != 3){	// Реализации рандомных частых промахов, если вам понадобятся.
	//	SetHookChainArg(4, ATYPE_FLOAT, 0.0);
	//	return HC_BREAK;
	//}

	if(rg_get_user_armor(id) > 0){	// Если есть броня, расходуем всем уроном только броню, применяя к урону мультипликатор, заданный ранее.
		if(rg_get_user_armor(id) >= floatround(damage / MULTIPLIER)){
			rg_set_user_armor(id, rg_get_user_armor(id) - floatround(damage / MULTIPLIER), ARMOR_VESTHELM);
		}else{
			rg_set_user_armor(id, 0, ARMOR_VESTHELM); // При поломке бронежилет поглотит весь входящий урон от целой пули, а потом сломается.
		}
		SetHookChainArg(4, ATYPE_FLOAT, 0.0);
		return HC_SUPERCEDE;
	}

	return HC_CONTINUE;
}