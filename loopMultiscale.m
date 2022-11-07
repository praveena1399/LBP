function dist=loopMultiscale(op,loopFunc)
dist=[];
lcnt=length(op.wlist)*4;
cnt=0;

lcnt2=lcnt;
cnt2=0;
tic
for w=op.wlist
    op.w=w;
    [rr1,rr2]=shiftrange(op);
    for rshift=rr1
        for cshift=rr2
            if cnt2==0
                str='--';
            else
                str=datestr(now+toc/cnt2*(lcnt2-cnt2)/24/60/60);
            end
            caller=dbstack;
            fprintf('%s,%s,%d,%d-%.2f%%-estimated finish time:%s   \r',...
                caller(2).name,util.opStr(op),rshift,cshift,cnt/lcnt*100,str);
            cnt=cnt+1;
            d=loopFunc(op,rshift,cshift);
            if isempty(d)
                lcnt2=lcnt2-1;
                continue;
            else
                cnt2=cnt2+1;
            end
            if isempty(dist)
                dist=d;
            elseif iscell(d)
                for ii=1:length(d)
                    dist{ii}=dist{ii}+d{ii};
                    if op.showPartialResult
                        if ii==1
                            clearline();
                        end
                        L4classify(op,dist{ii});
                    end
                end
            else
                dist=dist+d;
                if op.showPartialResult
                    clearline();
                    L4classify(op,d);
                end
            end
        end
    end
end
clearline();
if toc > 5
    toc
end
end

function clearline()
fprintf('                                                                                                \r');
end

function printProgress()
persistent cnt cnt2 lcnt lcnt2;
if cnt2==0
    str='--';
else
    str=datestr(now+toc/cnt2*(lcnt2-cnt2)/24/60/60);
end
caller=dbstack;
fprintf('%s,%s,%d,%d-%.2f%%-estimated finish time:%s   \r',...
    caller(2).name,util.opStr(op),rshift,cshift,cnt/lcnt*100,str);
cnt=cnt+1;
end

function [rr1,rr2]=shiftrange(op)
op.r=floor(mean(op.rlist));
f1=load(util.lbpFile(op),'rsz','csz');
rr1=shiftrange1(f1.rsz,op.w);
rr2=shiftrange1(f1.csz,op.w);
end

function rr=shiftrange1(sz,w)
t1=mod(floor(sz/2),w)+1;
t2=mod(floor((sz+w)/2),w)+1;
rr=[t1 t2];
end