nen = input("Enter the number of nodes: ");
nel = input("Enter the number of elements: ");
ndn = input("Enter the number of displacements per node: ");
npe = input("Enter the nodes per element: ");
ndim = input("Enter the problem dimension: ");
fprintf("Enter the co-ordinates of the nodes: ")
for i=1:nen
   for j=1:2
       fprintf("Enter %d node's coord: ", i);
       Ncoord(i,j)=input('');
   end
end
for i=1:nel
    for j=1:4
        fprintf("Enter the %d element's connectivity nodes in counterclockwise manner: ",i);
        Elementdata(i,j)=input('');
    end
end
%%Mesh Attributes%%
choice= input("Enter 1 if all elements have same properties and 0 for otherwise: ");
if(choice==1)
    nom= input('Enter number of materials: ');
    nprops = input('Enter number of elastic properties: ');
    E = input("Enter young's modulus in Pa: ");
    nu = input("Enter poisson's ratio: ");
    alpha = input("Enter temperature coefficient in per deg C: ");
    thick =input('Enter the thickness of each element: ');
    for i=1:nel
        for j=1:6
                Mesh(i,1)=i;
                Mesh(i,2)=nom;
                Mesh(i,3)= E;
                Mesh(i,4)= nu;
                Mesh(i,5)=alpha;
                Mesh(i,6)=thick;
        end
    end
else
    for i=1:nel
        for j=1:6
            Mesh(i,1)=i;
            fprintf("Enter number of materials for %d element: ", i);
            Mesh(i,2)=input('');
            fprintf("Enter young's modulus in Pa for %d element: ", i);
            Mesh(i,3)=input('');
            fprintf("Enter poisson's ratio for %d element: ", i);
            Mesh(i,4)=input('');
            fprintf("Enter temp coefficient in per deg C for %d element: ", i);
            Mesh(i,5)=input('');
            fprintf("Enter thickness of % element: ",i);
            Mesh(i,6)= input('');
        end
    end
end
const=input('Enter constant for gauss point: ');
for i=1:4
    for j=1:2
        if (i<2)
                XNI(i,j)=(-const);
        elseif(i==2)
            if(j==2)
                XNI(i,j)=(-const);
            else
                
                XNI(i,j)=const;
            end
        elseif(i==4)
            if(j==1)
                XNI(i,j)=-(const);
            else
                XNI(i,j)=const;
            end
        
        else
            XNI(i,j)=const;
        end
    end
end

%Nodal loads%
for i=1:2*nen
    fprintf("Enter the nodal load of %d DOF : ",i);
    Nodal_load(i,1)=input('');  
end

%%FDOF and RDOF%%
fprintf("Enter the restrained dofs. Press '1000' when completed: ");
choice=0;
RDOF=[];
while(choice~=1000)
    choice= input('');
    RDOF=[RDOF choice];
end
 RDOF(end)=[];

 fprintf("Enter the free dofs. Press '1000' when completed: ");
choice=0;
FDOF=[];
while(choice~=1000)
    choice= input('');
    FDOF=[FDOF choice];
end
 FDOF(end)=[];
%%Joint loads %%
G_stiff = zeros(2*nen, 2*nen);    
DOF=[];
Dj= zeros(2*nen,1);
 
for element=1:nel
    [Ke_i,Be_i, DOF_i,C_i]= Stiffness_quad(Elementdata, Mesh, Ncoord, XNI);
    DOF = [DOF; DOF_i];
    G_stiff([DOF(element,:)],[DOF(element,:)])= G_stiff([DOF(element,:)],[DOF(element,:)])+Ke_i;
end

Sff = Global_stiff([FDOF],[FDOF]);
Sfr = Global_stiff([FDOF],[RDOF]);
Srf = Global_stiff([RDOF],[FDOF]);
Srr = Global_stiff([RDOF],[RDOF]);
Afc = Nodal_load([FDOF],1);
Arc = Nodal_load([RDOF],1);

Df =  inv(Sff)*Afc;
Ar = -1*Arc + Srf*Df;

% Print Joint Displacements and Support reactions on the screen:
Joint_Displacements = Df'
Support_Reactions = Ar'

Dj([FDOF],1) = Df;

for element=1:nel
    Dj_i = zeros(8,1);
    [Ke_i,Be_i, DOF_i,C_i]= Stiffness_quad(Elementdata, Mesh, Ncoord, XNI);
    Dj_i = Dj([DOF_i],1);
    Element_stresses(:,element)= C_i*Be_i*Dj_i;
    fprintf("Displacments for element %d : ",i);
    Dj_i'
    fprintf("Stresses for element %d : ",i);
    Element_stresses'
end
