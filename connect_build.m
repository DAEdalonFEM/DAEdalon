fid_el=fopen('input\el.inp');
inp=textscan(fid_el,'%f%f%f%f%f');
el=[inp{2},inp{3},inp{4},inp{5}];

temp={};rows=[];
nodenr=find(nodes(:,3)==1000);
max=1;
for i=1:length(nodenr)
    x=find(el==nodenr(i));
    if length(x)>max
        max=length(x);
    end
    rows=[rows;mod(x,length(el))];
    temp{i}=mod(x,length(el));
    temp{i}=sort(temp{i});
end

rows=sort(rows);
rows(diff(rows)==0)=[];
rowmatrx=zeros(max,length(nodenr));
for i=1:length(nodenr)
    rowmatrx(1:length(temp{i}),i)=temp{i};
end

connectvty=[];temp=[];
for i=1:length(rows)
    if length(find(rowmatrx==rows(i)))==3
        temp=[];
        for j=1:length(nodenr)
            if find(rowmatrx(:,j)==rows(i))
                temp=[temp,j];
            end
        end
        connectvty=[connectvty;nodenr(temp)'];
    end
end
       