--セキュア・ガードナー
--Security Gardna
--Script by nekrozar
function c101003043.initial_effect(c)
	c:SetUniqueOnField(1,0,101003043)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101003043.matfilter,1,1)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101003043.regop)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c101003043.damval2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c101003043.damcon)
	c:RegisterEffect(e4)
end
function c101003043.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101003043.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101003043.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_CYBERSE,lc,sumtype,tp) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function c101003043.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c101003043.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:GetFlagEffect(101003043)==0 then
		c:RegisterFlagEffect(101003043,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function c101003043.damcon(e)
	return e:GetHandler():GetFlagEffect(101003043)==0
end
