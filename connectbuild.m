function nodeforce=connectbuild(coord_plane,coord_wert,tol,aforce,node,el)

temp={};rows=[];
nodenr=find(node(:,coord_plane)<=coord_wert+tol & node(:,coord_plane)>=coord_wert-tol);

if isempty(nodenr)
    uiwait(warndlg('ACHTUNG! Es wurden keine Knoten in der angegebenen Ebene gefunden!','Warnung'));
    nodeforce=[];
    return
end

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

connectvty=[];
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


force=[];  %Gleichflaechenlast mit 10 N/mm2
%Aufbau der Vektoren eines Dreiecks und Berechnung der Flaeche dieses Dreiecks
for i=1:size(connectvty,1)
    v1=node(connectvty(i,1),:)-node(connectvty(i,3),:);
    v2=node(connectvty(i,2),:)-node(connectvty(i,3),:);
    area=0.5*norm(cross(v1,v2));
    force=[force;area*aforce];
end

temp=size(connectvty,1)*size(connectvty,2);
connectvty=[connectvty,force/3];
nodeforce=[1:nodenr(end);coord_plane*ones(1,nodenr(end));zeros(1,nodenr(end))]';

%Verteilen der Kraefte auf die entsprechenden Knoten
for i=1:temp
    modul=mod(i,size(connectvty,1));
    if modul==0
        modul=modul+size(connectvty,1);
    end
    nodeforce(connectvty(i),3)=nodeforce(connectvty(i),3)+connectvty(modul,4);
end
delete=find(nodeforce(:,3)==0);
nodeforce(delete,:)=[];
