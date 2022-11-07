function ret=encodeLBP(imgData,radios,samplepoints,codemap)
[sz1,sz2,sz3]=size(imgData);
ret=zeros(sz1-2*radios,sz2-2*radios,sz3);
parfor gid=1:sz3
    I=imgData(:,:,gid);
    J=lbp(I,radios,samplepoints,codemap,'AsIs');
    ret(:,:,gid)=J;
end
end