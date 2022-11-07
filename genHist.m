function lbph=genHist(noWindows,lbpData,codemap,mask,maskbw)
[sz1,sz2,sz3]=size(lbpData);
if length(noWindows)==1
    nr=noWindows;
    nc=noWindows;
else
    nr=noWindows(1);
    nc=noWindows(2);
end

loopr=floor(linspace(0,sz1,nr+1));
loopc=floor(linspace(0,sz2,nc+1));
lbph=zeros(codemap.num,nr,nc,sz3);

if nargin~=5
    mask=false;
    maskbw=[];
end

parfor gid=1:sz3
    lbp=lbpData(:,:,gid);
    if mask
        lbp=lbp.*maskbw+maskbw-1;
    end
    for ir=1:nr
        ranger=loopr(ir)+1:loopr(ir+1);
        for ic=1:nc
            rangec=loopc(ic)+1:loopc(ic+1);
            w=lbp(ranger,rangec);
            h=hist(w(:),-1:(codemap.num-1));
            h=h(2:end);
            lbph(:,ir,ic,gid)=h;
        end
    end
end
end