function [nAng] = normAngle(inAng)


tmpSign = sign(inAng);
nAng= mod(abs(inAng),360);
nAng= tmpSign .* nAng;
nAng(nAng<-180) = nAng(nAng<-180)  + 360;
nAng(nAng>180) = nAng(nAng>180)  - 360;

end