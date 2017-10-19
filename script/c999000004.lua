--Majestic Mark
--AlphaKretin
function c999000004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c999000004.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999000004,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c999000004.distg)
	e2:SetOperation(c999000004.disop)
	c:RegisterEffect(e2)
	--Summon token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c999000004.condition)
	e3:SetCost(c999000004.spcost)
	e3:SetTarget(c999000004.sptg)
	e3:SetOperation(c999000004.spop)
	c:RegisterEffect(e3)
end
--search Maj Dragon
function c999000004.thfilter(c)
	return c:IsCode(21159309) and c:IsAbleToHand()
end
function c999000004.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c999000004.thfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(999000004,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--negate
function c999000004.disfiler(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x3f)
end
function c999000004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000004.disfiler,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c999000004.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999000004.disfiler,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
--summon token
function c999000004.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xc2) or ((c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON)))
		and c:IsType(TYPE_SYNCHRO)
end
function c999000004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999000004.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c999000004.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c999000004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000004.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c999000004.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c999000004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999000005,0x3f,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c999000004.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x3f)
end
function c999000004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999000005,0x3f,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,999000005)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		--cannot be used for anything
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(token)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(c999000004.synlimit)
		token:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end