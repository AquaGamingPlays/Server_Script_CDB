--リンクリボー
--Linkuriboh
--Scripted by Eerie Code
function c41999284.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c41999284.matfilter,1)
	--atk to 0
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c41999284.atkcon)
	e1:SetCost(c41999284.atkcost)
	e1:SetOperation(c41999284.atkop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,41999284)
	e2:SetCost(c41999284.spcost)
	e2:SetTarget(c41999284.sptg)
	e2:SetOperation(c41999284.spop)
	c:RegisterEffect(e2)
end
function c41999284.matfilter(c)
	return c:GetLevel()==1
end
function c41999284.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and aux.nzatk(Duel.GetAttacker())
end
function c41999284.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c41999284.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c41999284.cfilter(c,ft,tp)
	return c:GetLevel()==1 and c:IsControler(tp)
		and (ft>0 or c:GetSequence()<5)
end
function c41999284.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c41999284.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c41999284.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c41999284.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c41999284.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
